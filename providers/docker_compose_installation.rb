class Chef
  class Provider
    class DockerComposeInstallation < ::Chef::Provider
      provides :docker_compose_installation

      def load_current_resource
        @current_resource = ::Chef::Resource::AmaDockerComposeDockerComposeInstallation.new(@new_resource.name)
        @current_resource.path = @new_resource.path
        @current_resource.version = nil
        if ::File.exist?(@new_resource.path)
          match = /\d+(?:\.\d+){2}/.match(execute_shell_command(@new_resource.path, '--version'))
          @current_resource.version = match[0] if match
        end
        @current_resource
      end

      def action_install
        if @current_resource.version != nil and @current_resource.version == @new_resource.version
          ::Chef::Log.debug("docker-compose #{@current_resource.path} matches requested version, skipping")
          return
        end
        source_url = "https://github.com/docker/compose/releases/download/#{@new_resource.version}/docker-compose-#{get_platform}-#{get_arch}"
        converge_by "Download docker-compose v#{@new_resource.version} from #{source_url} to #{@new_resource.path}" do
          remote_file_resource = ::Chef::Resource::RemoteFile.new(@new_resource.path, run_context)
          remote_file_resource.source(source_url)
          remote_file_resource.mode('755')
          remote_file_resource.path(@new_resource.path)
          remote_file_resource.run_action(:create)
        end
      end

      def action_create
        action_install
      end

      def action_delete
        unless ::File::exist?(new_resource.path)
          ::Chef::Log.debug("docker-compose #{@new_resource.path} matches requested version, skipping")
          return
        end
        converge_by "Delete docker-compose installation #{@new_resource.path}" do
          file_resource = ::Chef::Resource::File.new(@new_resource.path, run_context)
          file_resource.path = @new_resource.path
          file_resource.run_action(:delete)
        end
      end

      def action_remove
        action_delete
      end

      def whyrun_supported
        true
      end

      private
      def get_platform
        execute_shell_command 'uname', '-s'
      end
      def get_arch
        execute_shell_command 'uname', '-m'
      end
      def execute_shell_command(*command)
        parameters = {}
        parameters[:timeout] = @new_resource.timeout if @new_resource.timeout
        execution = ::Mixlib::ShellOut.new(*command, parameters).run_command
        execution.error!
        execution.stdout.strip
      end
    end
  end
end