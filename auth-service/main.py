# FastAPI Auth Service - auth.avila.inc
# Gerenciamento de autenticação para toda plataforma Avila

from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, EmailStr
from passlib.context import CryptContext
from jose import JWTError, jwt
from datetime import datetime, timedelta
import os
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import secrets

# Config
JWT_SECRET = os.getenv("JWT_SECRET", "change-me-in-production")
JWT_ALGORITHM = "HS256"
JWT_EXPIRATION = int(os.getenv("JWT_EXPIRATION", "3600"))  # 1 hour

SMTP_HOST = os.getenv("SMTP_HOST", "mail.avila.inc")
SMTP_PORT = int(os.getenv("SMTP_PORT", "587"))
SMTP_USER = os.getenv("SMTP_USER", "noreply@avila.inc")
SMTP_PASSWORD = os.getenv("SMTP_PASSWORD", "")

# Password hashing
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# FastAPI app
app = FastAPI(
    title="Avila Auth API",
    description="Sistema de autenticação centralizado - auth.avila.inc",
    version="1.0.0"
)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "https://portal.avila.inc",
        "https://api.avila.inc",
        "http://localhost:8000",
        "http://localhost:3000",
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Models
class UserRegister(BaseModel):
    email: EmailStr
    password: str
    name: str
    company: str | None = None

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class TokenResponse(BaseModel):
    token: str
    expires_at: int
    user: dict

# In-memory storage (substituir por MySQL depois)
users_db = {}
mfa_codes = {}

# Utilities
def hash_password(password: str) -> str:
    return pwd_context.hash(password)

def verify_password(plain: str, hashed: str) -> bool:
    return pwd_context.verify(plain, hashed)

def create_jwt(user_id: str, email: str) -> str:
    expires = datetime.utcnow() + timedelta(seconds=JWT_EXPIRATION)
    payload = {
        "sub": user_id,
        "email": email,
        "exp": expires,
        "iat": datetime.utcnow(),
    }
    return jwt.encode(payload, JWT_SECRET, algorithm=JWT_ALGORITHM)

def send_email(to: str, subject: str, html: str):
    """Envia email via SMTP"""
    try:
        msg = MIMEMultipart('alternative')
        msg['Subject'] = subject
        msg['From'] = SMTP_USER
        msg['To'] = to

        html_part = MIMEText(html, 'html')
        msg.attach(html_part)

        with smtplib.SMTP(SMTP_HOST, SMTP_PORT) as server:
            server.starttls()
            server.login(SMTP_USER, SMTP_PASSWORD)
            server.send_message(msg)
        return True
    except Exception as e:
        print(f"Email error: {e}")
        return False

# Endpoints
@app.get("/")
async def root():
    return {
        "service": "Avila Auth API",
        "version": "1.0.0",
        "endpoints": {
            "register": "POST /auth/register",
            "login": "POST /auth/login",
            "verify_mfa": "POST /auth/mfa/verify",
            "health": "GET /health"
        }
    }

@app.get("/health")
async def health():
    return {
        "status": "healthy",
        "service": "auth",
        "timestamp": datetime.utcnow().isoformat()
    }

@app.post("/auth/register", response_model=dict)
async def register(user: UserRegister):
    """Registrar novo usuário"""

    # Verifica se já existe
    if user.email in users_db:
        raise HTTPException(status_code=400, detail="Email já cadastrado")

    # Hash da senha
    hashed = hash_password(user.password)

    # Salva usuário
    user_id = secrets.token_urlsafe(16)
    users_db[user.email] = {
        "id": user_id,
        "email": user.email,
        "password": hashed,
        "name": user.name,
        "company": user.company,
        "confirmed": False,
        "created_at": datetime.utcnow().isoformat()
    }

    # Envia email de confirmação
    confirmation_token = secrets.token_urlsafe(32)
    html = f"""
    <html>
        <body style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
            <h2 style="color: #0066cc;">Bem-vindo à Avila Inc!</h2>
            <p>Olá, {user.name}!</p>
            <p>Obrigado por se cadastrar. Confirme seu email clicando no botão abaixo:</p>
            <a href="https://auth.avila.inc/confirm/{confirmation_token}"
               style="display: inline-block; background: #0066cc; color: white;
                      padding: 12px 24px; text-decoration: none; border-radius: 4px; margin: 20px 0;">
                Confirmar Email
            </a>
            <p style="color: #666; font-size: 12px; margin-top: 30px;">
                Se você não criou esta conta, ignore este email.
            </p>
        </body>
    </html>
    """

    send_email(user.email, "Confirme seu cadastro - Avila Inc", html)

    return {
        "success": True,
        "message": "Usuário cadastrado! Verifique seu email para confirmar.",
        "email": user.email
    }

@app.post("/auth/login", response_model=dict)
async def login(credentials: UserLogin):
    """Login com email/senha"""

    # Verifica usuário
    user = users_db.get(credentials.email)
    if not user:
        raise HTTPException(status_code=401, detail="Credenciais inválidas")

    # Verifica senha
    if not verify_password(credentials.password, user["password"]):
        raise HTTPException(status_code=401, detail="Credenciais inválidas")

    # Gera código MFA
    mfa_code = str(secrets.randbelow(1000000)).zfill(6)
    mfa_codes[credentials.email] = {
        "code": mfa_code,
        "expires": (datetime.utcnow() + timedelta(minutes=5)).isoformat()
    }

    # Envia código por email
    html = f"""
    <html>
        <body style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; text-align: center;">
            <h2 style="color: #0066cc;">Código de Verificação</h2>
            <p>Seu código de verificação é:</p>
            <div style="font-size: 48px; font-weight: bold; color: #0066cc;
                        padding: 20px; background: #f0f0f0; border-radius: 8px; margin: 20px 0;">
                {mfa_code}
            </div>
            <p style="color: #666;">Este código expira em 5 minutos.</p>
        </body>
    </html>
    """

    send_email(credentials.email, "Código de Verificação - Avila Inc", html)

    return {
        "success": True,
        "requires_mfa": True,
        "message": "Código enviado para seu email"
    }

@app.post("/auth/mfa/verify", response_model=TokenResponse)
async def verify_mfa(email: EmailStr, code: str):
    """Verificar código MFA e retornar token"""

    # Verifica código
    mfa = mfa_codes.get(email)
    if not mfa:
        raise HTTPException(status_code=400, detail="Código não encontrado")

    if datetime.fromisoformat(mfa["expires"]) < datetime.utcnow():
        del mfa_codes[email]
        raise HTTPException(status_code=400, detail="Código expirado")

    if mfa["code"] != code:
        raise HTTPException(status_code=400, detail="Código inválido")

    # Remove código usado
    del mfa_codes[email]

    # Busca usuário
    user = users_db[email]

    # Gera JWT
    token = create_jwt(user["id"], user["email"])
    expires_at = int((datetime.utcnow() + timedelta(seconds=JWT_EXPIRATION)).timestamp())

    return TokenResponse(
        token=token,
        expires_at=expires_at,
        user={
            "id": user["id"],
            "email": user["email"],
            "name": user["name"],
            "company": user.get("company")
        }
    )

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
