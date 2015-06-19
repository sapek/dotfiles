# Install Chocolatey
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Git and Chef
choco install git.install -version 1.9.5.20150114 -y
choco install chef-client -y

# Run in a new instance of PowerShell so that environment is refreshed
powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/sapek/dotfiles/master/cook.ps1'))"

