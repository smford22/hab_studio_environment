#
# Cookbook:: hab_studio_environment
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

yum_updated_file = "/var/run/yum_already_updated"

#
# Ensure the package repository is all up-to-date. This is essential
# because sometimes the packages will fail to install because of a
# stale package repository.
#
# This is not idempotent by nature, so we'll add a guard file to make
# it easier/faster for us to iterate on this recipe.
#
execute "yum update -y" do
  action :run
  notifies :create, "file[#{yum_updated_file}]", :immediately
end

file yum_updated_file do
  action :nothing
end

#
# Ensure iptables is disabled and stopped.
#
service "iptables" do
  action [ :disable, :stop ]
end

#
# Semi-disable SELinux, because that's what you do
#
selinux_state "disable SELinux" do
  action :disabled
end

#
# Create the "dockeroot" group and put the "chef" user in it.
# This will be needed later for docker socket permissions.
#
group "dockerroot" do
  members "vagrant"
  action :create
end

#
# Enable the Docker Community Edition repository which is where we'll
# pull Docker from.
#
yum_repository "docker-ce-stable" do
  baseurl 'https://download.docker.com/linux/centos/7/$basearch/stable'
  enabled true
  gpgcheck true
  gpgkey "https://download.docker.com/linux/centos/gpg"
  action :create
end


#
# Upgrade any old "docker" packages to the one from the docker repo
#
package "docker" do
  action :upgrade
end

#
# Write out a docker sysconfig that disables SELinux support
#
template "/etc/sysconfig/docker" do
  source "docker-sysconfig.erb"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

#
# Start the docker service
#
service "docker" do
  action [ :enable, :start ]
end

#
# Ensure the docker socket is grouped into the previously-created
# dockerroot group
#
execute "chown root:dockerroot /var/run/docker.sock" do
  action :run
end

#
# Install docker-compose
#
execute 'sudo curl -L https://github.com/docker/compose/releases/download/1.17.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose' do
  not_if { ::File.exist?('/usr/local/bin/docker-compose') }
end

file '/usr/local/bin/docker-compose' do
  mode '0655'
end


# Install Git
git_client 'default' do
  action :install
end

# Install some basic utils
%w(tree curl).each do |p|
  package p
end

# Install the latest Habitat
hab_install 'install habitat'