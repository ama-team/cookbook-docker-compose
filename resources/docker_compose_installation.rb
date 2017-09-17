resource_name :docker_compose_installation

actions :install, :delete, :create, :remove
default_action :install

attribute :version, [String, NilClass], required: false
attribute :path, String, name_attribute: true, required: true

load_current_value do
  klass = Class.new do
    include AMA::Chef::DockerCompose::Helper
  end
  if ::File.exist?(path)
    match = /\d+(?:\.\d+){2}/.match(klass.new.command_output(path, '--version'))
    version(match[0]) if match
  end
end

action_class do
  include AMA::Chef::DockerCompose::Helper
  def command_create
    new_version = (new_resource.version or node['ama-docker-compose']['version'])
    if !current_resource.version.nil? and current_resource.version == new_version
      ::Chef::Log.debug("docker-compose #{current_resource.path} matches requested version, skipping")
      return
    end
    source_url = "https://github.com/docker/compose/releases/download/#{new_version}/docker-compose-#{platform}-#{architecture}"
    converge_by "Download docker-compose v#{new_resource.version} from #{source_url} to #{new_resource.path}" do
      remote_file_resource = ::Chef::Resource::RemoteFile.new(new_resource.path, run_context)
      remote_file_resource.source(source_url)
      remote_file_resource.mode('755')
      remote_file_resource.path(new_resource.path)
      remote_file_resource.run_action(:create)
    end
  end

  def command_delete
    unless ::File::exist?(new_resource.path)
      ::Chef::Log.debug("docker-compose #{new_resource.path} doesn't exist, skipping")
      return
    end
    converge_by "Delete docker-compose installation #{new_resource.path}" do
      file_resource = ::Chef::Resource::File.new(new_resource.path, run_context)
      file_resource.path = new_resource.path
      file_resource.run_action(:delete)
    end
  end

  private

  def platform
    command_output 'uname', '-s'
  end

  def architecture
    command_output 'uname', '-m'
  end
end

[:install, :create].each do |action_name|
  action action_name do
    command_create
  end
end

[:delete, :remove].each do |action_name|
  action action_name do
    command_delete
  end
end
