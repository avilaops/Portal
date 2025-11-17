## ?? Descrição

Descreva de forma clara e concisa as mudanças feitas neste PR.

## ?? Tipo de Mudança

- [ ] ?? Bug fix (mudança que corrige um problema)
- [ ] ? Nova feature (mudança que adiciona funcionalidade)
- [ ] ?? Breaking change (fix ou feature que quebra compatibilidade)
- [ ] ?? Documentação (mudanças apenas em documentação)
- [ ] ?? Estilo (formatação, identação, etc)
- [ ] ?? Refactoring (mudança que não corrige bug nem adiciona feature)
- [ ] ? Performance (mudança que melhora performance)
- [ ] ? Testes (adição ou correção de testes)

## ?? Issue Relacionada

Closes #(issue)

## ?? Screenshots

Se aplicável, adicione screenshots das mudanças visuais.

## ? Checklist

### Código
- [ ] O código segue o style guide do projeto
- [ ] Realizei self-review do meu código
- [ ] Comentei partes complexas do código
- [ ] Atualizei a documentação relevante
- [ ] Minhas mudanças não geram novos warnings
- [ ] Adicionei testes que provam que meu fix funciona ou feature funciona
- [ ] Testes novos e existentes passam localmente
- [ ] Mudanças dependentes foram mergeadas

### Backend (se aplicável)
- [ ] Migrations adicionadas/atualizadas
- [ ] Endpoints documentados
- [ ] Error handling implementado
- [ ] Testes unitários adicionados
- [ ] `cargo clippy` passou sem warnings
- [ ] `cargo fmt` executado

### Frontend (se aplicável)
- [ ] Componentes documentados
- [ ] Design responsivo testado
- [ ] Estados de loading/error implementados
- [ ] Acessibilidade considerada
- [ ] Build WASM funciona (`trunk build`)

### DevOps (se aplicável)
- [ ] Docker build funciona
- [ ] Variáveis de ambiente documentadas
- [ ] CI/CD atualizado se necessário

## ?? Como Testar

Descreva os passos para testar as mudanças:

1. Setup inicial: ...
2. Execute: ...
3. Verifique que: ...
4. Teste edge case: ...

## ?? Performance

Se aplicável, descreva impacto na performance:

- Bundle size: antes X KB ? depois Y KB
- Load time: antes X ms ? depois Y ms
- Memory: antes X MB ? depois Y MB

## ?? Segurança

- [ ] Não introduz vulnerabilidades de segurança
- [ ] Validação de inputs implementada
- [ ] Autenticação/autorização verificada
- [ ] Dados sensíveis não expostos

## ?? Documentação Atualizada

- [ ] README.md
- [ ] ARCHITECTURE.md
- [ ] DEVELOPMENT.md
- [ ] CHANGELOG.md
- [ ] API docs
- [ ] Comentários inline

## ?? Deployment

- [ ] Testado localmente
- [ ] Testado em staging
- [ ] Pronto para produção
- [ ] Requer migração de banco
- [ ] Requer variável de ambiente nova
- [ ] Requer rollout especial

## ?? Revisores Sugeridos

@username1, @username2

## ?? Notas Adicionais

Informações extras para os revisores.
