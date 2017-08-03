node {
  timestamps {
    node('docker') {
      stage('Build') {
        echo 'Building...'
      }
    }
    node('docker') {
      stage('Test') {
        echo 'Testing...'
      }
    }
    node('docker') {
      stage('Deploy') {
        echo 'Deploying...'
      }
    }
  }
}
