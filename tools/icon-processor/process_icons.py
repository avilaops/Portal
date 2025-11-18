"""
Script para processar imagens e criar ícones otimizados para diferentes plataformas
Remove o fundo e redimensiona para os tamanhos ideais de favicon e ícones de apps
"""

import os
from pathlib import Path
from rembg import remove
from PIL import Image, ImageDraw
import io
import numpy as np
import json

# Configurações de tamanhos para diferentes plataformas (2025)
ICON_SIZES = {
    'favicon': [16, 32, 48, 64],  # Favicon web (64x64 para Chrome/Firefox modernos)
    'apple': [57, 60, 72, 76, 120, 144, 152, 167, 180, 1024],  # iOS/iPadOS/macOS (App Store)
    'android': [36, 48, 72, 96, 144, 192, 512],  # Android (legacy + Chrome)
    'windows': [(44, 44), (70, 70), (150, 150), (310, 150), (310, 310)],  # Windows tiles + PWA
    'mac': [16, 32, 64, 128, 256, 512, 1024],  # macOS apps nativos (ICNS)
    'social': [300, 400, 720, 800, 1080],  # Redes sociais (LinkedIn, X, Facebook, YouTube, Instagram)
}

# Padding por plataforma (% do tamanho)
PADDING_CONFIG = {
    'favicon': 5,
    'apple': 5,
    'android': 5,
    'windows': 5,
    'mac': 5,
    'social': 2,  # Menor padding para perfis (evita cortes em círculos)
}

# Pasta de entrada e saída
INPUT_FOLDER = r'C:\Users\nicol\OneDrive\Avila\1.8 - Templates'
OUTPUT_FOLDER = os.path.join(INPUT_FOLDER, 'icons_processed')

# Extensões de imagem suportadas
SUPPORTED_EXTENSIONS = {'.png', '.jpg', '.jpeg', '.webp', '.bmp'}

def remove_background(image_path):
    """Remove o fundo da imagem"""
    print(f"Removendo fundo de: {os.path.basename(image_path)}")

    with open(image_path, 'rb') as input_file:
        input_data = input_file.read()

    # Remove o fundo
    output_data = remove(input_data)

    # Converte para imagem PIL
    image = Image.open(io.BytesIO(output_data))

    # Garante que está em RGBA
    if image.mode != 'RGBA':
        image = image.convert('RGBA')

    return image

def get_content_bounds(image):
    """Detecta os limites do conteúdo real da imagem (ignora transparência)"""
    # Converte para array numpy
    img_array = np.array(image)

    # Pega o canal alpha (transparência)
    if img_array.shape[2] == 4:  # RGBA
        alpha = img_array[:, :, 3]
    else:
        # Se não tem alpha, considera tudo como conteúdo
        return 0, 0, image.width, image.height

    # Encontra pixels não transparentes (alpha > 0)
    rows = np.any(alpha > 0, axis=1)
    cols = np.any(alpha > 0, axis=0)

    if not rows.any() or not cols.any():
        # Imagem totalmente transparente
        return 0, 0, image.width, image.height

    # Encontra os limites
    top = np.argmax(rows)
    bottom = len(rows) - np.argmax(rows[::-1])
    left = np.argmax(cols)
    right = len(cols) - np.argmax(cols[::-1])

    return left, top, right, bottom

def resize_image_smart(image, target_size, padding_percent=5):
    """
    Redimensiona a imagem de forma inteligente:
    1. Detecta os limites reais do conteúdo
    2. Adiciona padding proporcional
    3. Redimensiona mantendo o conteúdo visível e centralizado
    4. Suporta tamanhos quadrados (int) e retangulares (tuple)
    """
    # Suporta int (quadrado) ou tuple (retangular)
    if isinstance(target_size, int):
        target_width = target_height = target_size
    else:
        target_width, target_height = target_size

    # Detecta os limites do conteúdo real
    left, top, right, bottom = get_content_bounds(image)
    content_width = right - left
    content_height = bottom - top

    print(f"    📐 Conteúdo detectado: {content_width}x{content_height} px (posição: {left},{top} até {right},{bottom})")

    # Cria imagem com dimensões alvo e fundo transparente
    new_image = Image.new('RGBA', (target_width, target_height), (0, 0, 0, 0))

    # Calcula padding (margem interna)
    padding_x = int(target_width * (padding_percent / 100))
    padding_y = int(target_height * (padding_percent / 100))
    available_width = target_width - (2 * padding_x)
    available_height = target_height - (2 * padding_y)

    # Calcula a escala para caber no espaço disponível
    scale = min(available_width / content_width, available_height / content_height)

    # Calcula novo tamanho mantendo proporção do conteúdo original
    new_width = int(image.width * scale)
    new_height = int(image.height * scale)

    # Redimensiona a imagem completa (mantém posição relativa do conteúdo)
    resized = image.resize((new_width, new_height), Image.Resampling.LANCZOS)

    # Centraliza na imagem
    x = (target_width - new_width) // 2
    y = (target_height - new_height) // 2
    new_image.paste(resized, (x, y), resized)

    print(f"    ✓ Redimensionado para {new_width}x{new_height} px em canvas {target_width}x{target_height} (padding: {padding_x}x{padding_y} px)")

    return new_image

def save_icon(image, output_path, size, platform, padding_percent=5):
    """Salva o ícone no tamanho especificado (quadrado ou retangular)"""
    # Determina dimensões para exibição
    if isinstance(size, int):
        display_size = f"{size}x{size}"
        width = height = size
    else:
        width, height = size
        display_size = f"{width}x{height}"

    print(f"  📦 Criando ícone {platform} {display_size}:")
    resized = resize_image_smart(image.copy(), size, padding_percent)

    # Nome do arquivo com plataforma e tamanho
    filename = f"icon_{platform}_{width}x{height}.png"
    filepath = os.path.join(output_path, filename)

    # Otimização extra para tamanhos grandes (>= 512)
    optimize_level = True
    resized.save(filepath, 'PNG', optimize=optimize_level)
    print(f"    ✅ Salvo: {filename}\n")

    return filepath

def create_favicon_ico(images, output_path):
    """Cria um arquivo .ico com múltiplos tamanhos para favicon"""
    favicon_path = os.path.join(output_path, 'favicon.ico')

    # O primeiro tamanho será a imagem principal
    main_image = images[0]
    main_image.save(
        favicon_path,
        format='ICO',
        sizes=[(img.width, img.height) for img in images]
    )
    print(f"  ✓ Criado: favicon.ico (multi-size)")

def create_webmanifest(icon_files, output_path, app_name="My App"):
    """Cria manifest.json para PWA (Progressive Web App)"""
    manifest = {
        "name": app_name,
        "short_name": app_name,
        "icons": [],
        "theme_color": "#ffffff",
        "background_color": "#ffffff",
        "display": "standalone"
    }

    # Adiciona ícones Android e Windows
    for filepath in icon_files:
        filename = os.path.basename(filepath)
        if 'android' in filename or 'windows' in filename:
            # Extrai tamanho do nome do arquivo
            size_part = filename.split('_')[-1].replace('.png', '')
            manifest["icons"].append({
                "src": filename,
                "sizes": size_part,
                "type": "image/png",
                "purpose": "any maskable"
            })

    manifest_path = os.path.join(output_path, 'manifest.json')
    with open(manifest_path, 'w', encoding='utf-8') as f:
        json.dump(manifest, f, indent=2)

    print(f"  ✓ Criado: manifest.json (PWA)")
    return manifest_path

def create_html_snippet(icon_files, output_path):
    """Cria snippet HTML com meta tags para todos os ícones"""
    html_lines = [
        "<!-- Favicon e ícones de aplicação -->",
        "<!-- Copie estas tags para o <head> do seu HTML -->",
        ""
    ]

    # Favicon padrão
    html_lines.append('<!-- Favicon padrão -->')
    html_lines.append('<link rel="icon" type="image/x-icon" href="favicon.ico">')
    html_lines.append('<link rel="icon" type="image/png" sizes="32x32" href="icon_favicon_32x32.png">')
    html_lines.append('<link rel="icon" type="image/png" sizes="16x16" href="icon_favicon_16x16.png">')
    html_lines.append('')

    # Apple Touch Icons
    html_lines.append('<!-- Apple Touch Icons -->')
    for filepath in sorted(icon_files):
        filename = os.path.basename(filepath)
        if 'apple' in filename:
            size = filename.split('_')[-1].replace('.png', '').split('x')[0]
            html_lines.append(f'<link rel="apple-touch-icon" sizes="{size}x{size}" href="{filename}">')
    html_lines.append('')

    # Android/Chrome
    html_lines.append('<!-- Android/Chrome -->')
    html_lines.append('<link rel="manifest" href="manifest.json">')
    html_lines.append('<meta name="theme-color" content="#ffffff">')
    html_lines.append('')

    # Windows
    html_lines.append('<!-- Windows Tiles -->')
    html_lines.append('<meta name="msapplication-TileColor" content="#ffffff">')
    html_lines.append('<meta name="msapplication-TileImage" content="icon_windows_150x150.png">')
    html_lines.append('')

    # Social Media
    html_lines.append('<!-- Open Graph (Facebook, LinkedIn) -->')
    html_lines.append('<meta property="og:image" content="icon_social_1080x1080.png">')
    html_lines.append('<meta property="og:image:width" content="1080">')
    html_lines.append('<meta property="og:image:height" content="1080">')
    html_lines.append('')
    html_lines.append('<!-- Twitter Card -->')
    html_lines.append('<meta name="twitter:card" content="summary">')
    html_lines.append('<meta name="twitter:image" content="icon_social_400x400.png">')

    html_content = '\n'.join(html_lines)
    html_path = os.path.join(output_path, 'html_snippet.txt')

    with open(html_path, 'w', encoding='utf-8') as f:
        f.write(html_content)

    print(f"  ✓ Criado: html_snippet.txt (Meta tags)")
    return html_path

def process_images():
    """Processa todas as imagens da pasta"""

    # Cria pasta de saída se não existir
    os.makedirs(OUTPUT_FOLDER, exist_ok=True)

    print(f"\n{'='*60}")
    print(f"PROCESSADOR DE ÍCONES - Remoção de Fundo e Redimensionamento")
    print(f"{'='*60}\n")
    print(f"Pasta de entrada: {INPUT_FOLDER}")
    print(f"Pasta de saída: {OUTPUT_FOLDER}\n")

    # Lista todos os arquivos de imagem
    image_files = []
    for file in os.listdir(INPUT_FOLDER):
        if Path(file).suffix.lower() in SUPPORTED_EXTENSIONS:
            full_path = os.path.join(INPUT_FOLDER, file)
            if os.path.isfile(full_path):
                image_files.append(full_path)

    if not image_files:
        print("❌ Nenhuma imagem encontrada na pasta!")
        return

    print(f"Encontradas {len(image_files)} imagem(ns) para processar\n")

    # Processa cada imagem
    for img_path in image_files:
        base_name = Path(img_path).stem
        print(f"\n📸 Processando: {os.path.basename(img_path)}")
        print("-" * 60)

        try:
            # Remove o fundo
            image_no_bg = remove_background(img_path)

            # Cria pasta específica para esta imagem
            image_output_folder = os.path.join(OUTPUT_FOLDER, base_name)
            os.makedirs(image_output_folder, exist_ok=True)

            # Salva imagem sem fundo original
            original_no_bg = os.path.join(image_output_folder, f"{base_name}_no_bg.png")
            image_no_bg.save(original_no_bg, 'PNG')
            print(f"  ✓ Salva imagem sem fundo: {base_name}_no_bg.png")

            # Analisa o conteúdo da imagem
            left, top, right, bottom = get_content_bounds(image_no_bg)
            content_width = right - left
            content_height = bottom - top
            print(f"  📊 Análise da imagem:")
            print(f"     • Tamanho original: {image_no_bg.width}x{image_no_bg.height} px")
            print(f"     • Conteúdo real: {content_width}x{content_height} px")
            print(f"     • Posição: ({left}, {top}) até ({right}, {bottom})")

            # Detecta se é circular
            aspect_ratio = content_width / content_height if content_height > 0 else 1
            is_square = 0.9 <= aspect_ratio <= 1.1
            if is_square:
                print(f"     • Formato: Aproximadamente quadrado/circular ✓")
            else:
                print(f"     • Formato: Retangular ({aspect_ratio:.2f}:1)")

            # Gera ícones para cada plataforma
            favicon_images = []
            all_icon_files = []

            print(f"\n  🎨 Gerando ícones otimizados:")
            for platform, sizes in ICON_SIZES.items():
                # Pega padding configurado para a plataforma
                padding = PADDING_CONFIG.get(platform, 5)

                for size in sizes:
                    icon_path = save_icon(image_no_bg, image_output_folder, size, platform, padding)
                    all_icon_files.append(icon_path)

                    # Guarda imagens do favicon para criar .ico
                    if platform == 'favicon':
                        favicon_images.append(Image.open(icon_path))

            # Cria favicon.ico com múltiplos tamanhos
            if favicon_images:
                create_favicon_ico(favicon_images, image_output_folder)

            # Cria manifest.json para PWA
            print(f"\n  📄 Gerando arquivos auxiliares:")
            create_webmanifest(all_icon_files, image_output_folder, base_name)

            # Cria snippet HTML com meta tags
            create_html_snippet(all_icon_files, image_output_folder)

            print(f"\n  ✅ Concluído: {base_name}")

        except Exception as e:
            print(f"\n  ❌ Erro ao processar {os.path.basename(img_path)}: {str(e)}")

    print(f"\n{'='*70}")
    print(f"✅ PROCESSAMENTO CONCLUÍDO!")
    print(f"{'='*70}")
    print(f"\nTodos os ícones foram salvos em: {OUTPUT_FOLDER}")
    print(f"\n📱 Tamanhos gerados por plataforma (2025):")
    print(f"\n  🌐 Favicon (Web):")
    print(f"     • 16x16, 32x32, 48x48, 64x64 + favicon.ico")
    print(f"\n  🍎 Apple (iOS/iPadOS/macOS):")
    print(f"     • 57, 60, 72, 76, 120, 144, 152, 167, 180, 1024")
    print(f"     • iPhone, iPad, iPad Pro, App Store")
    print(f"\n  🤖 Android:")
    print(f"     • 36, 48, 72, 96, 144, 192, 512")
    print(f"     • Legacy + Chrome + PWA")
    print(f"\n  🪟 Windows:")
    print(f"     • 44x44, 70x70, 150x150, 310x150, 310x310")
    print(f"     • Taskbar, Small Tile, Medium Tile, Wide Tile, Large Tile")
    print(f"\n  💻 macOS:")
    print(f"     • 16, 32, 64, 128, 256, 512, 1024")
    print(f"     • Apps nativos (ICNS)")
    print(f"\n  📱 Redes Sociais:")
    print(f"     • 300 (LinkedIn), 400 (X/Twitter), 720 (Facebook)")
    print(f"     • 800 (YouTube), 1080 (Instagram)")
    print(f"\n  📄 Arquivos auxiliares:")
    print(f"     • manifest.json (PWA - Progressive Web App)")
    print(f"     • html_snippet.txt (Meta tags prontas para copiar)")
    print(f"\n{'='*70}")

if __name__ == "__main__":
    try:
        process_images()
    except KeyboardInterrupt:
        print("\n\n⚠️  Processamento interrompido pelo usuário")
    except Exception as e:
        print(f"\n\n❌ Erro fatal: {str(e)}")
