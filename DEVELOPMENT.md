# Guia de Desenvolvimento - Avila Portal

## Quick Start

### 1. Clone o repositório
```bash
git clone https://github.com/avilaops/portal.git
cd portal
```

### 2. Setup (escolha um)

**Opção A: Docker (Mais Rápido)**
```bash
./quickstart.sh      # Linux/Mac
quickstart.bat       # Windows
```

**Opção B: Manual**
```bash
./setup.sh           # Linux/Mac
setup.bat            # Windows
```

### 3. Configure o .env
```bash
cd backend
cp .env.example .env
# Edite .env com suas configurações
```

### 4. Inicie os serviços

**Terminal 1 - Backend**
```bash
cd backend
cargo run
```

**Terminal 2 - Frontend**
```bash
cd frontend
trunk serve --open
```

## Estrutura do Código

### Backend (backend/src/)
```
main.rs           ? Entry point, HTTP server
config.rs         ? Variáveis de ambiente
error.rs          ? Error handling personalizado
models.rs         ? Database models
auth.rs           ? Serviço de autenticação JWT
handlers/         ? Endpoints HTTP
  ??? auth_handlers.rs
  ??? product_handlers.rs
  ??? dashboard_handlers.rs
  ??? health_handlers.rs
middleware/       ? Middlewares customizados
  ??? auth_middleware.rs
services/         ? Business logic
  ??? user_service.rs
  ??? product_service.rs
```

### Frontend (frontend/src/)
```
main.rs           ? Entry point, Router
pages/            ? Páginas da aplicação
  ??? home.rs
  ??? login.rs
  ??? register.rs
  ??? dashboard.rs
  ??? products.rs
components/       ? Componentes reutilizáveis
  ??? navbar.rs
services/         ? API client
  ??? api.rs
```

## Comandos Úteis

### Desenvolvimento
```bash
# Backend
cd backend
cargo run                    # Rodar
cargo watch -x run          # Hot reload
cargo test                  # Testes
cargo clippy                # Linter

# Frontend
cd frontend
trunk serve                 # Dev server
trunk serve --open          # Dev + abrir browser
trunk build --release       # Build produção
```

### Database
```bash
cd backend
sqlx migrate run            # Rodar migrações
sqlx migrate revert         # Reverter última migração
sqlx migrate add <name>     # Criar nova migração
```

### Docker
```bash
docker-compose up           # Iniciar tudo
docker-compose up -d        # Background
docker-compose down         # Parar tudo
docker-compose logs -f      # Ver logs
```

## Padrões de Código

### Rust Style
- Use `rustfmt` antes de commitar
- Run `cargo clippy` para lints
- Siga convenções do [Rust Style Guide](https://doc.rust-lang.org/1.0.0/style/)

### Naming
- Variáveis: `snake_case`
- Funções: `snake_case`
- Structs: `PascalCase`
- Constants: `UPPER_SNAKE_CASE`

### Error Handling
```rust
// ? Não use .unwrap() em produção
let value = something.unwrap();

// ? Use Result e ?
let value = something?;

// ? Ou match para handling específico
let value = match something {
    Ok(v) => v,
    Err(e) => return Err(ApiError::from(e)),
};
```

### Async/Await
```rust
// ? Use async/await para I/O
pub async fn get_user(pool: &PgPool, id: Uuid) -> Result<User, ApiError> {
    let user = sqlx::query_as::<_, User>("SELECT * FROM users WHERE id = $1")
        .bind(id)
        .fetch_one(pool)
        .await?;
    
    Ok(user)
}
```

## Adicionando Features

### 1. Nova Tabela no Banco
```bash
cd backend
sqlx migrate add create_table_name
```

Edite o arquivo criado em `backend/migrations/`:
```sql
CREATE TABLE table_name (
    id UUID PRIMARY KEY,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

### 2. Novo Model
Em `backend/src/models.rs`:
```rust
#[derive(Debug, Clone, FromRow, Serialize, Deserialize)]
pub struct TableName {
    pub id: Uuid,
    pub created_at: DateTime<Utc>,
}
```

### 3. Novo Endpoint
Em `backend/src/handlers/`:
```rust
pub async fn handler_name(
    pool: web::Data<PgPool>,
) -> Result<HttpResponse, ApiError> {
    // Sua lógica aqui
    Ok(HttpResponse::Ok().json(ApiResponse::success(data)))
}
```

Registre em `handlers/mod.rs`:
```rust
.route("/path", web::get().to(handler_name))
```

### 4. Nova Página Frontend
Em `frontend/src/pages/`:
```rust
use yew::prelude::*;

#[function_component(NewPage)]
pub fn new_page() -> Html {
    html! {
        <div class="new-page">
            <h1>{"Nova Página"}</h1>
        </div>
    }
}
```

Adicione a rota em `main.rs`:
```rust
#[derive(Clone, Routable, PartialEq)]
pub enum Route {
    #[at("/new")]
    NewPage,
}

fn switch(routes: Route) -> Html {
    match routes {
        Route::NewPage => html! { <NewPage /> },
    }
}
```

## Testes

### Backend
```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[actix_web::test]
    async fn test_something() {
        // Arrange
        let pool = setup_test_db().await;
        
        // Act
        let result = function_to_test(&pool).await;
        
        // Assert
        assert!(result.is_ok());
    }
}
```

### Frontend
```rust
#[cfg(test)]
mod tests {
    use super::*;
    use yew::functional::function_component;

    #[test]
    fn test_component() {
        // Testes de componente
    }
}
```

## Debugging

### Backend
```bash
# Com logs
RUST_LOG=debug cargo run

# Com VSCode
# Use a configuração de launch em .vscode/launch.json
```

### Frontend
```bash
# Console do browser
# Yew mostra logs no DevTools
```

## Troubleshooting

### "sqlx migrate run" falha
```bash
# Verifique DATABASE_URL em .env
# Certifique-se que PostgreSQL está rodando
docker-compose up -d postgres
```

### Frontend não compila WASM
```bash
# Reinstale target
rustup target add wasm32-unknown-unknown

# Reinstale trunk
cargo install trunk --force
```

### Erro de CORS
```bash
# Verifique FRONTEND_URL em backend/.env
# Deve ser http://localhost:8080
```

## CI/CD

O projeto usa GitHub Actions:
- `.github/workflows/ci.yml`

Triggers:
- Push em `main` ou `develop`
- Pull requests

Steps:
1. Testes
2. Build backend
3. Build frontend
4. Deploy (se main)

## Performance

### Backend
- Use connection pooling (SQLx)
- Cache queries frequentes (Redis)
- Use indexes no PostgreSQL

### Frontend
- Minimize WASM bundle
- Lazy load componentes pesados
- Use `use_memo` para cálculos caros

## Segurança

### Checklist
- [ ] Nunca commitar .env
- [ ] Validar inputs do usuário
- [ ] Sanitizar SQL queries (use SQLx)
- [ ] Use HTTPS em produção
- [ ] Rate limit APIs
- [ ] Audit logs

## Deploy

### Staging
```bash
git push origin develop
# Auto-deploy via CI/CD
```

### Production
```bash
git push origin main
# Manual approval + deploy
```

## Resources

- [Actix Web](https://actix.rs/)
- [Yew Framework](https://yew.rs/)
- [SQLx](https://github.com/launchbadge/sqlx)
- [Rust Book](https://doc.rust-lang.org/book/)
- [WebAssembly](https://webassembly.org/)

## Suporte

- GitHub Issues: https://github.com/avilaops/portal/issues
- Email: contato@avila.inc
