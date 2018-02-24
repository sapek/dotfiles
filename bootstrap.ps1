# Specify proxy
# $env:HTTP_PROXY = "http://itgproxy"

# Install Chocolatey
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Git and Chef
choco install git.install -version 2.16.2 -y
choco install chef-client -y

# Refresh Path
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")

# "Clone" the dotfiles repo into home directory
cd $HOME
git init
git remote add origin https://github.com/sapek/dotfiles.git
git remote set-url --push origin git@github.com:sapek/dotfiles.git
git fetch
git checkout --track origin/master
git submodule init
git submodule update

Write-Host "Run cook.cmd or cook-base.cmd to apply Chef recipes"
