FROM rust:1.91 as backend-builder

WORKDIR /app

# Copiar todos arquivos workspace
COPY Cargo.toml Cargo.lock ./
COPY shared/ ./shared/
COPY backend/ ./backend/
COPY frontend/ ./frontend/

# Build backend
WORKDIR /app/backend
RUN cargo build --release

# Build frontend
FROM rust:1.91 as frontend-builder

RUN cargo install trunk
RUN rustup target add wasm32-unknown-unknown

WORKDIR /app

COPY Cargo.toml Cargo.lock ./
COPY shared/ ./shared/
COPY frontend/ ./frontend/

WORKDIR /app/frontend
RUN trunk build --release

# Runtime
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    ca-certificates \
    libssl3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copiar bin�rio do backend
COPY --from=backend-builder /app/target/release/server /app/server

# Copiar frontend buildado
COPY --from=frontend-builder /app/frontend/dist /app/static

# Copiar migrations
COPY backend/migrations /app/migrations

ENV HOST=0.0.0.0
ENV PORT=8080

EXPOSE 8080

CMD ["/app/server"]
