def ci_home = System.getenv('JENKINS_HOME')

def fileName = "${ci_home}/secrets/slave-to-master-security-kill-switch"
def killSwitchFile = new File(fileName)

if (killSwitchFile.exists()) {
  log.info("This file already exists in the required directory.")
} else {
  killSwitchFile.write("false")
}
