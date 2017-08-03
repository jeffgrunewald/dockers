pipelineJob("sample-pipeline") {
  description('Run Job using Pipeline script')
  parameters {
    stringParam('PIPELINE_REPO_URL', '', 'URL of git repo')
    stringParam('PIPELINE_BRANCH_NAME', 'master', 'git branch')
    stringParam('PIPELINE_FILENAME', 'jobs/PipelineSample.groovy', 'This will not work until JENKINS-42836 is fixed')
  }
  definition {
    cpsScm {
      scm {
        git {
          remote {
            url('\${PIPELINE_REPO_URL}')
          }
          branch('\${PIPELINE_BRANCH_NAME}')
        }
      }
      scriptPath('jobs/PipelineSample.groovy')
    }
  }
}
