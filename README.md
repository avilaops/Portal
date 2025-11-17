# 🦀 Portal Avila

> Full-stack enterprise portal built with **100% Rust** + **WebAssembly**

[![Rust](https://img.shields.io/badge/Rust-1.91+-orange.svg)](https://www.rust-lang.org/)
[![WASM](https://img.shields.io/badge/WebAssembly-Supported-blue.svg)](https://webassembly.org/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Deploy](https://img.shields.io/badge/Deploy-GitHub%20Pages-success.svg)](https://avilaops.github.io/Portal/)

Enterprise-grade portal managing **10 integrated products** with real-time dashboards, JWT authentication, and modern full-stack Rust architecture.

---

## ✨ Features

- 🦀 **100% Rust** - Backend and Frontend
- ⚡ **WebAssembly** - Native performance in browser
- 🔐 **JWT Auth** - Secure authentication system
- 🗄️ **SQLite** - Zero-config database
- 📊 **Dashboard** - Real-time metrics
- 🛍️ **10 Products** - Integrated product catalog
- 🐳 **Docker Ready** - One-command deployment
- 🚀 **GitHub Actions** - CI/CD pipeline

---

## 🏗️ Architecture

```
Frontend (Yew + WASM)  →  Backend (Actix)  →  SQLite
     ↓                        ↓                   ↓
  Routing                 REST API            Products
  Components              JWT Auth            Users
  State Mgmt              CORS                Activities
```

**Tech Stack:**
- **Frontend**: Rust → Yew → WebAssembly
- **Backend**: Rust → Actix-web → SQLx
- **Database**: SQLite (dev) / PostgreSQL (prod)
- **Auth**: JWT + bcrypt

---

## 🚀 Quick Start

### Prerequisites
- Rust 1.91+ ([Install](https://rustup.rs/))
- Trunk (`cargo install trunk`)

### Run Locally

**Option 1: Scripts (Windows)**
```powershell
.\run-backend.bat   # Terminal 1
.\run-frontend.bat  # Terminal 2
```

**Option 2: Manual**
```bash
# Terminal 1: Backend
cd backend
cargo run --bin server

# Terminal 2: Frontend  
cd frontend
trunk serve --open
```

**Access**: http://127.0.0.1:8081

---

## 📦 Integrated Products

| Product | URL | Category |
|---------|-----|----------|
| **Avila Vault** | vault.avila.inc | 🔐 Security |
| **Avila Pulse** | pulse.avila.inc | 📊 Analytics |
| **On Platform** | on.avila.inc | 🧠 AI |
| **Darwin** | darwin.avila.inc | 🔄 Infrastructure |
| **AgentHub** | agenthub.avila.inc | 🤖 AI |
| **Camacho** | camacho.avila.inc | 📋 SaaS |
| **Geolocation** | geolocation.avila.inc | 📍 AI |
| **Barbara** | barbara.avila.inc | 🎮 SaaS |
| **MRG** | mrgcaixastermicas.com.br | 📦 SaaS |
| **Reports** | portal.avila.inc/reports | 📊 Analytics |

---

## 🛠️ Development

### Setup
```bash
make setup
# or
rustup target add wasm32-unknown-unknown
cargo install trunk
```

### Build
```bash
make build
# or
cargo build --release --workspace
```

### Test
```bash
make test
# or
cargo test --all
```

---

## 🐳 Docker

```bash
docker-compose up
```

Access: http://localhost:8080

---

## 📚 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/health` | Health check |
| POST | `/api/auth/login` | User login |
| POST | `/api/auth/register` | User registration |
| GET | `/api/auth/me` | Get current user |
| GET | `/api/products` | List all products |
| GET | `/api/products/{id}` | Get product by ID |
| GET | `/api/dashboard/metrics` | Dashboard metrics |

---

## 🔒 Security

- ✅ JWT authentication
- ✅ Password hashing (bcrypt)
- ✅ CORS configured
- ✅ Type-safe end-to-end
- ✅ No secrets in code
- ✅ SQL injection protection

---

## 📖 Documentation

- [Architecture](ARCHITECTURE.md)
- [Development Guide](DEVELOPMENT.md)
- [Contributing](CONTRIBUTING.md)
- [Security](SECURITY.md)
- [Changelog](CHANGELOG.md)

---

## 🤝 Contributing

Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md)

---

## 📄 License

MIT License - see [LICENSE](LICENSE)

---

## 🌟 Highlights

- **Type Safety**: Rust's compile-time guarantees
- **Performance**: WebAssembly native speed
- **Zero JS**: No Node.js, no npm, no webpack
- **Modern**: Latest Rust ecosystem tools
- **Production Ready**: Docker, CI/CD, monitoring

---

## 📞 Support

- **Email**: contato@avila.inc
- **Issues**: [GitHub Issues](https://github.com/avilaops/Portal/issues)
- **Docs**: [GitHub Pages](https://avilaops.github.io/Portal/)

---

**Made with 🦀 by [Avila Inc](https://avila.inc)**
