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

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
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

#  hardware.printers.ensurePrinters = [
#  {
#    name = "Canon_G2170";
#    description = "Canon G2170 MegaTank puta";
#    location = "home";
#    deviceUri = "usb://Canon/G2070%20series?serial=033BBE&interface=1";
#    model = "gutenprint.5.3://bjc-PIXMA-G2100/expert";
#  }
#];
  
#  services.printing.enable = true;
#  services.printing.drivers = [ pkgs.gutenprint pkgs.cnijfilter2 ];
#  services.avahi.enable = true;
#  services.avahi.nssmdns4 = true;

  # ============================
  #         USUARIO
  # ============================

  users.users.kutex = {
    isNormalUser = true;                          # Usuario normal (no root)
    description = "Kutex";                        # Nombre que aparece en GUI
    extraGroups = [ "networkmanager" "wheel" ];   # Acceso a red y sudo
    packages = with pkgs; [
      gping                               # Ping pero mas bonito
    ];
  };

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "kutex";

  # ============================
  #       HYPRLAND
  # ============================

  programs.hyprland.enable = true;         # Activa el WM Hyprland
  programs.hyprland.xwayland.enable = true;

  # ============================
  #    PAQUETES INSTALADOS
  # ============================

  nixpkgs.config.permittedInsecurePackages = [ "mbedtls-2.28.10" ];

  nixpkgs.config.allowUnfree = true;       # Permite instalar software no libre (Discord, Spotify, etc)

  environment.systemPackages = with pkgs; [
    peaclock
    mpv
    ffmpeg
    mpvpaper
    pkgs.usbutils
    flatpak
    ntfs3g
    kdePackages.dolphin
    openrgb
    hyprland                               # WM
    kitty                                  # Terminal
    fastfetch                              # Stats pa' fardar
    wget                                   # Para bajar cosas del internet como cavernícola
    discord                                # Aplicación para decir que vas a programar y no hacer nada
    pipewire                               # Backend de audio/video
    wireplumber                            # Gestor de sesiones de pipewire
    alsa-utils                             # Herramientas de sonido clásico
    pavucontrol                            # Interfaz gráfica para controlar volumen
    spotify                                # Para escuchar música mientras haces nada
    wofi                                   # Menu para las apps
    swww                                   # Fondos de pantalla epicos
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
    osu-lazer                              # Jueguito para tunel carpiano            
    lunar-client                           # Minecraft god
    obsidian                               # Mejor editor de texto
  ];

  # ============================
  #           STEAM
  # ============================


programs.steam = {
  enable = true;
  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
};


# programs.steam = {
#   enable = true;                           # Master switch, already covered in installation
#   remotePlay.openFirewall = true;          # For Steam Remote Play
#   dedicatedServer.openFirewall = true;     # For Source Dedicated Server hosting
#                                           # Other general flags if available can be set here.
# };

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

 # =============================
 #        ALMACENAMIENTO
 # =============================

  fileSystems."/home/kutex/SSD y HDD Secundarios/HDD 1" = {
    device = "/dev/disk/by-uuid/DC80039780037774";  # UUID ok, pero verifica con blkid
    fsType = "ntfs-3g";  # NTFS? Instala ntfs3g ya, carnal
    options = [ "defaults" "nofail" "uid=1000" "gid=100" "dmask=027" "fmask=137" ];  # Para que tu user escriba sin sudo
  };

  fileSystems."/home/kutex/SSD y HDD Secundarios/SSD 1" = {
    device = "/dev/disk/by-uuid/E498A85298A824D0";  # UUID ok, pero verifica con blkid
    fsType = "ntfs-3g";  # NTFS? Instala ntfs3g ya, carnal
    options = [ "defaults" "nofail" "uid=1000" "gid=100" "dmask=027" "fmask=137" ];  # Para que t>
  };

  # ============================
  #          FLATPAK
  # ============================

services.flatpak.enable = true;
systemd.services.flatpak-repo = {
  wantedBy = [ "multi-user.target" ];
  path = [ pkgs.flatpak ];
  script = ''
    ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  '';
};

  # ============================
  #     VERSIÓN DEL SISTEMA
  # ============================

  system.stateVersion = "25.05";           # NO CAMBIAR A MENOS QUE SEPAS LO QUE HACÉS
}

# TE AMO XIMENA <3
