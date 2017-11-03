#
# Cookbook:: hab_studio_environment
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# Install the latest Habitat
hab_install 'install habitat'


# Install the latest Docker
docker_installation 'default' do
  action :create
end

# Start the Docker Service
docker_service 'default' do
  action [:create, :start]
end