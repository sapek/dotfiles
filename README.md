Bootstrapping a Windows workstation
===================================

Run the following command for an **elevated** cmd:

    @powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/sapek/dotfiles/master/bootstrap.ps1'))"
    
