<cfcomponent extends="mxunit.framework.TestCase">

	<cffunction name="beforeTests" output="false" access="public" returntype="any" hint="">
		<!--- NOTE: instantiating selenium will also start the Java if it was not already running --->
		<cfset variables.selenium = createObject("component", "cfselenium.selenium_tags").init() />
    	<!--- we rely on subclasses to specify browser URL OR override this and create a variable named selenium 
			subclasses can optionally specify a browserCommand to override the default Firefox browser --->
		<!--- This can be done in beforeTests OR setup --->
		<cfparam name="browserCommand" default="*firefox" />
    	<cfset variables.selenium.start(browserUrl,browserCommand) />
	</cffunction>

	<cffunction name="afterTests" output="false" access="public" returntype="any" hint="">
		<!--- NOTE: this will only stop the Java if it was started by this test case --->
		<cfset variables.selenium.stop() />
		<!--- NOTE: this will only stop the Java server if it was started by this test case --->
		<cfset variables.selenium.stopServer() />
	</cffunction>
	
</cfcomponent>