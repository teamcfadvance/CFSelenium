<cfcomponent extends="mxunit.framework.TestCase">

	<cfset seleniumServer = createObject("component", "cfselenium.server").init()>
	
	<!--- NOTE: the server object will only start and stop the server if it was not already running --->
		
	<cffunction name="beforeTests" output="false" access="public" returntype="any" hint="">
		<cfset seleniumServer.startServer()>
	</cffunction>

	<cffunction name="afterTests" output="false" access="public" returntype="any" hint="">
		<cfset seleniumServer.stopServer()>
	</cffunction>
	
	<cffunction name="setUp" output="false" access="public" returntype="any" hint="">    
    	<!--- we rely on subclasses to specify browser URL OR override this and create a variable named selenium 
			subclasses can optionally specify a browserCommand to override the default Firefox browser --->
		<cfparam name="browserCommand" default="*firefox" >
    	<cfset selenium = startSelenium(browserUrl,browserCommand)>
    </cffunction>
	
	<cffunction name="tearDown" output="false" access="public" returntype="any" hint="">   
    	<cfset selenium.stop()>
    </cffunction>
    
    <cffunction name="startSelenium" output="false" access="private" returntype="any" hint="">    
    	<cfargument name="browserURL" type="string" required="true"/>
		<cfargument name="browserCommand" type="string" required="false" default="*firefox"/>
       	<cfset selenium = createobject("component","CFSelenium.selenium").init(browserUrl,"localhost", 4444, browserCommand)>
        <cfset selenium.start()>
	    <cfreturn selenium>
    </cffunction>

</cfcomponent>