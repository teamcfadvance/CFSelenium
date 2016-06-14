<cfcomponent
	extends="mxunit.framework.TestCase"
	hint="Base class for MXUnit tests."
>

	<cfscript>
	variables.defaultLocalDriverRepoPath = expandPath(
		createObject("java", "java.lang.System")
			.getProperty("java.io.tmpdir")
			& "webdriver/"
	);
	</cfscript>

	<cffunction name="beforeTests" output="false" access="public" returntype="any" hint="">
		<cfargument name="version" required="false" default="1" type="numeric" hint="Version of selenium to use. 1=RC, 2=WebDriver">
		<cfargument name="browserCommand" required="false" default="*firefox" type="string" hint="Browser type to use (Selenium v1)" >
		<cfargument name="browserURL" required="false" default="" type="string" hint="Initial URL for browser (Selenium v1)" />
		<cfargument name="localDriverRepoPath" required="false" default="#variables.defaultLocalDriverRepoPath#" type="string" hint="Path to WebDriver drivers" />

		<cfscript>
			if ( !listFind("1,2", arguments.version) ) {
				throw("version argument value may only be '1' or '2'");
			}
			if ( arguments.version == 2 ) {
				variables.selenium = createObject( "component", "SeleniumWebDriver" ).init(
					localDriverRepoPath = arguments.localDriverRepoPath
				);
				variables.driver = variables.selenium.getDriver();
			} else {
				if ( !isDefined("arguments.browserURL") ) {
					throw("Version 1 requires the browserURL argument.");
				}
				variables.selenium = createObject( "component", "SeleniumRC" ).init();
				variables.selenium.start( arguments.browserURL, arguments.browserCommand );
			}
		</cfscript>
	</cffunction>

	<cffunction name="afterTests" output="false" access="public" returntype="any" hint="">
    	<!--- can leave driver and server open, which eventually stops tests from running so try to close them --->
		<cfscript>
			if ( structKeyExists( variables, "driver" ) ) {
				try {
					variables.driver.close();
				} catch( any error ) {
					
				}
				try {
					variables.driver.quit();
				} catch( any error ) {
					
				}
			} else {
				try {
					variables.selenium.stopServer();
				} catch( any error ) {
					
				}
			}
			structDelete( variables, "selenium" );
		</cfscript>
	</cffunction>
	
</cfcomponent>