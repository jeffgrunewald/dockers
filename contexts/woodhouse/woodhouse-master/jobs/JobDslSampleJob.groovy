job('hello-world') {
  label 'docker'
  scm {
    git {
      remote {
        url('https://github.com/jeffgrunewald/dockers.git')
        branch('*/master')
      }
    }
  }
  steps {
    shell('echo Hello World!')
    shell('ls')
  }
}
