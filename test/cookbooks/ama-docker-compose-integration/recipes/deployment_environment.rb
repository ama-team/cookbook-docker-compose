#
# Cookbook Name:: ama-docker-compose-integration
# Recipe:: deployment_environment
#
# Copyright 2017, AMA Team
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

workspace = workspace_directory!('environment')
path = ::File.join(workspace, 'docker-compose-custom.yml')
custom_path = ::File.join(workspace, 'docker-compose-custom.yml')

cookbook_file custom_path do
  source 'docker-compose.yml'
end

# It should bring up deployment even though compose file path is not
# supplied directly
docker_compose_deployment 'fake://path' do
  files([])
  environment(COMPOSE_FILE: custom_path)
  action [:up, :kill]
end
