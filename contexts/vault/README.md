Vault Docker
============

Running inside a container, self-unsealing and authorizing
dockerized vault that connects to the specified ldap instance
for user authentication backend and authorization, and 
automatically unseals itself and revokes the root access keys
with the understanding that an appropriate administrator group
has been assigned the `admin` policy to enable the retrieval
of root tokens and to seal/unseal the vault as needed.