<cfcomponent
	extends="mxunit.framework.TestCase"
	hint="Base class for WebDriver MXUnit tests."
>

	<cfscript>
	variables.defaultLocalDriverRepoPath = 
		createObject("java", "java.lang.System").getProperty("java.io.tmpdir")
		& "webdriver/";
	</cfscript>

	<cffunction name="beforeTests" output="false" access="public" returntype="any" hint="">
		<cfargument name="localDriverRepoPath" required="false" default="#variables.defaultLocalDriverRepoPath#" type="string" hint="Path to WebDriver drivers" />
		<cfscript>
			variables.selenium = createObject( "component", "SeleniumWebDriver" ).init(
				localDriverRepoPath = arguments.localDriverRepoPath
			);
			variables.driver = variables.selenium.getDriver();
		</cfscript>
	</cffunction>

	<cffunction name="afterTests" output="false" access="public" returntype="any" hint="">
		<!--- can leave driver and server open, which eventually stops tests from running so try to close them --->
		<cfscript>
			try {
				variables.driver.close();
			} catch( any error ) {
				
			}
			try {
				variables.driver.quit();
			} catch( any error ) {
				
			}
			structDelete( variables, "selenium" );
		</cfscript>
	</cffunction>
	
</cfcomponent>