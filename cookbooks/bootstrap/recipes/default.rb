#
# Cookbook Name:: bootstrap
# Recipe:: default
#
# Copyright (c) 2015 Adam Sapek, All Rights Reserved.
#

SOFTWARE_DRIVE = "#{ENV['SYSTEMDRIVE']}"
DEV_DRIVE = 'c:'

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
    haskellplatform
    cmake
    }
.each do |pack|
  chocolatey pack do
      action :install
  end
end

###############################################
# Install software from corpnet
###############################################
windows_package 'Odd' do
    source '\\\\tkfiltoolbox\\tools\\23785\\2.7.3.5\\msi\\Odd.msi'
    action :install
    ignore_failure true
end

windows_package 'Microsoft Visual Studio Ultimate 2013' do
    source "\\\\products\\public\\PRODUCTS\\Developers\\Visual Studio 2013\\Ultimate\\vs_ultimate"
    installer_type :custom
    options "/adminfile \"#{ENV['USERPROFILE']}\\VisualStudio2013Deployment.xml\" /quiet /norestart"
    ignore_failure true
    action :install
end

###############################################
# Install software from inet
###############################################
windows_package "Python 2.7.10 (64-bit)" do
    source 'https://www.python.org/ftp/python/2.7.10/python-2.7.10.amd64.msi'
    action :install
end

windows_zipfile "#{SOFTWARE_DRIVE}/Python27/symbols" do
    source 'https://www.python.org/ftp/python/2.7.10/python-2.7.10.amd64-pdb.zip'
    action :unzip
    not_if {::File.exists?("#{SOFTWARE_DRIVE}/Python27/symbols")}
end

windows_package 'Python Tools 2.1 for Visual Studio 2013' do
    # for fuck's sake, why can't we provide a normal download URL
    source 'http://download-codeplex.sec.s-msft.com/Download/Release?ProjectName=pytools&DownloadId=920477&FileTime=130576900091770000&Build=21018'
    installer_type :msi
    action :install
end

windows_package 'LLVM' do
    source 'http://llvm.org/releases/3.6.1/LLVM-3.6.1-win32.exe'
    installer_type :nsis
    action :install
end

windows_package "JetBrains ReSharper 8.2.3" do
    source 'http://download.jetbrains.com/resharper/ReSharperSetup.8.2.3000.5176.msi'
    action :install
end

windows_package 'PuTTY release 0.64' do
    source 'http://the.earth.li/~sgtatham/putty/latest/x86/putty-0.64-installer.exe'
    installer_type :inno
    action :install
end

windows_package 'Boost 1.58' do
    source 'http://downloads.sourceforge.net/project/boost/boost-binaries/1.58.0/boost_1_58_0-msvc-12.0-64.exe'
    options "/DIR=#{DEV_DRIVE}\\boost_1_58_0"
    not_if {::File.exists?("#{DEV_DRIVE}/boost_1_58_0/boost-build.jam")}
end

windows_zipfile "#{SOFTWARE_DRIVE}/tools/cmder" do
    source 'https://github.com/bliker/cmder/releases/download/v1.2/cmder.zip'
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
# Set environment variables
###############################################
env 'BOOST_ROOT' do
    value "#{DEV_DRIVE}/boost_1_58_0"
end

env 'BOOST_LIBRARYDIR' do
    value "#{DEV_DRIVE}/boost_1_58_0/lib64-msvc-12.0"
end

env 'PreferredToolArchitecture' do
    value 'x64'
end

###############################################
# Update PATH
###############################################
PATH = [
    "#{ENV['ProgramFiles(x86)']}/CMake/bin"
]

PATH.each do |path|
  windows_path path do
    action :add
  end
end

###############################################
# Registry settings
###############################################
registry_key 'HKCU\SOFTWARE\JetBrains\ReSharper\v8.2\vs12.0\LicenseSettings\Str' do
  values [{
    :name => 'CustomLicenseServerUrl',
    :type => :string,
    :data => 'http://resharper8:8080/licenseServer'
  },{
    :name => 'LicenseMode',
    :type => :string,
    :data => 'LICENSE_SERVER_FLOATING'
  }]
  action :create
  recursive true
end

registry_key 'HKCU\SOFTWARE\JetBrains\ReSharper\v8.2\vs12.0\LicenseSettings\Bool' do
  values [{
    :name => 'UseCustomLicenseServer',
    :type => :dword,
    :data => 1
  }]
  action :create
  recursive true
end

registry_key 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' do
  values [{
    :name => 'ConsentPromptBehaviorAdmin',
    :type => :dword,
    :data => 0
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
