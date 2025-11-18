# 🎨 Processador de Ícones 2025

Ferramenta completa para gerar ícones otimizados para todas as plataformas modernas.

## 📋 Funcionalidades

- ✅ **Remoção automática de fundo** das imagens
- ✅ **Detecção inteligente de conteúdo** (preserva desenhos e círculos)
- ✅ **Geração de 47+ ícones** para cada imagem
- ✅ **Interface gráfica** com botão e progresso em tempo real
- ✅ **Arquivos auxiliares**: manifest.json, html_snippet.txt, favicon.ico

## 🎯 Plataformas Suportadas

### 🌐 Web
- **Favicon**: 16, 32, 48, 64 + favicon.ico multi-size
- **PWA**: manifest.json completo

### 🍎 Apple (iOS/iPadOS/macOS)
- **10 tamanhos**: 57, 60, 72, 76, 120, 144, 152, 167, 180, 1024
- Cobre: iPhone, iPad, iPad Pro, App Store

### 🤖 Android
- **7 tamanhos**: 36, 48, 72, 96, 144, 192, 512
- Legacy + Chrome + PWA

### 🪟 Windows
- **5 tiles**: 44x44, 70x70, 150x150, 310x150 (retangular), 310x310
- Taskbar, Small Tile, Medium Tile, Wide Tile, Large Tile

### 💻 macOS
- **7 tamanhos**: 16, 32, 64, 128, 256, 512, 1024
- Para apps nativos (ICNS)

### 📱 Redes Sociais
- **5 tamanhos**: 300, 400, 720, 800, 1080
- LinkedIn, X/Twitter, Facebook, YouTube, Instagram

## 🚀 Como Usar

### Opção 1: Interface Gráfica (Recomendado)

#### Windows:
1. Duplo clique em `Processar_Icones.bat`
2. Selecione a pasta com as imagens
3. Clique em "🚀 PROCESSAR IMAGENS"

#### Linha de comando:
```bash
python icon_processor_gui.py
```

### Opção 2: Script Python Direto

```bash
python process_icons.py
```

## 📦 Dependências

```bash
pip install rembg pillow numpy
```

O arquivo `.bat` instala automaticamente as dependências se necessário.

## 📊 Estrutura de Saída

Para cada imagem processada:

```
icons_processed/
└── nome-da-imagem/
    ├── nome-da-imagem_no_bg.png         # Imagem original sem fundo
    ├── favicon.ico                       # Multi-size ICO
    ├── manifest.json                     # PWA manifest
    ├── html_snippet.txt                  # Meta tags prontas
    ├── icon_favicon_16x16.png
    ├── icon_favicon_32x32.png
    ├── icon_apple_180x180.png
    ├── icon_android_192x192.png
    ├── icon_windows_150x150.png
    ├── icon_windows_310x150.png          # Retangular (Wide Tile)
    ├── icon_mac_512x512.png
    ├── icon_social_1080x1080.png
    └── ... (47+ ícones no total)
```

## 🎨 Recursos Avançados

### Detecção Inteligente de Conteúdo
- Analisa pixels não-transparentes
- Preserva círculos e desenhos complexos
- Adiciona padding proporcional (2-5% dependendo da plataforma)

### Suporte a Ícones Retangulares
- Windows Wide Tile (310x150)
- Centralização automática
- Padding proporcional (15x7 px)

### Arquivos Auxiliares

#### manifest.json
```json
{
  "name": "My App",
  "icons": [
    {"src": "icon_android_192x192.png", "sizes": "192x192", "type": "image/png"}
  ],
  "theme_color": "#ffffff",
  "display": "standalone"
}
```

#### html_snippet.txt
Contém todas as meta tags prontas para copiar:
```html
<link rel="icon" href="favicon.ico">
<link rel="apple-touch-icon" sizes="180x180" href="icon_apple_180x180.png">
<link rel="manifest" href="manifest.json">
<meta property="og:image" content="icon_social_1080x1080.png">
```

## 🛠️ Arquivos do Projeto

- `process_icons.py` - Motor principal de processamento
- `icon_processor_gui.py` - Interface gráfica com Tkinter
- `Processar_Icones.bat` - Executável Windows com verificações automáticas

## 💡 Dicas de Uso

1. **Formato recomendado**: PNG com fundo transparente (processador remove automaticamente)
2. **Conteúdo ideal**: Imagens quadradas ou circulares
3. **Resolução mínima**: 512x512 px (ideal: 1024x1024 ou maior)
4. **Para redes sociais**: Use padding de 2% (já configurado)
5. **Para ícones de apps**: Use padding de 5% (já configurado)

## 📈 Benchmarks

- Processamento de 1 imagem: ~15-30 segundos
- Geração de 47 ícones + 3 arquivos auxiliares
- Remoção de fundo: ~10-20 segundos (primeira vez baixa modelo)

## 🔧 Troubleshooting

### Erro: "Python não encontrado"
Instale Python 3.x de https://www.python.org/downloads/

### Erro: "rembg não encontrado"
Execute: `pip install rembg pillow numpy`

### Interface não abre
Verifique se tkinter está instalado:
```bash
python -c "import tkinter"
```

Se der erro, reinstale Python marcando "tcl/tk" durante instalação.

## 📝 Changelog

### v1.0 (2025-11-17)
- ✅ Geração de 47+ ícones para todas as plataformas
- ✅ Interface gráfica com progresso em tempo real
- ✅ Suporte a ícones retangulares (Windows Wide Tile)
- ✅ Detecção inteligente de conteúdo
- ✅ Geração de manifest.json e HTML snippets
- ✅ Padding configurável por plataforma
- ✅ Remoção automática de fundo

## 📄 Licença

Parte do Portal Avilaops - Ferramentas internas

---

**Desenvolvido para:** Portal Avilaops
**Data:** Novembro 2025
**Versão:** 1.0
