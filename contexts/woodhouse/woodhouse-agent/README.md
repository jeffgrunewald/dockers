Woodhouse Agent Docker
======================

ENV:

  * AUTHORIZED_KEYS - content to place in ~/.ssh/authorized_keys

VOLUMES:

  * None - to share workspace with master, mount host path to same location in
    both master and agent (e.g. -v /data/jenkins/agents:/data/jenkins/agents on
    both master and agent dockers)

EXPOSE:

  * 22 - sshd for launching jenkins agent
