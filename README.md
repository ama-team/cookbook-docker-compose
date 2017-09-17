# ama-docker-compose Cookbook

This cookbook automates installation and usage of 
[Docker Compose][compose] tool.

Please not that most of the actions - at least for 0.1.x - are executed
regardless of current state. Even if all containers are up and running,
action `:up` will issue a new shell command. Single-service actions 
are not yet supported either.

Dev branch state:

[![Travis branch](https://img.shields.io/travis/ama-team/cookbook-docker-compose/dev.svg?style=flat-square)](https://travis-ci.org/ama-team/cookbook-docker-compose)

## Requirements

### Platforms

- Ubuntu LTS 14.04+
- Debian 7+
- Fedora 21+
- Centos 6.5+

Should work on other Linux distros as well, but we don't 
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
| `['ama-docker-compose']['version']` | `1.16.1` |

## Recipes

You can skip some burden and include `default` recipe to install 
version specified in attribute in default location 
(`/usr/local/bin/docker-compose`).

## Resources

### docker_compose_installation

Installs Docker Compose, latest version (known by cookbook) by default.

Examples:

```ruby
docker_compose_installation '/usr/local/bin/docker-compose'
```

```ruby
docker_compose_installation 'default' do
  version '1.10.1' 
  path '/usr/local/bin/docker-compose'
end
```

Available actions are `:create`/`:install` and `:delete`/`:remove`,
`path` attribute defaults to resource name, `version` attribute
defaults to `node['ama-docker-compose']['version']`. I can't promise
it will always be up to date, though.

### docker_compose_deployment

This resource operates with docker composition (named as deployment for
clarity), running commands as up, down, kill and others against set of
docker-compose files.

Examples:

```ruby
# Runs up command against  specified file
docker_compose_deployment '/srv/router/docker-compose.yml'
```

```ruby
docker_compose_deployment '/srv/router/docker-compose.yml' do
  environment({COMPOSE_PROJECT_NAME: 'my_custom_name'})
end
```

```ruby
docker_compose_deployment 'router' do
  executable '/usr/local/bin/docker-compose'
  files '/srv/router/docker-compose.yml'
  signal 'SIGHUP'
  action :kill
end
```

```ruby
docker_compose_deployment 'router' do
  files ['/srv/router/docker-compose.yml', '/srv/router/docker-compose-overrides.yml']
  timeout 10
  action :stop
end
```

Attributes:

| Attribute | Types | Default | Description |
|:----------------|:---|:---|:---|
| `files`         | String / String[] | Resource name                   | Single or multiple paths to configuration files |
| `executable`    | String            | `/usr/local/bin/docker-compose` | Path to specific docker-compose executable      |
| `timeout`       | Integer / Nil     | `10`                            | Timeout for internal docker-compose commands where applicable |
| `shell_timeout` | Integer / Nil     | `300`                           | Timeout for any underlying command to prevent infinite stalling | 
| `signal`        | String            | `SIGKILL`                       | Signal for kill command |
| `scale`         | String            |                                 | Arguments for docker-compose scale command e.g. `nginx=2`|
| `environment`   | Hash / Nil        | `{}`                            | Arbitrary environment variables to be passed to docker-compose call

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
| `:scale`   | Maps to same docker-compose command                  |


Please note that those actions are always executed (at least, for now),
since it is difficult to check whether all containers are up, killed, 
stopped or anything else regarding state of deployment. However, you 
can always use guard files that, if present, would guarantee action
has been executed.

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request to `dev` branch using Github

## License and Authors

Authors: AMA Team / Operations  
License: MIT

Information about Docker Compose authors and license can be found in
[official github repository][github/compose].

  [compose]: https://docs.docker.com/compose/
  [github/compose]: https://github.com/docker/compose
