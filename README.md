# ama-docker-compose Cookbook

This cookbook automates installation and usage of docker-compose.

Please not that most of the actions - at least for 0.1.x - are executed
regardless of current state. Even if all containers are up and running,
action `:up` will issue a new shell command. Single-service actions 
are not supported either. 

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

Attributes are used to set default values only.

| Key                                 | Default  |
|:------------------------------------|:---------|
| `['ama-docker-compose']['version']` | `1.10.1` |

## Resources

### docker_compose_installation

```ruby
docker_compose_installation '/usr/local/bin/docker-compose' do
  # optional, attribute value is used if omitted
  version '1.10.1'
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
  # used to prevent shell commands stalling
  # you may set it to nil to disable
  timeout 300
  # used with :stop action
  stop_timeout 10
  # used with :kill action
  signal 'SIGHUP'
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

Please note that those actions are always executed (at least, for now),
since it is difficult to check whether all containers are up. However,
you can always use guard files that, if present, would guarantee action
has been executed.

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

