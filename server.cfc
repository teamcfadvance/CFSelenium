<!---
PROPS: this is adapted from Joe Rinehart and Brian Kotek's work. Thanks, gents.
 --->
<cfcomponent accessors="true">

	<cfproperty name="serverURL"/>
	<cfproperty name="executionDelay"/>
	<cfproperty name="seleniumServerArguments"/>
	<cfproperty name="seleniumJarPath"/>

	<cffunction name="init" output="false" access="public" returntype="any" hint="">
		<cfargument name="serverURL" type="string" required="false" default="http://localhost:4444/selenium-server"/>
		<cfargument name="executionDelay" type="numeric" required="false" default="1000"/>
		<cfargument name="seleniumServerArguments" type="string" required="false"/>
		<cfargument name="seleniumJarPath" type="string" required="false" default="/cfselenium/Selenium-RC/selenium-server-standalone-2.0b2.jar"/>

		<cfset structAppend(variables, arguments)>
		<cfreturn this>
	</cffunction>

	<cffunction name="startServer" output="false">
		<cfif not serverIsRunning()>
			<cfset var startTS = getTickCount()>
			<cfset var jarPath = "#expandPath(getSeleniumJarPath())#">
			<cfset args = "-jar ""#jarPath#"" #getSeleniumServerArguments()#">
			<cfexecute name="java" arguments="#args#"/>
			<cfset sleep(getExecutionDelay())/>
			<cflog text="!!!!    STARTING Selenium RC with jar path: #jarPath#!  args were: #args#. Startup took #getTickCount()-startTS# ms"/>
		</cfif>
	</cffunction>

	<cffunction name="stopServer" output="false">
		<cfset var startTS = getTickCount()>
		<cfhttp url="#getServerURL()#/driver/?cmd=shutDownSeleniumServer"/>
		<cflog text="!!!!    STOPPING Selenium RC! Took #getTickCount()-startTS# ms"/>
		<cfset sleep(getExecutionDelay())/>
	</cffunction>

	<cffunction name="serverIsRunning" output="false">
		<cfset var response = ""/>
		<cflog text="!!!!    CHECKING Selenium RC at #getServerUrl()#/driver/?cmd=testComplete: Are you running?">
		<cfhttp url="#getServerUrl()#/driver/?cmd=testComplete" result="response"/>
		<!---<cflog text="#serializeJson(response)#">--->
		<cfreturn isStruct(response) and structKeyExists(response, "fileContent") and response.fileContent
		         eq "OK"/>
	</cffunction>

</cfcomponent>