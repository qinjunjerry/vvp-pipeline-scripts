# extract artifactId and version from POM file
pomFile=../vvp-pipeline-demo/pom.xml

read -r artifactId version <<< `cat ${pomFile} | python -c "
import sys, xml.etree.ElementTree
root = xml.etree.ElementTree.fromstring(sys.stdin.read())
artifactId = ''
version = ''
for child in root:
  if child.tag.endswith('artifactId'):
    artifactId = child.text
  if child.tag.endswith('version'):
    version = child.text
print artifactId + ' ' + version
"`

if [ x$artifactId = x -o x$version = x ]; then
  echo "<artifactId> and/or <version> not found in pom.xml"
  exit 1;
fi

jarFileName=$artifactId-$version.jar
