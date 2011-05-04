<cfcomponent extends="mxunit.framework.TestCase">

	<cfset __seleniumWasRunning__ = false>
	
	<cffunction name="getSeleniumServer" output="false" access="private" returntype="any" hint="">
		<cfreturn createObject("component", "cfselenium.server").init()>
	</cffunction>

	<cffunction name="beforeTests" output="false" access="public" returntype="any" hint="">
		<cfset __seleniumWasRunning__ = getSeleniumServer().serverIsRunning()>
		<cfif NOT __seleniumWasRunning__>
			<cfset getSeleniumServer().startServer()>
		</cfif>
	</cffunction>

	<cffunction name="afterTests" output="false" access="public" returntype="any" hint="">
		<!--- we only want to stop selenium if we started it --->
		<cfif NOT __seleniumWasRunning__>
			<cfset getSeleniumServer().stopServer()>
		</cfif>
			
	</cffunction>

</cfcomponent>