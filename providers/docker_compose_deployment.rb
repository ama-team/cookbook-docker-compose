class Chef
  class Provider
    class DockerComposeDeployment < ::Chef::Provider
      use_inline_resources

      provides :docker_compose_deployment

      def load_current_resource
        @current_resource ||= ::Chef::Resource::AmaDockerComposeDockerComposeDeployment.new(@new_resource.name)
      end

      %w{create start restart pull push down}.each do |command|
        action command.to_sym do
          execute_command command
        end
      end

      action :up do
        execute_command 'up', '-d'
      end

      action :rm do
        execute_command 'rm', '-f'
      end

      action :delete do
        action_rm
      end

      action :kill do
        execute_command 'kill', '-s', @new_resource.signal
      end

      action :stop do
        arguments = ['stop']
        if @new_resource.stop_timeout
          arguments = arguments.concat(['--timeout', @new_resource.stop_timeout.to_s])
        end
        execute_command *arguments
      end

      private
      def get_configuration_files
        configuration_files = [@new_resource.configuration_file]
        if not @new_resource.configuration_files.nil? and not @new_resource.configuration_files.empty?
          configuration_files = @new_resource.configuration_files
        end
        configuration_files
      end

      def execute(*arguments)
        command = [@new_resource.compose_path]
        get_configuration_files.each do |file|
          command.push('-f')
          command.push(file)
        end
        command = command.concat(arguments)
        parameters = {}
        parameters[:timeout] = @new_resource.timeout if @new_resource.timeout
        execution = Mixlib::ShellOut.new(*command, parameters).run_command
        execution.error!
      end

      def execute_command(*command)
        representation = command.map { |part| '"' + part + '"' } .join ' '
        description = "call command `#{representation}` for deployment defined by configuration #{get_configuration_files}"
        converge_by description do
          execute(*command)
        end
      end
    end
  end
end