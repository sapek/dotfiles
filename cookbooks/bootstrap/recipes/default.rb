#
# Cookbook Name:: bootstrap
# Recipe:: default
#
# Copyright (c) 2015 Adam Sapek, All Rights Reserved.
#

SOFTWARE_DRIVE = "#{ENV['SYSTEMDRIVE']}"
DEV_DRIVE = 'c:'

###############################################
# Install software from corpnet
###############################################
windows_package 'Microsoft Visual Studio Enterprise 2015' do
    source "\\\\products\\public\\PRODUCTS\\Developers\\Visual Studio 2015\\Enterprise 2015.3\\vs_enterprise"
    installer_type :custom
    options "/adminfile \"#{ENV['USERPROFILE']}\\VisualStudio2015.3Deployment.xml\" /quiet /norestart"
    ignore_failure true
    timeout 1800
    action :install
end

windows_package 'Odd' do
    source '\\\\tkfiltoolbox\\tools\\23785\\2.7.3.5\\msi\\Odd.msi'
    action :install
    ignore_failure true
end

###############################################
# Enable Windows features
###############################################
%w{
    IIS-WebServerRole
    IIS-WebServer
    Microsoft-Hyper-V-All
    }
.each do |feature|
  windows_feature feature do
    action :install
  end
end

###############################################
# Install Chocolatey packages
###############################################
%w{
    vim
    google-chrome-x64
    firefox
    cmake
    doxygen.install
    }
.each do |pack|
  chocolatey pack do
      action :install
  end
end

###############################################
# Install software from inet
###############################################
windows_package "Haskell Platform 7.10.2-a" do
    source 'https://haskell.org/platform/download/7.10.2/HaskellPlatform-7.10.2-a-x86_64-setup.exe'
    action :install
    installer_type :nsis
end

windows_package "Python 2.7.10 (64-bit)" do
    source 'https://www.python.org/ftp/python/2.7.10/python-2.7.10.amd64.msi'
    action :install
end

windows_zipfile "#{SOFTWARE_DRIVE}/Python27/symbols" do
    source 'https://www.python.org/ftp/python/2.7.10/python-2.7.10.amd64-pdb.zip'
    action :unzip
    not_if {::File.exists?("#{SOFTWARE_DRIVE}/Python27/symbols")}
end

windows_zipfile "#{ENV['ProgramFiles(x86)']}/ProcessExplorer" do
    source 'https://download.sysinternals.com/files/ProcessExplorer.zip'
    action :unzip
    not_if {::File.exists?("#{ENV['ProgramFiles(x86)']}/ProcessExplorer/procexp.exe")}
end

%w{
    2015
}
.each do |ver|
    windows_package "JetBrains ReSharper Ultimate in Visual Studio #{ver}" do
        source 'http://download.jetbrains.com/resharper/JetBrains.ReSharperUltimate.2015.1.2.exe'
        installer_type :custom
        options "/VsVersion=12,14 /SpecificProductNames=ReSharper /Silent=True"
        action :install
    end
end

windows_package 'PuTTY release 0.67' do
    source 'http://the.earth.li/~sgtatham/putty/latest/x86/putty-0.67-installer.exe'
    installer_type :inno
    action :install
end

%w{
    14
}
.each do |ver|
    windows_package "Boost 1.61 msvc-#{ver}" do
        source "http://heanet.dl.sourceforge.net/project/boost/boost-binaries/1.61.0/boost_1_61_0-msvc-#{ver}.0-64.exe"
        options "/NOICONS /NORESTART /SUPPRESSMSGBOXES /SP- /VERYSILENT /DIR=#{DEV_DRIVE}\\boost_1_61_0"
        not_if {::File.exists?("#{DEV_DRIVE}/boost_1_61_0/lib64-msvc-#{ver}.0/DEPENDENCY_VERSIONS.txt")}
    end
end

windows_zipfile "#{SOFTWARE_DRIVE}/tools/cmder" do
    source 'https://github.com/cmderdev/cmder/releases/download/v1.3.0-pre/cmder.zip'
    action :unzip
    not_if {::File.exists?("#{SOFTWARE_DRIVE}/tools/cmder/cmder.exe")}
end

link "#{SOFTWARE_DRIVE}/tools/cmder/config/ConEmu.xml" do
    to "#{ENV['USERPROFILE']}/ConEmu.xml"
end

link "#{ENV['USERPROFILE']}/vimfiles" do
    to "#{ENV['USERPROFILE']}/.vim"
end


###############################################
# install cabal packages
###############################################
powershell_script "cabal update" do
    code <<-EOH
    $env:HTTP_PROXY = "http://itgproxy"
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")
    cabal update
    EOH
end

%w{
    pointfree
    pandoc
}
.each do |package|
    powershell_script package do
        code <<-EOH
        $env:HTTP_PROXY = "http://itgproxy"
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")
        cabal install --jobs #{package}
        EOH
        timeout 1800
    end
end


# Non-gui vim on Windows doesn't find spelling dictionaries in the install
# location. As a workaround create links from .vim/spell directory.
%w{
    en.ascii.spl
    en.ascii.sug
    en.latin1.spl
    en.latin1.sug
    en.utf-8.spl
    en.utf-8.sug
}
.each do |dictionary|
    link "#{ENV['USERPROFILE']}/.vim/spell/#{dictionary}" do
        to "#{ENV['ProgramFiles(x86)']}/vim/vim74/spell/#{dictionary}"
    end
end

###############################################
# Set environment variables
###############################################
env 'BOOST_ROOT' do
    value "#{DEV_DRIVE}/boost_1_61_0"
end

env 'BOOST_LIBRARYDIR' do
    value "#{DEV_DRIVE}/boost_1_61_0/lib64-msvc-12.0;#{DEV_DRIVE}/boost_1_61_0/lib64-msvc-14.0"
end

env 'PreferredToolArchitecture' do
    value 'x64'
end

env 'HTTP_PROXY' do
    value 'http://itgproxy'
end

###############################################
# Update PATH
###############################################
PATH = [
    "#{ENV['ProgramFiles(x86)']}/CMake/bin",
    "#{SOFTWARE_DRIVE}/Python27",
]

PATH.each do |path|
  windows_path path do
    action :add
  end
end

###############################################
# Registry settings
###############################################
registry_key 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' do
  values [{
    :name => 'ConsentPromptBehaviorAdmin',
    :type => :dword,
    :data => 0
  }]
  action :create
end

registry_key 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock' do
  values [{
    :name => 'AllowDevelopmentWithoutDevLicense',
    :type => :dword,
    :data => 1
  },{
    :name => 'AllowAllTrustedApps',
    :type => :dword,
    :data => 1
  }]
  action :create
end

registry_key 'HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' do
  values [{
    :name => 'Hidden',
    :type => :dword,
    :data => 1
  },{
    :name => 'HideFileExt',
    :type => :dword,
    :data => 0
  }]
  action :create
end

# Enable RDP
registry_key 'HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server' do
  values [{
    :name => 'fDenyTSConnections',
    :type => :dword,
    :data => 0
  }]
  action :create
end

# Enable firewall groups
firewall_groups = [
    'Remote Desktop',
    'File and Printer Sharing',
    'World Wide Web Services (HTTP)',
]

firewall_groups.each do |group|
    execute group do
        command "netsh advfirewall firewall set rule group=\"#{group}\" new enable=\"Yes\""
    end
end

execute 'High performance power scheme' do
    command 'powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c'
end

execute 'Putty sessions' do
    command "regedit /s \"#{ENV['USERPROFILE']}\\putty.reg"
    not_if {registry_key_exists?('HKEY_CURRENT_USER\SOFTWARE\SimonTatham\PuTTY\Sessions\sapek.com')} 
end

# Chrome extensions
extensions = [
    'cjpalhdlnbpafiamejdnhcphjbkeiagm', # uBlock
    'hdokiejnpimakedhajhdlcegeplioahd', # LastPass
]

extensions.each do |id|
    registry_key "HKEY_LOCAL_MACHINE\\Software\\Wow6432Node\\Google\\Chrome\\Extensions\\#{id}" do
      values [{
        :name => 'update_url',
        :type => :string,
        :data =>  'https://clients2.google.com/service/update2/crx'
      }]
      action :create
      recursive true
    end
end
