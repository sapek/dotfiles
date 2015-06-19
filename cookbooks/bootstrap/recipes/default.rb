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
    python2
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
    only_if {::File.exists?('\\\\tkfiltoolbox\\tools')}
end    

execute 'Microsoft Visual Studio Ultimate 2013' do
    command "\"\\\\products\\public\\PRODUCTS\\Developers\\Visual Studio 2013\\Ultimate\\vs_ultimate\" /adminfile \"#{ENV['USERPROFILE']}\\VisualStudio2013Deployment.xml\" /quiet /norestart"
    not_if {::File.exists?("#{ENV['ProgramFiles(x86)']}/Microsoft Visual Studio 12.0")}
end

###############################################
# Install software from inet
###############################################
windows_package 'Python Tools 2.1 for Visual Studio 2013' do
    # for fuck's sake, why can't we provide a normal download URL
    source 'http://download-codeplex.sec.s-msft.com/Download/Release?ProjectName=pytools&DownloadId=920477&FileTime=130576900091770000&Build=21018'
    installer_type :msi
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
end

registry_key 'HKCU\SOFTWARE\JetBrains\ReSharper\v8.2\vs12.0\LicenseSettings\Bool' do
  values [{
    :name => 'UseCustomLicenseServer',
    :type => :dword,
    :data => 1
  }]
  action :create
end

# Enable RDP
registry_key 'HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server' do
  values [{
    :name => 'FdenyTSConnections',
    :type => :dword,
    :data => 0
  }]
  action :create
end

execute "RDP firewall hole" do
    command "netsh advfirewall firewall set rule group=\"remote desktop\" new enable=Yes"
end

