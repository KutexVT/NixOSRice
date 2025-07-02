{ config, pkgs, ... }:

{
  # ============================
  #      CONFIGURACIÓN BASE
  # ============================

  imports = [
    ./hardware-configuration.nix             # Configuración automática de hardware
  ];

  # ============================
  #      AUDIO Y PIPEWIRE
  # ============================

  hardware.pulseaudio.enable = false;        # No usaremos PulseAudio standalone
  security.rtkit.enable = true;              # Necesario para prioridades de audio en PipeWire

  services.pipewire = {
    enable = true;                           # Activa PipeWire (audio/video moderno)
    alsa.enable = true;                      # Compatibilidad con ALSA
    alsa.support32Bit = true;                # Soporte para apps de 32 bits (ej: juegos)
    pulse.enable = true;                     # Emulación de servidor PulseAudio
    wireplumber.enable = true;               # Gestor de sesión recomendado para PipeWire
  };

  # ============================
  #       BOOTLOADER / UEFI
  # ============================

  boot.loader.systemd-boot.enable = true;          # Usa systemd-boot como gestor de arranque
  boot.loader.efi.canTouchEfiVariables = true;     # Permite escribir en el firmware UEFI

  # ============================
  #         REDES
  # ============================

  networking.hostName = "nixos";            # Nombre del sistema
  networking.networkmanager.enable = true;  # Habilita NetworkManager para redes (wifi, etc)
  # networking.wireless.enable = true;      # Opción de soporte wireless con wpa_supplicant (innecesario si usás NetworkManager)

  # ============================
  #   ZONA HORARIA Y LOCALES
  # ============================

  time.timeZone = "America/Costa_Rica";     # Zona horaria

  i18n.defaultLocale = "es_MX.UTF-8";       # Locale base (español latino)

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_CR.UTF-8";
    LC_IDENTIFICATION = "es_CR.UTF-8";
    LC_MEASUREMENT = "es_CR.UTF-8";
    LC_MONETARY = "es_CR.UTF-8";
    LC_NAME = "es_CR.UTF-8";
    LC_NUMERIC = "es_CR.UTF-8";
    LC_PAPER = "es_CR.UTF-8";
    LC_TELEPHONE = "es_CR.UTF-8";
    LC_TIME = "es_CR.UTF-8";
  };

  # ============================
  #       TECLADO EN X11
  # ============================

  services.xserver = {
    enable = true;                         # Activa X11 (necesario para Hyprland igual que Wayland)
    xkb = {
      layout = "us";                       # Distribución del teclado
      variant = "";                        # Variante vacía = por defecto
    };
  };

  # ============================
  #     INTERFAZ GRÁFICA KDE
  # ============================

  services.displayManager.sddm.enable = false;    # Gestor de inicio gráfico (KDE)
  services.desktopManager.plasma6.enable = false; # KDE Plasma 6 por si te da por cambiar de Hyprland algún día xd

  # ============================
  #         IMPRESIÓN
  # ============================

  services.printing.enable = true;         # Activa soporte de impresoras con CUPS

  # ============================
  #         USUARIO
  # ============================

  users.users.kutex = {
    isNormalUser = true;                          # Usuario normal (no root)
    description = "Kutex";                        # Nombre que aparece en GUI
    extraGroups = [ "networkmanager" "wheel" ];   # Acceso a red y sudo
    packages = with pkgs; [
      kdePackages.kate                            # Editor KDE (por si lo querías probar)
    ];
  };

  # ============================
  #       HYPRLAND
  # ============================

  programs.hyprland.enable = true;         # Activa el WM Hyprland

  # ============================
  #    PAQUETES INSTALADOS
  # ============================

  nixpkgs.config.allowUnfree = true;       # Permite instalar software no libre (Discord, Spotify, etc)

  environment.systemPackages = with pkgs; [
    hyprland                               # WM
    kitty                                  # Terminal
    fastfetch                              # Stats pa' fardar
    wget                                   # Para bajar cosas del internet como cavernícola
    firefox                                # Navegador que no es Chrome
    discord                                # Aplicación para decir que vas a programar y no hacer nada
    pipewire                               # Backend de audio/video
    wireplumber                            # Gestor de sesiones de pipewire
    alsa-utils                             # Herramientas de sonido clásico
    pavucontrol                            # Interfaz gráfica para controlar volumen
    spotify                                # Para escuchar música mientras haces nada
    wofi                                   # Menu para las apps
    swww                                   # Fondos de pantalla epicos
    openrgb                                # Control del RGB de la PC
    cmatrix                                # Texto cayendo tipo matrix
    xdg-desktop-portal                     # Dependencia del OBS para no me acuerdo que
    xdg-desktop-portal-wlr                 # Dependencia de la dependencia para el OBS
    obs-studio                             # Grabar pantalla, transmisiones, y todo eso
    obs-studio-plugins.obs-vkcapture       # Para capturar cosas con Vulkan (juegos, etc.)
    cava                                   # Visualizador de audio para flexear
    hollywood                              # Para parecer Eliot Anderson
    cbonsai                                # Hace un bonsai bien bien bonito
    btop                                   # Muestra registros del sistema y uso de datos
    lolcat                                 # Le pone color a los comandos
    figlet                                 # Escribe lo que le digas en la terminal
    toilet                                 # Complemento de figlet para más fonts
    asciiquarium                           # Hace un acuario bien bonito
    llama-cpp                              # Backend para modelos GGUF
    python3                                # Necesario para scripts y frontends
    git                                    # Para clonar cosas desde GitHub
    unzip                                  # Para descomprimir xddd
    zip                                    # Para comprimir xddd
    curl                                   # Por si wget no alcanza
    gcc                                    # Algunas veces necesario para compilar extensiones
    cmake                                  # Dependencia común para proyectos C++
    nodejs                                 # Algunos frontends lo requieren
    which                                  # Te dice dónde está un binario
    libGL                                  # OpenGL libs necesarias para apps gráficas
    zlib                                   # Librería de compresión
    stdenv.cc.cc                           # Compiler env (a veces requerido en manual builds)
    kdePackages.kio-fuse                   # Para montar sistemas de archivos remotos
    kdePackages.kio-extras                 # Protocolos adicionales para KIO (fish, sftp, etc.)
    kdePackages.dolphin                    # Visualizador de archivos CON INTERFAZ GRAFICA
    kdePackages.qtsvg                      # Hace que dolphin tenga iconos normales
    vim                                    # vim = nano
  ];

  # ============================
  #     OBS STUDIO
  # ============================

  programs.obs-studio = {
    enable = true;                         # Activa OBS Studio
    enableVirtualCamera = true;            # Para usar OBS como webcam virtual
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs                               # Plugin para capturar con Wayland
      obs-backgroundremoval                # Para quitar el fondo como mago
      obs-pipewire-audio-capture           # Captura el audio de PipeWire directamente
    ];
  };

  # ============================
  #     TIPOGRAFIAS
  # ============================

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono              # Fuente con íconos para terminal
  ];

  # ============================
  #     VERSIÓN DEL SISTEMA
  # ============================

  system.stateVersion = "25.05";           # NO CAMBIAR A MENOS QUE SEPAS LO QUE HACÉS
}

