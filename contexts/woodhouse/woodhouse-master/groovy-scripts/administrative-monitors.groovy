// Disable global level warning about security
hudson.model.AdministrativeMonitor.all()
  .grep{ it instanceof jenkins.security.s2m.MasterKillSwitchWarning }
  .each{ it.disable(true) }
// Disable warning that new version of Jenkins available
hudson.model.AdministrativeMonitor.all()
  .grep{ it instanceof hudson.model.UpdateCenter$CoreUpdateMonitor }
  .each{ it.disable(true) }
