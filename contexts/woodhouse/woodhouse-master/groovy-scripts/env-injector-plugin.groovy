// Configure the Environment Injector Plugin
instance = jenkins.model.Jenkins.getInstance()
envInject = instance.getDescriptor("org.jenkinsci.plugins.envinject.EnvInjectPluginConfiguration")

env_inject_load_master = System.getenv('ENV_INJECT_LOAD_MASTER').toBoolean()

// See plugin for more info on this method
// https://github.com/jenkinsci/envinject-plugin/blob/master/src/main/java/org/jenkinsci/plugins/envinject/EnvInjectPluginConfiguration.java
envInject.configure(false,                  /* hideInjectedVars - Do not show injected variables */
                    false,                  /* enablePermissions - Enable permissions */
                    env_inject_load_master) /* enableLoadingFromMaster - Enable file loading from master */

envInject.save()
instance.save()
