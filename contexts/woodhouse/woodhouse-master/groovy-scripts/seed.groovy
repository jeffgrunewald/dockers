// Set up the seed job(s) from the file that has been placed inside the docker.

jenkins_home = System.getenv()['JENKINS_HOME']
logger = java.util.logging.Logger.getLogger('seed.groovy')
jenkins = jenkins.model.Jenkins.getInstance()
ENV = System.getenv()

def buildParams(job) {
  params = []
  job.getAllActions()
    .findAll { it instanceof hudson.model.ParametersDefinitionProperty }
    .each { pdp ->
      pdp.getParameterDefinitions()
        .findAll { it instanceof hudson.model.SimpleParameterDefinition }
        .each { spd ->
          if (ENV[spd.name]) {
            params.push(new hudson.model.StringParameterValue(spd.name, ENV[spd.name], spd.description))
          } else {
            params.push(spd.defaultParameterValue)
          }
        }
    }
    new hudson.model.ParametersAction(params);
}

def createAndBuildSeedJob(seedJobDsl) {
  logger.info(seedJobDsl)

  jobManagement = new javaposse.jobdsl.plugin.JenkinsJobManagement(System.out, [:], new File("${jenkins_home}/workspace"))

  items = new javaposse.jobdsl.dsl.DslScriptLoader(jobManagement).runScript(seedJobDsl)
  items.jobs.each { dslJob ->
    logger.info("Created job: ${dslJob.jobName}")
    job = jenkins.getJob(dslJob.jobName)
    params = buildParams(job)
    job.scheduleBuild(0, null, params)
  }
}

createAndBuildSeedJob(new File("${jenkins_home}/seeds/dslSeed.groovy").newReader().text)
createAndBuildSeedJob(new File("${jenkins_home}/seeds/fetchARug.groovy").newReader().text)
