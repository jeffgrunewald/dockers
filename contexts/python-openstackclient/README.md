Lunar Whale OpenStack Client CLI capsule
========================================

This container contains all of the necessary dependency
packages to run any of the OpenStack API CLI clients.

Usage varies based on flavor, but each is a multi-tenancy
supporting container allowing the user to switch the tenant
to execute the command against at runtime.

Mk 2 flavor uses a simplified wrapper script to call the
'docker run' but relies on the user to source their own openrc.sh
prior to execution. This extra step is traded off by the lack
of need to configure the wrapper script at install time.

Required: set location of wrapper script in $PATH; source
desired openrc.sh on a per tenant/per run basis

Usage: . [path to openrc file of desired tenant] && \
       openstack [-c ${OS_CMD}]

Environment Variables:

  * OS_AUTH_URL    - URL of the Keystone auth server;
                     defaults to standard class B address
  * OS_CMD         - OpenStack API client, command, and any options to pass;
                     defaults to 'openstack server list'
  * OS_PASSWORD    - OpenStack password of the executing user; defaults to placeholder
  * OS_TENANT_ID   - ID of the desired OpenStack tenant; defaults to placeholder
  * OS_TENANT_NAME - Name of the desired OpenStack tenant; defaults to placeholder
  * OS_REGION_NAME - Region of the desired OpenStack tenant; defaults to RegionOne
  * OS_USERNAME    - Username of the executing user; defaults to placeholder
