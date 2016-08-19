<cfcomponent
	extends="mxunit.framework.TestCase"
	hint="Base class for Selenium-RC MXUnit tests."
>

	<cffunction name="beforeTests" output="false" access="public" returntype="any" hint="">
		<cfargument name="browserCommand" required="false" default="*firefox" type="string" hint="Browser type to use." >
		<cfargument name="browserURL" required="false" default="" type="string" hint="Initial URL for browser." />
		<cfscript>
			variables.selenium = createObject( "component", "SeleniumRC" ).init();
			variables.selenium.start( arguments.browserURL, arguments.browserCommand );
		</cfscript>
	</cffunction>

	<cffunction name="afterTests" output="false" access="public" returntype="any" hint="">
		<!--- can leave driver and server open, which eventually stops tests from running so try to close them --->
		<cfscript>
			try {
				variables.selenium.stopServer();
			} catch( any error ) {
				
			}
			structDelete( variables, "selenium" );
		</cfscript>
	</cffunction>
	
</cfcomponent>