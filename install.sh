#!/bin/bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)
RESET=$(tput sgr0)

GO_VERSION=$(curl --silent https://go.dev/VERSION?m=text | head -n 1)

echo "${RED}########################################################################## ${RESET}"
echo "${RED}#                            TOOLS FOR BUG BOUNTY                        # ${RESET}"
echo "${RED}########################################################################## ${RESET}"
logo(){
echo "${BLUE}                                              _                        ${RESET}"
echo "${BLUE}                                             | |                       ${RESET}"
echo "${BLUE}                         ___ _ __   __ _ _ __| | __                    ${RESET}"
echo "${BLUE}                        / __| '_ \ / _' | '__| |/ /                    ${RESET}"
echo "${BLUE}                        \__ \ |_) | (_| | |  |   <                     ${RESET}"
echo "${BLUE}                        |___/ .__/ \__,_|_|  |_|\_\                    ${RESET}"
echo "${BLUE}                            | |                                        ${RESET}"
echo "${BLUE}                            |_|                                        ${RESET}"
}
logo

echo ""
echo "${GREEN}Compilation of tools created by the best people in the InfoSec Community ${RESET}"
echo "${GREEN}                            Thanks to everyone!                          ${RESET}"
echo ""

echo "${GREEN}[+] Updating and installing dependencies ${RESET}"
{
sudo DEBIAN_FRONTEND=noninteractive apt install -yq curl net-tools
sudo DEBIAN_FRONTEND=noninteractive /bin/bash -c "$(curl -sL https://raw.githubusercontent.com/atemporalzen/apt-fast-dev/main/quick-install.sh)"
sudo DEBIAN_FRONTEND=noninteractive echo debconf apt-fast/maxdownloads string 16 | sudo DEBIAN_FRONTEND=noninteractive debconf-set-selections
sudo DEBIAN_FRONTEND=noninteractive echo debconf apt-fast/dlflag boolean true | sudo DEBIAN_FRONTEND=noninteractive debconf-set-selections
sudo DEBIAN_FRONTEND=noninteractive echo debconf apt-fast/aptmanager string apt-get | sudo DEBIAN_FRONTEND=noninteractive debconf-set-selections
sudo DEBIAN_FRONTEND=noninteractive apt install -yq aptitude gnupg

sudo DEBIAN_FRONTEND=noninteractive apt-fast -yq update
sudo DEBIAN_FRONTEND=noninteractive apt-fast -yq upgrade

sudo DEBIAN_FRONTEND=noninteractive apt-fast install -yq apt-transport-https
sudo DEBIAN_FRONTEND=noninteractive apt-fast install -yq libcurl4-openssl-dev
sudo DEBIAN_FRONTEND=noninteractive apt-fast install -yq libssl-dev
sudo DEBIAN_FRONTEND=noninteractive apt-fast install -yq jq
sudo DEBIAN_FRONTEND=noninteractive apt-fast install -yq ruby-full
sudo DEBIAN_FRONTEND=noninteractive apt-fast install -yq libcurl4-openssl-dev libxml2 libxml2-dev libxslt1-dev ruby-dev build-essential libgmp-dev zlib1g-dev
sudo DEBIAN_FRONTEND=noninteractive apt-fast install -yq build-essential libssl-dev libffi-dev
sudo DEBIAN_FRONTEND=noninteractive apt-fast install -yq python-setuptools
sudo DEBIAN_FRONTEND=noninteractive apt-fast install -yq libldns-dev
sudo DEBIAN_FRONTEND=noninteractive apt-fast install -yq python3
sudo DEBIAN_FRONTEND=noninteractive apt-fast install -yq python3-pip
sudo DEBIAN_FRONTEND=noninteractive apt-fast install -yq git gcc make libcap-dev
sudo DEBIAN_FRONTEND=noninteractive apt-fast install -yq npm
sudo DEBIAN_FRONTEND=noninteractive apt-fast install -yq nmap python3-dev
sudo DEBIAN_FRONTEND=noninteractive apt-fast install -yq gem
sudo DEBIAN_FRONTEND=noninteractive apt-fast install -yq perl
sudo DEBIAN_FRONTEND=noninteractive apt-fast install -yq parallel sqlmap
sudo DEBIAN_FRONTEND=noninteractive apt-fast install -yq tmux
sudo DEBIAN_FRONTEND=noninteractive apt-fast install -yq dnsutils
sudo DEBIAN_FRONTEND=noninteractive pip3 install jsbeautifier
} > /dev/null 2>&1
echo ""

echo "${GREEN}[+] Installing Golang ${RESET}"
if [[ ! -f /usr/local/go/bin/go && ! -f /usr/bin/go ]];then
    {
    wget "https://dl.google.com/go/$GO_VERSION.linux-amd64.tar.gz" -O /tmp/$GO_VERSION.linux-amd64.tar.gz
    sudo tar -C /usr/local -xzf /tmp/$GO_VERSION.linux-amd64.tar.gz
    sudo ln -sf /usr/local/go/bin/go /usr/local/bin/
    [[ ":$PATH:" != *":$HOME/.go:"* ]] && ! grep -q "[[ \":\$PATH:\" != *\":\$HOME/.go:\"* ]] && PATH=\$PATH:\$HOME/.go" ~/.bashrc && echo "[[ \":\$PATH:\" != *\":\$HOME/.go:\"* ]] && PATH=\$PATH:\$HOME/.go" >> ~/.bashrc
    [[ ":$PATH:" != *":$HOME/go:"* ]] && ! grep -q "[[ \":\$PATH:\" != *\":\$HOME/go:\"* ]] && PATH=\$PATH:\$HOME/go" ~/.bashrc && echo "[[ \":\$PATH:\" != *\":\$HOME/go:\"* ]] && PATH=\$PATH:\$HOME/go" >> ~/.bashrc
    [[ ":$PATH:" != *":$HOME/go/bin:"* ]] && ! grep -q "[[ \":\$PATH:\" != *\":\$HOME/go/bin:\"* ]] && PATH=\$PATH:\$HOME/go/bin" ~/.bashrc && echo "[[ \":\$PATH:\" != *\":\$HOME/go/bin:\"* ]] && PATH=\$PATH:\$HOME/go/bin" >> ~/.bashrc
    [[ ":$PATH:" != *":$HOME/.go/bin:"* ]] && ! grep -q "[[ \":\$PATH:\" != *\":\$HOME/.go/bin:\"* ]] && PATH=\$PATH:\$HOME/.go/bin" ~/.bashrc && echo "[[ \":\$PATH:\" != *\":\$HOME/.go/bin:\"* ]] && PATH=\$PATH:\$HOME/.go/bin" >> ~/.bashrc
    source ~/.bashrc
    } > /dev/null 2>&1
else
    echo "${BLUE}Golang is already installed.${RESET}"
    echo "${BLUE}Verify you're using the latest version, if not already done.${RESET}"
fi
echo ""

echo "${GREEN}[+] Installing Tools ${RESET}"
{
#Subdomain Enum
go install -v github.com/owasp-amass/amass/v4/...@master
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/tomnomnom/assetfinder@latest   
go install -v github.com/harleo/knockknock@latest
pip3 install dnsgen
pip3 install py-altdns
pip3 install aiodnsbrute
go install -v github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest
go install -v github.com/tomnomnom/burl@latest
go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest
go install -v github.com/d3mondev/puredns/v2@latest
git clone https://github.com/blechschmidt/massdns.git ~/tools/massdns && cd ~/tools/massdns
make && sudo make install
cd ~

#Content Discovery
go install -v github.com/tomnomnom/httprobe@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/OJ/gobuster/v3@latest
go install -v github.com/ffuf/ffuf@latest
pip3 install dirsearch
pip3 install wfuzz
pip3 install dirhunt
pip3 install git+https://github.com/xnl-h4ck3r/urless.git
go install -v github.com/tomnomnom/meg@latest
go install -v github.com/tomnomnom/waybackurls@latest
go install -v github.com/lc/gau/v2/cmd/gau@latest

#Visual Inspection
go install -v github.com/michenriksen/aquatone@latest
go install -v github.com/sensepost/gowitness@latest

#Misc
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
go install -v github.com/projectdiscovery/katana/cmd/katana@latest
go install -v github.com/projectdiscovery/tlsx/cmd/tlsx@latest
go install -v github.com/projectdiscovery/notify/cmd/notify@latest
go install -v github.com/projectdiscovery/uncover/cmd/uncover@latest
go install -v github.com/projectdiscovery/asnmap/cmd/asnmap@latest
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
go install -v github.com/projectdiscovery/mapcidr/cmd/mapcidr@latest
go install -v github.com/BishopFox/jsluice/cmd/jsluice@latest
go install -v github.com/hakluke/hakrawler@latest
go install -v github.com/hahwul/dalfox/v2@latest
go install -v github.com/tomnomnom/qsreplace@latest
go install -v github.com/tomnomnom/hacks/kxss@latest
go install -v github.com/tomnomnom/unfurl@latest
go install -v github.com/tomnomnom/anew@latest

#gf
go install -v github.com/tomnomnom/gf@latest
wget "https://raw.githubusercontent.com/emadshanab/Gf-Patterns-Collection/main/set-all.sh" -O /tmp/gf.sh
chmod +x /tmp/gf.sh && bash /tmp/gf.sh
rm /tmp/gf.sh

#Tools
git clone https://github.com/GerbenJavado/LinkFinder.git ~/tools/linkfinder
git clone https://github.com/devanshbatham/ParamSpider ~/tools/paramspider
git clone https://github.com/s0md3v/Arjun.git ~/tools/arjun
git clone https://github.com/m4ll0k/SecretFinder.git ~/tools/secretfinder
git clone https://github.com/xnl-h4ck3r/waymore.git ~/tools/waymore
git clone https://github.com/xnl-h4ck3r/xnLinkFinder.git ~/tools/xnlinkfinder
} > /dev/null 2>&1
echo "${BLUE}You now have the authority to seize control of the entire world!${RESET}"
echo ""

echo "${GREEN}[+] Downloading wordlists ${RESET}"
echo "${BLUE}Download speed depends on your internet connection${RESET}"
{
mkdir ~/wordlists
git clone https://github.com/danielmiessler/SecLists ~/wordlists/seclists
git clone https://github.com/random-robbie/bruteforce-lists.git ~/wordlists/rrlists
mkdir ~/wordlists/assetnote
wget "https://raw.githubusercontent.com/Bo0oM/fuzz.txt/master/fuzz.txt" -O ~/wordlists/fuzz.txt
wget "https://wordlists-cdn.assetnote.io/./data/manual/pl.txt" -O ~/wordlists/assetnote/pl.txt
wget "https://wordlists-cdn.assetnote.io/./data/manual/2m-subdomains.txt" -O ~/wordlists/assetnote/2m-subdomains.txt
wget "https://wordlists-cdn.assetnote.io/./data/manual/jsp.txt" -O ~/wordlists/assetnote/jsp.txt
wget "https://wordlists-cdn.assetnote.io/./data/manual/wordlist_with_underscores.txt" -O ~/wordlists/assetnote/wordlist_with_underscores.txt
wget "https://wordlists-cdn.assetnote.io/./data/manual/wordlist_no_underscores.txt" -O ~/wordlists/assetnote/wordlist_with_no_underscores.txt
wget "https://wordlists-cdn.assetnote.io/./data/manual/do.txt" -O ~/wordlists/assetnote/do.txt
wget "https://wordlists-cdn.assetnote.io/./data/manual/best-dns-wordlist.txt" -O ~/wordlists/assetnote/best-dns-wordlist.txt
wget "https://wordlists-cdn.assetnote.io/./data/manual/bak.txt" -O ~/wordlists/assetnote/bak.txt
wget "https://wordlists-cdn.assetnote.io/./data/manual/cfm.txt" -O ~/wordlists/assetnote/cfm.txt
wget "https://wordlists-cdn.assetnote.io/./data/manual/php.txt" -O ~/wordlists/assetnote/php.txt
wget "https://wordlists-cdn.assetnote.io/./data/manual/xml_filenames.txt" -O ~/wordlists/assetnote/xml_filenames.txt
wget "https://wordlists-cdn.assetnote.io/./data/manual/asp_lowercase.txt" -O ~/wordlists/assetnote/asp_lowercase.txt
wget "https://wordlists-cdn.assetnote.io/./data/manual/aspx_lowercase.txt" -O ~/wordlists/assetnote/aspx_lowercase.txt
wget "https://wordlists-cdn.assetnote.io/./data/manual/html.txt" -O ~/wordlists/assetnote/html.txt
wget "https://wordlists-cdn.assetnote.io/./data/manual/dot_filenames.txt" -O ~/wordlists/assetnote/dot_filenames.txt
wget "https://wordlists-cdn.assetnote.io/./data/manual/phpmillion.txt" -O ~/wordlists/assetnote/phpmillion.txt
wget "https://raw.githubusercontent.com/six2dez/OneListForAll/main/onelistforallmicro.txt" -O ~/wordlists/onelistforallmicro.txt
wget "https://raw.githubusercontent.com/six2dez/OneListForAll/main/onelistforallshort.txt" -O ~/wordlists/onelistforallshort.txt
} > /dev/null 2>&1

echo ""
echo "${RED}########################################################################## ${RESET}"
echo "${RED}#                                  DONE                                  # ${RESET}"
echo "${RED}########################################################################## ${RESET}"

#> /dev/null 2>&1
