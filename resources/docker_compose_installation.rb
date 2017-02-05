resource_name :docker_compose_installation

actions :install, :delete, :create, :remove
default_action :install

# todo: it is potentially unsafe to refer to attribute like this, default value should be set at runtime
attribute :version, kind_of: String, required: false, default: node['ama-docker-compose']['version']
attribute :path, kind_of: String, name_attribute: true, required: true
attribute :timeout, kind_of: Integer, default: 300