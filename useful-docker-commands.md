# Useful commands

## Docker Commands

### Single Container Commands

Get an the exposed port and associated HostIp and HostPort of a container
- `docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}} {{$p}} -> {{(index $conf 0).HostIp}}:{{(index $conf 0).HostPort}}{{end}}' <container_name>`

Get the IP:ExposedPort of a container
- `docker inspect -f '{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}:{{range $index, $elem := .Config.ExposedPorts }}{{ $index }}{{end}}' <container_name> | sort`

Get the IP:HostPort of a container
- `docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}:{{range $p, $conf := .NetworkSettings.Ports}}{{(index $conf 0).HostPort}}{{end}}' <container_name>`

Get the IP of a container with a hardcoded port
- `docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}:6379' <container_name>`

Get the HostPort of a container (2 methods)
- `docker inspect --format='{{(index (index .NetworkSettings.Ports "6379/tcp") 0).HostPort}}' <container_name>`
- `docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}}{{(index $conf 0).HostPort}}{{end}}' <container_name>`

Get the IP Address of a container
- simple command
  - `docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" <container_name>`
- with descriptions
  - `docker inspect -f "{{.Name}} --> Container IP: {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" <container_name>`

Get a JSON object of Ports
- `docker inspect --format='{{json .NetworkSettings.Ports}}' <container_name>`

### Multi-container Commands
One quick way to convert the above commands from single containter to multi-container is to replace the `<container_name>` with `$(docker ps -aq)`

_Handy Tips_

- sort the output.
  - In Linux: Add ` | sort` to the end of the command
- filtering
  - to filter what is selected by `$(docker ps -aq)` command, include `--filter name=<partial_container_name_to_match>`

Get the IP Address of all running containers
- simple command (output only IP addresses)
  - `docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -aq --filter name=<partial_container_name>) | sort`
- with descriptions (by name)
  - `docker inspect -f '{{.Name}} - {{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -aq --filter name=<partial_container_name>) | sort`

Get the IP:ExposedPort of all running containers
- simple command
  - `docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}:{{range $index, $elem := .Config.ExposedPorts }}{{ $index }}{{end}}' $(docker ps -aq --filter name=<partial_container_name>) | sort`
- with descriptions (by name)
  - `docker inspect -f '{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}:{{range $index, $elem := .Config.ExposedPorts }}{{ $index }}{{end}}' $(docker ps -aq --filter name=<partial_container_name>) | sort`

Get the IP:HostPort of all running containers
- `docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}:{{range $p, $conf := .NetworkSettings.Ports}}{{(index $conf 0).HostPort}}{{end}}' $(docker ps -aq --filter "name=redis-cluster")`

Get the IP of all running container with a hardcoded port
- `docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}:6379' $(docker ps -aq --filter "name=redis-cluster")`


### Commands to get ip addresses/ports to use with redis-cli command

Get list of container IP:HostPort addresses to use with `redis-cli create cluster`
- `docker inspect --format='{{.Name}} {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}:{{range $p, $conf := .NetworkSettings.Ports}}{{(index $conf 0).HostPort}}{{end}}' $(docker ps -aq --filter "name=redis-cluster") | sort | cut -d' ' -f2 | tr -s '\n' ' '`

Command to run on a redis-cluster container to create the custer
- `docker exec -it redis-cluster-0 redis-cli --cluster create $(docker inspect --format='{{.Name}} {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}:{{range $p, $conf := .NetworkSettings.Ports}}{{(index $conf 0).HostPort}}{{end}}' $(docker ps -aq --filter "name=redis-cluster") | sort | cut -d' ' -f2 | tr -s '\n' ' ') --cluster-replicas 1`
