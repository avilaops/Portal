# ?? Guia de Contribuição

Obrigado por considerar contribuir com o Avila Portal!

## ?? Como Contribuir

### 1. Fork o Repositório

```bash
# Via GitHub UI ou CLI
gh repo fork avilaops/portal
```

### 2. Clone seu Fork

```bash
git clone https://github.com/SEU_USERNAME/portal.git
cd portal
```

### 3. Configure o Upstream

```bash
git remote add upstream https://github.com/avilaops/portal.git
```

### 4. Crie uma Branch

```bash
git checkout -b feature/minha-feature
# ou
git checkout -b fix/meu-bugfix
```

### 5. Faça suas Mudanças

Siga os padrões de código do projeto (veja abaixo).

### 6. Teste

```bash
# Testes
cargo test --all

# Clippy
cargo clippy -- -D warnings

# Formatação
cargo fmt
```

### 7. Commit

```bash
git add .
git commit -m "tipo: descrição curta

Descrição detalhada do que foi feito e por quê.
"
```

#### Tipos de Commit
- `feat`: Nova funcionalidade
- `fix`: Correção de bug
- `docs`: Mudanças em documentação
- `style`: Formatação, espaços em branco
- `refactor`: Refatoração de código
- `perf`: Melhorias de performance
- `test`: Adição ou correção de testes
- `chore`: Tarefas de build, CI, etc

### 8. Push

```bash
git push origin feature/minha-feature
```

### 9. Pull Request

Abra um PR no GitHub seguindo o template.

---

## ?? Padrões de Código

### Rust

```rust
// ? Bom
pub async fn get_user(pool: &PgPool, id: Uuid) -> Result<User, ApiError> {
    let user = sqlx::query_as::<_, User>("SELECT * FROM users WHERE id = $1")
        .bind(id)
        .fetch_one(pool)
        .await?;
    
    Ok(user)
}

// ? Evite
pub async fn get_user(pool: &PgPool, id: Uuid) -> User {
    let user = sqlx::query_as::<_, User>("SELECT * FROM users WHERE id = $1")
        .bind(id)
        .fetch_one(pool)
        .await
        .unwrap(); // Nunca use unwrap!
    
    user
}
```

### Naming
- Variáveis: `snake_case`
- Funções: `snake_case`
- Structs/Enums: `PascalCase`
- Constantes: `UPPER_SNAKE_CASE`
- Arquivos: `snake_case.rs`

### Error Handling
- Use `Result<T, E>` sempre
- Use `?` para propagar erros
- Crie errors customizados quando apropriado
- Nunca use `.unwrap()` em produção

### Async
- Use `async/await` para I/O
- Evite blocking calls
- Use `tokio::spawn` para tasks paralelas

---

## ?? Testes

### Estrutura
```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[actix_web::test]
    async fn test_create_user() {
        // Arrange
        let pool = setup_test_db().await;
        let user_data = UserData { /* ... */ };
        
        // Act
        let result = create_user(&pool, user_data).await;
        
        // Assert
        assert!(result.is_ok());
        let user = result.unwrap();
        assert_eq!(user.email, "test@example.com");
    }
}
```

### Coverage
- Mínimo: 70%
- Ideal: 80%+
- Crítico: 100% (auth, security)

---

## ?? Documentação

### Código
```rust
/// Cria um novo usuário no sistema.
///
/// # Arguments
/// * `pool` - Connection pool do PostgreSQL
/// * `data` - Dados do usuário a ser criado
///
/// # Returns
/// * `Ok(User)` - Usuário criado com sucesso
/// * `Err(ApiError)` - Erro ao criar usuário
///
/// # Example
/// ```
/// let user = create_user(&pool, user_data).await?;
/// ```
pub async fn create_user(pool: &PgPool, data: UserData) -> Result<User, ApiError> {
    // ...
}
```

### README
Se adicionar nova funcionalidade, atualize:
- README.md
- ARCHITECTURE.md (se relevante)
- DEVELOPMENT.md (se muda workflow)

---

## ?? Code Review

### O que procuramos:
- ? Código limpo e legível
- ? Testes adequados
- ? Documentação atualizada
- ? Sem breaking changes (ou bem documentados)
- ? Performance considerada
- ? Segurança verificada

### Checklist do Revisor:
- [ ] Código faz o que promete
- [ ] Testes cobrem casos importantes
- [ ] Sem vazamento de memória
- [ ] Sem race conditions
- [ ] Error handling apropriado
- [ ] Docs atualizadas

---

## ?? O que NÃO fazer

### ? Evite
- Commitar arquivos `.env`
- Hardcoded secrets
- `unwrap()` sem verificação
- Comentários TODO sem issue
- Breaking changes sem aviso
- Código não testado
- Mudanças de formatação massivas

### ?? Cuidado com
- Mudanças em migrations (crie novas)
- Alterações em APIs públicas
- Dependências novas (justifique)
- Configurações de produção

---

## ?? Comunicação

### Onde Discutir
- **Issues**: Bugs e features
- **Discussions**: Perguntas gerais
- **PR Comments**: Code review
- **Email**: contato@avila.inc

### Seja Respeitoso
- Linguagem profissional
- Feedback construtivo
- Paciência com iniciantes
- Reconheça contribuições

---

## ?? Reconhecimento

Contribuidores são listados em:
- README.md (Contributors section)
- CHANGELOG.md (por feature)
- Release notes

---

## ?? Licença

Ao contribuir, você concorda que suas contribuições serão licenciadas sob a [MIT License](LICENSE).

---

## ? Perguntas?

- ?? Email: contato@avila.inc
- ?? Discussions: github.com/avilaops/portal/discussions
- ?? Issues: github.com/avilaops/portal/issues

---

**Obrigado por contribuir! ??**
