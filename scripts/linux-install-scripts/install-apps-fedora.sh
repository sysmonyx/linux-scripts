# !/bin/bash
################################################################################################################################
#    /$$$$$$
#   /$$__  $$
#  | $$  \__/ /$$   /$$  /$$$$$$$ /$$$$$$/$$$$   /$$$$$$  /$$$$$$$  /$$   /$$ /$$   /$$         # Author:   Soham Ray [Sysmonyx]
#  |  $$$$$$ | $$  | $$ /$$_____/| $$_  $$_  $$ /$$__  $$| $$__  $$| $$  | $$|  $$ /$$/
#   \____  $$| $$  | $$|  $$$$$$ | $$ \ $$ \ $$| $$  \ $$| $$  \ $$| $$  | $$ \  $$$$/          # Website:  https://sysmonyx.com
#   /$$  \ $$| $$  | $$ \____  $$| $$ | $$ | $$| $$  | $$| $$  | $$| $$  | $$  >$$  $$
#  |  $$$$$$/|  $$$$$$$ /$$$$$$$/| $$ | $$ | $$|  $$$$$$/| $$  | $$|  $$$$$$$ /$$/\  $$         # Email:    contact@sysmonyx.com
#   \______/  \____  $$|_______/ |__/ |__/ |__/ \______/ |__/  |__/ \____  $$|__/  \__/
#             /$$  | $$                                             /$$  | $$
#            |  $$$$$$/                                            |  $$$$$$/
#             \______/                                              \______/
################################################################################################################################
#   Description:    This script installs specified RPM & Flatpak packages automatically on a Fedora system.
#                   Flatpak is the primary mode for easier replication across distros.
#
#   Last Updated:   27.07.2025
################################################################################################################################
# --- Check for Root Privileges ---
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with root privileges. Please use sudo." >&2
    exit 1
fi

# RPM packages -------------------------------------------------------------------------
packages=(

    # System Utilities -----------------------------------------
    "btop"                                                      # Btop
    "fish"                                                      # Fish Shell
    "gnome-tweaks"                                              # Gnome Tweaks
    "htop"                                                      # Htop
    "neofetch"                                                  # Neofetch
    "zsh"                                                       # Z-Shell

    # Multimedia -----------------------------------------------
    "vlc"                                                       # VLC Media Player
    "gimp"                                                      # GIMP

    # Download Managers ----------------------------------------
    
    # Development Tools ----------------------------------------
    "vim"                                                       # Vim
    "code"                                                      # VS-Code (MS-Repo nneds to be added first)

)

# Flatpak Apps -------------------------------------------------------------------------------------
flatpaks=(

    # Browsers -------------------------------------------------
    "com.brave.Browser"                                         # Brave Browser
    "com.google.Chrome"                                         # Google Chrome
    "io.gitlab.librewolf-community"                             # LibreWolf
    "org.mozilla.firefox"                                       # Mozilla Firefox
    "com.vivaldi.Vivaldi"                                       # Vivaldi
    "app.zen_browser.zen"                                       # Zen Browser


    # Communication---------------------------------------------
    "com.discordapp.Discord"                                    # Discord
    "network.loki.Session"                                      # Session
    "org.telegram.desktop"                                      # Telegram

    # Gaming ---------------------------------------------------
    "com.valvesoftware.Steam"                                   # Steam
    "com.heroicgameslauncher.hgl"                               # Heroic Launcher
    "net.lutris.Lutris"                                         # Lutris
    "org.libretro.RetroArch"                                    # RetroArch

    # Multimedia -----------------------------------------------
    "fr.handbrake.ghb"                                          # HandBrake
    "com.spotify.Client"                                        # Spotify
    "org.videolan.VLC"                                          # VLC Media Player

    # Download Managers ----------------------------------------
    "de.haeckerfelix.Fragments"                                 # Fragments (GC)
    "org.qbittorrent.qBittorrent"                               # qBittorrent
    
    # Development ----------------------------------------------
    "io.gitlab.liferooter.TextPieces"                           # Text Pieces (GC)
    "org.gaphor.Gaphor"                                         # Gaphor (GC)
    "org.gnome.design.Emblem"                                   # Emblem (GC)

    # Password Managers ----------------------------------------
    "com.bitwarden.desktop"                                     # Bitwarden Desktop
    "org.keepassxc.KeePassXC"                                   # KeePassXC

    # Productivity ---------------------------------------------
    "org.gnome.gitlab.somas.Apostrophe"                         # Apostrophe (GC)
    "md.obsidian.Obsidian"                                      # Obsidian
    "org.gnome.World.Iotas"                                     # Iotas (GC)
    "io.gitlab.gregorni.Letterpress"                            # Letterpress (GC)
    "io.gitlab.news_flash.NewsFlash"                            # Newsflash (GC)
    "com.notesnook.Notesnook"                                   # Notesnook
    "com.obsproject.Studio"                                     # OBS Studio
    "io.github.najepaliya.kleaner"                              # Kleaner
    "net.xmind.XMind"                                           # Xmind

    # System Utilities -----------------------------------------
    "net.nokyan.Resources"                                      # Resources (GC)
    "org.gnome.World.PikaBackup"                                # Pika Backup (GC)
    "com.mattjakeman.ExtensionManager"                          # Extensions Manager
    "com.github.tchx84.Flatseal"                                # Flatseal
    "com.usebottles.bottles"                                    # Bottles
    "io.missioncenter.MissionCenter"                            # Mission Center

    # Utilities ------------------------------------------------
    "com.belmoussaoui.Authenticator"                            # Authenticator (GC)
    "org.cryptomator.Cryptomator"                               # Cryptomator
    "com.belmoussaoui.Decoder"                                  # Decoder (GC)
    "io.ente.auth"                                              # Ente Auth

    # File Transfer / Sharing ----------------------------------
    "org.onionshare.OnionShare"                                 # OnionShare
    "app.drey.Warp"                                             # Warp (GC)
)


# Install RPM Packages -----------------------------------------------------------------------------
echo "Starting installation of all specified packages..."

# Check if the package list is empty.
if [ ${#packages[@]} -eq 0 ]; then
    echo "No packages specified for installation. Exiting."
    exit 0
fi

echo "The following packages will be installed:"
echo "----------------------------------------------------------------"
printf " - %s\n" "${packages[@]}"
echo "----------------------------------------------------------------"

# Install all packages at once.
sudo dnf install -y "${packages[@]}"

# Check the exit status of the dnf install command
if [ $? -eq 0 ]; then
    echo "================================================================"
    echo "Successfully installed all specified packages."
    echo "================================================================"
else
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" >&2
    echo "Error: The DNF command failed. Not all packages were installed." >&2
    echo "Check the output above for specific error messages." >&2
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" >&2
    exit 1
fi

exit 0

# Install Flatpak packages -------------------------------------------------------------------------
if [ ${#flatpaks[@]} -eq 0 ]; then
    echo "No Flatpak applications specified for installation. Skipping."
else
    echo "Starting installation of Flatpak applications..."
    
    # Ensure the Flathub remote repository is configured.
    echo "--> Ensuring Flathub remote is configured..."
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    
    echo "----------------------------------------------------------------"
    printf " - %s\n" "${flatpaks[@]}"
    echo "----------------------------------------------------------------"

    # Install all Flatpak applications at once.
    flatpak install --noninteractive flathub "${flatpaks[@]}"

    # Check the exit status of the flatpak install command
    if [ $? -eq 0 ]; then
        echo "================================================================"
        echo "[OK] Successfully installed all specified Flatpak applications. "
        echo "================================================================"
    else
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" >&2
        echo "[ERROR] The Flatpak command failed." >&2
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" >&2
    fi
fi

################################################################################################################################
