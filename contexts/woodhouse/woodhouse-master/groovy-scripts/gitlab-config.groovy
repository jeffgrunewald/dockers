import jenkins.model.*;
import hudson.Util;
import com.dabsquared.gitlabjenkins.connection.*;

String url = System.getenv()['GITLAB_URL']
String description = System.getenv()['GITLAB_DESCRIPTION']
String apiToken = System.getenv()['GITLAB_SVC_ACCT']
boolean ignoreCertErrors = false
Integer connectionTimeout = 10
Integer readTimeout = 10
List connections = []

gitLabConfig = new GitLabConnection(
  description,
  url,
  apiToken,
  ignoreCertErrors,
  connectionTimeout,
  readTimeout
)
connections.add(gitLabConfig)

instance = jenkins.model.Jenkins.getInstance()
gitLabConnections = instance.getDescriptorByType(com.dabsquared.gitlabjenkins.connection.GitLabConnectionConfig)
gitLabConnections.setConnections(connections)
gitLabConnections.refreshConnectionMap()
gitLabConnections.clients.clear()
gitLabConnections.save()
