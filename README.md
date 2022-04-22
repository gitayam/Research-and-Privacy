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
| \## Installed Git Repos | \### Applications Installed |
| --- | --- |
| \- [Amass](https://github.com/OWASP/Amass)<br>\- [Brew](https://brew.sh)<br>\- [Elasticsearch-Crawler](https://github.com/AmIJesse/Elasticsearch-Crawler)<br>\- [ExifTool](https://github.com/pandastream/libimage-exiftool-perl-9.27)<br>\- [EyeWitness](https://github.com/ChrisTruncer/EyeWitness)<br>\- [ffsend](https://github.com/timvisee/ffsend)<br>\- [fsociety](https://github.com/Manisso/fsociety)<br>\- [HTTrack](https://www.httrack.com/)<br>\- [h8mail](https://github.com/khast3x/h8mail)<br>\- [holehe](https://github.com/megadose/holehe)<br>\- [instaloader](https://instaloader.github.io/)<br>\- [instaLooter](https://github.com/althonos/InstaLooter)<br>\- [linkScrap](https://github.com/NickSanzotta/linkScrape.git)<br>\- [Metagoofil](https://github.com/opsdisk/metagoofil)<br>\- [Moriarty-Project V2.6](https://github.com/AzizKpln/Moriarty-Project)<br>\- [nmap](https://nmap.org/)<br>\- [OSINTgram](https://github.com/Datalux/Osintgram.git)<br>\- [Photon](https://github.com/s0md3v/Photon)<br>\- [recon-ng](https://github.com/lanmaster53/recon-ng)<br>\- [redditsfinder](https://github.com/Fitzy1293/redditsfinder)<br>\- [Ripgrep](https://github.com/BurntSushi/ripgrep)<br>\- [sublist3r](https://github.com/aboul3la/Sublist3r)<br>\- [sherlock](https://github.com/sherlock-project/sherlock)<br>\- [spiderfoot](https://github.com/smicallef/spiderfoot)<br>\- [SNScrape](https://github.com/JustAnotherArchivist/snscrape)<br>\- [twint](https://github.com/twintproject/twint)<br>\- [The Harvester](https://github.com/laramies/theHarvester) | \- [Android Studio](https://developer.android.com/studio)<br>\- [Audacity](https://www.audacityteam.org/)<br>\- [Brave Browser](https://brave.com/)<br>\- [ClamsAV](https://www.clamav.net/)<br>\- [Cryptomator](https://cryptomator.org/)<br>\- [Cyberduck](https://cyberduck.io/) \| [Filezilla](https://filezilla-project.org/)<br>\- [Draw.io](https://draw.io)<br>\- [Google Earth](https://www.google.com/earth/versions/#earth-pro)<br>\- [iTerm2](https://iterm2.com/)<br>\- [Joplin](https://joplinapp.org/)<br>\- [KeepassXC](https://keepassxc.org/)<br>\- [Kazam](https://launchpad.net/kazam)<br>\- [Ripgrep](https://github.com/BurntSushi/ripgrep)<br>\- [OpenShot](https://www.openshot.org/)<br>\- [Tor Browser](https://www.torproject.org/)<br>\- [Visutal Studio Code](https://code.visualstudio.com/)<br>\- [Virtual Box](https://www.virtualbox.org/)<br>\- [VLC](https://www.videolan.org/vlc/index.html)<br>\- [Youtube Downloader](https://github.com/yt-dlp/yt-dlp) // Not buffered by youtube |