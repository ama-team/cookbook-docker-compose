class DockerComposeInstallation < Inspec.resource(1)
  name :docker_compose_installation

  attr_accessor :version

  def initialize(path = '/usr/local/bin/docker-compose')
    @path = path
    if exist?
      execution = inspec.bash("'#{@path}' --version")
      return unless execution.exit_status == 0
      output = execution.stdout
      return unless output
      match = /\d+\.\d+\.\d+/.match(output)
      return unless match
      @version = match[0]
    end
  end

  def exist?
    inspec.file(@path).exist?
  end

  def to_s
    "docker_compose_installation[#{@path}]"
  end
end
