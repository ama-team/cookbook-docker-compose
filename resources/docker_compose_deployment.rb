resource_name :docker_compose_deployment

actions :create, :start, :stop, :delete, :rm, :restart, :pull, :push, :up, :down, :kill
default_action :up

attribute :compose_path, kind_of: String, default: '/usr/local/bin/docker-compose'
attribute :configuration_file, kind_of: String, name_property: true
attribute :configuration_files, kind_of: Array, default: []
attribute :timeout, kind_of: Integer, default: 30
attribute :stop_timeout, kind_of: Integer, default: 10
attribute :signal, kind_of: String, default: 'SIGKILL'
