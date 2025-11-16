# 🌐 Portal Avila Inc

**Landing page institucional da Avila Inc** - Plataforma centralizada que apresenta todos os produtos e soluções com IA.

## 🎯 Objetivo

Portal principal que serve como:
- **Landing page institucional** da Avila Inc
- **Catálogo de produtos** (Darwin, AgentHub, Camacho, Geolocation, Barbara, MRG)
- **Ponto de entrada** para clientes e prospects
- **Hub de navegação** para todos os serviços Avila

## 🏗️ Arquitetura

### **Stack Tecnológica**
- **Frontend**: HTML5 + CSS3 + JavaScript Vanilla
- **Hospedagem**: Azure Static Web Apps
- **DNS**: Porkbun API (portal.avila.inc)
- **Deployment**: SWA CLI

### **Estrutura de Arquivos**
```
Portal/
├── index.html          # Página principal
├── styles.css          # Estilos responsivos
├── script.js           # Interatividade e animações
└── README.md           # Este arquivo
```

## ✨ Features

### **Design Moderno**
- ✅ Gradientes e animações suaves
- ✅ Totalmente responsivo (mobile-first)
- ✅ Dark mode ready
- ✅ Acessibilidade (ARIA labels)

### **Seções**
1. **Hero** - Apresentação com CTA principal
2. **Produtos** - Grid com todos os 6 produtos Avila
3. **Tech Stack** - Tecnologias utilizadas
4. **Sobre** - História e valores da empresa
5. **Contato** - Formulário e informações

### **Interatividade**
- ✅ Smooth scroll
- ✅ Animações on-scroll (Intersection Observer)
- ✅ Formulário de contato funcional
- ✅ Status em tempo real dos produtos
- ✅ Mobile menu responsivo

## 🚀 Deploy

### **Azure Static Web App**
```bash
# 1. Criar Static Web App
az staticwebapp create \
  --name portal-avila \
  --resource-group rg-avila-frontend-prod \
  --location eastus2

# 2. Obter token de deploy
TOKEN=$(az staticwebapp secrets list \
  --name portal-avila \
  --resource-group rg-avila-frontend-prod \
  --query "properties.apiKey" -o tsv)

# 3. Deploy via SWA CLI
cd Portal
swa deploy . --deployment-token $TOKEN
```

### **DNS Configuration**
```bash
# Configurar portal.avila.inc via Porkbun API
python ../Scripts/configure_portal_dns.py
```

## 🌐 URLs

- **Produção**: https://portal.avila.inc
- **Azure Preview**: https://[random].azurestaticapps.net

## 📊 Produtos Integrados

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
