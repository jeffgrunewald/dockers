ENV = System.getenv()

String dslRepoUrl = (ENV['DSL_REPO_URL'] ?: '')
String dslBranchName = (ENV['DSL_BRANCH_NAME'] ?: 'master')
String dslJobPattern = (ENV['DSL_JOB_PATTERN'] ?: 'jobs/**/*Job.groovy')

// This prevents mysterious errors when DSL_REPO_URL is not set
if (!dslRepoUrl) {
  println "No DSL_REPO_URL specified, using default test jobs"
  dslRepoUrl = 'https://github.com/jeffgrunewald/dockers/tree/master/contexts/woodhouse/woodhouse-master/jobs/**/*Job.groovy'
}

URL aURL = new URL(dslRepoUrl)
projectName = 'plain:' + aURL.getPath().replaceAll("^/+", "")

String projectBranch = 'plain:' + dslBranchName

println "dslRepoUrl:    ${dslRepoUrl}"
println "dslBranchName: ${dslBranchName}"
println "dslJobPattern: ${dslJobPattern}"

job('dsl-seed-job') {
  description('Generate jobs from DSL files')
  wrappers {
    timestamps()
  }
  triggers {
    githubPush()
  }
  steps {
    scm {
      git {
        remote {
          url(dslRepoUrl)
        }
        branch(dslBranchName)
      }
    }
    dsl {
      external(dslJobPattern)
      ignoreExisting(false)
      removeAction('DISABLE')
      removeViewAction('IGNORE')
    }
  }
}
