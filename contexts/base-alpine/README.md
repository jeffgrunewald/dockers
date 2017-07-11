base-alpine
===========

a base docker image for deriving other container images employing
best practices I have come across in my travels including:

confd
-----
+ _description_: a templating engine for parameterizing docker containers without
  the need for building new images for every possible configuration or
  exposing volumes on the host and modifying running config files.
+ _usage_: place a confd directory into the image at /etc/confd with a
  confd.toml configuration file, a conf.d directory, and a templates
  directory at it's root. Place configuration settings for the confd
  service itself in the confd.toml file (such as the desired key/value
  backend), place <service-config-file-name>.toml files in the conf.d
  directory that includes the name of the template file and the destination
  on the container file system where the container service will be looking
  for its configuration file, and a list of expected keys to be found in
  the template file. Finally place a template file, matching the container
  service's desired config file with the configurable values swapped out
  for golang template variables `{{ getv "var-name" }}` in the templates
  directory. template and configuration toml files should have the same
  names as the desired final configuration file appended with the "tpml"
  or "toml" suffixes respectively (ex: apache2.conf.tmpl, apache2.conf.toml).
  at runtime, prior to starting the container service, run the
  "/usr/local/confd" command with any arguments not baked into the confd.toml
  configuration file to supply any environment variables passed into the
  container or found in an available service discovery key/value store,
  write the values to the corresponding locations in the template file, and
  copy the final template file to the location on the container filesystem
  where the service will expect to find it.
+ _source_: (https://github.com/kelseyhightower/confd.git)

smell-baron
-----------
+ _description_: a process management tool for simplifying the containers
  process management, handles reaping, and allows for multiple command
  execution, including configuration commands, to run at container init.
+ _usage_: using /bin/smell-baron as a container's ENTRYPOINT, supply the
  command(s) to run the desired container service to the container's
  CMD declaration and these will be passed to smell-baron at run time to
  manage. Multiple commands can be supplied to the CMD array, separated by
  "---" (ex: `["/sbin/apache2", "---", "ping", "localhost"]`).
  configuration commands can be supplied with the "-c" flag to indicate a
  command is required to complete successfully in order to properly configure
  any subsequent commands in a multiple command definition (ex: `["-c",
  "/usr/local/bin/confd", "-onetime", "---", "/sbin/apache2", "-D", "FOREGROUND"]`)
+ _source_: (https://github.com/ohjames/smell-baron.git)

build cache management
----------------------
+ _description_: a leading arg to store the date of the image's
  last build and immediately invalidate and update the cache if a value
  is supplied to override the default.

explicitly defined timezone
---------------------------
+ _description_: simplifies aggregated log parsing from the
  container to prevent the container, host machine, and any log aggregation
  service from having differing timezones for log message cross-referencing.

defining the xterm variable
---------------------------
+ _description_: simplifies container diagnostics and trouble-shooting when
  exec-ing into the container to view files, running processes,
  etc.

installing basic tools
----------------------
+ _description_: simplifies container diagnostics and troubleshooting to be able
  to simply view and edit files, test network connectivity, etc.

copy dockerfile and readme into the container
---------------------------------------------
+ _description_: provide downstream users of images built from the container with
  the explicit documentation detailing the architecture and build process for
  the container to assist in diagnosis of issues and share engineering practices freely.
