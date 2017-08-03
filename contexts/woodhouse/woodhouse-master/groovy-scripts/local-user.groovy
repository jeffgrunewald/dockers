import jenkins.*
import hudson.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.common.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.jenkins.plugins.sshcredentials.impl.*
import hudson.plugins.sshslaves.*;
import hudson.model.*
import jenkins.model.*
import hudson.security.*

global_domain = Domain.global()
credentials_store =
  Jenkins.instance.getExtensionList(
    'com.cloudbees.plugins.credentials.SystemCredentialsProvider'
  )[0].getStore()

credentials = new BasicSSHUserPrivateKey(CredentialsScope.GLOBAL,null,"root",new BasicSSHUserPrivateKey.UsersPrivateKeySource(),"","")

credentials_store.addCredentials(global_domain, credentials)

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
def adminUsername = System.getenv('LOCAL_ADMIN') ?: 'admin'
def adminPassword = System.getenv('LOCAL_PASSWORD') ?: 'password'
hudsonRealm.createAccount(adminUsername, adminPassword)

def instance = Jenkins.getInstance()
instance.setSecurityRealm(hudsonRealm)
instance.save()


def strategy = new GlobalMatrixAuthorizationStrategy()

//  Slave Permissions
//strategy.add(hudson.model.Computer.BUILD,'woodhouse')
//strategy.add(hudson.model.Computer.CONFIGURE,'woodhouse')
//strategy.add(hudson.model.Computer.CONNECT,'woodhouse')
//strategy.add(hudson.model.Computer.CREATE,'woodhouse')
//strategy.add(hudson.model.Computer.DELETE,'woodhouse')
//strategy.add(hudson.model.Computer.DISCONNECT,'woodhouse')

//  Credential Permissions
//strategy.add(com.cloudbees.plugins.credentials.CredentialsProvider.CREATE,'woodhouse')
//strategy.add(com.cloudbees.plugins.credentials.CredentialsProvider.DELETE,'woodhouse')
//strategy.add(com.cloudbees.plugins.credentials.CredentialsProvider.MANAGE_DOMAINS,'woodhouse')
//strategy.add(com.cloudbees.plugins.credentials.CredentialsProvider.UPDATE,'woodhouse')
//strategy.add(com.cloudbees.plugins.credentials.CredentialsProvider.VIEW,'woodhouse')

//  Overall Permissions
//strategy.add(hudson.model.Hudson.ADMINISTER,'woodhouse')
//strategy.add(hudson.PluginManager.CONFIGURE_UPDATECENTER,'woodhouse')
//strategy.add(hudson.model.Hudson.READ,'woodhouse')
//strategy.add(hudson.model.Hudson.RUN_SCRIPTS,'woodhouse')
//strategy.add(hudson.PluginManager.UPLOAD_PLUGINS,'woodhouse')

//  Job Permissions
//strategy.add(hudson.model.Item.BUILD,'woodhouse')
//strategy.add(hudson.model.Item.CANCEL,'woodhouse')
//strategy.add(hudson.model.Item.CONFIGURE,'woodhouse')
//strategy.add(hudson.model.Item.CREATE,'woodhouse')
//strategy.add(hudson.model.Item.DELETE,'woodhouse')
//strategy.add(hudson.model.Item.DISCOVER,'woodhouse')
//strategy.add(hudson.model.Item.READ,'woodhouse')
//strategy.add(hudson.model.Item.WORKSPACE,'woodhouse')

//  Run Permissions
//strategy.add(hudson.model.Run.DELETE,'woodhouse')
//strategy.add(hudson.model.Run.UPDATE,'woodhouse')

//  View Permissions
//strategy.add(hudson.model.View.CONFIGURE,'woodhouse')
//strategy.add(hudson.model.View.CREATE,'woodhouse')
//strategy.add(hudson.model.View.DELETE,'woodhouse')
//strategy.add(hudson.model.View.READ,'woodhouse')

//  Setting Anonymous Permissions
strategy.add(hudson.model.Hudson.READ,'anonymous')
strategy.add(hudson.model.Item.BUILD,'anonymous')
strategy.add(hudson.model.Item.CANCEL,'anonymous')
strategy.add(hudson.model.Item.DISCOVER,'anonymous')
strategy.add(hudson.model.Item.READ,'anonymous')

// Setting Admin Permissions
strategy.add(Jenkins.ADMINISTER, adminUsername)

// Setting easy settings for local builds
def local = System.getenv("BUILD").toString()
if(local == "local") {
  //  Overall Permissions
  strategy.add(hudson.model.Hudson.ADMINISTER,'anonymous')
  strategy.add(hudson.PluginManager.CONFIGURE_UPDATECENTER,'anonymous')
  strategy.add(hudson.model.Hudson.READ,'anonymous')
  strategy.add(hudson.model.Hudson.RUN_SCRIPTS,'anonymous')
  strategy.add(hudson.PluginManager.UPLOAD_PLUGINS,'anonymous')
}

instance.setAuthorizationStrategy(strategy)
instance.save()
