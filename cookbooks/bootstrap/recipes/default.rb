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
package 'Odd' do
    source '\\\\tkfiltoolbox\\tools\\23785\\2.8.5.1\\Odd-Release-2.8.5.1.msi'
    action :install
    ignore_failure true
end

###############################################
# Install Chocolatey packages
###############################################
%w{
    vim
    google-chrome-x64
    }
.each do |pack|
  chocolatey pack do
      action :install
  end
end

###############################################
# Install software from inet
###############################################
package "Microsoft Git Credential Manager for Windows 1.14.0" do
    source "https://github.com/Microsoft/Git-Credential-Manager-for-Windows/releases/download/v1.14.0/GCMW-1.14.0.exe"
    action :install
end

windows_zipfile "#{ENV['ProgramFiles(x86)']}/ProcessExplorer" do
    source 'https://download.sysinternals.com/files/ProcessExplorer.zip'
    action :unzip
    not_if {::File.exists?("#{ENV['ProgramFiles(x86)']}/ProcessExplorer/procexp.exe")}
end

windows_zipfile "#{SOFTWARE_DRIVE}/tools/cmder" do
    source 'https://github.com/cmderdev/cmder/releases/download/v1.3.5/cmder.zip'
    action :unzip
    not_if {::File.exists?("#{SOFTWARE_DRIVE}/tools/cmder/cmder.exe")}
end

link "#{SOFTWARE_DRIVE}/tools/cmder/config/ConEmu.xml" do
    to "#{ENV['USERPROFILE']}/ConEmu.xml"
end

link "#{SOFTWARE_DRIVE}/tools/cmder/vendor/conemu-maximus5/ConEmu.xml" do
    to "#{ENV['USERPROFILE']}/ConEmu.xml"
end

link "#{SOFTWARE_DRIVE}/tools/cmder/config/prompt.lua" do
    to "#{ENV['USERPROFILE']}/prompt.lua"
end

link "#{ENV['USERPROFILE']}/vimfiles" do
    to "#{ENV['USERPROFILE']}/.vim"
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
        to "#{ENV['ProgramFiles(x86)']}/vim/vim80/spell/#{dictionary}"
    end
end

###############################################
# Update PATH
###############################################
PATH = [
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

execute 'High performance power scheme' do
    command 'powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c'
end

# Chrome extensions
extensions = [
    'cjpalhdlnbpafiamejdnhcphjbkeiagm', # uBlock
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
