{

  commonTargetPkgs = pkgs: with pkgs; [
    # Needed for operating system detection until
    # https://github.com/ValveSoftware/steam-for-linux/issues/5909 is resolved
    lsb-release
    # Errors in output without those
    pciutils
    # Games' dependencies
    xorg.xrandr
    which
    # Needed by gdialog, including in the steam-runtime
    perl
    # Open URLs
    xdg-utils
    iana-etc
    # Steam Play / Proton
    python3
    # Steam VR
    procps
    usbutils

    # It tries to execute xdg-user-dir and spams the log with command not founds
    xdg-user-dirs

    # electron based launchers need newer versions of these libraries than what runtime provides
    mesa
    sqlite
  ];

  multiPkgs = pkgs: with pkgs; [
    # These are required by steam with proper errors
    xorg.libXcomposite
    xorg.libXtst
    xorg.libXrandr
    xorg.libXext
    xorg.libX11
    xorg.libXfixes
    libGL
    libva
    pipewire.lib

    # steamwebhelper
    harfbuzz
    libthai
    pango

    lsof # friends options won't display "Launch Game" without it
    file # called by steam's setup.sh

    # dependencies for mesa drivers, needed inside pressure-vessel
    mesa.llvmPackages.llvm.lib
    vulkan-loader
    expat
    wayland
    xorg.libxcb
    xorg.libXdamage
    xorg.libxshmfence
    xorg.libXxf86vm
    libelf
    (lib.getLib elfutils)

    # Without these it silently fails
    xorg.libXinerama
    xorg.libXcursor
    xorg.libXrender
    xorg.libXScrnSaver
    xorg.libXi
    xorg.libSM
    xorg.libICE
    gnome2.GConf
    curlWithGnuTls
    nspr
    nss
    cups
    libcap
    SDL2
    libusb1
    dbus-glib
    gsettings-desktop-schemas
    ffmpeg
    libudev0-shim

    # Verified games requirements
    fontconfig
    freetype
    xorg.libXt
    xorg.libXmu
    libogg
    libvorbis
    SDL
    SDL2_image
    glew110
    libdrm
    libidn
    tbb
    zlib

    # SteamVR
    udev

    # Other things from runtime
    glib
    gtk2
    bzip2
    flac
    freeglut
    libjpeg
    libpng
    libpng12
    libsamplerate
    libmikmod
    libtheora
    libtiff
    pixman
    speex
    SDL_image
    SDL_ttf
    SDL_mixer
    SDL2_ttf
    SDL2_mixer
    libappindicator-gtk2
    libdbusmenu-gtk2
    libindicator-gtk2
    libcaca
    libcanberra
    libgcrypt
    libvpx
    librsvg
    xorg.libXft
    libvdpau
  ];
}
