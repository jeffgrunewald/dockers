import jenkins.model.*
import groovy.xml.*

def jenkins_home = System.getenv('JENKINS_HOME')
def jenkins_url = System.getenv('JENKINS_URL')

if (!jenkins_url) {
  jenkins_url = 'http://localhost:8080'
}

css_file = "${jenkins_url}/userContent/jenkins-material-theme.css"

def themeXmlString = """\
<?xml version='1.0' encoding='UTF-8'?>
<org.codefirst.SimpleThemeDecorator plugin="simple-theme-plugin@0.3">
  <cssUrl>${css_file}</cssUrl>
  <jsUrl></jsUrl>
</org.codefirst.SimpleThemeDecorator>"""

def themeXml = new StringWriter()
def themeXmlBody = new XmlParser().parseText(themeXmlString)

def xml = new MarkupBuilder(themeXml)
xml.mkp.xmlDeclaration(version: "1.0", encoding: "UTF-8")
new XmlNodePrinter(new PrintWriter(themeXml)).print(themeXmlBody)

def styleXmlFile = new File("${jenkins_home}/org.codefirst.SimpleThemeDecorator.xml")
styleXmlFile.write(themeXml.toString())

jlc = JenkinsLocationConfiguration.get()
jlc.setUrl(jenkins_url)
jlc.save()
