# extract artifactId and version from POM file
pomFile=$1/pom.xml

if [ ! -f ${pomFile} ]; then
  echo "POM file not found: $pomFile"
  exit 1;
fi

# install xmllint if not present
if ! which xmllint; then
	sudo apt-get install libxml2-utils
fi

artifactId=`xmllint ${pomFile} --xpath "/*[local-name()='project']/*[local-name()='artifactId']/text()" `
version=`xmllint ${pomFile} --xpath "/*[local-name()='project']/*[local-name()='version']/text()" `

if [ x$artifactId = x -o x$version = x ]; then
  echo "<artifactId> and/or <version> not found in pom.xml"
  exit 1;
fi

jarFileName=$artifactId-$version.jar
