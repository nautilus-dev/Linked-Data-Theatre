# Make a release.
To make a release, follow these steps.

##1. Set version number for new release.
The Linked Data Theatre uses [semantic versioning](http://semver.org). 
All LDT releases should have a PATCH version number `.0`. Patches are not considered releases, but only tags in the github administration.

If you make any changes to the LDT, you should include a `-SNAPSHOT` postfix to the project version, like any maven project. *A release version should never have such a postfix.*

Both the Maven project version AND the release version should have the same version number. Change this in the `\pom.xml` maven project file:

	<project>
		<version>1.6.0</version>
		<properties>
			<release.version>1.6.0</release.version>
			<release.date>2016-03-13</release.date>
		</properties>

(This example shows only the relevant lines from the pom.xml. This example refers to a release with version 1.6.0 and release data march 13, 2016).

##2. Check if all license headers are set correctly
All license-headers should have the release version includes. This means that all files should have the same date (the release date).

	mvn license:format

You should perform this step twice, just to be sure that every file header has the correct file date.

##3. Create the war package
You're now ready to create the war:

	mvn clean package

##4. Test the package
You should perform a regression test. A regression test is currently not part of the build procedure. 

##5. Commit changes to github and create release tag
For example (refering to release 1.6.0):

	git add *
	git commit -m "Release 1.6.0"
	git tag -a v1.6.0 -m "Release 1.6.0"
	git push origin v1.6.0

##6. Add war to github release
Goto github: [https://github.com/architolk/Linked-Data-Theatre/tags](https://github.com/architolk/Linked-Data-Theatre/tags). Look for the correct tag (should be the topmost) and navigate to "Add release notes" and update the documentation for the release notes. Upload the war using the user interface of github.
   