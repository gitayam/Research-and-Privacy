#!/bin/bash

### System Checks ###
# detect  OS
    os=$(uname)
# check for internet
    if nc -zw1 google.com 443 &> /dev/null;then
    #assume Internet available.
        echo &> /dev/null
    else
        #assume Offline.
        printf "No Internet Detected.\nCheck Internet Connection and try again.\n"
        exit 1
    fi


### Global Variables ###
base_pips="coloredlogs censys rich testresources lxml matplotlib xeuledoc pipenv"
osint_pips="snscrape gallery-dl yt-dlp youtube-tool nested-lookup internetarchive ripgrepy waybackpy search-that-hash h8mail streamlink Instalooter Instaloader toutatis redditsfinder bdfr beautifulsoup4 bs4 socialscan holehe webscreenshot"
research_gits="NickSanzotta/linkScrape.git mxrch/GHunt.git AmIJesse/Elasticsearch-Crawler.git twintproject/twint.git Und3rf10w/kali-anonsurf.git AzizKpln/Moriarty-Project.git soxoj/maigret.git megadose/holehe.git smicallef/spiderfoot.git Lazza/Carbon14.git sherlock-project/sherlock.git WebBreacher/WhatsMyName.git martinvigo/email2phonenumber.git aboul3la/Sublist3r.git s0md3v/Photon.git GuidoBartoli/sherloq.git opsdisk/metagoofil.git MalloyDelacroix/DownloaderForReddit.git laramies/theHarvester.git lanmaster53/recon-ng.git"
dfp_pips="yubikey-manager"

### Functions ### 
git_installer(){ # Function for installing Git
    mkdir ~/Downloads/Programs
    git_name=$(echo "$1"|cut -d '/' -f 5|cut -d '.' -f 1)
    #pass git url as arg $1 and identify path for git download as program dir
    cd ~/Downloads/Programs
    git clone "$1"
    ##assume in program dir
    cd ./$git_name || printf "Something is wrong\nThat directory doesn't exist here\n"
    pip3 install -r requirements.txt -I
    #return back to program dir
    cd ~/Downloads/Programs
}
git_update(){
    git_name=$(echo "$1"|cut -d '/' -f 5|cut -d '.' -f 1)
    #pass git url as arg $1
    #cd  ~/Downloads/Programs || echo "assuming no git downloads" && exit
    cd ~/Downloads/Programs/$git_name || printf "Something is wrong\nThat directory doesn't exist here\n"
    git pull "$1"
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
    #install base level pips
    for pip_pkg in $base_pips;do pip3 install "$pip_pkg";done
    #install required pip using python3.9 pip3
    for pip_pkg in $osint_pips;do pip3 install "$pip_pkg";done
    #install several git repos
    for git_repo in $research_gits;do git_installer "https://github.com/$git_repo";done

}
gpg_generator(){
    sudo apt-get install -y gpg scdaemon pcscd python3-ptyprocess
    for pip_pkg in $dfp_pips;do  pip3 install"$pip_pkg";done #install yubikeymanager os agnostic
    git_installer https://github.com/Logicwax/gpg-provision.git
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
    printf "export GPG_TTY=\"$(tty)\"\nexport SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)\ngpgconf --launch gpg-agent"  >> ~/.bash_profile
    printf 'alias ssh="gpg-connect-agent updatestartuptty /bye > /dev/null; ssh"\nalias scp="gpg-connect-agent updatestartuptty /bye > /dev/null; scp"'>> ~/.bash_profile
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
    sudo periodic daily weekly monthly
    pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 sudo -H python3 -m pip install -U
    softwareupdate -ia
}

macos_install_osint_tools(){
    brew_apps="firefox brave-browser thunderbird vlc tor-browser element cryptomator audacity iterm2 cyberduck joplin visual-studio-code drawio clamxav google-earth-pro keepassxc wine-stable android-studio virtualbox virtualbox-extension-pack"
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
    
    ##FIXME: Brave and Firefox configs
    #
    
    macos_upgrade_all
}
## Linux Based Functions
linux_update_all(){
    sudo apt update --fix-missing && sudo apt -y upgrade
    pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U
}

linux_install_browsers(){
    echo "Installing Browsers: Brave and Tor Browser https://brave.com/linux/"
    #install brave browser
    sudo  curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    #install torbrowser launcher
    sudo add-apt-repository -y ppa:micahflee/ppa
    #update and install
    sudo apt update 
    sudo apt install -y torbrowser-launcher brave-browser
}

linux_install_osint_tools(){
    basic_pkgs="build-essential dkms tldr clamav clamav-daemon clamtk snapd gcc make perl python3-pip python3 vlc curl git apt-transport-https python3.9"
    research_pkgs="ffmpeg youtube-dl yt-dlp libncurses5-dev libffi-dev code kazam keepassxc subversion default-jre mediainfo-gui libimage-exiftool-perl mat2 webhttrack libcanberra-gtk-module"
    dfp_pkgs="element-desktop filezilla"
    research_snaps="gallery-dl amass joplin-james-carroll ffsend drawio"
    
    sudo apt update --fix-missing

    # install visual studio code for linux
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg

    # Install element messenger for linux
    sudo wget -O /usr/share/keyrings/element-io-archive-keyring.gpg https://packages.element.io/debian/element-io-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/element-io-archive-keyring.gpg] https://packages.element.io/debian/ default main" | sudo tee /etc/apt/sources.list.d/element-io.list

    # install cryptomator repo 
    sudo add-apt-repository ppa:sebastian-stenzel/cryptomator

    #install required linux packages, osint pkgs, dpf pkgs, ands snaps
    sudo  apt update
    for pkg in $basic_pkgs;do sudo apt install -y "$pkg";done #install basic linux packages
    for pkg in $research_pkgs;do sudo apt install -y "$pkg";done
    for pkg in $dfp_pkgs;do sudo apt install -y "$pkg";done
    for snap in $research_snaps;do sudo snap install "$snap";done #install basic snaps
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
    cd  ~/Downloads/Programs || printf "Something is wrong\nThat directory doesn't exist here\n"
    wget https://github.com/ripmeapp/ripme/releases/latest/download/ripme.jar
    chmod +x ripme.jar

    #install google earth
    wget http://dl.google.com/dl/earth/client/current/google-earth-stable_current_amd64.deb
    sudo  apt install -y ./google-earth-stable_current_amd64.deb
    sudo rm google-earth-stable_current_amd64.deb

    linux_update_all
}

base_setup(){
    
    #install required pip using python3.9 pip3
    install_git_pip

    
    if [ "$os" == "Darwin" ];then
        macos_install_osint_tools
        sudo  reboot
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
    #update git repos
    for git_repo in $research_gits;do git_update "https://github.com/$git_repo";done
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
            echo "pending" ##FIXME
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