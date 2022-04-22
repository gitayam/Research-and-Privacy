#!/bin/bash

### System Checks ###
# detect  OS
    os=$(uname)
# check for internet
    if nc -zw1 google.com 443;then
    #assume Internet available.
        echo
    else
        #assume Offline.
        printf "No Internet Detected.\nCheck Internet Connection and try again.\n"
        exit 1
    fi
### Global Variables ###
osint_pips="snscrape gallery-dl yt-dlp youtube-tool nested-lookup internetarchive ripgrep waybackpy search-that-hash h8mail streamlink Instalooter Instaloader toutatis redditsfinder bdfr matplotlib xeuledoc socialscan holehe testresources pipenv webscreenshot"
osint_gits="mxrch/GHunt.git AmIJesse/Elasticsearch-Crawler.git twintproject/twint Und3rf10w/kali-anonsurf AzizKpln/Moriarty-Project soxoj/maigret megadose/holehe smicallef/spiderfoot.git Lazza/Carbon14 sherlock-project/sherlock.git WebBreacher/WhatsMyName.git martinvigo/email2phonenumber.git aboul3la/Sublist3r.git s0md3v/Photon.git GuidoBartoli/sherloq.git opsdisk/metagoofil.git MalloyDelacroix/DownloaderForReddit.git laramies/theHarvester.git lanmaster53/recon-ng.git"
dfp_pips="yubikey-manager"
### Functions ### 
git_installer(){ # Function for installing Git
    git_name=$(echo "$1"|cut -d '/' -f 5|cut -d '.' -f 1)
    #pass git url as arg $1
    cd  "$USER"/Downloads/Programs || mkdir -p "$USER"/Downloads/Programs && cd  "$USER"/Downloads/Programs || exit
    git clone "$1"
    cd git_name || printf "Something is wrong\nThat directory doesn't exist here"
    sudo -H pip install -r requirements.txt -I
}
git_update(){
    git_name=$(echo "$1"|cut -d '/' -f 5|cut -d '.' -f 1)
    #pass git url as arg $1
    cd  "$USER"/Downloads/Programs || echo "assuming no git downloads" && exit
    cd git_name || printf "Something is wrong\nThat directory doesn't exist here"
    git pull "$1"
}
inteltech_download(){ #which download is passed as argument
    downloaded_inteltech_path="$USER/Desktop/$1"
    curl -u osint9:book143wt -O --output-dir "$USER"/Desktop https://inteltechniques.com/osintbook9/"{$1}".zip
    unzip "$downloaded_inteltech_path".zip -d  "$USER"/Desktop/
    rm "$downloaded_inteltech_path".zip
}
setup_firefox(){
    #install Firefox Profile
    inteltech_download ff-template 
    downloaded_inteltech_path="$USER/Desktop/ff-template"
     if [ "$os" == "Darwin" ];then
        #open /Applications/Firefox.app/ #FIXME: might be best to open firefox and close, but could be an issue
        cp -R ff-template/* ~/Library/Application\ Support/Firefox/Profiles/*.default-release
        rm -rf "$USER"/Desktop/ff-template __MACOSX
    elif [ "$os" == "Linux" ];then
        cp -R "$USER"/.mozilla/firefox/ff-template/* "$USER"/.mozilla/firefox/*.default-release
    else
        #assume not linux or mac
        echo "firefox not set up"
    fi
    #
    #linux
    rm -rf "$downloaded_inteltech_path"
}

install_git_pip(){
    if [ "$os" == "Darwin" ];then
        which brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        brew install python@3.9 pyenv-pip-migrate git  
    elif [ "$os" == "Linux" ];then
        sudo apt install -y git python3.9
    else
        #assume not linux or mac
        echo "Something is wrong, not detected as macOS or Linux"
    fi

     #install required pip using python3.9 pip3
    for pip_pkg in $osint_pips;do  sudo -H pip "$pip_pkg";done
    #install several git repos
    for git_repo in $osint_gits;do git_installer "https://github.com/$git_repo";done

}
gpg_generator(){
    sudo apt-get install -y gpg scdaemon pcscd python3-ptyprocess
    for pip_pkg in $dfp_pips;do  sudo -H pip "$pip_pkg";done #install yubikeymanager os agnostic
    git_installer https://github.com/Logicwax/gpg-provision
    read -p "Generate GPG cryptographic key pair now? (y/n): " gpg_response
    if [ "$gpg_response" == "y" ];then
        ./gpg-provision
    else
        printf "When you are ready, navigate to ~/Downloads/Programs/gpg-provision/gpg-provision\nrun:./gpg-provision"
        printf "This will generate gpg key pairs with ssh subkeys and place them all inside a Yubikey"
    fi

    ##FIXME: configure environment for gpg authentication using Yubikey
    #macOS focused 
    # //https://gist.github.com/ixdy/6fdd1ecea5d17479a6b4dab4fe1c17eb
    printf "pinentry-program /usr/local/MacGPG2/libexec/pinentry-mac.app/Contents/MacOS/pinentry-mac
    enable-ssh-support\ndefault-cache-ttl 60\nmax-cache-ttl 120"|sudo tee /.gnupg/gpg-agent.conf
    printf "export GPG_TTY="$(tty)"\nexport SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)\ngpgconf --launch gpg-agent" >> "$USER"/.bash_profile
    printf 'alias ssh="gpg-connect-agent updatestartuptty /bye > /dev/null; ssh"\nalias scp="gpg-connect-agent updatestartuptty /bye > /dev/null; scp"'>> "$USER"/.bash_profile
    #require touch on yubikey
    ykman openpgp set-touch aut on
    ykman openpgp set-touch enc on
    ykman openpgp set-touch sig on


}   
## MacOS Based Functions
macos_upgrade_all(){
    brew update
    brew upgrade
    brew upgrade --greedy
    brew autoremove
    brew cleanup -s
    rm -rf "$(brew --cache)"
    brew doctor
    brew missing
    sudo -S "$system_password" periodic daily weekly monthly
    sudo -H python3 -m pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 sudo -H python3 -m pip install -U
    #use function to pull request for all git repos
    for git_repo in $osint_gits;do git_update "https://github.com/$git_repo";done
    softwareupdate -ia
}
macos_update_icons(){
    ln -s ~/Documents/scripts/ /Applications/ 
    defaults write com.apple.dock show-recents -bool FALSE
    defaults write com.apple.dock tilesize -int 32
    defaults write com.apple.dock persistent-apps -array
    defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Firefox.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
    defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Google Chrome.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
    defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Tor Browser.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
    defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/System/Applications/Utilities/Terminal.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
    defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/scripts/Updates</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
    defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/scripts/OSINT Tools</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
    defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/scripts/Video Download Tool</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
    defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/scripts/Video Utilities</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
    defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/scripts/Video Stream Tool</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
    defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/scripts/Instagram Tool</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
    defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/scripts/Gallery Tool</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
    defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/scripts/Username Tool</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
    defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/scripts/WebScreenShot</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
    defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/scripts/Domain Tool</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
    defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/scripts/Metadata Tool</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
    defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/scripts/HTTrack</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
    defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/scripts/Metagoofil</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
    defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/scripts/Breaches-Leaks Tool</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
    defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/scripts/Reddit Tool</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
    defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/scripts/Internet Archive Tool</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
    defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/scripts/Spiderfoot</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
    defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/scripts/Recon-NG</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
    defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/MediaInfo.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
    defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Google Earth Pro.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
    defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/KeePassXC.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
    defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/System/Applications/System Preferences.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
    killall Dock


}
macos_install_osint_tools(){
    brew_apps="firefox brave-browser thunderbird vlc tor-browser cryptomator audacity iterm2 cyberduck joplin visual-studio-code drawio clamxav google-earth-pro keepassxc wine-stable android-studio virtualbox virtualbox-extension-pack"
    brew_casts="ffsend nmap python3 tldr zenity youtube-dl ffmpeg yt-dlp pipenv openssl gpg-suite mat2 httrack exiftool internetarchive ripgrep instalooter fileicon wget streamlink libmagic mediainfo phantomjs xquartz"
    which brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew autoremove
    brew cleanup -s
    rm -rf "$(brew --cache)"
    brew doctor
    brew missing
    
    #install apps and pkgs from above
    for brew_pkg in $brew_apps;do brew list "$brew_pkg" || brew install --cask "$brew_pkg";done
    for brew_pkg in $brew_casts;do brew list "$brew_pkg" || brew install --cask "$brew_pkg";done
    brew tap caffix/amass && brew install amass
    #set up firefox
    setup_firefox

    #install custom tools and scripts
    inteltech_download tools
    inteltech_download mac-files
    downloaded_inteltech_path="$USER/Desktop/mac-files"
    cp "$downloaded_inteltech_path"/scripts/*  "$USER"/Documents/scripts/
    cp "$downloaded_inteltech_path"/icons/*  "$USER"/Documents/icons/  
    sudo cp "$downloaded_inteltech_path"/shortcuts/* /usr/share/applications/
    rm -rf "$downloaded_inteltech_path"
    rm -rf mac-files __MACOSX
    sed -i '' 's/\;leak\-lookup\_pub/leak\-lookup\_pub/g' h8mail_config.ini
    sudo -H python3 -m pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 sudo -H python3 -m pip install -U

    ##apply icons to script
    cd ~/Documents/scripts || printf "Something is wrong\nThat directory doesn't exist here"
    fileicon set Domain\ Tool ~/Documents/icons/domains.png
    fileicon set Breaches-Leaks\ Tool ~/Documents/icons/elasticsearch.png
    fileicon set WebScreenShot ~/Documents/icons/eyewitness.png
    fileicon set Gallery\ Tool ~/Documents/icons/gallery.png
    fileicon set HTTrack ~/Documents/icons/httrack.png
    fileicon set Instagram\ Tool ~/Documents/icons/instagram.png
    fileicon set Internet\ Archive\ Tool ~/Documents/icons/internetarchive.png
    fileicon set Metadata\ Tool ~/Documents/icons/metadata.png
    fileicon set Metagoofil ~/Documents/icons/metagoofil.png
    fileicon set OSINT\ Tools ~/Documents/icons/tools.png
    fileicon set Recon-NG ~/Documents/icons/recon-ng.png
    fileicon set Reddit\ Tool ~/Documents/icons/reddit.png
    fileicon set Spiderfoot ~/Documents/icons/spiderfoot.png
    fileicon set Updates ~/Documents/icons/updates.png
    fileicon set Username\ Tool ~/Documents/icons/usertool.png
    fileicon set Video\ Download\ Tool ~/Documents/icons/youtube-dl.png
    fileicon set Video\ Utilities ~/Documents/icons/ffmpeg.png
    fileicon set Video\ Stream\ Tool ~/Documents/icons/streamlink.png

    macos_update_icons

    macos_upgrade_all
}
## Linux Based Functions
linux_update_all(){
    sudo apt update --fix-missing
    sudo apt -y upgrade
    sudo apt --fix-broken install
    sudo -H pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 sudo -H pip install -U
    #update git repos
    for git_repo in $osint_gits;do git_update "https://github.com/$git_repo";done
}

linux_install_browsers(){
    echo "Installing Browsers: Brave and Tor Browser https://brave.com/linux/"
    #install brave browser
    sudo -S "$system_password" curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    #install torbrowser launcher
    sudo add-apt-repository -y ppa:micahflee/ppa
    #update and install
    sudo apt update 
    sudo apt install -y torbrowser-launcher brave-browser
}
linux_user_interface(){
    gsettings set org.gnome.desktop.background picture-uri ''
    gsettings set org.gnome.desktop.background primary-color 'rgb(66, 81, 100)'
    gsettings set org.gnome.shell favorite-apps []
    gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
    gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'brave-browser.desktop', 'torbrowser.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'updates.desktop', 'tools.desktop', 'youtube_dl.desktop', 'ffmpeg.desktop', 'streamlink.desktop', 'instagram.desktop', 'gallery.desktop', 'usertool.desktop', 'eyewitness.desktop', 'domains.desktop', 'metadata.desktop', 'httrack.desktop', 'metagoofil.desktop', 'elasticsearch.desktop', 'reddit.desktop', 'internetarchive.desktop', 'spiderfoot.desktop', 'recon-ng.desktop', 'mediainfo-gui.desktop', 'google-earth-pro.desktop', 'kazam.desktop', 'keepassxc_keepassxc.desktop', 'gnome-control-center.desktop']"
    gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 32
}
linux_install_osint_tools(){
    basic_pkgs="build-essential dkms tldr clamav clamav-daemon clamtk snapd gcc make perl python3-pip python3 vlc curl git apt-transport-https python3.9"
    osint_pkgs="ffmpeg youtube-dl yt-dlp libncurses5-dev filezilla libffi-dev code kazam keepassxc subversion default-jre mediainfo-gui libimage-exiftool-perl mat2 webhttrack libcanberra-gtk-module"
    osint_snaps="gallery-dl amass joplin-james-carroll ffsend drawio"
    
    sudo -S "$system_password"  apt update --fix-missing

    #install vm files from intel techniques website
    inteltech_download vm-files
    downloaded_inteltech_path="$USER/Desktop/vm-files"
    cp "$downloaded_inteltech_path"/scripts/*  "$USER"/Documents/scripts/
    cp "$downloaded_inteltech_path"/icons/*  "$USER"/Documents/icons/  
    sudo cp "$downloaded_inteltech_path"/shortcuts/* /usr/share/applications/
    rm -rf "$downloaded_inteltech_path"

    #install Firefox Profile
    setup_firefox
    #install Search Tools
    inteltech_download tools
    downloaded_inteltech_path="$USER/Desktop/tools"
    #install caller id
    cd "$USER"/Documents/scripts || printf "Something is wrong\nThat directory doesn't exist here"
    curl -u osint9:book143wt -O  https://inteltechniques.com/osintbook9/cid.sh
    chmod +x cid.sh
    curl -u osint9:book143wt -O  https://inteltechniques.com/osintbook9/cid.desktop
    chmod +x cid.desktop
    sudo cp cid.desktop /usr/share/applications/
    rm cid.desktop

    # install visual studio code for linux
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg

    # install cryptomator repo 
    sudo add-apt-repository ppa:sebastian-stenzel/cryptomator

    #install required linux packages
    sudo -S system_password apt update
    for pkg in $basic_pkgs;do sudo apt install -y "$pkg";done #install basic linux packages
    for pkg in $osint_pkgs;do sudo apt install -y "$pkg";done
    for snap in $osint_snaps;do sudo snap install "$snap";done #install basic snaps
    # prevent from breaking if 1 install fails
    
    #install browsers
    linux_install_browsers

    git_installer https://github.com/Datalux/Osintgram.git
    python3 -m venv venv
    source venv/bin/activate

    read -p "set up with instagram creds (y/n):" setup_var
    if [ "$setup_var" == 'y' ];then 
    make setup #(This asks for IG username/pass, skip if desired)
    fi 
    #install joplin
    wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bashwget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash
    
    git_installer https://github.com/ChrisTruncer/EyeWitness.git
    sudo -H ./setup.sh

    echo "RipMe is an album ripper for various websites. It is a cross-platform tool that runs on your computer, and requires Java 8. RipMe has been tested and confirmed working on Windows, Linux and MacOS." 
    sleep 3 #pause for user to read
    echo "Double Click for GUI or java -jar ripme.jar for CLI" 
    sleep 1
    cd  "$USER"/Downloads/Programs || printf "Something is wrong\nThat directory doesn't exist here"
    wget https://github.com/ripmeapp/ripme/releases/latest/download/ripme.jar
    chmod +x ripme.jar

    #install google earth
    wget http://dl.google.com/dl/earth/client/current/google-earth-stable_current_amd64.deb
    sudo -S "$system_password" apt install -y ./google-earth-stable_current_amd64.deb
    sudo rm google-earth-stable_current_amd64.deb

    linux_update_all
}

base_setup(){
    # Make Directories
    mkdir -p "$USER"/Downloads/Programs "$USER"/Documents/scripts "$USER"/Documents/icons
    #install required pip using python3.9 pip3
    install_git_pip

    echo "Type sudo password to use througout program, Leave blank for added security "
    read -s system_password
    if [ "$os" == "Darwin" ];then
        macos_install_osint_tools
        sudo -S "$system_password" reboot
    elif [ "$os" == "Linux" ];then
        #assume linux
        linux_install_osint_tools
        reboot
    else
        #assume not linux or mac
        exit 1
    fi
}

upgrade_system(){
    if [ "$os" == "Darwin" ];then
        macos_upgrade_all
    elif [ "$os" == "Linux" ];then
        linux_update_all
    else
        #assume not linux or mac
        exit 1
    fi
    # perform other database updates
    tldr --update
    freshclam
}
### Menu and Run Script ###
PS3='Please enter your choice: '
options=("Set Up Computer" "Setup Firefox" "Install Only Git and PIP Tools" "GPG Setup" "Upgrade System" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Set Up Computer")
            base_setup
            ;;
        "Setup Firefox")
            setup_firefox
            ;;
        "Upgrade System")
            upgrade_system
            ;;
        "Install Only Git and PIP Tools")
            install_git_pip
            ;;
        "GPG Setup")
            gpg_generator
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done