# Research and Privacy
 System set up for research and use using secure tools and configurations


# Script Usage & Install 
## Install 
`git clone https://github.com/gitayam/Research-and-Privacy.git && chmod 755 ./Research-and-Privacy/OSINT_setup.sh`
## Configure
Make the download script executable using the following command in the Terminal App if you did not copy and past the above script
`chmod 755 ./OSINT_setup.sh`

To add, remove, or modify the tools and pkgs being installed search for the following:
- basic_pkgs (Linux)
- osint_pkgs (Linux)
- osint_snaps (Linux)
- osint_pips (both)
- osint_gits (both)
- dfp_pips (both)
- brew_apps (macOS)
- brew_casts (macOS)
## Use
`./OSINT_setup.sh`

# System Requirements 
macOS or Debian Based Linux

# Credits
## [Michael Bazzell](https://inteltechniques.com/) 
Based and expanded from 2022 Michael Bazzell OSINT 9. His books and guides are great and always cutting edge, this script is intended to make the tools even easier to start on macOS or Linux. Highly recommend you buy his [books](https://inteltechniques.com/books.html)

## [Logicwax](https://github.com/Logicwax)
The guides provided in this repo are what got me started using GPG and Yubikey. They are introduced here though you should consider using an air-gapped separate system when generating your gpg key pairs

## [Carey Parker](https://firewallsdontstopdragons.com/)
Some of the tools and configurations were identified by carey parker. I highly recommend his [podcast](https://firewallsdontstopdragons.com/podcast/)

## [Shell Check](https://www.shellcheck.net/)
My go to bash debugger and all around proofreading tool

# TOOLS and Packages used
## GPG Setup
- [gpg-provision](https://github.com/Logicwax/gpg-provision): easy interface for generating a full GPG keychain (Master CA key + 3 subkeys), generating backup files, revocation certifications, public ssh keys, and provisoning yubikeys/smart cards with these keys (one yubikey/smartcard for the CA master key to enable expiration bumping and signing others public keys, and another yubikey/smartcard to hold the 3-subkeys for day-today usage such as signing, authorizing, and decryption).
- [gpg-agent setup](): set up environment to work with yubikey for OpenPGP based SSH keys
- [GPG Suite](https://gpgtools.org/)
- [yubikey manager](yubikey-manager)
- [Thunderbird](https://www.thunderbird.net/en-US/thunderbird/all/): free email application that’s easy to set up and customize and works well with GPG and Yubikey
## Installed Git Repos
- [Amass](https://github.com/OWASP/Amass)
- [Brew](https://brew.sh)
- [Elasticsearch-Crawler](https://github.com/AmIJesse/Elasticsearch-Crawler)
- [ExifTool](https://github.com/pandastream/libimage-exiftool-perl-9.27)
- [EyeWitness](https://github.com/ChrisTruncer/EyeWitness)
- [ffsend](https://github.com/timvisee/ffsend)
- [fsociety](https://github.com/Manisso/fsociety)
- [HTTrack](https://www.httrack.com/)
- [h8mail](https://github.com/khast3x/h8mail)
- [holehe](https://github.com/megadose/holehe)
- [instaloader](https://instaloader.github.io/)
- [instaLooter](https://github.com/althonos/InstaLooter)
- [linkScrap](https://github.com/NickSanzotta/linkScrape.git)
- [Metagoofil](https://github.com/opsdisk/metagoofil)
- [Moriarty-Project V2.6](https://github.com/AzizKpln/Moriarty-Project)
- [nmap](https://nmap.org/)
- [OSINTgram](https://github.com/Datalux/Osintgram.git)
- [Photon](https://github.com/s0md3v/Photon)
- [recon-ng](https://github.com/lanmaster53/recon-ng)
- [redditsfinder](https://github.com/Fitzy1293/redditsfinder)
- [Ripgrep](https://github.com/BurntSushi/ripgrep)
- [sublist3r](https://github.com/aboul3la/Sublist3r)
- [sherlock](https://github.com/sherlock-project/sherlock)
- [spiderfoot](https://github.com/smicallef/spiderfoot)
- [SNScrape](https://github.com/JustAnotherArchivist/snscrape)
- [twint](https://github.com/twintproject/twint)
- [The Harvester](https://github.com/laramies/theHarvester)


### Applications Installed
- [Android Studio](https://developer.android.com/studio)
- [Audacity](https://www.audacityteam.org/)
- [Brave Browser](https://brave.com/)
- [ClamsAV](https://www.clamav.net/)
- [Cryptomator](https://cryptomator.org/)
- [Cyberduck](https://cyberduck.io/) || [Filezilla](https://filezilla-project.org/)
- [Draw.io](https://draw.io)
- [Google Earth](https://www.google.com/earth/versions/#earth-pro)
- [iTerm2](https://iterm2.com/)
- [Joplin](https://joplinapp.org/)
- [KeepassXC](https://keepassxc.org/)
- [Kazam](https://launchpad.net/kazam)
- [Ripgrep](https://github.com/BurntSushi/ripgrep)
- [OpenShot](https://www.openshot.org/)
- [Tor Browser](https://www.torproject.org/)
- [Visutal Studio Code](https://code.visualstudio.com/)
- [Virtual Box](https://www.virtualbox.org/)
- [VLC](https://www.videolan.org/vlc/index.html)
- [Youtube Downloader](https://github.com/yt-dlp/yt-dlp) // Not buffered by youtube
