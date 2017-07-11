composiler docker
=================

This image is intended as a base image for use of composiler to
template docker-compose yml files and run them, either directly
on the executing machine or on a remote host via the DOCKER_HOST
envar at runtime of the container.

For use of the composiler tool, see the README at 
https://github.com/jeffgrunewald/composiler.git.

To use this container tool, create a simple Dockerfile with the
following:
```
FROM composiler:<date-time-tag>

COPY <composiler-config-directory>/ /composiler/
```

To run the container, create the file, and run the resulting docker
services:

`docker run --rm -v <host-directory>:/composiler/output -v /var/run/docker.sock -e ENVIRONMENT=production composiler:<date-time-tag>`

The following envars can be used to further customize the execution
of the templating and compose run:

DOCKER_HOST: Set a remote docker host with an open tcp port to execute
             the resulting compose file against.
ENVIRONMENT: The deployment environment for which configs composiler
             will pull values when writing out the templated compose file
EXEC:        Defaults to true; if false, only write out the template and
             do not attempt to instantiate the resulting compose file services.
MODE:        Defaults to `standalone`; if set to `swarm`, the execution
             command changes from `docker-compose up -d` to `docker stack deploy`.
OUTFILE:     Defaults to docker-compose.yml; the name of the resulting
             compose file desired. This is good for flagging the compose
             file generated as a deployment artifact for documentation,
             auditing, and rollbacks.
TEMPLATES:   A series of command line flags to select specific services,
             volumes, networks, or secrets definitions if a full, unified
             compose of all templates in the templates directory is
             desired. This is good for splitting services across nodes or
             swarms, or when doing testing and debugging of services and
             their associated volumes, networks, etc.
             of the form `--service redis,web,mongo --volume mongo...`
VERSION:     Defaults to 3.3; the version of the compose file format to use.

NOTE: In order to save off the constructed compose file for archiving, repeat
      deployments, or rollbacks, mount a volume into the CONFDIR/output directory
      in the container and the compose yml file will be left after the container
      exits. In order to execute the compose services on the host executing the
      container, mount the local host's /var/run/docker.sock into the container's.
