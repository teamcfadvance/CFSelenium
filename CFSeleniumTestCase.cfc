<cfcomponent extends="mxunit.framework.TestCase">

	<cffunction name="beforeTests" output="false" access="public" returntype="any" hint="">
		<cfargument name="version" required="false" default="2" type="numeric" hint="version of selenium to use">
		<cfargument name="browserCommand" required="false" default="*firefox" type="string" hint="browser type to use (Selenium v1)" >
		<cfargument name="browserURL" required="false" default="" type="string" hint="initial URL for browser (Selenium v1)" />

		<cfscript>
			if ( arguments.version == 2 ) {
				variables.selenium = createObject( "component", "selenium" ).init();
				variables.driver = variables.selenium.getDriver();
			} else {
				variables.selenium = createObject( "component", "webSelenium" ).init();
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