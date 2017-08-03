import javaposse.jobdsl.plugin.GlobalJobDslSecurityConfiguration

instance = jenkins.model.Jenkins.getInstance()

globalConfig = instance.getDescriptorByType(GlobalJobDslSecurityConfiguration.class)
globalConfig.useScriptSecurity = false
globalConfig.save()
