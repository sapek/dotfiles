# Install Chocolatey
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Git and Chef
choco install git.install -version 1.9.5.20150114 -y
choco install chef-client -y

# Refresh Path
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")

# "Clone" the dotfiles repo into home directory
cd $HOME
git init
git remote add origin https://github.com/sapek/dotfiles.git
git fetch
git checkout --track origin/master
git submodule init
git submodule update

# Apply the Chef recipe bootstrap
chef-client --local-mode --runlist 'recipe[bootstrap]'

