"""
Processador de Ícones - Interface Gráfica
Remove fundo e gera ícones otimizados para todas as plataformas (2025)
"""

import os
import sys
import tkinter as tk
from tkinter import ttk, filedialog, scrolledtext, messagebox
from pathlib import Path
import threading
from process_icons import (
    remove_background, get_content_bounds, resize_image_smart,
    create_favicon_ico, create_webmanifest, create_html_snippet,
    ICON_SIZES, PADDING_CONFIG, SUPPORTED_EXTENSIONS
)
from PIL import Image

class IconProcessorGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("🎨 Processador de Ícones - 2025")
        self.root.geometry("800x700")
        self.root.resizable(True, True)

        # Variáveis
        self.input_folder = tk.StringVar()
        self.output_folder = tk.StringVar()
        self.processing = False

        self.setup_ui()

    def setup_ui(self):
        """Configura a interface do usuário"""

        # Estilo
        style = ttk.Style()
        style.theme_use('clam')

        # Frame principal
        main_frame = ttk.Frame(self.root, padding="20")
        main_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))

        # Configurar grid
        self.root.columnconfigure(0, weight=1)
        self.root.rowconfigure(0, weight=1)
        main_frame.columnconfigure(1, weight=1)

        # Título
        title_label = ttk.Label(
            main_frame,
            text="🎨 Processador de Ícones 2025",
            font=('Arial', 16, 'bold')
        )
        title_label.grid(row=0, column=0, columnspan=3, pady=(0, 20))

        # Descrição
        desc_label = ttk.Label(
            main_frame,
            text="Remove fundo e gera ícones para Web, iOS, Android, Windows, macOS e Redes Sociais",
            font=('Arial', 9),
            foreground='gray'
        )
        desc_label.grid(row=1, column=0, columnspan=3, pady=(0, 20))

        # Pasta de entrada
        ttk.Label(main_frame, text="📁 Pasta com imagens:", font=('Arial', 10, 'bold')).grid(
            row=2, column=0, sticky=tk.W, pady=(0, 5)
        )

        input_entry = ttk.Entry(main_frame, textvariable=self.input_folder, width=50)
        input_entry.grid(row=3, column=0, columnspan=2, sticky=(tk.W, tk.E), padx=(0, 10))

        browse_btn = ttk.Button(main_frame, text="Procurar...", command=self.browse_input)
        browse_btn.grid(row=3, column=2, sticky=tk.W)

        # Pasta de saída
        ttk.Label(main_frame, text="💾 Pasta de saída:", font=('Arial', 10, 'bold')).grid(
            row=4, column=0, sticky=tk.W, pady=(15, 5)
        )

        output_entry = ttk.Entry(main_frame, textvariable=self.output_folder, width=50)
        output_entry.grid(row=5, column=0, columnspan=2, sticky=(tk.W, tk.E), padx=(0, 10))

        browse_out_btn = ttk.Button(main_frame, text="Procurar...", command=self.browse_output)
        browse_out_btn.grid(row=5, column=2, sticky=tk.W)

        # Informações
        info_frame = ttk.LabelFrame(main_frame, text="📊 Ícones que serão gerados", padding="10")
        info_frame.grid(row=6, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=20)
        info_frame.columnconfigure(0, weight=1)
        info_frame.columnconfigure(1, weight=1)

        info_text = """
🌐 Favicon: 16, 32, 48, 64 + .ico
🍎 Apple: 10 tamanhos (57-1024)
🤖 Android: 7 tamanhos (36-512)
        """

        info_text2 = """
🪟 Windows: 5 tiles (44-310)
💻 macOS: 7 tamanhos (16-1024)
📱 Social: 5 tamanhos (300-1080)
        """

        ttk.Label(info_frame, text=info_text, justify=tk.LEFT, font=('Courier', 9)).grid(
            row=0, column=0, sticky=tk.W, padx=10
        )
        ttk.Label(info_frame, text=info_text2, justify=tk.LEFT, font=('Courier', 9)).grid(
            row=0, column=1, sticky=tk.W, padx=10
        )

        # Botão processar
        self.process_btn = ttk.Button(
            main_frame,
            text="🚀 PROCESSAR IMAGENS",
            command=self.start_processing,
            style='Accent.TButton'
        )
        self.process_btn.grid(row=7, column=0, columnspan=3, pady=10, ipadx=20, ipady=10)

        # Barra de progresso
        self.progress = ttk.Progressbar(main_frame, mode='indeterminate')
        self.progress.grid(row=8, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=(0, 10))

        # Console de saída
        ttk.Label(main_frame, text="📝 Log de processamento:", font=('Arial', 10, 'bold')).grid(
            row=9, column=0, sticky=tk.W, pady=(10, 5)
        )

        self.console = scrolledtext.ScrolledText(
            main_frame,
            height=15,
            width=70,
            font=('Courier', 9),
            bg='#1e1e1e',
            fg='#d4d4d4',
            insertbackground='white'
        )
        self.console.grid(row=10, column=0, columnspan=3, sticky=(tk.W, tk.E, tk.N, tk.S), pady=(0, 10))
        main_frame.rowconfigure(10, weight=1)

        # Botão limpar console
        clear_btn = ttk.Button(main_frame, text="🗑️ Limpar Log", command=self.clear_console)
        clear_btn.grid(row=11, column=0, sticky=tk.W)

        # Status bar
        self.status_label = ttk.Label(main_frame, text="✅ Pronto para processar", foreground='green')
        self.status_label.grid(row=11, column=1, columnspan=2, sticky=tk.E)

        # Configurar botão de estilo
        style.configure('Accent.TButton', font=('Arial', 11, 'bold'))

    def browse_input(self):
        """Seleciona pasta de entrada"""
        folder = filedialog.askdirectory(title="Selecione a pasta com as imagens")
        if folder:
            self.input_folder.set(folder)
            # Define pasta de saída padrão
            if not self.output_folder.get():
                self.output_folder.set(os.path.join(folder, 'icons_processed'))

    def browse_output(self):
        """Seleciona pasta de saída"""
        folder = filedialog.askdirectory(title="Selecione a pasta de saída")
        if folder:
            self.output_folder.set(folder)

    def clear_console(self):
        """Limpa o console"""
        self.console.delete(1.0, tk.END)

    def log(self, message, color=None):
        """Adiciona mensagem ao console"""
        self.console.insert(tk.END, message + "\n")
        if color:
            # Implementar colorização se necessário
            pass
        self.console.see(tk.END)
        self.console.update()

    def update_status(self, message, color='green'):
        """Atualiza status"""
        self.status_label.config(text=message, foreground=color)

    def start_processing(self):
        """Inicia o processamento em thread separada"""
        if self.processing:
            return

        input_folder = self.input_folder.get()
        output_folder = self.output_folder.get()

        if not input_folder:
            messagebox.showerror("Erro", "Selecione uma pasta de entrada!")
            return

        if not os.path.exists(input_folder):
            messagebox.showerror("Erro", "Pasta de entrada não existe!")
            return

        if not output_folder:
            messagebox.showerror("Erro", "Selecione uma pasta de saída!")
            return

        # Desabilita botão
        self.process_btn.config(state='disabled')
        self.progress.start()
        self.processing = True
        self.clear_console()
        self.update_status("⏳ Processando...", 'orange')

        # Processa em thread separada
        thread = threading.Thread(target=self.process_images, args=(input_folder, output_folder))
        thread.daemon = True
        thread.start()

    def process_images(self, input_folder, output_folder):
        """Processa as imagens"""
        try:
            # Cria pasta de saída
            os.makedirs(output_folder, exist_ok=True)

            self.log("=" * 70)
            self.log("🎨 PROCESSADOR DE ÍCONES - 2025")
            self.log("=" * 70)
            self.log(f"📁 Entrada: {input_folder}")
            self.log(f"💾 Saída: {output_folder}\n")

            # Lista arquivos de imagem
            image_files = []
            for file in os.listdir(input_folder):
                if Path(file).suffix.lower() in SUPPORTED_EXTENSIONS:
                    full_path = os.path.join(input_folder, file)
                    if os.path.isfile(full_path):
                        image_files.append(full_path)

            if not image_files:
                self.log("❌ Nenhuma imagem encontrada na pasta!")
                self.finish_processing(False)
                return

            self.log(f"✅ Encontradas {len(image_files)} imagem(ns) para processar\n")

            # Processa cada imagem
            for idx, img_path in enumerate(image_files, 1):
                base_name = Path(img_path).stem
                self.log(f"\n{'='*70}")
                self.log(f"📸 [{idx}/{len(image_files)}] Processando: {os.path.basename(img_path)}")
                self.log("="*70)

                try:
                    # Remove fundo
                    image_no_bg = remove_background(img_path)

                    # Cria pasta específica
                    image_output_folder = os.path.join(output_folder, base_name)
                    os.makedirs(image_output_folder, exist_ok=True)

                    # Salva imagem sem fundo
                    original_no_bg = os.path.join(image_output_folder, f"{base_name}_no_bg.png")
                    image_no_bg.save(original_no_bg, 'PNG')
                    self.log(f"✅ Salva imagem sem fundo: {base_name}_no_bg.png")

                    # Análise
                    left, top, right, bottom = get_content_bounds(image_no_bg)
                    content_width = right - left
                    content_height = bottom - top
                    aspect_ratio = content_width / content_height if content_height > 0 else 1
                    is_square = 0.9 <= aspect_ratio <= 1.1

                    self.log(f"\n📊 Análise:")
                    self.log(f"   • Original: {image_no_bg.width}x{image_no_bg.height} px")
                    self.log(f"   • Conteúdo: {content_width}x{content_height} px")
                    self.log(f"   • Formato: {'Quadrado/Circular ✓' if is_square else f'Retangular ({aspect_ratio:.2f}:1)'}")

                    # Gera ícones
                    self.log(f"\n🎨 Gerando ícones:\n")
                    favicon_images = []
                    all_icon_files = []

                    total_icons = sum(len(sizes) for sizes in ICON_SIZES.values())
                    current = 0

                    for platform, sizes in ICON_SIZES.items():
                        padding = PADDING_CONFIG.get(platform, 5)

                        for size in sizes:
                            current += 1
                            if isinstance(size, int):
                                display = f"{size}x{size}"
                            else:
                                display = f"{size[0]}x{size[1]}"

                            self.log(f"   [{current}/{total_icons}] {platform.capitalize()} {display}...")

                            resized = resize_image_smart(image_no_bg.copy(), size, padding)

                            if isinstance(size, int):
                                filename = f"icon_{platform}_{size}x{size}.png"
                            else:
                                filename = f"icon_{platform}_{size[0]}x{size[1]}.png"

                            filepath = os.path.join(image_output_folder, filename)
                            resized.save(filepath, 'PNG', optimize=True)
                            all_icon_files.append(filepath)

                            if platform == 'favicon':
                                favicon_images.append(resized)

                    # Cria arquivos auxiliares
                    self.log(f"\n📄 Gerando arquivos auxiliares:")

                    if favicon_images:
                        favicon_path = os.path.join(image_output_folder, 'favicon.ico')
                        favicon_images[0].save(
                            favicon_path,
                            format='ICO',
                            sizes=[(img.width, img.height) for img in favicon_images]
                        )
                        self.log(f"   ✅ favicon.ico")

                    create_webmanifest(all_icon_files, image_output_folder, base_name)
                    self.log(f"   ✅ manifest.json")

                    create_html_snippet(all_icon_files, image_output_folder)
                    self.log(f"   ✅ html_snippet.txt")

                    self.log(f"\n✅ Concluído: {base_name}")

                except Exception as e:
                    self.log(f"\n❌ Erro: {str(e)}")

            # Finaliza
            self.log("\n" + "="*70)
            self.log("✅ PROCESSAMENTO CONCLUÍDO!")
            self.log("="*70)
            self.log(f"\n📁 Todos os ícones salvos em: {output_folder}")
            self.log(f"\n📊 Total gerado: {total_icons} ícones por imagem")

            self.finish_processing(True)

        except Exception as e:
            self.log(f"\n❌ Erro fatal: {str(e)}")
            self.finish_processing(False)

    def finish_processing(self, success):
        """Finaliza o processamento"""
        self.processing = False
        self.progress.stop()
        self.process_btn.config(state='normal')

        if success:
            self.update_status("✅ Processamento concluído com sucesso!", 'green')
            messagebox.showinfo(
                "Sucesso!",
                "Ícones gerados com sucesso!\n\nVerifique a pasta de saída."
            )
        else:
            self.update_status("❌ Processamento falhou", 'red')

def main():
    root = tk.Tk()
    app = IconProcessorGUI(root)
    root.mainloop()

if __name__ == "__main__":
    main()
