<cfcomponent extends="mxunit.framework.TestCase">
	
	<cffunction name="getSeleniumServer" output="false" access="private" returntype="any" hint="">    
    	<cfreturn createObject("component", "cfselenium.server").init()>
    </cffunction>
	
	<cffunction name="beforeTests" output="false" access="public" returntype="any" hint="">    
		<cfset getSeleniumServer().startServer()>
    </cffunction>
    
    <cffunction name="afterTests" output="false" access="public" returntype="any" hint="">    
		<cfset getSeleniumServer().stopServer()>
    </cffunction>
	
</cfcomponent>