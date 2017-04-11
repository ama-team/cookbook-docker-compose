module AMA
  module Chef
    module DockerCompose
      module Helper
        def command_output(*command)
          execution = ::Mixlib::ShellOut.new(*command).run_command
          execution.error!
          execution.stdout.strip
        end
      end
    end
  end
end