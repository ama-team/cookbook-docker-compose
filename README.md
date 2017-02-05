# Draft warning

This cookbook is in active development and hasn't been released yet. 
You are looking at this simply because master branch had to have 
initial commit.

# ama-docker-compose Cookbook

This cookbook automates installation and usage of docker-compose.

## Requirements

### Platforms

- Ubuntu

Should work on Debian and other Linux distros as well, but we don't 
have enough time to set up kitchen grounds for all cases. Should work
on Mac as well but never tested.

### Chef

- Chef 12.0 or later

### Cookbooks

This cookbook doesn't have any dependencies on other cookbooks.

## Attributes

Attributes are used to set default values only. Most probably you 
will override them in resource specification and will never need to 
tune.

| Key                                 | Default  |
|:------------------------------------|:---------|
| `['ama-docker-compose']['version']` | `1.10.1` |

## Resources

### docker_compose_installation

```ruby
docker_compose_installation '/usr/local/bin/docker-compose' do
  version '1.10.1'
   # if not set, uname output will be used - most probably you won't need it
  arch 'x86_64'
  # same thing
  platform 'Linux'
  # just in case you don't like specifying path in resource name 
  path '/usr/local/bin/docker-compose'
  # create it or delete it
  action :create
end
```

### docker_compose_deployment

```ruby
docker_compose_deployment '/srv/router/docker-compose.yml' do
  # standard location is used by default, but you can specify it if you wish
  compose_path '/usr/local/bin/docker-compose'
  configuration_files ['/srv/router/docker-compose.yml', '/srv/router/docker-compose-overrides.yml']
  timeout 10 # for :stop action
  signal 'SIGHUP' # for :kill action
  action :up
end
```

Please note that name property is used to locate configuration file
unless `configuration_files` contains non-empty array, in that case
`configuration_files` will take precedence.

Available actions are:

| Action     | Description                                          |
|:-----------|:-----------------------------------------------------|
| `:create`  | Maps to same docker-compose command                  |
| `:start`   | Maps to same docker-compose command                  |
| `:stop`    | Maps to same docker-compose command                  |
| `:delete`  | Alias for `:rm` to preserve standard Chef action set |
| `:rm`      | Maps to same docker-compose command                  |
| `:restart` | Maps to same docker-compose command                  |
| `:pull`    | Maps to same docker-compose command                  |
| `:push`    | Maps to same docker-compose command                  |
| `:up`      | Maps to same docker-compose command                  |
| `:down`    | Maps to same docker-compose command                  |
| `:kill`    | Maps to same docker-compose command                  |

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

## License and Authors

Authors: AMA Team / Operations  
License: MIT

