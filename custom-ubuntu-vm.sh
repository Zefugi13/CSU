#!/bin/bash

## General setup
sudo dpkg-reconfigure locales

sudo dpkg-reconfigure tzdata

sudo apt update

sudo apt install -y aptitude

sudo aptitude update

sudo aptitude dist-upgrade -y

sudo aptitude install -y apt-transport-https \
	ca-certificates \
	curl \
	software-properties-common \
	net-tools \
	ncdu \
	htop \
	asciinema \
	unzip \
	zip \
	dos2unix \
	wget \
	mlocate \
	build-essential \
	git \
	qemu-guest-agent \
	dtrx

apt autoremove -y
apt autoclean -y


## Add primary user
sudo adduser wilson

## sudoers.d file for passwordless sudo
cat > /etc/sudoers.d/010_wilson-nopasswd <<EOF
wilson ALL=(ALL) NOPASSWD: ALL
EOF

mkdir /home/wilson/bin
ln -s /home/wilson/bin /root/bin
chown wilson:wilson -R /home/wilson/bin

## Improve nano syntax highlighting
sudo git clone https://github.com/scopatz/nanorc.git /usr/share/nano-syntax-highlighting
/bin/bash /usr/share/nano-syntax-highlighting/install.sh -l


## Add color to the terminal interface (user root}
sed -i "s/#force_color_prompt=yes/force_color_prompt=yes/" /root/.bashrc
sed -i "s/#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'/export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'/" /root/.bashrc


## Custom additions to ~/.bashrc (user root)
echo 'PATH="$HOME/bin:/home/taylor/bin:/usr/local/bin:/usr/bin:$PATH"' >> /root/.bashrc


## Add color to the terminal interface (user Wilson)
sed -i "s/#force_color_prompt=yes/force_color_prompt=yes/" /home/wilson/.bashrc
sed -i "s/#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'/export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'/" /home/taylor/.bashrc


## Custom additions to ~/.bashrc (user Wilson)
echo 'PATH="$HOME/bin:/root/bin:$PATH"' >> /home/wilson/.bashrc
chown wilson:wilson /home/wilson/.bashrc

## Create ~/.bash_aliases (user root)
cat > /root/.bash_aliases <<EOF
################################ Bash Aliases ####################################
############################## ~/.bash_aliases ###################################

## Enable Colors
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi


## General Use
alias ll='ls -AFhHl'
alias la='ls -AH'
alias l='ls -CFhH'
alias lsd="ls -aFhHl | grep /$"
alias jc="sudo journalctl -xe"


## Package management
alias supd='sudo aptitude update'
alias supg='sudo aptitude full-upgrade'
alias supdg='sudo aptitude update && sudo aptitude full-upgrade'
alias sai='sudo aptitude install'
alias sclean='sudo apt autoclean && sudo apt autoremove'


## ZFS management
alias zfs-listss="zfs list -o name -H -t snapshot -r"


## Print sorted disk usage for current directory
alias diskspace='du -S | sort -n -r |more'

## Print sorted size of only the folders in the current directory
alias folders='find . -maxdepth 1 -type d -print | xargs du -sk | sort -rn'



########################### Program Specific Aliases ###############################

## Caddy command
alias caddy-edit="nano /home/caddy/Caddyfile"
alias caddy-start="sudo systemctl start caddy.service"
alias caddy-stop="sudo systemctl stop caddy.service"
alias caddy-status="sudo systemctl status caddy.service"
alias caddy-restart="sudo systemctl restart caddy.service"
alias caddy-service="sudo nano /etc/systemd/system/caddy.service"
alias caddy-log="sudo nano /var/log/caddy/caddy-server.log"


## Mediawiki
alias update-mediawiki="cd /var/www/mediawiki && php maintenance/update.php --doshared --quick"


## Confluence Commands
alias confluence-start='sudo /bin/bash /opt/atlassian/confluence/bin/start-confluence.sh'
alias confluence-stop='sudo /bin/bash /opt/atlassian/confluence/bin/stop-confluence.sh'
EOF


## Creating bash aliases (user Wilson)
cat > /home/wilson/.bash_aliases <<EOF
################################ Bash Aliases ####################################
############################## ~/.bash_aliases ###################################

## Enable Colors
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi


## General Use
alias ll='ls -AFhHl'
alias la='ls -AH'
alias l='ls -CFhH'
alias lsd="ls -aFhHl | grep /$"
alias jc="sudo journalctl -xe"


## Package management
alias supd='sudo aptitude update'
alias supg='sudo aptitude full-upgrade'
alias supdg='sudo aptitude update && sudo aptitude full-upgrade'
alias sai='sudo aptitude install'
alias sclean='sudo apt autoclean && sudo apt autoremove'


## Print sorted disk usage for current directory
alias diskspace='du -S | sort -n -r |more'


## Print sorted size of only the folders in the current directory
alias folders='find . -maxdepth 1 -type d -print | xargs du -sk | sort -rn'



########################### Program Specific Aliases ###############################

## Caddy command
alias caddy-edit="nano /home/caddy/Caddyfile"
alias caddy-start="sudo systemctl start caddy.service"
alias caddy-stop="sudo systemctl stop caddy.service"
alias caddy-status="sudo systemctl status caddy.service"
alias caddy-restart="sudo systemctl restart caddy.service"
alias caddy-service="sudo nano /etc/systemd/system/caddy.service"
alias caddy-log="sudo nano /var/log/caddy/caddy-server.log"


## Mediawiki
alias update-mediawiki="cd /var/www/mediawiki && php maintenance/update.php --doshared --quick"


## Confluence Commands
alias confluence-start='sudo /bin/bash /opt/atlassian/confluence/bin/start-confluence.sh'
alias confluence-stop='sudo /bin/bash /opt/atlassian/confluence/bin/stop-confluence.sh'
EOF
chown wilson:wilson /home/wilson/.bash_aliases

## File sharing
sudo aptitude install -y samba \
	openssh-server \
	nfs-common


## Custom samba
cat >> /etc/samba/smb.conf <<EOF
[root directory]
path = /
writeable = yes
guest ok = yes
create mask = 0644
directory mask = 0775
force user = root
EOF

sudo systemctl restart smbd

sudo systemctl status smbd


sudo apt autoclean
sudo apt autoremove

echo -e '\033[1;33m Finished setting up your new Ubuntu Server \033[0m'
