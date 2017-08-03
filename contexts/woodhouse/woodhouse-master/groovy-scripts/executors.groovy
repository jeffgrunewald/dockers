// Set executors on master node to 4
instance = jenkins.model.Jenkins.getInstance()
instance.setNumExecutors(4)
instance.save()
