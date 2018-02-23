#
# Cookbook Name:: devtools
# Recipe:: default
#
# Copyright (c) 2015 Adam Sapek, All Rights Reserved.
#

SOFTWARE_DRIVE = "#{ENV['SYSTEMDRIVE']}"
DEV_DRIVE = 'c:'

###############################################
# Install software from corpnet
###############################################
package 'Microsoft Visual Studio Enterprise 2015' do
    source "\\\\products\\public\\PRODUCTS\\Developers\\Visual Studio 2015\\Enterprise 2015.3\\vs_enterprise.exe"
    installer_type :custom
    options "/adminfile \"#{ENV['USERPROFILE']}\\VisualStudio2015.3Deployment.xml\" /quiet /norestart"
    ignore_failure true
    timeout 1800
    action :install
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
package "Haskell Platform 7.10.2-a" do
    source 'https://haskell.org/platform/download/7.10.2/HaskellPlatform-7.10.2-a-x86_64-setup.exe'
    action :install
    installer_type :nsis
end

package "Python 2.7.10 (64-bit)" do
    source 'https://www.python.org/ftp/python/2.7.10/python-2.7.10.amd64.msi'
    action :install
end

windows_zipfile "#{SOFTWARE_DRIVE}/Python27/symbols" do
    source 'https://www.python.org/ftp/python/2.7.10/python-2.7.10.amd64-pdb.zip'
    action :unzip
    not_if {::File.exists?("#{SOFTWARE_DRIVE}/Python27/symbols")}
end

%w{
    2015
}
.each do |ver|
    package "JetBrains ReSharper Ultimate in Visual Studio #{ver}" do
        source 'http://download.jetbrains.com/resharper/JetBrains.ReSharperUltimate.2015.1.2.exe'
        installer_type :custom
        options "/VsVersion=12,14 /SpecificProductNames=ReSharper /Silent=True"
        action :install
    end
end

%w{
    14
}
.each do |ver|
    package "Boost 1.64 msvc-#{ver}" do
        source "http://iweb.dl.sourceforge.net/project/boost/boost-binaries/1.64.0/boost_1_64_0-msvc-#{ver}.1-64.exe"
        options "/NOICONS /NORESTART /SUPPRESSMSGBOXES /SP- /VERYSILENT /DIR=#{DEV_DRIVE}\\boost_1_64_0"
        not_if {::File.exists?("#{DEV_DRIVE}/boost_1_64_0/lib64-msvc-#{ver}.1/DEPENDENCY_VERSIONS.txt")}
    end
end

###############################################
# install cabal packages
###############################################
powershell_script "cabal update" do
    code <<-EOH
    $env:HTTP_PROXY = "http://itgproxy:80"
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")
    cabal update
    EOH
end

%w{
    pointfree
}
.each do |package|
    powershell_script package do
        code <<-EOH
        $env:HTTP_PROXY = "http://itgproxy:80"
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")
        cabal install --jobs #{package}
        EOH
        timeout 1800
    end
end


###############################################
# Set environment variables
###############################################
env 'BOOST_ROOT' do
    value "#{DEV_DRIVE}/boost_1_64_0"
end

env 'BOOST_LIBRARYDIR' do
    value "#{DEV_DRIVE}/boost_1_64_0/lib64-msvc-12.0;#{DEV_DRIVE}/boost_1_64_0/lib64-msvc-14.0"
end

env 'PreferredToolArchitecture' do
    value 'x64'
end

###############################################
# Update PATH
###############################################
PATH = [
    "#{ENV['ProgramFiles']}/CMake/bin",
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

# Chrome extensions
extensions = [
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
