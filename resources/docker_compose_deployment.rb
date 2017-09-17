resource_name :docker_compose_deployment

actions :create, :start, :stop, :delete, :rm, :restart, :pull, :push, :up, :down, :kill, :scale
default_action :up

attribute :executable, String, default: '/usr/local/bin/docker-compose'
attribute :files, [Array, String], name_property: true
attribute :timeout, Integer, default: 10
attribute :shell_timeout, Integer, default: 300
attribute :signal, String, default: 'SIGKILL'
attribute :scale, String
attribute :environment, [Hash, NilClass], default: {}

action_class do
  def configuration_files
    new_resource.files.is_a?(Array) ? new_resource.files : [new_resource.files]
  end

  def execute(*arguments)
    command = [new_resource.executable]
    configuration_files.each do |file|
      command.push('-f')
      command.push(file)
    end
    command = command.concat(arguments)
    parameters = {}
    if new_resource.shell_timeout and new_resource.shell_timeout > 0
      parameters[:timeout] = new_resource.shell_timeout
    end
    if new_resource.environment
      parameters[:environment] = new_resource.environment
    end
    execution = Mixlib::ShellOut.new(*command, parameters).run_command
    execution.error!
  end

  def execute_command(*command)
    description = "call command `#{command}` for deployment defined by configuration #{configuration_files}"
    converge_by description do
      execute(*command)
    end
  end

  def command_rm
    execute_command 'rm', '-f'
  end
end

%w(create start restart pull push down).each do |command|
  action command.to_sym do
    execute_command command
  end
end

action :up do
  execute_command 'up', '-d'
end

action :rm do
  command_rm
end

action :delete do
  command_rm
end

action :kill do
  execute_command 'kill', '-s', new_resource.signal
end

action :stop do
  arguments = ['stop']
  if new_resource.timeout and new_resource.timeout > 0
    arguments = arguments.concat(['--timeout', new_resource.timeout.to_s])
  end
  execute_command(*arguments)
end

action :scale do
    execute_command 'scale', new_resource.scale
end
