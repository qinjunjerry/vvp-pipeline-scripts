# extract artifactId and version from POM file
pomFile=$1/pom.xml

if [ ! -f ${pomFile} ]; then
  echo "POM file not found: $pomFile"
  exit 1;
fi

artifactId=`xmllint ${pomFile} --xpath "/*[local-name()='project']/*[local-name()='artifactId']/text()" `
version=`xmllint ${pomFile} --xpath "/*[local-name()='project']/*[local-name()='version']/text()" `

if [ x$artifactId = x -o x$version = x ]; then
  echo "<artifactId> and/or <version> not found in ${pomFile}"
  exit 1;
fi

jarFileName=$artifactId-$version.jar
