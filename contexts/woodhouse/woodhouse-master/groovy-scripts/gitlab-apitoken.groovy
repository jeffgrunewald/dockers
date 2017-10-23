import jenkins.model.*;
import com.cloudbees.plugins.credentials.*;
import com.cloudbees.plugins.credentials.common.*;
import com.cloudbees.plugins.credentials.domains.*;
import com.cloudbees.plugins.credentials.impl.*;
import com.dabsquared.gitlabjenkins.connection.*;
import hudson.Util;
import hudson.util.Secret;

String tokenString = System.getenv()['GITLAB_API_TOKEN']
String userId = System.getenv()['GITLAB_SVC_ACCT']
apiToken = new hudson.util.Secret(tokenString)
String userDesc = 'Gitlab CI service account'

domain = Domain.global()
store = Jenkins.instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()

apiTokenCredential = new GitLabApiTokenImpl(
  CredentialsScope.GLOBAL,
  userId,
  userDesc,
  apiToken
)

store.addCredentials(domain, apiTokenCredential)
