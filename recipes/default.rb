#
# Cookbook Name:: autoconf
# Recipe:: default
#
# Copyright (C) 2013 Joshua Mervine
#
# All rights reserved - Do Not Redistribute
#
defaults = {
  :ver => "2.69",
  :path => "http://ftp.gnu.org/gnu/autoconf/"
}

autoconf_ver  = (node['autoconf']['version'] || defaults[:ver])  rescue defaults[:ver]
autoconf_path = (node['autoconf']['path']    || defaults[:path]) rescue defaults[:path]
autoconf_tar  = "autoconf-#{autoconf_ver}.tar.gz"
autoconf_url  = "#{autoconf_path}/#{autoconf_tar}"
autoconf_dir  = "/usr/local/bin"

remote_file "/usr/local/src/#{autoconf_tar}" do
  source autoconf_url
  mode 0644
  action :create_if_missing
end

execute "tar --no-same-owner -xzf #{autoconf_tar}" do
  cwd "/usr/local/src"
  creates "/usr/local/src/autoconf-#{autoconf_ver}"
end

execute "configure autoconf" do
  command "./configure"
  cwd "/usr/local/src/autoconf-#{autoconf_ver}"
  creates "/usr/local/src/autoconf-#{autoconf_ver}/Makefile"
end

execute "make autoconf" do
  command "make"
  cwd "/usr/local/src/autoconf-#{autoconf_ver}"
  creates "/usr/local/src/autoconf-#{autoconf_ver}/bin"
end

execute "make install autoconf" do
  command "sudo make install"
  cwd "/usr/local/src/autoconf-#{autoconf_ver}"
  not_if {File.exists?("#{autoconf_dir}/autoconf") && `#{autoconf_dir}/autoconf --version`.chomp =~ /#{autoconf_ver}/}
  creates "#{autoconf_dir}/autoconf"
end

# vim: filetype=ruby
