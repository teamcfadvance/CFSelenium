<cfcomponent accessors="true" hint="A CFML binding for Selenium">

	<!---
	Copyright 2011 Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at
	
	    http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
	
	
	--->
	
	<cfproperty type="string" name="host">
	<cfproperty type="numeric" name="port">
	<cfproperty type="string" name="browserStartCommand">
	<cfproperty type="string" name="browserURL">
	<cfproperty type="string" name="sessionId">
	<cfproperty type="string" name="extensionJs">
	
	<cffunction returntype="any" name="init">
		<cfargument required="false" type="string" name="host" default="localhost" />
		<cfargument required="false" type="numeric" name="port" default="4444" />
		<cfargument required="false" type="numeric" name="executionDelay" default="200" />
		<cfargument required="false" type="string" name="seleniumJarPath" default="/cfselenium/Selenium-RC/selenium-server-standalone-2.2.0.jar" />
		<cfargument required="false" type="boolean" name="verbose" default="false" />
		<cfargument required="false" type="string" name="seleniumServerArguments" default="" />
		<cfargument required="false" type="numeric" name="waitTimeout" default="30000" />
		
		<cfset structAppend(variables,arguments,true) />
		<cfset variables.sessionId= "" />
		<cfset arguments.selenium= this />
		<cfset variables.server= createObject("component","server").init(this,arguments.executionDelay,arguments.seleniumJarPath,arguments.verbose,arguments.seleniumServerArguments)>
		<cfset variables.server.startServer()>
		
		<cfreturn this />
	
	</cffunction>
	
	<cffunction returntype="string" name="getHost">
		<cfreturn variables.host />
	</cffunction>
	
	<cffunction returntype="numeric" name="getPort">
		<cfreturn variables.port />
	</cffunction>
	
	<cffunction returntype="string" name="getBrowserStartCommand">
		<cfreturn variables.browserStartCommand />
	</cffunction>
	
	<cffunction returntype="string" name="getBrowserURL">
		<cfreturn variables.browserURL />
	</cffunction>
	
	<cffunction returntype="string" name="getSessionId">
		<cfreturn variables.sessionId />
	</cffunction>
	
	<cffunction returntype="string" name="getExtensionJs">
		<cfreturn variables.extensionJs />
	</cffunction>
	
	<cffunction returntype="any" name="doCommand">
		<cfargument required="true" type="string" name="command" />
		<cfargument required="false" type="array" name="args" default="#ArrayNew(1)#" />
		
		<cfset var i= "">
		<cfset var resultData= "">
		<cfset var response= "">
		
		<cfset var urlString= "http://" & variables.host & ":" & variables.port & "/selenium-server/driver/" />
		
		<cfhttp url="#urlString#" charset="utf-8" method="post" result="resultData">
			<cfhttpparam type="formfield" name="cmd" value="#urlEncodedFormat(arguments.command,'utf-8')#" />
			<cfloop index="i" from="1" to="#ArrayLen(arguments.args)#">
				<cfhttpparam type="formfield" name="#i#" value="#arguments.args[i]#" />
			</cfloop>
			<cfif Len(variables.sessionId) GT 0>
				<cfhttpparam type="formfield" name="sessionId" value="#variables.sessionId#" />
			</cfif>
			<cfhttpparam type="header" name="Content-Type" value="application/x-www-form-urlencoded" />
		</cfhttp>
			
		<cfset response= resultData.FileContent />
		
		
		<cfif Left(response,2) EQ "OK">
			<cfreturn response />
		</cfif>
		
		<cfthrow message="The Response of the Selenium RC is invalid: #response#" />
		
	</cffunction>
	
	<cffunction returntype="void" name="waitForElementPresent">
		<cfargument required="true" type="string" name="locator" />
		<cfargument required="false" type="numeric" name="timeout" default="#variables.waitTimeout#" />
		<cfset var counter= 0>
		<cfset var thread= "">
		<cfloop condition="Not isElementPresent(arguments.locator)">
			<cfset thread= CreateObject("java","java.lang.Thread") />
			<cfset thread.sleep(100) />
			<cfset counter= counter+100>
			<cfif counter EQ arguments.timeout>
				<cfthrow type="CFSelenium.elementNotFound" message="The element: #arguments.locator# was not found after #arguments.timeout/1000# seconds." / >
			</cfif>
		</cfloop> 
	</cffunction>

	<cffunction returntype="void" name="waitForElementVisible">
		<cfargument required="true" type="string" name="locator" />
		<cfargument required="false" type="numeric" name="timeout" default="#variables.waitTimeout#" />
		<cfset var counter= 0>
		<cfset var thread= "">
		<cfloop condition="Not isVisible(arguments.locator)">
			<cfset thread= CreateObject("java","java.lang.Thread") />
			<cfset thread.sleep(100) />
			<cfset counter= counter+100>
			<cfif counter EQ arguments.timeout>
				<cfthrow type="CFSelenium.elementNotVisible" message="The element: #arguments.locator# was not visible after #arguments.timeout/1000# seconds." / >
			</cfif>
		</cfloop> 
	</cffunction>

	<cffunction returntype="void" name="waitForElementNotVisible">
		<cfargument required="true" type="string" name="locator" />
		<cfargument required="false" type="numeric" name="timeout" default="#variables.waitTimeout#" />
		<cfset var counter= 0>
		<cfset var thread= "">
		<cfloop condition="isVisible(arguments.locator)">
			<cfset thread= CreateObject("java","java.lang.Thread") />
			<cfset thread.sleep(100) />
			<cfset counter= counter+100>
			<cfif counter EQ arguments.timeout>
				<cfthrow type="CFSelenium.elementStillVisible" message="The element: #arguments.locator# was still visible after #arguments.timeout/1000# seconds." / >
			</cfif>
		</cfloop> 
	</cffunction>

	<cffunction returntype="string" name="getString">
		<cfargument required="true" type="string" name="command" />
		<cfargument required="false" type="array" name="args" default="#ArrayNew(1)#"/>
		
		<cfset var result= doCommand(argumentCollection=arguments) />
		<cfset var responseLen= Len(result)-3 />
		<cfif responseLen EQ 0>
			<cfreturn "">
		<cfelse>
			<cfreturn Right(result,responseLen) />
		</cfif>
	
	</cffunction>
	
	<cffunction returntype="array" name="getStringArray">
		<cfargument required="true" type="string" name="command" />
		<cfargument required="false" type="array" name="args" default="#ArrayNew(1)#"/>
		
		<cfreturn parseCSV(getString(argumentCollection=arguments)) />
	
	</cffunction>
	
	<cffunction returntype="numeric" name="getNumber">
		<cfargument required="true" type="string" name="command" />
		<cfargument required="false" type="array" name="args" default="#ArrayNew(1)#" />
		
		<cfreturn val(getString(argumentCollection=arguments)) />
		
	</cffunction>
	
	<cffunction returntype="array" name="getNumberArray">
		<cfargument required="true" type="string" name="command" />
		<cfargument required="false" type="array" name="args" default="#ArrayNew(1)#" />
		
		<cfset var stringArray= parseCSV(getString(argumentCollection=arguments)) />
		<cfset var item= "" />
		<cfset var numericArray= ArrayNew(1) />
		<cfloop index="item" from="1" to="#ArrayLen(stringArray)#">
			<cfset arrayAppend(numericArray,int(stringArray[item])) />
		</cfloop>
		<cfreturn numericArray />
		
	</cffunction>
	
	<cffunction returntype="boolean" name="getBoolean">
		<cfargument required="true" type="string" name="command" />
		<cfargument required="false" type="array" name="args" default="#ArrayNew(1)#" />
		
		<cfset var result= getString(argumentCollection=arguments)>
		<cfif isBoolean(result)>
			<cfreturn result />
		<cfelse>
			<cfthrow message="Error getting a boolean value from Selenium. The value '#result#' is not a valid boolean." />
		</cfif>
	</cffunction>
	
	<cffunction returntype="array" name="getBooleanArray">
		<cfargument required="true" type="string" name="command" />
		<cfargument required="false" type="array" name="args" default="#ArrayNew(1)#" />
		
		<cfset var stringArray= parseCSV(getString(argumentCollection=arguments)) />
		<cfset var item= "" />
		<cfloop index="item" from="1" to="#ArrayLen(stringArray)#">
			<cfif isBoolean(stringArray[item]) EQ false>
				<cfthrow message= "Error getting a boolean value from Selenium. The value '#item#' is not a valid boolean.">
			</cfif>
		</cfloop>
		<cfreturn stringArray />
		
	</cffunction>
	
	<cffunction returntype="array" name="parseCSV">
		<cfargument required="true" type="string" name="csv" />
		
		<cfset var sb= createObject("java","java.lang.StringBuffer").init() />
		<cfset var result= ArrayNew(1) />
		<cfset var i= 0>
		<cfset var c= "">
		
		<cfloop condition="i LT Len(arguments.csv)">
			<cfset c= arguments.csv.charAt(JavaCast("int",i))>
			<cfif c EQ ",">
				<cfset arrayAppend(result,sb.toString()) />
				<cfset sb= createObject("java","java.lang.StringBuffer").init() /> 	
				<cfset i= i+1>	
			<cfelseif c EQ "\">
				<cfset i= i+1 />
				<cfset c= arguments.csv.charAt(JavaCast("int",i))>
				<cfset sb.append(JavaCast("string",c)) />
				<cfset i= i+1 />
			<cfelse>
				<cfset sb.append(JavaCast("string",c)) />
				<cfset i= i+1>
			</cfif>
		</cfloop>
	
		<cfset arrayAppend(result,sb.toString()) />
		<cfreturn result />
		
	</cffunction>
	
	<cffunction returntype="any" name="start">
		<cfargument required="true" type="string" name="browserURL" />
		<cfargument required="false" type="string" name="browserStartCommand" default="*firefox" />
		<cfargument required="false" type="string" name="extensionJs" default="" /> 
		<cfargument required="false" type="array" name="browserConfigurationOptions" default="#ArrayNew(1)#" />
		
		<cfset var startArgs= ArrayNew(1) />
		<cfset var i= 0 />
		<cfset var result= "" />
		
		<cfset arrayAppend(startArgs,arguments.browserStartCommand) />
		<cfset arrayAppend(startArgs,arguments.browserURL) />
		<cfset arrayAppend(startArgs,arguments.extensionJs) />
		
		<cfloop index="i" from="1" to="#ArrayLen(arguments.browserConfigurationOptions)#">
			<cfset ArrayAppend(startArgs,arguments.browserConfigurationOptions[i]) />
		</cfloop>
		
		<cfset result= getString("getNewBrowserSession",startArgs) />
		
		<cfif Len(result) GT 0>
			<cfset variables.sessionId= result />
		<cfelse>
			<cfthrow message="No sessionId returned from selenium.start()" />
		</cfif>
		
	</cffunction>
	
	<cffunction returntype="void" name="stop">
		<cfset doCommand("testComplete") />
		<cfset variables.sessionId= "" />
	</cffunction>
	
	<cffunction returntype="boolean" name="serverIsRunning">
		<cftry>
			<cfset doCommand("testComplete")>
			<cfreturn true />
			<cfcatch type="any">
				<cfif Find("Connection Failure",cfcatch.message)>
					<cfreturn false />
				<cfelse>
					<cfreturn true />
				</cfif>
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction returntype="void" name="stopServer">
		<cfset variables.server.stopServer()>
	</cffunction>
	
	<cffunction returntype="void" name="click" hint="Clicks on a link, button, checkbox or radio button. If the click action causes a new page to load (like a link usually does), call waitForPageToLoad.">
		<cfargument required="true" type="string" name="locator" />
		<cfset var paramArray= ArrayNew(1)>
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfset doCommand("click",paramArray) />
	</cffunction> 
    
    <cffunction returntype="void" name="doubleClick" hint="Double clicks on a link, button, checkbox or radio button. If the double click action causes a new page to load (like a link usually does), call waitForPageToLoad.">
		<cfargument required="true" type="string" name="locator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfset doCommand("doubleClick",paramArray) />	
	</cffunction>

    <cffunction returntype="void" name="contextMenu" hint="Simulates opening the context menu for the specified element (as might happen if the user 'right-clicked' on the element).">
    	<cfargument required="true" type="string" name="locator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfset doCommand("contextMenu",paramArray) />
	</cffunction>
	

	<cffunction returntype="void" name="clickAt"  hint="Clicks on a link, button, checkbox or radio button. If the click action causes a new page to load (like a link usually does), call waitForPageToLoad.">
		<cfargument required="true" type="string" name="locator" />
		<cfargument required="true" type="string" name="coordString" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfset ArrayAppend(paramArray,arguments.coordString) />
		<cfset doCommand("clickAt",paramArray) />
	</cffunction>
	
	<cffunction returntype="void" name="doubleClickAt" hint="Double clicks on a link, button, checkbox or radio button. If the double click action causes a new page to load (like a link usually does), call waitForPageToLoad.">
		<cfargument required="true" type="string" name="locator" />
		<cfargument required="true" type="string" name="coordString" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfset ArrayAppend(paramArray,arguments.coordString) />
		<cfset doCommand("doubleClickAt",paramArray) />
	</cffunction>
	
	<cffunction returntype="void" name="fireEvent" hint="Explicitly simulate an event, to trigger the corresponding 'on\ *event*' handler.">
		<cfargument required="true" type="string" name="locator" />
		<cfargument required="true" type="string" name="eventName" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfset ArrayAppend(paramArray,arguments.eventName) />
		<cfset doCommand("fireEvent",paramArray) />
	</cffunction>	
	
    <cffunction returntype="void" name="focus" hint=" Move the focus to the specified element; for example, if the element is an input field, move the cursor to that field.">
		<cfargument required="true" type="string" name="locator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfset doCommand("focus",paramArray) />
	</cffunction>

	<cffunction returntype="void" name="keyPress" hint="Simulates a user pressing and releasing a key.">
		<cfargument required="true" type="string" name="locator" />
		<cfargument required="true" type="string" name="keySequence" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfset ArrayAppend(paramArray,arguments.keySequence) />
		<cfset doCommand("keyPress",paramArray) />
	</cffunction>
	
	<cffunction returntype="void" name="shiftKeyDown" hint="Press the shift key and hold it down until doShiftUp() is called or a new page is loaded.">
    	<cfset doCommand("shiftKeyDown") />
    </cffunction>
	
	<cffunction returntype="void" name="shiftKeyUp" hint="Release the shift key">
    	<cfset doCommand("shiftKeyUp") />
    </cffunction>
	
	<cffunction returntype="void" name="metaKeyDown" hint="Press the meta key and hold it down until doMetaUp() is called or a new page is loaded.">
    	<cfset doCommand("metaKeyDown") />
    </cffunction>
	
	<cffunction returntype="void" name="metaKeyUp" hint="Release the meta key.">
    	<cfset doCommand("metaKeyUp") />
    </cffunction>
	
	<cffunction returntype="void" name="altKeyDown" hint="Press the alt key and hold it down until doAltUp() is called or a new page is loaded.">
    	<cfset doCommand("altKeyDown") />
    </cffunction>
	
	<cffunction returntype="void" name="altKeyUp" hint="Release the alt key.">
    	<cfset doCommand("altKeyUp") />
    </cffunction>
	
	<cffunction returntype="void" name="controlKeyDown" hint="Press the control key and hold it down until doControlUp() is called or a new page is loaded.">
    	<cfset doCommand("controlKeyDown") />
    </cffunction>
	
	<cffunction returntype="void" name="controlKeyUp" hint="Release the control key.">
    	<cfset doCommand("controlKeyUp") />
    </cffunction>
	
	<cffunction returntype="void" name="keyDown" hint="Simulates a user pressing a key (without releasing it yet).">
		<cfargument required="true" type="string" name="locator" />
		<cfargument required="true" type="string" name="keySequence" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfset ArrayAppend(paramArray,arguments.keySequence) />
		<cfset doCommand("keyDown",paramArray) />
	</cffunction>
	
	<cffunction returntype="void" name="keyUp" hint="Simulates a user releasing a key.">
		<cfargument required="true" type="string" name="locator" />
		<cfargument required="true" type="string" name="keySequence" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfset ArrayAppend(paramArray,arguments.keySequence) />
		<cfset doCommand("keyUp",paramArray) />
	</cffunction>
	
	<cffunction returntype="void" name="mouseOver" hint="Simulates a user hovering a mouse over the specified element">
		<cfargument required="true" type="string" name="locator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfset doCommand("mouseOver",paramArray) />
	</cffunction>
	
	<cffunction returntype="void" name="mouseOut" hint="Simulates a user hovering a mouse over the specified element.">
		<cfargument required="true" type="string" name="locator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfset doCommand("mouseOut",paramArray) />
	</cffunction>
	
	<cffunction returntype="void" name="mouseDown" hint="Simulates a user pressing the left mouse button (without releasing it yet) on the specified element.">
		<cfargument required="true" type="string" name="locator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfset doCommand("mouseDown",paramArray) />
	</cffunction>
	
	<cffunction returntype="void" name="mouseDownRight" hint="Simulates a user pressing the right mouse button (without releasing it yet) on the specified element.">
		<cfargument required="true" type="string" name="locator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfset doCommand("mouseDownRight",paramArray) />
	</cffunction>
	
	<cffunction returntype="void" name="mouseDownAt" hint="Simulates a user pressing the left mouse button (without releasing it yet) at the specified location.">
		<cfargument required="true" type="string" name="locator" />
		<cfargument required="true" type="string" name="coordString" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfset ArrayAppend(paramArray,arguments.coordString) />
		<cfset doCommand("mouseDownAt",paramArray) />
	</cffunction>
	
	<cffunction returntype="void" name="mouseDownRightAt" hint="Simulates a user pressing the right mouse button (without releasing it yet) at the specified location.">
		<cfargument required="true" type="string" name="locator" />
		<cfargument required="true" type="string" name="coordString" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfset ArrayAppend(paramArray,arguments.coordString) />
		<cfset doCommand("mouseDownRightAt",paramArray) />
	</cffunction>
	
	<cffunction returntype="void" name="mouseUp" hint="Simulates the event that occurs when the user releases the left mouse button (i.e., stops holding the button down) on the specified element.">
		<cfargument required="true" type="string" name="locator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfset doCommand("mouseUp",paramArray) />
	</cffunction>
	
	<cffunction returntype="void" name="mouseUpRight" hint="Simulates the event that occurs when the user releases the right mouse button (i.e., stops holding the button down) on the specified element.">
		<cfargument required="true" type="string" name="locator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfset doCommand("mouseUp",paramArray) />
	</cffunction>
	
	<cffunction returntype="void" name="mouseUpAt" hint="Simulates the event that occurs when the user releases the left mouse button (i.e., stops holding the button down) at the specified location.">
		<cfargument required="true" type="string" name="locator" />
		<cfargument required="true" type="string" name="coordString" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfset ArrayAppend(paramArray,arguments.coordString) />
		<cfset doCommand("mouseUpAt",paramArray) />
	</cffunction>
	
	<cffunction returntype="void" name="mouseUpRightAt" hint="Simulates the event that occurs when the user releases the right mouse button (i.e., stops holding the button down) at the specified location.">
		<cfargument required="true" type="string" name="locator" />
		<cfargument required="true" type="string" name="coordString" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfset ArrayAppend(paramArray,arguments.coordString) />
		<cfset doCommand("mouseUpRightAt",paramArray) />
	</cffunction>
	
	<cffunction returntype="void" name="mouseMove" hint="Simulates a user pressing the mouse button (without releasing it yet) on the specified element.">
		<cfargument required="true" type="string" name="locator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfset doCommand("mouseMove",paramArray) />
	</cffunction>

	<cffunction returntype="void" name="mouseMoveAt" hint="Simulates a user pressing the mouse button (without releasing it yet) on the specified element."	>
		<cfargument required="true" type="string" name="locator" />
		<cfargument required="true" type="string" name="coordString" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfset ArrayAppend(paramArray,arguments.coordString) />
		<cfset doCommand("mouseMoveAt",paramArray) />
	</cffunction>
	
	<cffunction returntype="void" name="type" 
		hint="Sets the value of an input field, as though you typed it in.
	
	 	Can also be used to set the value of combo boxes, check boxes, etc. In these cases,
	 	value should be the value of the option selected, not the visible text.Simulates a user pressing the mouse button (without releasing it yet) on the specified element.">
		
		<cfargument required="true" type="string" name="locator" />
		<cfargument required="true" type="string" name="value" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfset ArrayAppend(paramArray,arguments.value) />
		<cfset doCommand("type",paramArray) />
		
	</cffunction>
	
	<cffunction returntype="void" name="typeKeys"
		hint="Simulates keystroke events on the specified element, as though you typed the value key-by-key.

        This is a convenience method for calling keyDown, keyUp, keyPress for every character in the specified string;
        this is useful for dynamic UI widgets (like auto-completing combo boxes) that require explicit key events.
        
        Unlike the simple 'type' command, which forces the specified value into the page directly, this command
        may or may not have any visible effect, even in cases where typing keys would normally have a visible effect.
        For example, if you use 'typeKeys' on a form element, you may or may not see the results of what you typed in
        the field.
        
        In some cases, you may need to use the simple 'type' command to set the value of the field and then the 'typeKeys' command to
        send the keystroke events corresponding to what you just typed.">
        
        <cfargument required="true" type="string" name="locator" />
        <cfargument required="true" type="string" name="value" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfset ArrayAppend(paramArray,arguments.value) />
		<cfset doCommand("typeKeys",paramArray) />
	</cffunction>
	
	<cffunction returntype="void" name="setSpeed" hint="Set execution speed (i.e., set the millisecond length of a delay which will follow each selenium operation).  By default, there is no such delay, i.e., the delay is 0 milliseconds.">
		<cfargument required="true" type="string" name="value" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.value) />
		<cfset doCommand("setSpeed",paramArray) />
	</cffunction>
	
	<cffunction returntype="string" name="getSpeed" hint="Get execution speed (i.e., get the millisecond length of the delay following each selenium operation).  By default, there is no such delay, i.e., the delay is 0 milliseconds.">
    	<cfreturn getString("getSpeed") />
    </cffunction>
	
	<cffunction returntype="string" name="getLog" hint="Get RC logs associated with current session.">
    	<cfreturn getString("getLog") />
    </cffunction>
	
	<cffunction returntype="void" name="check" hint="Check a toggle-button (checkbox/radio)">
    	<cfargument required="true" type="string" name="locator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
    	<cfset doCommand("check",paramArray) />
    </cffunction>
	
	<cffunction returntype="void" name="uncheck" hint="Uncheck a toggle-button (checkbox/radio)">
    	<cfargument required="true" type="string" name="locator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
    	<cfset doCommand("uncheck",paramArray) />
    </cffunction>
	
	<cffunction returntype="void" name="select"
		hint="Select an option from a drop-down using an option locator.

		Option locators provide different ways of specifying options of an HTML
		Select element (e.g. for selecting a specific option, or for asserting
		that the selected option satisfies a specification). There are several
		forms of Select Option Locator.
		
		*   \ **label**\ =\ *labelPattern*:
		    matches options based on their labels, i.e. the visible text. (This is the default.)
		    
		    *   label=regexp:^[Oo]ther
		    
		*   \ **value**\ =\ *valuePattern*:
		    matches options based on their values.
		    
		    *   value=other
		    
		*   \ **id**\ =\ *id*:
		    
		    matches options based on their ids.
		    
		    *   id=option1
		    
		*   \ **index**\ =\ *index*:
		    matches an option based on its index (offset from zero).
		    
		    *   index=2
		    
		If no option locator prefix is provided, the default behaviour is to match on \ **label**\ .">
		
		<cfargument required="true" type="string" name="locator" />
		<cfargument required="true" type="string" name="optionLocator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfset ArrayAppend(paramArray,arguments.optionLocator) />
		<cfset doCommand("select",paramArray) />
		
	</cffunction>
	
	<cffunction returntype="void" name="addSelection"
		hint="Remove a selection from the set of selected options in a multi-select element using an option locator.

		Option locators provide different ways of specifying options of an HTML
		Select element (e.g. for selecting a specific option, or for asserting
		that the selected option satisfies a specification). There are several
		forms of Select Option Locator.
		
		*   \ **label**\ =\ *labelPattern*:
		    matches options based on their labels, i.e. the visible text. (This is the default.)
		    
		    *   label=regexp:^[Oo]ther
		    
		*   \ **value**\ =\ *valuePattern*:
		    matches options based on their values.
		    
		    *   value=other
		    
		*   \ **id**\ =\ *id*:
		    
		    matches options based on their ids.
		    
		    *   id=option1
		    
		*   \ **index**\ =\ *index*:
		    matches an option based on its index (offset from zero).
		    
		    *   index=2
		    
		If no option locator prefix is provided, the default behaviour is to match on \ **label**\ .">
		
		<cfargument required="true" type="string" name="locator" />
		<cfargument required="true" type="string" name="optionLocator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfset ArrayAppend(paramArray,arguments.optionLocator) />
		<cfset doCommand("addSelection",paramArray) />
		
	</cffunction>
	
	<cffunction returntype="void" name="removeSelection"
		hint="Add a selection to the set of selected options in a multi-select element using an option locator.

		Option locators provide different ways of specifying options of an HTML
		Select element (e.g. for selecting a specific option, or for asserting
		that the selected option satisfies a specification). There are several
		forms of Select Option Locator.
		
		*   \ **label**\ =\ *labelPattern*:
		    matches options based on their labels, i.e. the visible text. (This is the default.)
		    
		    *   label=regexp:^[Oo]ther
		    
		*   \ **value**\ =\ *valuePattern*:
		    matches options based on their values.
		    
		    *   value=other
		    
		*   \ **id**\ =\ *id*:
		    
		    matches options based on their ids.
		    
		    *   id=option1
		    
		*   \ **index**\ =\ *index*:
		    matches an option based on its index (offset from zero).
		    
		    *   index=2
		    
		If no option locator prefix is provided, the default behaviour is to match on \ **label**\ .">
		
		<cfargument required="true" type="string" name="locator" />
		<cfargument required="true" type="string" name="optionLocator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfset ArrayAppend(paramArray,arguments.optionLocator) />
		<cfset doCommand("removeSelection",paramArray) />
		
	</cffunction>
	
	<cffunction returntype="void" name="removeAllSelections" hint="Unselects all of the selected options in a multi-select element.">
    	<cfargument required="true" type="string" name="locator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
    	<cfset doCommand("removeAllSelections",paramArray) />
    </cffunction>
	
	<cffunction returntype="void" name="submit" hint="Submit the specified form. This is particularly useful for forms without submit buttons, e.g. single-input 'Search' forms.">
    	<cfargument required="true" type="string" name="formLocator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.formLocator) />
    	<cfset doCommand("submit",paramArray) />
    </cffunction>
	
	<cffunction returntype="void" name="open"
		hint="Opens an URL in the test frame. This accepts both relative and absolute URLs.
        
        The 'open' command waits for the page to load before proceeding, ie. the 'AndWait' suffix is implicit.
        
        \ *Note*: The URL must be on the same domain as the runner HTML
        due to security restrictions in the browser (Same Origin Policy). If you
        need to open an URL on another domain, use the Selenium Server to start a
        new browser session on that domain.">
        
        <cfargument required="true" type="string" name="url" />
		<cfargument required="false" type="boolean" name="ignoreResponseCode" default="true" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.url) />
		<cfset ArrayAppend(paramArray,arguments.ignoreResponseCode) />
		<cfset doCommand("open",paramArray) />	
			
	</cffunction>
	
	<cffunction returntype="void" name="openWindow"
		hint="Opens a popup window (if a window with that ID isn't already open).
        After opening the window, you'll need to select it using the selectWindow command.
        
        This command can also be a useful workaround for bug SEL-339.  In some cases, Selenium will be unable to intercept a call to window.open (if the call occurs during or before the 'onLoad' event, for example).
        In those cases, you can force Selenium to notice the open window's name by using the Selenium openWindow command, using
        an empty (blank) url, like this: openWindow('', 'myFunnyWindow').">
		
		<cfargument required="true" type="string" name="url" />
		<cfargument required="true" type="string" name="windowId" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.url) />
		<cfset ArrayAppend(paramArray,arguments.windowId) />
		<cfset doCommand("openWindow",paramArray) />
	</cffunction>
	
	<cffunction returntype="void" name="selectWindow"
		hint="Selects a popup window using a window locator; once a popup window has been selected, all
        commands go to that window. To select the main window again, use null as the target.
        
        Window locators provide different ways of specifying the window object:
        by title, by internal JavaScript 'name,' or by JavaScript variable.
        
        *   \ **title**\ =\ *My Special Window*:
            Finds the window using the text that appears in the title bar.  Be careful;
            two windows can share the same title.  If that happens, this locator will
            just pick one.
            
        *   \ **name**\ =\ *myWindow*:
            Finds the window using its internal JavaScript 'name' property.  This is the second 
            parameter 'windowName' passed to the JavaScript method window.open(url, windowName, windowFeatures, replaceFlag)
            (which Selenium intercepts).
            
        *   \ **var**\ =\ *variableName*:
            Some pop-up windows are unnamed (anonymous), but are associated with a JavaScript variable name in the current
            application window, e.g. 'window.foo = window.open(url);'.  In those cases, you can open the window using
            'var=foo'.
        
        If no window locator prefix is provided, we'll try to guess what you mean like this:
        
        1.) if windowID is null, (or the string 'null') then it is assumed the user is referring to the original window instantiated by the browser).
        
        2.) if the value of the 'windowID' parameter is a JavaScript variable name in the current application window, then it is assumed
        that this variable contains the return value from a call to the JavaScript window.open() method.
        
        3.) Otherwise, selenium looks in a hash it maintains that maps string names to window 'names'.
        
        4.) If \ *that* fails, we'll try looping over all of the known windows to try to find the appropriate 'title'.
        Since 'title' is not necessarily unique, this may have unexpected behavior.
        
        If you're having trouble figuring out the name of a window that you want to manipulate, look at the Selenium log messages
        which identify the names of windows created via window.open (and therefore intercepted by Selenium).  You will see messages
        like the following for each window as it is opened:
        
        'debug: window.open call intercepted; window ID (which you can use with selectWindow()) is 'myNewWindow''
        
        In some cases, Selenium will be unable to intercept a call to window.open (if the call occurs during or before the 'onLoad' event, for example).
        (This is bug SEL-339.)  In those cases, you can force Selenium to notice the open window's name by using the Selenium openWindow command, using
        an empty (blank) url, like this: openWindow('', 'myFunnyWindow').">
			
		<cfargument required="true" type="string" name="windowId" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.windowId) />
		<cfset doCommand("selectWindow",paramArray) />	
	</cffunction>
	
	<cffunction returntype="void" name="selectPopUp"
		hint="Simplifies the process of selecting a popup window (and does not offer functionality beyond what 'selectWindow()' already provides).
        
        *   If 'windowID' is either not specified, or specified as 'null', the first non-top window is selected. The top window is the one
            that would be selected by 'selectWindow()' without providing a 'windowID' . This should not be used when more than one popup window is in play.
        *   Otherwise, the window will be looked up considering 'windowID' as the following in order: 1) the 'name' of the
            window, as specified to 'window.open()'; 2) a javascript variable which is a reference to a window; and 3) the title of the
            window. This is the same ordered lookup performed by 'selectWindow' .">
		
		<cfargument required="true" type="string" name="windowId" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.windowId) />
		<cfset doCommand("selectPopUp",paramArray) />
	
	</cffunction>
	
	<cffunction returntype="void" name="deselectPopUp" hint="Selects the main window. Functionally equivalent to using 'selectWindow()' and specifying no value for 'windowID'.">
		<cfset doCommand("deselectPopUp") />
	</cffunction>
	
	<cffunction returntype="void" name="selectFrame"
		hint="Selects a frame within the current window.  (You may invoke this command multiple times to select nested frames.)
		To select the parent frame, use 'relative=parent' as a locator; to select the top frame, use 'relative=top'.
        You can also select a frame by its 0-based index number; select the first frame with 'index=0', or the third frame with 'index=2'.
		
        You may also use a DOM expression to identify the frame you want directly, like this: 'dom=frames['main'].frames['subframe']'">
		
		<cfargument required="true" type="string" name="locator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfset doCommand("selectFrame",paramArray) />
	
	</cffunction>
	 
	 <cffunction returntype="boolean" name="getWhetherThisFrameMatchFrameExpression"
	 	hint="Determine whether current/locator identify the frame containing this running code.
        
        This is useful in proxy injection mode, where this code runs in every browser frame and window, and sometimes the selenium server needs to identify the 'current' frame.
        In this case, when the test calls selectFrame, this routine is called for each frame to figure out which one has been selected.
        The selected frame will return true, while all others will return false.">
        
    	<cfargument required="true" type="string" name="currentFrameString" />
		<cfargument required="true" type="string" name="target" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.currentFrameString) />
		<cfset ArrayAppend(paramArray,arguments.target) />
		<cfreturn getBoolean("getWhetherThisFrameMatchFrameExpression",paramArray) />   

	</cffunction>
	
	<cffunction returntype="boolean" name="getWhetherThisWindowMatchWindowExpression"
	 	hint="Determine whether currentWindowString plus target identify the window containing this running code.
        
        This is useful in proxy injection mode, where this code runs in every browser frame and window, and sometimes the selenium server needs to identify the 'current' window.
        In this case, when the test calls selectWindow, this routine is called for each window to figure out which one has been selected.
        The selected window will return true, while all others will return false.">
        
    	<cfargument required="true" type="string" name="currentWindowString" />
		<cfargument required="true" type="string" name="target" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.currentWindowString) />
		<cfset ArrayAppend(paramArray,arguments.target) />
		<cfreturn getBoolean("getWhetherThisWindowMatchWindowExpression",paramArray) />   

	</cffunction>
	
	<cffunction returntype="void" name="waitForPopUp" hint="Waits for a popup window to appear and load up.">
    	<cfargument required="false" type="string" name="windowId" default="null" />
		<cfargument required="false" type="string" name="timeout" default="" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.windowId) />
		<cfset ArrayAppend(paramArray,arguments.timeout) />
    	<cfset doCommand("waitForPopUp",paramArray) />
    </cffunction>
    	
	<cffunction returntype="void" name="chooseCancelOnNextConfirmation" 
		hint="By default, Selenium's overridden window.confirm() function will return true, as if the user had manually clicked OK;
		after running this command, the next call to confirm() will return false, as if the user had clicked Cancel.
		Selenium will then resume using the default behavior for future confirmations, automatically returning true (OK) 
		unless/until you explicitly call this command for each confirmation.
        
        Take note - every time a confirmation comes up, you must consume it with a corresponding getConfirmation, or else the next selenium operation will fail.">
        
		<cfset doCommand("chooseCancelOnNextConfirmation") />

	</cffunction>
	
	<cffunction returntype="void" name="chooseOkOnNextConfirmation" 
		hint="Undo the effect of calling chooseCancelOnNextConfirmation.  
		Note that Selenium's overridden window.confirm() function will normally automatically return true, as if the user had manually clicked OK,
		so you shouldn't need to use this command unless for some reason you need to change your mind prior to the next confirmation.
		After any confirmation, Selenium will resume using the default behavior for future confirmations, automatically returning 
        true (OK) unless/until you explicitly call chooseCancelOnNextConfirmation for each confirmation.
        
        Take note - every time a confirmation comes up, you must consume it with a corresponding getConfirmation, or else the next selenium operation will fail.">
        
		<cfset doCommand("chooseOkOnNextConfirmation") />

	</cffunction>
	
	<cffunction returntype="void" name="answerOnNextPrompt" hint="Instructs Selenium to return the specified answer string in response to the next JavaScript prompt [window.prompt()].">
    	<cfargument required="true" type="string" name="answer" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.answer) />
    	<cfset doCommand("answerOnNextPrompt",paramArray) />
    </cffunction>
	
	<cffunction returntype="void" name="goBack" hint="Simulates the user clicking the 'back' button on their browser.">
		<cfset doCommand("goBack") />
	</cffunction>
	
	<cffunction returntype="void" name="refresh" hint="Simulates the user clicking the 'refresh' button on their browser.">
		<cfset doCommand("refresh") />
	</cffunction>
	
	<cffunction returntype="void" name="close" hint="Simulates the user clicking the 'close' button in the titlebar of a popup window or tab.">
		<cfset doCommand("close") />
	</cffunction>
	
	<cffunction returntype="boolean" name="isAlertPresent" hint="Has an alert occurred?">
		<cfreturn getBoolean("isAlertPresent") />
	</cffunction>
	
	<cffunction returntype="boolean" name="isPromptPresent" hint="Has a prompt occurred?">
		<cfreturn getBoolean("isAlertPresent") />
	</cffunction>
	
	<cffunction returntype="boolean" name="isConfirmationPresent" hint="Has confirm() been called?">
		<cfreturn getBoolean("isAlertPresent") />
	</cffunction>
	
	<cffunction returntype="string" name="getAlert"
		hint="Retrieves the message of a JavaScript alert generated during the previous action, or fail if there were no alerts.
        
        Getting an alert has the same effect as manually clicking OK. 
        If an alert is generated but you do not consume it with getAlert, the next Selenium action will fail.
        
        Under Selenium, JavaScript alerts will NOT pop up a visible alert dialog.
        
        Selenium does NOT support JavaScript alerts that are generated in a page's onload() event handler. In this case a visible dialog WILL be
        generated and Selenium will hang until someone manually clicks OK.">
        
        <cfreturn getString("getAlert") />
	</cffunction>
	
	<cffunction returntype="string" name="getConfirmation"
		hint="Retrieves the message of a JavaScript confirmation dialog generated during the previous action.
        
        By default, the confirm function will return true, having the same effect as manually clicking OK.
        This can be changed by prior execution of the chooseCancelOnNextConfirmation command. 
        
        If an confirmation is generated but you do not consume it with getConfirmation, the next Selenium action will fail.
        
        NOTE: under Selenium, JavaScript confirmations will NOT pop up a visible dialog.
        
        NOTE: Selenium does NOT support JavaScript confirmations that are generated in a page's onload() event handler. 
        In this case a visible dialog WILL be generated and Selenium will hang until you manually click OK.">
        
        <cfreturn getString("getConfirmation") />
	</cffunction>
	
	<cffunction returntype="string" name="getPrompt"
		hint="Retrieves the message of a JavaScript question prompt dialog generated during the previous action.
        
        Successful handling of the prompt requires prior execution of the answerOnNextPrompt command.
        If a prompt is generated but you do not get/verify it, the next Selenium action will fail.
        
        NOTE: under Selenium, JavaScript prompts will NOT pop up a visible dialog.
        
        NOTE: Selenium does NOT support JavaScript prompts that are generated in a page's onload() event handler. 
        In this case a visible dialog WILL be generated and Selenium will hang until you manually click OK.">
        
        <cfreturn getString("getPrompt") />
	</cffunction>
	
	<cffunction returntype="string" name="getLocation" hint="Gets the absolute URL of the current page.">
		<cfreturn getString("getLocation") />
	</cffunction>
	
	<cffunction returntype="string" name="getTitle" hint="Gets the title of the current page.">
		<cfreturn getString("getTitle") />
	</cffunction>

	<cffunction returntype="string" name="getBodyText" hint="Gets the entire text of the current page.">
		<cfreturn getString("getBodyText") />
	</cffunction>
	
	<cffunction returntype="string" name="getValue" 
		hint="Gets the (whitespace-trimmed) value of an input field (or anything else with a value parameter). 
		For checkbox/radio elements, the value will be 'on' or 'off' depending on whether the element is checked or not.">
    	
    	<cfargument required="true" type="string" name="locator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
    	<cfreturn getString("getValue",paramArray) />
		
    </cffunction>
	
	<cffunction returntype="string" name="getText" 
		hint="Gets the text of an element. This works for any element that contains text.
		This command uses either the textContent (Mozilla-like browsers) or the innerText (IE-like browsers) of the element, which is the rendered text shown to the user.">
    	
    	<cfargument required="true" type="string" name="locator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
    	<cfreturn getString("getText",paramArray) />
		
    </cffunction>
	
	<cffunction returntype="string" name="highlight" hint="Briefly changes the backgroundColor of the specified element yellow.  Useful for debugging.">
    	<cfargument required="true" type="string" name="locator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
    	<cfset doCommand("highlight",paramArray) />
	</cffunction>
	
	<cffunction returntype="string" name="getEval" 
		hint="Gets the result of evaluating the specified JavaScript snippet.  
		The snippet may have multiple lines, but only the result of the last line will be returned.
        
        Note that, by default, the snippet will run in the context of the 'selenium' object itself, so 'this' will refer to the Selenium object.
        Use 'window' to refer to the window of your application, e.g. 'window.document.getElementById('foo')'
        
        If you need to use a locator to refer to a single element in your application page, you can use 'this.browserbot.findElement('id=foo')' where 'id=foo' is your locator.">
    	
    	<cfargument required="true" type="string" name="script" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.script) />
    	<cfreturn getString("getEval",paramArray) />
		
    </cffunction>
	
	<cffunction returntype="boolean" name="isChecked" hint="Gets whether a toggle-button (checkbox/radio) is checked.  Fails if the specified element doesn't exist or isn't a toggle-button.">
		
		<cfargument required="true" type="string" name="locator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfreturn getBoolean("isChecked",paramArray) />
    
    </cffunction>
    
	<cffunction returntype="string" name="getTable" hint="Gets the text from a cell of a table. The cellAddress syntax tableLocator.row.column, where row and column start at 0.">
		
		<cfargument required="true" type="string" name="tableCellAddress" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.tableCellAddress) />
		<cfreturn getString("getTable",paramArray) />
		
	</cffunction>
	
	<cffunction returntype="array" name="getSelectedLabels" hint="Gets all option labels (visible text) for selected options in the specified select or multi-select element.">
		
		<cfargument required="true" type="string" name="selectLocator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.selectLocator) />
		<cfreturn getStringArray("getSelectedLabels",paramArray) />
		
	</cffunction>
	
	<cffunction returntype="string" name="getSelectedLabel" hint="Gets option label (visible text) for selected option in the specified select element.">
		
		<cfargument required="true" type="string" name="selectLocator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.selectLocator) />
		<cfreturn getString("getSelectedLabel",paramArray) />
		
	</cffunction>
	
	<cffunction returntype="array" name="getSelectedValues" hint="Gets all option values (value attributes) for selected options in the specified select or multi-select element.">
		
		<cfargument required="true" type="string" name="selectLocator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.selectLocator) />
		<cfreturn getStringArray("getSelectedValues",paramArray) />
		
	</cffunction>
	
	<cffunction returntype="string" name="getSelectedValue" hint="Gets option value (value attribute) for selected option in the specified select element.">
		
		<cfargument required="true" type="string" name="selectLocator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.selectLocator) />
		<cfreturn getString("getSelectedValue",paramArray) />
		
	</cffunction>
	
	<cffunction returntype="array" name="getSelectedIndexes" hint="Gets all option indexes (option number, starting at 0) for selected options in the specified select or multi-select element.">
		
		<cfargument required="true" type="string" name="selectLocator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.selectLocator) />
		<cfreturn getStringArray("getSelectedIndexes",paramArray) />
		
	</cffunction>
	
	<cffunction returntype="string" name="getSelectedIndex" hint="Gets option index (option number, starting at 0) for selected option in the specified select element.">
		
		<cfargument required="true" type="string" name="selectLocator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.selectLocator) />
		<cfreturn getString("getSelectedIndex",paramArray) />
		
	</cffunction>
	
	<cffunction returntype="array" name="getSelectedIds" hint="Gets all option element IDs for selected options in the specified select or multi-select element.">
		
		<cfargument required="true" type="string" name="selectLocator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.selectLocator) />
		<cfreturn getStringArray("getSelectedIds",paramArray) />
		
	</cffunction>
	
	<cffunction returntype="string" name="getSelectedId" hint="Gets option element ID for selected option in the specified select element.">
		
		<cfargument required="true" type="string" name="selectLocator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.selectLocator) />
		<cfreturn getString("getSelectedId",paramArray) />
		
	</cffunction>
	
	<cffunction returntype="boolean" name="isSomethingSelected" hint="Determines whether some option in a drop-down menu is selected.">
		
		<cfargument required="true" type="string" name="selectLocator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.selectLocator) />
		<cfreturn getBoolean("isSomethingSelected",paramArray) />
		
	</cffunction>
	
	<cffunction returntype="array" name="getSelectOptions" hint="Gets all option labels in the specified select drop-down">
	
		<cfargument required="true" type="string" name="selectLocator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.selectLocator) />
		<cfreturn getStringArray("getSelectOptions",paramArray) />
	
	</cffunction>
	
	<cffunction returntype="string" name="getAttribute" hint="Gets the value of an element attribute. The value of the attribute may differ across browsers (this is the case for the 'style' attribute, for example).">
		<cfargument required="true" type="string" name="attributeLocator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.attributeLocator) />
		<cfreturn getString("getAttribute",paramArray) />
	</cffunction>
	
	<cffunction returntype="boolean" name="isTextPresent" hint="Verifies that the specified text pattern appears somewhere on the rendered page shown to the user.">
		<cfargument required="true" type="string" name="pattern" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.pattern) />
		<cfreturn getBoolean("isTextPresent",paramArray) />
	</cffunction>
	
	<cffunction returntype="boolean" name="isElementPresent" hint="Verifies that the specified element is somewhere on the page.">
		<cfargument required="true" type="string" name="locator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfreturn getBoolean("isElementPresent",paramArray) />
	</cffunction>
	
	<cffunction returntype="boolean" name="isVisible" 
		hint="Determines if the specified element is visible.
		An element can be rendered invisible by setting the CSS 'visibility' property to 'hidden', or the 'display' property to 'none', either for the element itself or one if its ancestors.
		This method will fail if the element is not present.">
		
		<cfargument required="true" type="string" name="locator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfreturn getBoolean("isVisible",paramArray) />
	</cffunction>
	
	<cffunction returntype="boolean" name="isEditable" hint="Determines whether the specified input element is editable, ie hasn't been disabled. This method will fail if the specified element isn't an input element.">
		<cfargument required="true" type="string" name="locator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfreturn getBoolean("isEditable",paramArray) />
	</cffunction>
	
	<cffunction returntype="array" name="getAllButtons" hint="Returns the IDs of all buttons on the page.">
		<cfreturn getStringArray("getAllButtons") />
	</cffunction>
	
	<cffunction returntype="array" name="getAllLinks" hint="Returns the IDs of all links on the page.">
		<cfreturn getStringArray("getAllLinks") />
	</cffunction>

	<cffunction returntype="array" name="getAllFields" hint="Returns the IDs of all input fields on the page.">
		<cfreturn getStringArray("getAllFields") />
	</cffunction>
	
	<cffunction returntype="array" name="getAttributeFromAllWindows" hint="Returns every instance of some attribute from all known windows.">
		<cfargument required="true" type="string" name="attributeName" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.attributeName) />	
		<cfreturn getStringArray("getAttributeFromAllWindows",paramArray) />
	</cffunction>
	
	<cffunction returntype="void" name="dragdrop" hint="deprecated - use dragAndDrop instead.">
    	<cfargument required="true" type="string" name="locator" />
		<cfargument required="true" type="string" name="movementsString" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfset ArrayAppend(paramArray,arguments.movementsString) />
    	<cfset doCommand("dragdrop",paramArray) />
    </cffunction>
    
	<cffunction returntype="void" name="setMouseSpeed" 
		hint="Configure the number of pixels between 'mousemove' events during dragAndDrop commands (default=10).
        
        Setting this value to 0 means that we'll send a 'mousemove' event to every single pixel in between the start location and the end location;
        that can be very slow, and may cause some browsers to force the JavaScript to timeout.
        
        If the mouse speed is greater than the distance between the two dragged objects, we'll just send one 'mousemove' at the start location and then one final one at the end location.">
        
        <cfargument required="true" type="numeric" name="pixels" />
    	<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.pixels) />
    	<cfset doCommand("setMouseSpeed",paramArray) />
    </cffunction>
	
	<cffunction returntype="numeric" name="getMouseSpeed" hint="Returns the number of pixels between 'mousemove' events during dragAndDrop commands (default=10).">
		<cfreturn getNumber("getMouseSpeed") />
	</cffunction>
	
	<cffunction returntype="void" name="dragAndDrop" hint="Drags an element a certain distance and then drops it.">
    	<cfargument required="true" type="string" name="locator" />
		<cfargument required="true" type="string" name="movementsString" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfset ArrayAppend(paramArray,arguments.movementsString) />
    	<cfset doCommand("dragAndDrop",paramArray) />
    </cffunction>
	
	<cffunction returntype="void" name="dragAndDropToObject" hint="Drags an element and drops it on another element.">
		<cfargument required="true" type="string" name="locatorOfObjectToBeDragged" />
		<cfargument required="true" type="string" name="locatorOfDragDestinationObject" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locatorOfObjectToBeDragged) />
		<cfset ArrayAppend(paramArray,arguments.locatorOfDragDestinationObject) />
		<cfset doCommand("dragAndDropToObject",paramArray) />
	</cffunction>
	
	<cffunction returntype="void" name="windowFocus" hint="Gives focus to the currently selected window.">
		<cfset doCommand("windowFocus") />
	</cffunction>
	
	<cffunction returntype="void" name="windowMaximize" hint="Resize currently selected window to take up the entire screen.">
		<cfset doCommand("windowMaximize") />
	</cffunction>
	
	<cffunction returntype="array" name="getAllWindowIds" hint="Returns the IDs of all windows that the browser knows about.">
		<cfreturn getStringArray("getAllWindowIds") />
	</cffunction>
	
	<cffunction returntype="array" name="getAllWindowNames" hint="Returns the names of all windows that the browser knows about.">
		<cfreturn getStringArray("getAllWindowNames") />
	</cffunction>
	
	<cffunction returntype="array" name="getAllWindowTitles" hint="Returns the titles of all windows that the browser knows about.">
		<cfreturn getStringArray("getAllWindowTitles") />
	</cffunction>
	
	<cffunction returntype="string" name="getHtmlSource" hint="Returns the entire HTML source between the opening and closing 'html' tags.'">
		<cfreturn getString("getHtmlSource") />
	</cffunction>
	
	<cffunction returntype="void" name="setCursorPosition" hint="Moves the text cursor to the specified position in the given input element or textarea. This method will fail if the specified element isn't an input element or textarea.">
    	<cfargument required="true" type="string" name="locator" />
		<cfargument required="true" type="string" name="position" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfset ArrayAppend(paramArray,arguments.position) />
    	<cfset doCommand("setCursorPosition",paramArray) />
    </cffunction>
	
	<cffunction returntype="numeric" name="getElementIndex" hint="Get the relative index of an element to its parent (starting from 0). The comment node and empty text node will be ignored.">
		<cfargument required="true" type="string" name="locator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfreturn getNumber("getElementIndex",paramArray) />
	</cffunction>
	
	<cffunction returntype="boolean" name="isOrdered" 
		hint="Check if these two elements have same parent and are ordered siblings in the DOM. Two same elements will not be considered ordered.">
		
		<cfargument required="true" type="string" name="locator" />
		<cfargument required="true" type="string" name="locator2" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfset ArrayAppend(paramArray,arguments.locator2) />
		<cfreturn getBoolean("isOrdered",paramArray) />
    </cffunction>
	
	<cffunction returntype="numeric" name="getElementPositionLeft" hint="Retrieves the horizontal position of an element.">
		<cfargument required="true" type="string" name="locator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfreturn getNumber("getElementPositionLeft",paramArray) />
	</cffunction>
	
	<cffunction returntype="numeric" name="getElementPositionTop" hint="Retrieves the vertical position of an element.">
		<cfargument required="true" type="string" name="locator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfreturn getNumber("getElementPositionTop",paramArray) />
	</cffunction>
	
	<cffunction returntype="numeric" name="getElementWidth" hint="Retrieves the width of an element.">
		<cfargument required="true" type="string" name="locator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfreturn getNumber("getElementWidth",paramArray) />
	</cffunction>
	
	<cffunction returntype="numeric" name="getElementHeight" hint="Retrieves the height of an element.">
		<cfargument required="true" type="string" name="locator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfreturn getNumber("getElementHeight",paramArray) />
	</cffunction>
	
	<cffunction returntype="numeric" name="getCursorPosition" 
		hint="Retrieves the text cursor position in the given input element or textarea; beware, this may not work perfectly on all browsers.
        
        Specifically, if the cursor/selection has been cleared by JavaScript, this command will tend to return the position of the last location of the cursor, even though the cursor is now gone from the page.  This is filed as SEL-243.
        
        This method will fail if the specified element isn't an input element or textarea, or there is no cursor in the element.">
        
        <cfargument required="true" type="string" name="locator" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfreturn getNumber("getCursorPosition",paramArray) />
        
	</cffunction>
	
	<cffunction returntype="string" name="getExpression"
		hint="Returns the specified expression.
        This is useful because of JavaScript preprocessing. It is used to generate commands like assertExpression and waitForExpression.">
		
		<cfargument required="true" type="string" name="expression" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.expression) />
		<cfreturn getString("getExpression",paramArray) />
	</cffunction>
		
	<cffunction returntype="numeric" name="getXpathCount" hint="Returns the number of nodes that match the specified xpath, eg. '//table' would give the number of tables.">
		<cfargument required="true" type="string" name="xpath" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.xpath) />
		<cfreturn getNumber("getXpathCount",paramArray) />
	</cffunction>
	
	<cffunction returntype="numeric" name="getCssCount" hint="Returns the number of nodes that match the specified css selector, eg. 'css=table' would give the number of tables.">
		<cfargument required="true" type="string" name="css" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.css) />
		<cfreturn getNumber("getCssCount",paramArray) />
	</cffunction>
	
	<cffunction returntype="void" name="assignId"
		hint="Temporarily sets the 'id' attribute of the specified element, so you can locate it in the future using its ID rather than a slow/complicated XPath.
		This ID will disappear once the page is reloaded.">
		
		<cfargument required="true" type="string" name="locator" />
		<cfargument required="true" type="string" name="identifier" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.locator) />
		<cfset ArrayAppend(paramArray,arguments.identifier) />
		<cfset doCommand("assignId",paramArray) />
	</cffunction>
	
	<cffunction returntype="void" name="allowNativeXpath" 
		hint="Specifies whether Selenium should use the native in-browser implementation of XPath (if any native version is available);
		if you pass 'false' to this function, we will always use our pure-JavaScript xpath library.
        Using the pure-JS xpath library can improve the consistency of xpath element locators between different browser vendors, but the pure-JS version is much slower than the native implementations.">
    	
    	<cfargument required="true" type="boolean" name="allow" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.allow) />
    	<cfset doCommand("allowNativeXpath",paramArray) />
    </cffunction>
    
	<cffunction returntype="void" name="ignoreAttributesWithoutValue" 
		hint="Specifies whether Selenium will ignore xpath attributes that have no value, i.e. are the empty string, when using the non-native xpath evaluation engine.
		You'd want to do this for performance reasons in IE.
        However, this could break certain xpaths, for example an xpath that looks for an attribute whose value is NOT the empty string.
        
        The hope is that such xpaths are relatively rare, but the user should have the option of using them.
        Note that this only influences xpath evaluation when using the ajaxslt engine (i.e. not 'javascript-xpath').">
    	
    	<cfargument required="true" type="boolean" name="ignore" />
		<cfset var paramArray= ArrayNew(1) />
		<cfset ArrayAppend(paramArray,arguments.ignore) />
    	<cfset doCommand("ignoreAttributesWithoutValue",paramArray) />
    </cffunction>
	
<cffunction returntype="void" name="waitForCondition" 
	hint="Runs the specified JavaScript snippet repeatedly until it evaluates to 'true'.
        The snippet may have multiple lines, but only the result of the last line will be considered.
        
        Note that, by default, the snippet will be run in the runner's test window, not in the window of your application.
        To get the window of your application, you can use the JavaScript snippet 'selenium.browserbot.getCurrentWindow()', and then run your JavaScript in there">
    
	<cfargument required="true" type="string" name="script" />
	<cfargument required="true" type="string" name="timeout" />
	<cfset var paramArray= ArrayNew(1) />
	<cfset ArrayAppend(paramArray,arguments.script) />
	<cfset ArrayAppend(paramArray,arguments.timeout) />
	<cfset doCommand("waitForCondition",paramArray) />
</cffunction>

<cffunction returntype="void" name="setTimeout" 
	hint="Specifies the amount of time that Selenium will wait for actions to complete.
        Actions that require waiting include 'open' and the 'waitFor\*' actions.
        The default timeout is 30 seconds.">
	
	<cfargument required="true" type="numeric" name="timeout" />
	<cfset var paramArray= ArrayNew(1) />
	<cfset ArrayAppend(paramArray,arguments.timeout) />
	<cfset doCommand("setTimeout",paramArray) />
</cffunction>

<cffunction returntype="void" name="waitForPageToLoad" 
	hint="Waits for a new page to load.                  
	
	You can use this command instead of the 'AndWait' suffixes, 'clickAndWait', 'selectAndWait', 'typeAndWait' etc. (which are only available in the JS API).                  
	
	Selenium constantly keeps track of new pages loading, and sets a 'newPageLoaded' flag when it first notices a page load.         
	Running any other Selenium command after turns the flag to false.  Hence, if you want to wait for a page to load, you must wait immediately after a Selenium command that caused a page-load.">
	
	<cfargument required="true" type="numeric" name="timeout" />
	<cfset var paramArray= ArrayNew(1) />
	<cfset ArrayAppend(paramArray,arguments.timeout) />
	<cfset doCommand("waitForPageToLoad",paramArray) />
</cffunction>

<cffunction returntype="void" name="waitForFrameToLoad" 
	hint="Waits for a new frame to load.
        Selenium constantly keeps track of new pages and frames loading, and sets a 'newPageLoaded' flag when it first notices a page load.
        See waitForPageToLoad for more information.">
	
	<cfargument required="true" type="string" name="frameAddress" />
	<cfargument required="true" type="numeric" name="timeout" />
	<cfset var paramArray= ArrayNew(1) />
	<cfset ArrayAppend(paramArray,arguments.frameAddress) />
	<cfset ArrayAppend(paramArray,arguments.timeout) />
	<cfset doCommand("waitForFrameToLoad",paramArray) />
</cffunction>

<cffunction returntype="string" name="getCookie" hint="Return all cookies of the current page under test.">
	<cfreturn getString("getCookie") />
</cffunction>

<cffunction returntype="string" name="getCookieByName" hint="Returns the value of the cookie with the specified name, or throws an error if the cookie is not present.">
	<cfargument required="true" type="string" name="name" />
	<cfset var paramArray= ArrayNew(1) />
	<cfset ArrayAppend(paramArray,arguments.name) />
	<cfreturn getString("getCookieByName",paramArray) />
</cffunction>

<cffunction returntype="boolean" name="isCookiePresent" hint="Returns true if a cookie with the specified name is present, or false otherwise.">
	<cfargument required="true" type="string" name="name" />
	<cfset var paramArray= ArrayNew(1) />
	<cfset ArrayAppend(paramArray,arguments.name) />
	<cfreturn getBoolean("isCookiePresent",paramArray) />
</cffunction>

<cffunction returntype="void" name="createCookie" hint="Create a new cookie whose path and domain are same with those of current page under test, unless you specified a path for this cookie explicitly.">
	<cfargument required="true" type="string" name="nameValuePair" />
	<cfargument required="true" type="string" name="optionsString" />
	<cfset var paramArray= ArrayNew(1) />
	<cfset ArrayAppend(paramArray,arguments.nameValuePair) />
	<cfset ArrayAppend(paramArray,arguments.optionsString) />
	<cfset doCommand("createCookie",paramArray) />
</cffunction>

<cffunction returntype="void" name="deleteCookie" 
	hint="Delete a named cookie with specified path and domain.  
		Be careful; to delete a cookie, you need to delete it using the exact same path and domain that were used to create the cookie.
        If the path is wrong, or the domain is wrong, the cookie simply won't be deleted.  
        Also note that specifying a domain that isn't a subset of the current domain will usually fail.
        
        Since there's no way to discover at runtime the original path and domain of a given cookie, we've added an option called 'recurse' to try all sub-domains of the current domain with
        all paths that are a subset of the current path.
        Beware; this option can be slow.  In big-O notation, it operates in O(n\*m) time, where n is the number of dots in the domain name and m is the number of slashes in the path.">
        
	<cfargument required="true" type="string" name="name" />
	<cfargument required="true" type="string" name="optionsString" />
	<cfset var paramArray= ArrayNew(1) />
	<cfset ArrayAppend(paramArray,arguments.name) />
	<cfset ArrayAppend(paramArray,arguments.optionsString) />
	<cfset doCommand("deleteCookie",paramArray) />
</cffunction>

<cffunction returntype="void" name="deleteAllVisibleCookies" 
	hint="Calls deleteCookie with recurse=true on all cookies visible to the current page.
        As noted on the documentation for deleteCookie, recurse=true can be much slower than simply deleting the cookies using a known domain/path.">
	
	<cfset doCommand("deleteAllVisibleCookies") />
</cffunction>

<cffunction returntype="void" name="setBrowserLogLevel" 
	hint="Sets the threshold for browser-side logging messages; log messages beneath this threshold will be discarded.
        Valid logLevel strings are: 'debug', 'info', 'warn', 'error' or 'off'.
        To see the browser logs, you need to either show the log window in GUI mode, or enable browser-side logging in Selenium RC.">
    
	<cfargument required="true" type="string" name="logLevel" />
	<cfset var paramArray= ArrayNew(1) />
	<cfset ArrayAppend(paramArray,arguments.logLevel) />
	<cfset doCommand("setBrowserLogLevel",paramArray) />
</cffunction>

<cffunction returntype="void" name="runScript" 
	hint="Creates a new 'script' tag in the body of the current test window, and adds the specified text into the body of the command.
		Scripts run in this way can often be debugged more easily than scripts executed using Selenium's 'getEval' command.
		Beware that JS exceptions thrown in these script tags aren't managed by Selenium, so you should probably wrap your script in try/catch blocks if there is any chance that the script will throw an exception.">
	
	<cfargument required="true" type="string" name="script" />
	<cfset var paramArray= ArrayNew(1) />
	<cfset ArrayAppend(paramArray,arguments.script) />
	<cfset doCommand("runScript",paramArray) />
</cffunction>

<cffunction returntype="void" name="addLocationStrategy" 
	hint="Defines a new function for Selenium to locate elements on the page.
        For example, if you define the strategy 'foo', and someone runs click('foo=blah'), we'll run your function, passing you the string 'blah', 
		and click on the element that your function returns, or throw an 'Element not found' error if your function returns null.
        
        We'll pass three arguments to your function:
        
        *   locator: the string the user passed in
        *   inWindow: the currently selected window
        *   inDocument: the currently selected document
        
        The function must return null if the element can't be found.">
	
	<cfargument required="true" type="string" name="strategyName" />
	<cfargument required="true" type="string" name="functionDefinition" />
	<cfset var paramArray= ArrayNew(1) />
	<cfset ArrayAppend(paramArray,arguments.strategyName) />
	<cfset ArrayAppend(paramArray,arguments.functionDefinition) />
	<cfset doCommand("addLocationStrategy",paramArray) />
</cffunction>

<cffunction returntype="void" name="captureEntirePageScreenshot" 
	hint="Saves the entire contents of the current window canvas to a PNG file.
        Contrast this with the captureScreenshot command, which captures the contents of the OS viewport (i.e. whatever is currently being displayed on the monitor), and is implemented in the RC only.
        Currently this only works in Firefox when running in chrome mode, and in IE non-HTA using the EXPERIMENTAL 'Snapsie' utility.
        The Firefox implementation is mostly borrowed from the Screengrab! Firefox extension. 
        Please see http://www.screengrab.org and http://snapsie.sourceforge.net/ for details.">
        
	<cfargument required="true" type="string" name="filename" />
	<cfargument required="true" type="string" name="kwargs" />
	<cfset var paramArray= ArrayNew(1) />
	<cfset ArrayAppend(paramArray,arguments.filename) />
	<cfset ArrayAppend(paramArray,arguments.kwargs) />
	<cfset doCommand("captureEntirePageScreenshot",paramArray) />
</cffunction>

<cffunction returntype="void" name="rollup" 
	hint="Executes a command rollup, which is a series of commands with a unique name, and optionally arguments that control the generation of the set of commands.
		If any one of the rolled-up commands fails, the rollup is considered to have failed. Rollups may also contain nested rollups.">
		
	<cfargument required="true" type="string" name="rollupName" />
	<cfargument required="true" type="string" name="kwargs" />
	<cfset var paramArray= ArrayNew(1) />
	<cfset ArrayAppend(paramArray,arguments.rollupName) />
	<cfset ArrayAppend(paramArray,arguments.kwargs) />
	<cfset doCommand("rollup",paramArray) />
</cffunction>

<cffunction returntype="void" name="addScript"
	hint="Loads script content into a new script tag in the Selenium document.
		This differs from the runScript command in that runScript adds the script tag to the document of the AUT, not the Selenium document.
		The following entities in the script content are replaced by the characters they represent:
        
            &lt;
            &gt;
            &amp;
        
        The corresponding remove command is removeScript.">
        
	<cfargument required="true" type="string" name="stringContent" />
	<cfargument required="true" type="string" name="scriptTagId" />
	<cfset var paramArray= ArrayNew(1) />
	<cfset ArrayAppend(paramArray,arguments.stringContent) />
	<cfset ArrayAppend(paramArray,arguments.scriptTagId) />
	<cfset doCommand("addScript",paramArray) />
</cffunction>

<cffunction returntype="void" name="removeScript" hint="Removes the specified script">
	<cfargument required="true" type="string" name="scriptTagId" />
	<cfset var paramArray= ArrayNew(1) />
	<cfset ArrayAppend(paramArray,arguments.scriptTagId) />
	<cfset doCommand("removeScript",paramArray) />
</cffunction>

<cffunction returntype="void" name="useXpathLibrary" 
	hint="Allows choice of one of the available libraries.
        
        'libraryName' is name of the desired library Only the following three can be chosen: 
        *   'ajaxslt' - Google's library
        *   'javascript-xpath' - Cybozu Labs' faster library
        *   'default' - The default library.  Currently the default library is 'ajaxslt' .
        
         If libraryName isn't one of these three, then  no change will be made.">
         
	<cfargument required="true" type="string" name="libraryName" />
	<cfset var paramArray= ArrayNew(1) />
	<cfset ArrayAppend(paramArray,arguments.libraryName) />
	<cfset doCommand("useXpathLibrary",paramArray) />
</cffunction>

<cffunction returntype="void" name="setContext" hint="Writes a message to the status bar and adds a note to the browser-side log.">
	<cfargument required="true" type="string" name="locator" />
	<cfset var paramArray= ArrayNew(1) />
	<cfset ArrayAppend(paramArray,arguments.locator) />
	<cfset doCommand("setContext",paramArray) />
</cffunction>

<cffunction returntype="void" name="attachFile" hint="Sets a file input (upload) field to the file listed in fileLocator">
	<cfargument required="true" type="string" name="fieldLocator" />
	<cfargument required="true" type="string" name="fileLocator" />
	<cfset var paramArray= ArrayNew(1) />
	<cfset ArrayAppend(paramArray,arguments.fieldLocator) />
	<cfset ArrayAppend(paramArray,arguments.fileLocator) />
	<cfset doCommand("attachFile",paramArray) />
</cffunction>

<cffunction returntype="void" name="captureScreenshot" hint="Captures a PNG screenshot to the specified file.">
	<cfargument required="true" type="string" name="filename" />
	<cfset var paramArray= ArrayNew(1) />
	<cfset ArrayAppend(paramArray,arguments.filename) />
	<cfset doCommand("captureScreenshot",paramArray) />
</cffunction>

<cffunction returntype="string" name="captureScreenshotToString" hint="Capture a PNG screenshot. It then returns the file as a base 64 encoded string">
	<cfreturn getString("captureScreenshotToString") />
</cffunction>

<cffunction returntype="string" name="captureNetworkTraffic" hint="Returns the network traffic seen by the browser, including headers, AJAX requests, status codes, and timings. When this function is called, the traffic log is cleared, so the returned content is only the traffic seen since the last call.">
	<cfargument required="true" type="string" name="type" />
	<cfset var paramArray= ArrayNew(1) />
	<cfset ArrayAppend(paramArray,arguments.type) />
	<cfreturn getString("captureNetworkTraffic") />
</cffunction>

<cffunction returntype="void" name="addCustomRequestHeader" hint="Tells the Selenium server to add the specificed key and value as a custom outgoing request header. This only works if the browser is configured to use the built in Selenium proxy.j">
	<cfargument required="true" type="string" name="key" />
	<cfargument required="true" type="string" name="value" />
	<cfset var paramArray= ArrayNew(1) />
	<cfset ArrayAppend(paramArray,arguments.key) />
	<cfset ArrayAppend(paramArray,arguments.value) />
	<cfset doCommand("addCustomRequestHeader",paramArray) />
</cffunction>

<cffunction returntype="string" name="captureEntirePageScreenshotToString" 
	hint="Downloads a screenshot of the browser current window canvas to a based 64 encoded PNG file. 
		The \ *entire* windows canvas is captured, including parts rendered outside of the current view port.
        
        Currently this only works in Mozilla and when running in chrome mode.">
        
    	<cfreturn getString("captureEntirePageScreenshotToString") />

</cffunction>

<cffunction returntype="void" name="shutDownSeleniumServer" 
	hint="Kills the running Selenium Server and all browser sessions.
		After you run this command, you will no longer be able to send commands to the server; you can't remotely start the server once it has been stopped.
		Normally you should prefer to run the 'stop' command, which terminates the current browser session, rather than shutting down the entire server.">
	
	
	<cfset doCommand("shutDownSeleniumServer") />
</cffunction>

<cffunction returntype="string" name="retrieveLastRemoteControlLogs"
	hint="Retrieve the last messages logged on a specific remote control.
		Useful for error reports, especially when running multiple remote controls in a distributed environment.
		The maximum number of log messages that can be retrieve is configured on remote control startup.">
	<cfreturn getString("retrieveLastRemoteControlLogs") />
</cffunction>

<cffunction returntype="void" name="keyDownNative" 
	hint="Simulates a user pressing a key (without releasing it yet) by sending a native operating system keystroke.
        This function uses the java.awt.Robot class to send a keystroke; this more accurately simulates typing a key on the keyboard.
        It does not honor settings from the shiftKeyDown, controlKeyDown, altKeyDown and metaKeyDown commands, and does not target any particular HTML element.
        To send a keystroke to a particular element, focus on the element first before running this command.">
    
    <cfargument required="true" type="string" name="keycode" />
	<cfset var paramArray= ArrayNew(1) />
	<cfset ArrayAppend(paramArray,arguments.keycode) />
	<cfset doCommand("keyDownNative",paramArray) />
</cffunction>

<cffunction returntype="void" name="keyUpNative" 
	hint="Simulates a user releasing a key by sending a native operating system keystroke.
        This function uses the java.awt.Robot class to send a keystroke; this more accurately simulates typing a key on the keyboard.
        It does not honor settings from the shiftKeyDown, controlKeyDown, altKeyDown and metaKeyDown commands, and does not target any particular HTML element.
        To send a keystroke to a particular element, focus on the element first before running this command.">
    
    <cfargument required="true" type="string" name="keycode" />
	<cfset var paramArray= ArrayNew(1) />
	<cfset ArrayAppend(paramArray,arguments.keycode) />
	<cfset doCommand("keyUpNative",paramArray) />
</cffunction>

<cffunction returntype="void" name="keyPressNative" 
	hint="Simulates a user pressing and releasing a key by sending a native operating system keystroke.
        This function uses the java.awt.Robot class to send a keystroke; this more accurately simulates typing a key on the keyboard.
        It does not honor settings from the shiftKeyDown, controlKeyDown, altKeyDown and metaKeyDown commands, and does not target any particular HTML element.
        To send a keystroke to a particular element, focus on the element first before running this command.">
    
    <cfargument required="true" type="string" name="keycode" />
	<cfset var paramArray= ArrayNew(1) />
	<cfset ArrayAppend(paramArray,arguments.keycode) />
	<cfset doCommand("keyPressNative",paramArray) />
</cffunction>
	
</cfcomponent>