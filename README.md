## A 6 node redis-cluster that is locally accessible

- This solution is a six node redis cluster (3 master, 3 slave), that can be run independently and then accessed by a locally running application.
- Any `redis-cli` command run from a local terminal will connect and interact with the cluster.
- Used for testing redis-cluster/application functionality and behavior for an application that is non-containerized and running locally on your system
- Created similarly to how a redis-cluster is created in kubernetes. The six redis nodes are created first via the docker-compose file and then an `npm script` is run to create the redis-cluster.

### Accessing via _redis-cli_
Since this is a cluster, you must use the `-c` option for all `redis-cli` commands to use it in cluster mode

Example
- `redis-cli -c -p 6379` which will log you into the redis-cli console on the 'redis-cluster-0' node

### To create
You can either run a single script or you can run two together to create the local redis-cluster

#### Running the single, master script to create the redis-cluster
Run the npm script
- `npm run go`

#### Running two scripts together to create the redis-cluster

Run the npm script that executes docker-compose file
- `npm run up`

Run the npm script that creates the redis-cluster using the 6 independent redis nodes just created
- `npm run create-cluster`


### To stop and remove the running redis-cluster
- Run the npm script that stops and removes the cluster containers
  - `npm run down`
