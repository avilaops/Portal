
| Produto                | URL                           | Descrição                            |
| ---------------------- | ----------------------------- | ------------------------------------ |
| **Avila Vault**        | vault.avila.inc               | Secrets management inteligente       |
| **Avila Pulse**        | pulse.avila.inc               | Hub de telemetria executiva          |
| **On Platform**        | on.avila.inc                  | Multi-Agent AI Platform              |
| **Darwin**             | darwin.avila.inc              | Self-healing autônomo                |
| **AgentHub**           | agenthub.avila.inc            | Orquestração de agentes IA           |
| **Camacho**            | camacho.avila.inc             | Gestão inteligente de cardápios      |
| **Geolocation**        | geolocation.avila.inc         | Inteligência geoespacial             |
| **Barbara**            | barbara.avila.inc             | Plataforma 3D WebGL                  |
| **MRG**                | mrgcaixastermicas.com.br      | Logística refrigerada                |
| **Reports Automation** | portal.avila.inc/reports.html | Framework de automação de relatórios |

## 🔧 Desenvolvimento Local

```bash
# Opção 1: Servidor Python simples
cd Portal
python -m http.server 8000

# Opção 2: Live Server (VS Code)
# Instalar extensão Live Server e clicar com botão direito em index.html

# Opção 3: SWA CLI
swa start . --port 8000
```

Acesse: http://localhost:8000

## 🎨 Customização

### **Cores** (em `styles.css`)
```css
:root {
    --primary: #6366f1;      /* Indigo */
    --secondary: #8b5cf6;    /* Purple */
    --accent: #ec4899;       /* Pink */
}
```

### **Adicionar Novo Produto**
Editar `index.html`, seção `.products-grid`:

```html
<div class="product-card">
    <div class="product-icon">🆕</div>
    <h3>Novo Produto</h3>
    <p class="product-description">Descrição...</p>
    <ul class="product-features">
        <li>✓ Feature 1</li>
        <li>✓ Feature 2</li>
    </ul>
    <div class="product-footer">
        <a href="https://produto.avila.inc" class="product-link">
            Acessar →
        </a>
        <span class="product-status online">● Online</span>
    </div>
</div>
```

## 📈 Performance

- **Lighthouse Score**: 95+ (Mobile & Desktop)
- **Load Time**: < 1s (first paint)
- **Bundle Size**: < 50KB (total)
- **Zero dependencies**: Vanilla JS

## 🔐 Segurança

- ✅ HTTPS only
- ✅ Content Security Policy headers
- ✅ No inline scripts (CSP compliant)
- ✅ XSS protection
- ✅ CORS configurado

## 📝 TODO / Roadmap

- [ ] Adicionar sistema de autenticação (Portal do Cliente)
- [ ] Integrar com API de contato real
- [ ] Adicionar blog/notícias
- [ ] Dashboard de métricas dos produtos
- [ ] Suporte a internacionalização (i18n)
- [ ] PWA (Progressive Web App)
- [ ] Analytics integration (Plausible/Umami)

## 🤝 Contribuição

1. Clone o repositório
2. Faça suas modificações
3. Teste localmente
4. Commit e push
5. Deploy automático via GitHub Actions (futuro)

## 📞 Suporte

- **Email**: contato@avila.inc
- **Documentação**: https://docs.avila.inc
- **Status**: https://status.avila.inc

---

**© 2025 Avila Inc** - Transformando negócios com IA 🚀
# Portal
