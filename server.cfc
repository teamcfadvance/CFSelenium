<!---
PROPS: this is adapted from Joe Rinehart and Brian Kotek's work. Thanks, gents.
 --->
<cfcomponent accessors="true">

	<cfproperty name="serverURL"/>
	<cfproperty name="seleniumServerArguments"/>
	<cfproperty name="executionDelay"/> 
	<cfproperty name="seleniumJarPath"/>
	<cfproperty name="verbose"/>	
	<cfproperty name="iStartedThisServer" setter="false">

	<cffunction name="init" output="false" access="public" returntype="any" hint="">
		<cfargument name="serverURL" type="string" required="false" default="http://localhost:4444/selenium-server"/>
		<cfargument name="seleniumServerArguments" type="string" required="false"/>
		<cfargument name="executionDelay" type="numeric" required="false" default="200"/>
		<cfargument name="seleniumJarPath" type="string" required="false" default="/cfselenium/Selenium-RC/selenium-server-standalone-2.0b2.jar"/>
		<cfargument name="verbose" type="boolean" required="false" default="false"/>
	
		<cfset structAppend(variables, arguments)>
		<cfset variables.iStartedThisServer = false> 
			
		<cfreturn this>
	</cffunction>

	<cffunction name="startServer" output="false">
		<cfif not serverIsRunning()>
			<cfset var jarPath = "#expandPath(getSeleniumJarPath())#">
			<cfset var loopStart = getTickCount()>
			<cfset isRunning = false>
			<cfset args = "-jar ""#jarPath#"" #getSeleniumServerArguments()#">
			<cfset logStatus( text="!!!!    STARTING Selenium RC with jar path: #jarPath#!  args were: #args#." )/>
			<cfexecute name="java" arguments="#args#"/>
			
			<!--- we need to give the server time to fully start --->
			<cfloop condition="NOT serverIsRunning()">
				<cfset sleep(getExecutionDelay())/>
				<cfif getTickCount() - loopStart GT 10000>
					<cfthrow message="After 10 seconds selenium server still not started">
				</cfif>
			</cfloop>
			<cfset variables.iStartedThisServer = true>
			<cfset logStatus( text="  Startup took #getTickCount()-loopStart# ms" )/>
		</cfif>
	</cffunction>

	<cffunction name="stopServer" output="false">
		<!--- we only stop the server if we started it --->
		<cfif getIStartedThisServer()>
			<cfset var loopStart = getTickCount()>
			<cfhttp url="#getServerURL()#/driver/?cmd=shutDownSeleniumServer"/>
			
			<!--- we need to give the server time to fully shutdown --->
			<cfloop condition="serverIsRunning()">
				<cfset sleep(getExecutionDelay())/>
				<cfif getTickCount() - loopStart GT 10000>
					<cfthrow message="After 10 seconds selenium server still not stopped">
				</cfif>
			</cfloop>
			
			<cfset logStatus( text="!!!!    STOPPED Selenium RC! Took #getTickCount()-loopStart# ms" )/>
		</cfif>
	</cffunction>

	<cffunction name="serverIsRunning" output="false">
		<cfset var response = ""/>
		<cfset logStatus( text="!!!!    CHECKING Selenium RC at #getServerUrl()#/driver/?cmd=testComplete: Are you running?" )>
		<cfhttp url="#getServerUrl()#/driver/?cmd=testComplete" result="response"/>
		<cfreturn isStruct(response) and structKeyExists(response, "fileContent") and response.fileContent eq "OK"/>
	</cffunction>
	
	<cffunction name="logStatus" output="false" access="private" returntype="any" hint="">    
    	<cfargument name="text" type="string" required="true"/>
		<cfif variables.verbose>
			<cflog text="#text#">
		</cfif>
    </cffunction>

</cfcomponent>