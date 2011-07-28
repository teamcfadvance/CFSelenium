component accessors="true" hint="A CFML binding for Selenium" {

	/*
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
	*/

	public any function init (string host = "localhost", numeric port = 4444, 
		numeric executionDelay = 200, string seleniumJarPath = "/cfselenium/Selenium-RC/selenium-server-standalone-2.2.0.jar", boolean verbose = false, string seleniumServerArguments = "",
		numeric waitTimeout = 30000) {

		structAppend(variables,arguments,true);
		variables.sessionId = "";
		
		arguments.selenium = this;
		variables.server = createObject("component","server").init(argumentCollection=arguments);
		variables.server.startServer();
		return this;
		
	}

	public string function getSessionId() {
		return variables.sessionId;
	}
	
	public any function doCommand(required string command, array args = arrayNew(1)) {
		
		var connection = new http(url="http://" & variables.host & ":" & variables.port & "/selenium-server/driver/",charset="utf-8",method="POST");
		var i = "";
		var response = "";
		
		connection.addParam(type="formfield",name="cmd",value=urlEncodedFormat(arguments.command,"utf-8"));
        for (i = 1; i <= arrayLen(arguments.args); i++) {
			connection.addParam(type="formfield",name=i,value=arguments.args[i]);
        }
        if (len(variables.sessionId) > 0) {
			connection.addParam(type="formfield",name="sessionId",value=variables.sessionId);
        }
		
		connection.addParam(type="header",name="Content-Type",value="application/x-www-form-urlencoded");
		
		response = connection.send().getPrefix().fileContent;
		if (left(response,2) eq "OK") {
			return response;
		}
		throw("The Response of the Selenium RC is invalid: #response#");
		
	}

	public void function waitForElementPresent(required string locator, numeric timeout = variables.waitTimeout) {
		var counter = 0;
		while (not isElementPresent(arguments.locator)) {
			sleep(100);
			counter += 100;
			if (counter eq arguments.timeout) {
				throw (type="CFSelenium.elementNotFound", message="The element: #arguments.locator# was not found after #arguments.timeout/1000# seconds.");
			}
		}
	}

	public void function waitForElementVisible(required string locator, numeric timeout = variables.waitTimeout) {
		var counter = 0;
		while (not isVisible(arguments.locator)) {
			sleep(100);
			counter += 100;
			if (counter eq arguments.timeout) {
				throw (type="CFSelenium.elementNotVisible", message="The element: #arguments.locator# was not visible after #arguments.timeout/1000# seconds.");
			}
		}
	}

	public void function waitForElementNotVisible(required string locator, numeric timeout = variables.waitTimeout) {
		var counter = 0;
		while (isVisible(arguments.locator)) {
			sleep(100);
			counter += 100;
			if (counter eq arguments.timeout) {
				throw (type="CFSelenium.elementStillVisible", message="The element: #arguments.locator# was still visible after #arguments.timeout/1000# seconds.");
			}
		}
	}

	public string function getString(required string command, array args = arrayNew(1)) {
		
		var result = doCommand(argumentCollection=arguments);
		var responseLen = len(result) - 3;
		return (responseLen eq 0) ? "" : right(result,responseLen);

	}

	public array function getStringArray(required string command, array args = arrayNew(1)) {

		return parseCSV(getString(argumentCollection=arguments));
		
	}

	public numeric function getNumber(required string command, array args = arrayNew(1)) {
		
		return val(getString(argumentCollection=arguments));

	}

	public array function getNumberArray(required string command, array args = arrayNew(1)) {

		var stringArray = parseCSV(getString(argumentCollection=arguments));
		var item = "";
		var numericArray = [];
		for (item in stringArray) {
			arrayAppend(numericArray,int(item));
		}
		return numericArray;
		
	}


	public boolean function getBoolean(required string command, array args = arrayNew(1)) {
		
		var result = getString(argumentCollection=arguments);
		if (isBoolean(result)) {
			return result;
		} else {
			throw "Error getting a boolean value from Selenium. The value '#result#' is not a valid boolean.";
		}

	}

	public array function getBooleanArray(required string command, array args = arrayNew(1)) {

		var stringArray = parseCSV(getString(argumentCollection=arguments));
		var item = "";
		for (item in stringArray) {
			if (not isBoolean(item)) {
				throw "Error getting a boolean value from Selenium. The value '#item#' is not a valid boolean.";
			}
		}
		return stringArray;
		
	}

	public array function parseCSV(required string csv)	{
		
		var sb = createObject( "java", "java.lang.StringBuilder" ).init();
 		var result = [];
 		var i = "";
 		var c = "";
 		
        for (i = 0; i < csv.length(); i++) {
            c = csv.charAt(i);
            switch (c) {
                case ',':
                    arrayAppend(result,sb.toString());
                    sb = createObject( "java", "java.lang.StringBuilder" ).init();
                    break;
                case '\':
                    i++;
                    c = csv.charAt(i);
                    // fall through to:
                default:
                    sb.append(c);
            }
        }
        arrayAppend(result,sb.toString());
        return result;
		
	}

	public any function start(required string browserURL, string browserStartCommand = "*firefox", string extensionJs = "",	browserConfigurationOptions = arrayNew(1)) {
		
		var startArgs = [arguments.browserStartCommand, arguments.browserURL, arguments.extensionJs];
		var i = 0;
		var result = "";
		
        for (i = 1; i <= arrayLen(arguments.browserConfigurationOptions); i++) {
			arrayAppend(startArgs,arguments.browserConfigurationOptions[i]);
        }
		
		result = getString("getNewBrowserSession",startArgs);
		
		if (len(result) > 0) {
			variables.sessionId = result;
		} else {
			throw "No sessionId returned from selenium.start()";
		}
	}
	
	public void function stop() {
		doCommand("testComplete");
        variables.sessionId = "";
	}

	public boolean function serverIsRunning() {
		try {
			doCommand("testComplete");		
		}
		catch (any e) {
			if (e.message contains "Connection Failure") {
				return false;
			}
		}
		return true;
	}	
	
	public void function stopServer() {
		// I will only stop the server if I also started the server
		variables.server.stopServer();
	}	
	
	public void function click(required string locator) hint="Clicks on a link, button, checkbox or radio button. If the click action causes a new page to load (like a link usually does), call waitForPageToLoad." {
		doCommand("click",[arguments.locator]);    
	}    
    
    public void function doubleClick(required string locator) hint="Double clicks on a link, button, checkbox or radio button. If the double click action causes a new page to load (like a link usually does), call waitForPageToLoad." {
		doCommand("doubleClick",[arguments.locator]);    
	}

    public void function contextMenu(required string locator) hint="Simulates opening the context menu for the specified element (as might happen if the user 'right-clicked' on the element)." {    
		doCommand("contextMenu",[arguments.locator]);    
	}

	public void function clickAt(required string locator, required string coordString) hint="Clicks on a link, button, checkbox or radio button. If the click action causes a new page to load (like a link usually does), call waitForPageToLoad." {
		doCommand("clickAt",[arguments.locator, arguments.coordString]);
	}

	public void function doubleClickAt(required string locator, required string coordString) hint="Double clicks on a link, button, checkbox or radio button. If the double click action causes a new page to load (like a link usually does), call waitForPageToLoad." {
		doCommand("doubleClickAt",[arguments.locator, arguments.coordString]);
	}

	public void function contextMenuAt(required string locator, required string coordString) hint="Simulates opening the context menu for the specified element (as might happen if the user 'right-clicked' on the element)." {
		doCommand("contextMenuAt",[arguments.locator, arguments.coordString]);
	}

	public void function fireEvent(required string locator, required string eventName) hint="Explicitly simulate an event, to trigger the corresponding 'on\ *event*' handler." {
		doCommand("fireEvent",[arguments.locator, arguments.eventName]);
	}

    public void function focus(required string locator) hint=" Move the focus to the specified element; for example, if the element is an input field, move the cursor to that field." {
		doCommand("focus",[arguments.locator]);    
	}

	public void function keyPress(required string locator, required string keySequence) hint="Simulates a user pressing and releasing a key."  {
		doCommand("keyPress",[arguments.locator, arguments.keySequence]);
	}

    public void function shiftKeyDown() hint="Press the shift key and hold it down until doShiftUp() is called or a new page is loaded."  {
		doCommand("shiftKeyDown");    
	}

    public void function shiftKeyUp() hint="Release the shift key." {
		doCommand("shiftKeyUp");    
	}

    public void function metaKeyDown() hint="Press the meta key and hold it down until doMetaUp() is called or a new page is loaded."  {
		doCommand("metaKeyDown");    
	}

    public void function metaKeyUp() hint="Release the meta key." {
		doCommand("metaKeyUp");    
	}

    public void function altKeyDown() hint="Press the alt key and hold it down until doAltUp() is called or a new page is loaded."  {
		doCommand("altKeyDown");    
	}

    public void function altKeyUp() hint="Release the alt key." {
		doCommand("altKeyUp");    
	}

    public void function controlKeyDown() hint="Press the control key and hold it down until doControlUp() is called or a new page is loaded."  {
		doCommand("controlKeyDown");    
	}

    public void function controlKeyUp() hint="Release the control key." {
		doCommand("controlKeyUp");    
	}

	public void function keyDown(required string locator, required string keySequence) hint ="Simulates a user pressing a key (without releasing it yet)." {
		doCommand("keyDown",[arguments.locator, arguments.keySequence]);
	}

	public void function keyUp(required string locator, required string keySequence) hint ="Simulates a user releasing a key." {
		doCommand("keyUp",[arguments.locator, arguments.keySequence]);
	}

    public void function mouseOver(required string locator) hint="Simulates a user hovering a mouse over the specified element." {
		doCommand("mouseOver",[arguments.locator]);    
	}

    public void function mouseOut(required string locator) hint="Simulates a user moving the mouse pointer away from the specified element." {
		doCommand("mouseOut",[arguments.locator]);    
	}

    public void function mouseDown(required string locator) hint="Simulates a user pressing the left mouse button (without releasing it yet) on the specified element." {
		doCommand("mouseDown",[arguments.locator]);    
	}

    public void function mouseDownRight(required string locator) hint="Simulates a user pressing the right mouse button (without releasing it yet) on the specified element." {
		doCommand("mouseDownRight",[arguments.locator]);    
	}

	public void function mouseDownAt(required string locator, required string coordString) hint="Simulates a user pressing the left mouse button (without releasing it yet) at the specified location." {
		doCommand("mouseDownAt",[arguments.locator, arguments.coordString]);
	}

	public void function mouseDownRightAt(required string locator, required string coordString) hint="Simulates a user pressing the right mouse button (without releasing it yet) at the specified location." {
		doCommand("mouseDownRightAt",[arguments.locator, arguments.coordString]);
	}

    public void function mouseUp(required string locator) hint="Simulates the event that occurs when the user releases the mouse button (i.e., stops holding the button down) on the specified element." {
		doCommand("mouseUp",[arguments.locator]);    
	}

    public void function mouseUpRight(required string locator) hint="Simulates the event that occurs when the user releases the mouse button (i.e., stops holding the button down) on the specified element." {
		doCommand("mouseUpRight",[arguments.locator]);    
	}

	public void function mouseUpAt(required string locator, required string coordString) hint="Simulates the event that occurs when the user releases the mouse button (i.e., stops holding the button down) at the specified location." {
		doCommand("mouseUpAt",[arguments.locator, arguments.coordString]);
	}

	public void function mouseUpRightAt(required string locator, required string coordString) hint="Simulates the event that occurs when the user releases the mouse button (i.e., stops holding the button down) at the specified location." {
		doCommand("mouseUpRightAt",[arguments.locator, arguments.coordString]);
	}

    public void function mouseMove(required string locator) hint="Simulates a user pressing the mouse button (without releasing it yet) on the specified element." {
		doCommand("mouseMove",[arguments.locator]);    
	}

	public void function mouseMoveAt(required string locator, required string coordString) hint="Simulates a user pressing the mouse button (without releasing it yet) on the specified element." {
		doCommand("mouseMoveAt",[arguments.locator, arguments.coordString]);
	}

	public void function type(required string locator, required string value) 
		hint="Sets the value of an input field, as though you typed it in.

        Can also be used to set the value of combo boxes, check boxes, etc. In these cases,
        value should be the value of the option selected, not the visible text.Simulates a user pressing the mouse button (without releasing it yet) on the specified element." {
		doCommand("type",[arguments.locator, arguments.value]);
	}

	public void function typeKeys(required string locator, required string value) 
		hint=" Simulates keystroke events on the specified element, as though you typed the value key-by-key.

        This is a convenience method for calling keyDown, keyUp, keyPress for every character in the specified string;
        this is useful for dynamic UI widgets (like auto-completing combo boxes) that require explicit key events.
        
        Unlike the simple 'type' command, which forces the specified value into the page directly, this command
        may or may not have any visible effect, even in cases where typing keys would normally have a visible effect.
        For example, if you use 'typeKeys' on a form element, you may or may not see the results of what you typed in
        the field.
        
        In some cases, you may need to use the simple 'type' command to set the value of the field and then the 'typeKeys' command to
        send the keystroke events corresponding to what you just typed." {
		doCommand("typeKeys",[arguments.locator, arguments.value]);
	}

    public void function setSpeed(required string value) hint="Set execution speed (i.e., set the millisecond length of a delay which will follow each selenium operation).  By default, there is no such delay, i.e., the delay is 0 milliseconds." {
		doCommand("setSpeed",[arguments.value]);    
	}

    public string function getSpeed() hint="Get execution speed (i.e., get the millisecond length of the delay following each selenium operation).  By default, there is no such delay, i.e., the delay is 0 milliseconds." {
		return getString("getSpeed");    
	}

    public string function getLog() hint="Get RC logs associated with current session." {
		return getString("getLog");    
	}

    public void function check(required string locator) hint="Check a toggle-button (checkbox/radio)" {
		doCommand("check",[arguments.locator]);    
	}

    public void function uncheck(required string locator) hint="Uncheck a toggle-button (checkbox/radio)" {
		doCommand("uncheck",[arguments.locator]);    
	}

    public void function select(required string locator, required string optionLocator) 
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
		    
		If no option locator prefix is provided, the default behaviour is to match on \ **label**\ ." {
		doCommand("select",[arguments.locator,arguments.optionLocator]);    
	}

    public void function addSelection(required string locator, required string optionLocator) 
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
		    
		If no option locator prefix is provided, the default behaviour is to match on \ **label**\ ." {
		doCommand("addSelection",[arguments.locator,arguments.optionLocator]);    
	}

    public void function removeSelection(required string locator, required string optionLocator) 
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
		    
		If no option locator prefix is provided, the default behaviour is to match on \ **label**\ ." {
		doCommand("removeSelection",[arguments.locator,arguments.optionLocator]);    
	}

    public void function removeAllSelections(required string locator) hint="Unselects all of the selected options in a multi-select element." {
		doCommand("removeAllSelections",[arguments.locator]);    
	}

    public void function submit(required string formLocator) hint="Submit the specified form. This is particularly useful for forms without submit buttons, e.g. single-input 'Search' forms." {
		doCommand("submit",[arguments.formLocator]);    
	}

	public void function open(required string url,boolean ignoreResponseCode=true) 
		hint="Opens an URL in the test frame. This accepts both relative and absolute URLs.
        
        The 'open' command waits for the page to load before proceeding, ie. the 'AndWait' suffix is implicit.
        
        \ *Note*: The URL must be on the same domain as the runner HTML
        due to security restrictions in the browser (Same Origin Policy). If you
        need to open an URL on another domain, use the Selenium Server to start a
        new browser session on that domain." {
		doCommand("open", [arguments.url,arguments.ignoreResponseCode]);
	}

	public void function openWindow(required string url,required string windowID) 
		hint="Opens a popup window (if a window with that ID isn't already open).
        After opening the window, you'll need to select it using the selectWindow command.
        
        This command can also be a useful workaround for bug SEL-339.  In some cases, Selenium will be unable to intercept a call to window.open (if the call occurs during or before the 'onLoad' event, for example).
        In those cases, you can force Selenium to notice the open window's name by using the Selenium openWindow command, using
        an empty (blank) url, like this: openWindow('', 'myFunnyWindow')." {
		doCommand("openWindow", [arguments.url,arguments.windowID]);
	}

	public void function selectWindow(required string windowID) 
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
        an empty (blank) url, like this: openWindow('', 'myFunnyWindow')." {
		doCommand("selectWindow", [arguments.windowID]);
	}

	public void function selectPopUp(required string windowID) 
		hint="Simplifies the process of selecting a popup window (and does not offer functionality beyond what 'selectWindow()' already provides).
        
        *   If 'windowID' is either not specified, or specified as 'null', the first non-top window is selected. The top window is the one
            that would be selected by 'selectWindow()' without providing a 'windowID' . This should not be used when more than one popup window is in play.
        *   Otherwise, the window will be looked up considering 'windowID' as the following in order: 1) the 'name' of the
            window, as specified to 'window.open()'; 2) a javascript variable which is a reference to a window; and 3) the title of the
            window. This is the same ordered lookup performed by 'selectWindow' ." {
		doCommand("selectPopUp", [arguments.windowID]);
	}

	public void function deselectPopUp() hint=" Selects the main window. Functionally equivalent to using 'selectWindow()' and specifying no value for 'windowID'." {
		doCommand("deselectPopUp");
	}

	public void function selectFrame(required string locator) 
		hint="Selects a frame within the current window.  (You may invoke this command multiple times to select nested frames.)
		To select the parent frame, use 'relative=parent' as a locator; to select the top frame, use 'relative=top'.
        You can also select a frame by its 0-based index number; select the first frame with 'index=0', or the third frame with 'index=2'.
        
        You may also use a DOM expression to identify the frame you want directly, like this: 'dom=frames['main'].frames['subframe']'" {
		doCommand("selectFrame", [arguments.locator]);
	}

	public boolean function getWhetherThisFrameMatchFrameExpression(required string currentFrameString,required string target) 
		hint=" Determine whether current/locator identify the frame containing this running code.
        
        This is useful in proxy injection mode, where this code runs in every browser frame and window, and sometimes the selenium server needs to identify the 'current' frame.
        In this case, when the test calls selectFrame, this routine is called for each frame to figure out which one has been selected.
        The selected frame will return true, while all others will return false." {
		return getBoolean("getWhetherThisFrameMatchFrameExpression", [arguments.currentFrameString,arguments.target]);
	}

	public boolean function getWhetherThisWindowMatchWindowExpression(required string currentWindowString,required string target) 
		hint=" Determine whether currentWindowString plus target identify the window containing this running code.
        
        This is useful in proxy injection mode, where this code runs in every browser frame and window, and sometimes the selenium server needs to identify the 'current' window.
        In this case, when the test calls selectWindow, this routine is called for each window to figure out which one has been selected.
        The selected window will return true, while all others will return false." {
		return getBoolean("getWhetherThisWindowMatchWindowExpression", [arguments.currentWindowString,arguments.target]);
	}

	public void function waitForPopUp(string windowID="null",string timeout="") hint="Waits for a popup window to appear and load up." {
		doCommand("waitForPopUp", [arguments.windowID, arguments.timeout]);
	}

	public void function chooseCancelOnNextConfirmation()
		hint="By default, Selenium's overridden window.confirm() function will return true, as if the user had manually clicked OK;
		after running this command, the next call to confirm() will return false, as if the user had clicked Cancel.
		Selenium will then resume using the default behavior for future confirmations, automatically returning true (OK) 
		unless/until you explicitly call this command for each confirmation.
        
        Take note - every time a confirmation comes up, you must consume it with a corresponding getConfirmation, or else the next selenium operation will fail." {
		doCommand("chooseCancelOnNextConfirmation");
	}

	public void function chooseOkOnNextConfirmation()
		hint="Undo the effect of calling chooseCancelOnNextConfirmation.  
		Note that Selenium's overridden window.confirm() function will normally automatically return true, as if the user had manually clicked OK,
		so you shouldn't need to use this command unless for some reason you need to change your mind prior to the next confirmation.
		After any confirmation, Selenium will resume using the default behavior for future confirmations, automatically returning 
        true (OK) unless/until you explicitly call chooseCancelOnNextConfirmation for each confirmation.
        
        Take note - every time a confirmation comes up, you must consume it with a corresponding getConfirmation, or else the next selenium operation will fail." {
		doCommand("chooseOkOnNextConfirmation");
	}

	public void function answerOnNextPrompt(required string answer)	hint="Instructs Selenium to return the specified answer string in response to the next JavaScript prompt [window.prompt()]." {
		doCommand("answerOnNextPrompt", [arguments.answer]);
	}

	public void function goBack() hint="Simulates the user clicking the 'back' button on their browser." {
		doCommand("goBack");
	}

	public void function refresh() hint="Simulates the user clicking the 'refresh' button on their browser." {
		doCommand("refresh");
	}

	public void function close() hint="Simulates the user clicking the 'close' button in the titlebar of a popup window or tab." {
		doCommand("close");
	}

	public boolean function isAlertPresent() hint="Has an alert occurred?" {
		return getBoolean("isAlertPresent");
	}

	public boolean function isPromptPresent() hint="Has a prompt occurred?" {
		return getBoolean("isPromptPresent");
	}

	public boolean function isConfirmationPresent() hint="Has confirm() been called?" {
		return getBoolean("isConfirmationPresent");
	}

	public string function getAlert() 
		hint="Retrieves the message of a JavaScript alert generated during the previous action, or fail if there were no alerts.
        
        Getting an alert has the same effect as manually clicking OK. 
        If an alert is generated but you do not consume it with getAlert, the next Selenium action will fail.
        
        Under Selenium, JavaScript alerts will NOT pop up a visible alert dialog.
        
        Selenium does NOT support JavaScript alerts that are generated in a page's onload() event handler. In this case a visible dialog WILL be
        generated and Selenium will hang until someone manually clicks OK." {
		return getString("getAlert");
	}

	public string function getConfirmation() 
		hint=" Retrieves the message of a JavaScript confirmation dialog generated during the previous action.
        
        By default, the confirm function will return true, having the same effect as manually clicking OK.
        This can be changed by prior execution of the chooseCancelOnNextConfirmation command. 
        
        If an confirmation is generated but you do not consume it with getConfirmation, the next Selenium action will fail.
        
        NOTE: under Selenium, JavaScript confirmations will NOT pop up a visible dialog.
        
        NOTE: Selenium does NOT support JavaScript confirmations that are generated in a page's onload() event handler. 
        In this case a visible dialog WILL be generated and Selenium will hang until you manually click OK." {
		return getString("getConfirmation");
	}

	public string function getPrompt() 
		hint="Retrieves the message of a JavaScript question prompt dialog generated during the previous action.
        
        Successful handling of the prompt requires prior execution of the answerOnNextPrompt command.
        If a prompt is generated but you do not get/verify it, the next Selenium action will fail.
        
        NOTE: under Selenium, JavaScript prompts will NOT pop up a visible dialog.
        
        NOTE: Selenium does NOT support JavaScript prompts that are generated in a page's onload() event handler. 
        In this case a visible dialog WILL be generated and Selenium will hang until you manually click OK." {
		return getString("getPrompt");
	}


	public string function getLocation() hint="Gets the absolute URL of the current page." {
		return getString("getLocation");
	}

	public string function getTitle() hint="Gets the title of the current page." {
		return getString("getTitle");
	}

	public string function getBodyText() hint="Gets the entire text of the current page." {
		return getString("getBodyText");
	}
	
	public string function getValue(required string locator) 
		hint="Gets the (whitespace-trimmed) value of an input field (or anything else with a value parameter). 
		For checkbox/radio elements, the value will be 'on' or 'off' depending on whether the element is checked or not." {
		return getString("getValue", [arguments.locator]);
	}
	
	public string function getText(required string locator) 
		hint="Gets the text of an element. This works for any element that contains text.
		This command uses either the textContent (Mozilla-like browsers) or the innerText (IE-like browsers) of the element, which is the rendered text shown to the user." {
		return getString("getText", [arguments.locator]);
	}
	
	public string function highlight(required string locator) hint="Briefly changes the backgroundColor of the specified element yellow.  Useful for debugging." {
		doCommand("highlight", [arguments.locator]);
	}
	
	public string function getEval(required string script) 
		hint="Gets the result of evaluating the specified JavaScript snippet.  
		The snippet may have multiple lines, but only the result of the last line will be returned.
        
        Note that, by default, the snippet will run in the context of the 'selenium' object itself, so 'this' will refer to the Selenium object.
        Use 'window' to refer to the window of your application, e.g. 'window.document.getElementById('foo')'
        
        If you need to use a locator to refer to a single element in your application page, you can use 'this.browserbot.findElement('id=foo')' where 'id=foo' is your locator." {
		return getString("getEval", [arguments.script]);
	}
	
	public boolean function isChecked(required string locator) hint="Gets whether a toggle-button (checkbox/radio) is checked.  Fails if the specified element doesn't exist or isn't a toggle-button." {
		return getBoolean("isChecked", [arguments.locator]);
	}

	public string function getTable(required string tableCellAddress) hint="Gets the text from a cell of a table. The cellAddress syntax tableLocator.row.column, where row and column start at 0." { 
		return getString("getTable", [arguments.tableCellAddress]);
	}
	
	public array function getSelectedLabels(required string selectLocator) hint="Gets all option labels (visible text) for selected options in the specified select or multi-select element." { 
		return getStringArray("getSelectedLabels", [arguments.selectLocator]);
	}
	
	public string function getSelectedLabel(required string selectLocator) hint="Gets option label (visible text) for selected option in the specified select element." { 
		return getString("getSelectedLabel", [arguments.selectLocator]);
	}
	
	public array function getSelectedValues(required string selectLocator) hint="Gets all option values (value attributes) for selected options in the specified select or multi-select element." { 
		return getStringArray("getSelectedValues", [arguments.selectLocator]);
	}
	
	public string function getSelectedValue(required string selectLocator) hint="Gets option value (value attribute) for selected option in the specified select element." { 
		return getString("getSelectedValue", [arguments.selectLocator]);
	}
	
	public array function getSelectedIndexes(required string selectLocator) hint="Gets all option indexes (option number, starting at 0) for selected options in the specified select or multi-select element." { 
		return getStringArray("getSelectedIndexes", [arguments.selectLocator]);
	}
	
	public string function getSelectedIndex(required string selectLocator) hint="Gets option index (option number, starting at 0) for selected option in the specified select element." { 
		return getString("getSelectedIndex", [arguments.selectLocator]);
	}
	
	public array function getSelectedIds(required string selectLocator) hint="Gets all option element IDs for selected options in the specified select or multi-select element." { 
		return getStringArray("getSelectedIds", [arguments.selectLocator]);
	}
	
	public string function getSelectedId(required string selectLocator) hint="Gets option element ID for selected option in the specified select element." { 
		return getString("getSelectedId", [arguments.selectLocator]);
	}
	
	public boolean function isSomethingSelected(required string selectLocator) hint="Determines whether some option in a drop-down menu is selected." {
		return getBoolean("isSomethingSelected", [arguments.selectLocator]);
	}

	public array function getSelectOptions(required string selectLocator) hint="Gets all option labels in the specified select drop-down." { 
		return getStringArray("getSelectOptions", [arguments.selectLocator]);
	}
	
	public string function getAttribute(required string attributeLocator) hint="Gets the value of an element attribute. The value of the attribute may differ across browsers (this is the case for the 'style' attribute, for example)." { 
		return getString("getAttribute", [arguments.attributeLocator]);
	}
	
	public boolean function isTextPresent(required string pattern) hint="Verifies that the specified text pattern appears somewhere on the rendered page shown to the user." {
		return getBoolean("isTextPresent", [arguments.pattern]);
	}

	public boolean function isElementPresent(required string locator) hint="Verifies that the specified element is somewhere on the page." {
		return getBoolean("isElementPresent", [arguments.locator]);
	}

	public boolean function isVisible(required string locator) 
		hint="Determines if the specified element is visible.
		An element can be rendered invisible by setting the CSS 'visibility' property to 'hidden', or the 'display' property to 'none', either for the element itself or one if its ancestors.
		This method will fail if the element is not present." {
		return getBoolean("isVisible", [arguments.locator]);
	}

	public boolean function isEditable(required string locator) hint="Determines whether the specified input element is editable, ie hasn't been disabled. This method will fail if the specified element isn't an input element." {
		return getBoolean("isEditable", [arguments.locator]);
	}

	public array function getAllButtons() hint="Returns the IDs of all buttons on the page." { 
		return getStringArray("getAllButtons");
	}
	
	public array function getAllLinks() hint="Returns the IDs of all links on the page." {
		return getStringArray("getAllLinks");
	}
	
	public array function getAllFields() hint="Returns the IDs of all input fields on the page." {
		return getStringArray("getAllFields");
	}
	
	public array function getAttributeFromAllWindows(required string attributeName) hint="Returns every instance of some attribute from all known windows." { 
		return getStringArray("getAttributeFromAllWindows", [arguments.attributeName]);
	}
	
	public void function dragdrop(required string locator, required string movementsString) hint="deprecated - use dragAndDrop instead." {
		doCommand("dragdrop",[arguments.locator, arguments.movementsString]);
	}

	public void function setMouseSpeed(required numeric pixels) 
		hint="Configure the number of pixels between 'mousemove' events during dragAndDrop commands (default=10).
        
        Setting this value to 0 means that we'll send a 'mousemove' event to every single pixel in between the start location and the end location;
        that can be very slow, and may cause some browsers to force the JavaScript to timeout.
        
        If the mouse speed is greater than the distance between the two dragged objects, we'll just send one 'mousemove' at the start location and then one final one at the end location." {
		doCommand("setMouseSpeed",[arguments.pixels]);
	}

	public numeric function getMouseSpeed() hint="Returns the number of pixels between 'mousemove' events during dragAndDrop commands (default=10)." { 
		return getNumber("getMouseSpeed");
	}
	
	public void function dragAndDrop(required string locator, required string movementsString) hint="Drags an element a certain distance and then drops it." {
		doCommand("dragAndDrop",[arguments.locator, arguments.movementsString]);
	}

	public void function dragAndDropToObject(required string locatorOfObjectToBeDragged, required string locatorOfDragDestinationObject) hint="Drags an element and drops it on another element." {
		doCommand("dragAndDropToObject",[arguments.locatorOfObjectToBeDragged, arguments.locatorOfDragDestinationObject]);
	}

	public void function windowFocus() hint="Gives focus to the currently selected window." {
		doCommand("windowFocus");
	}

	public void function windowMaximize() hint="Resize currently selected window to take up the entire screen." {
		doCommand("windowMaximize");
	}

	public array function getAllWindowIds() hint="Returns the IDs of all windows that the browser knows about." {
		return getStringArray("getAllWindowIds");
	}
	
	public array function getAllWindowNames() hint="Returns the names of all windows that the browser knows about." {
		return getStringArray("getAllWindowNames");
	}
	
	public array function getAllWindowTitles() hint="Returns the titles of all windows that the browser knows about." {
		return getStringArray("getAllWindowTitles");
	}
	
	public string function getHtmlSource() hint="Returns the entire HTML source between the opening and closing 'html' tags." {
		return getString("getHtmlSource");
	}
	
	public void function setCursorPosition(required string locator, required string position) hint="Moves the text cursor to the specified position in the given input element or textarea. This method will fail if the specified element isn't an input element or textarea." {
		doCommand("setCursorPosition",[arguments.locator, arguments.position]);
	}

	public numeric function getElementIndex(required string locator) hint="Get the relative index of an element to its parent (starting from 0). The comment node and empty text node will be ignored." { 
		return getNumber("getElementIndex", [arguments.locator]);
	}
	
	public boolean function isOrdered(required string locator1, required string locator2) hint="Check if these two elements have same parent and are ordered siblings in the DOM. Two same elements will not be considered ordered." {
		return getBoolean("isOrdered",[arguments.locator1, arguments.locator2]);
	}

	public numeric function getElementPositionLeft(required string locator) hint="Retrieves the horizontal position of an element." { 
		return getNumber("getElementPositionLeft", [arguments.locator]);
	}
	
	public numeric function getElementPositionTop(required string locator) hint="Retrieves the vertical position of an element." { 
		return getNumber("getElementPositionTop", [arguments.locator]);
	}
	
	public numeric function getElementWidth(required string locator) hint="Retrieves the width of an element." { 
		return getNumber("getElementWidth", [arguments.locator]);
	}
	
	public numeric function getElementHeight(required string locator) hint="Retrieves the height of an element." { 
		return getNumber("getElementHeight", [arguments.locator]);
	}
	
	public numeric function getCursorPosition(required string locator) 
		hint="Retrieves the text cursor position in the given input element or textarea; beware, this may not work perfectly on all browsers.
        
        Specifically, if the cursor/selection has been cleared by JavaScript, this command will tend to return the position of the last location of the cursor, even though the cursor is now gone from the page.  This is filed as SEL-243.
        
        This method will fail if the specified element isn't an input element or textarea, or there is no cursor in the element." { 
		return getNumber("getCursorPosition", [arguments.locator]);
	}
	
	public string function getExpression(required string expression) 
		hint="Returns the specified expression.
        This is useful because of JavaScript preprocessing. It is used to generate commands like assertExpression and waitForExpression." { 
		return getString("getExpression", [arguments.expression]);
	}
	
	public numeric function getXpathCount(required string xpath) 
		hint="Returns the number of nodes that match the specified xpath, eg. '//table' would give the number of tables." { 
		return getNumber("getXpathCount", [arguments.xpath]);
	}
	
	public numeric function getCssCount(required string css) 
		hint="Returns the number of nodes that match the specified css selector, eg. 'css=table' would give the number of tables." { 
		return getNumber("getCssCount", [arguments.css]);
	}
	
	public void function assignId(required string locator, required string identifier) 
		hint="Temporarily sets the 'id' attribute of the specified element, so you can locate it in the future using its ID rather than a slow/complicated XPath.
		This ID will disappear once the page is reloaded." {
		doCommand("assignId",[arguments.locator, arguments.identifier]);
	}

	public void function allowNativeXpath(required boolean allow) 
		hint="Specifies whether Selenium should use the native in-browser implementation of XPath (if any native version is available);
		if you pass 'false' to this function, we will always use our pure-JavaScript xpath library.
        Using the pure-JS xpath library can improve the consistency of xpath element locators between different browser vendors, but the pure-JS version is much slower than the native implementations." {
		doCommand("allowNativeXpath",[arguments.allow]);
	}

	public void function ignoreAttributesWithoutValue(required boolean ignore) 
		hint="Specifies whether Selenium will ignore xpath attributes that have no value, i.e. are the empty string, when using the non-native xpath evaluation engine.
		You'd want to do this for performance reasons in IE.
        However, this could break certain xpaths, for example an xpath that looks for an attribute whose value is NOT the empty string.
        
        The hope is that such xpaths are relatively rare, but the user should have the option of using them.
        Note that this only influences xpath evaluation when using the ajaxslt engine (i.e. not 'javascript-xpath')." {
		doCommand("ignoreAttributesWithoutValue",[arguments.ignore]);
	}

	public void function waitForCondition(required string script, required string timeout) 
		hint=" Runs the specified JavaScript snippet repeatedly until it evaluates to 'true'.
        The snippet may have multiple lines, but only the result of the last line will be considered.
        
        Note that, by default, the snippet will be run in the runner's test window, not in the window of your application.
        To get the window of your application, you can use the JavaScript snippet 'selenium.browserbot.getCurrentWindow()', and then run your JavaScript in there" {
		doCommand("waitForCondition",[arguments.script, arguments.timeout]);
	}

	public void function setTimeout(required numeric timeout) 
		hint="Specifies the amount of time that Selenium will wait for actions to complete.
        Actions that require waiting include 'open' and the 'waitFor\*' actions.
        The default timeout is 30 seconds." {
		doCommand("setTimeout",[arguments.timeout]);
	}

	public void function waitForPageToLoad(required numeric timeout) 
		hint="Waits for a new page to load.
        
        You can use this command instead of the 'AndWait' suffixes, 'clickAndWait', 'selectAndWait', 'typeAndWait' etc. (which are only available in the JS API).
        
        Selenium constantly keeps track of new pages loading, and sets a 'newPageLoaded' flag when it first notices a page load.
        Running any other Selenium command after turns the flag to false.  Hence, if you want to wait for a page to load, you must wait immediately after a Selenium command that caused a page-load." {
		doCommand("waitForPageToLoad",[arguments.timeout]);
	}

	public void function waitForFrameToLoad(required string frameAddress, required numeric timeout) 
		hint=" Waits for a new frame to load.
        Selenium constantly keeps track of new pages and frames loading, and sets a 'newPageLoaded' flag when it first notices a page load.
        See waitForPageToLoad for more information." {
		doCommand("waitForFrameToLoad",[arguments.frameAddress, arguments.timeout]);
	}

	public string function getCookie() hint="Return all cookies of the current page under test." {
		return getString("getCookie");
	}
	
	public string function getCookieByName(required string name) hint="Returns the value of the cookie with the specified name, or throws an error if the cookie is not present." {
		return getString("getCookieByName", [arguments.name]);
	}

	public boolean function isCookiePresent(required string name) hint="Returns true if a cookie with the specified name is present, or false otherwise." {
		return getBoolean("isCookiePresent", [arguments.name]);
	}

	public void function createCookie(required string nameValuePair, required string optionsString) 
		hint="Create a new cookie whose path and domain are same with those of current page under test, unless you specified a path for this cookie explicitly." {
		doCommand("createCookie",[arguments.nameValuePair, arguments.optionsString]);
	}

	public void function deleteCookie(required string name, required string optionsString) 
		hint="Delete a named cookie with specified path and domain.  
		Be careful; to delete a cookie, you need to delete it using the exact same path and domain that were used to create the cookie.
        If the path is wrong, or the domain is wrong, the cookie simply won't be deleted.  
        Also note that specifying a domain that isn't a subset of the current domain will usually fail.
        
        Since there's no way to discover at runtime the original path and domain of a given cookie, we've added an option called 'recurse' to try all sub-domains of the current domain with
        all paths that are a subset of the current path.
        Beware; this option can be slow.  In big-O notation, it operates in O(n\*m) time, where n is the number of dots in the domain name and m is the number of slashes in the path." {
		doCommand("deleteCookie",[arguments.name, arguments.optionsString]);
	}

	public void function deleteAllVisibleCookies() 
		hint="Calls deleteCookie with recurse=true on all cookies visible to the current page.
        As noted on the documentation for deleteCookie, recurse=true can be much slower than simply deleting the cookies using a known domain/path." {
		doCommand("deleteAllVisibleCookies");
	}
	
	public void function setBrowserLogLevel(required string logLevel) 
		hint="Sets the threshold for browser-side logging messages; log messages beneath this threshold will be discarded.
        Valid logLevel strings are: 'debug', 'info', 'warn', 'error' or 'off'.
        To see the browser logs, you need to either show the log window in GUI mode, or enable browser-side logging in Selenium RC." {
		doCommand("setBrowserLogLevel",[arguments.logLevel]);
	}

	public void function runScript(required string script) 
		hint="Creates a new 'script' tag in the body of the current test window, and adds the specified text into the body of the command.
		Scripts run in this way can often be debugged more easily than scripts executed using Selenium's 'getEval' command.
		Beware that JS exceptions thrown in these script tags aren't managed by Selenium, so you should probably wrap your script in try/catch blocks if there is any chance that the script will throw an exception." {
		doCommand("runScript",[arguments.script]);
	}

	public void function addLocationStrategy(required string strategyName, required string functionDefinition) 
		hint="Defines a new function for Selenium to locate elements on the page.
        For example, if you define the strategy 'foo', and someone runs click('foo=blah'), we'll run your function, passing you the string 'blah', 
		and click on the element that your function returns, or throw an 'Element not found' error if your function returns null.
        
        We'll pass three arguments to your function:
        
        *   locator: the string the user passed in
        *   inWindow: the currently selected window
        *   inDocument: the currently selected document
        
        The function must return null if the element can't be found." {
		doCommand("addLocationStrategy",[arguments.strategyName, arguments.functionDefinition]);
	}

	public void function captureEntirePageScreenshot(required string filename, required string kwargs) 
		hint="Saves the entire contents of the current window canvas to a PNG file.
        Contrast this with the captureScreenshot command, which captures the contents of the OS viewport (i.e. whatever is currently being displayed on the monitor), and is implemented in the RC only.
        Currently this only works in Firefox when running in chrome mode, and in IE non-HTA using the EXPERIMENTAL 'Snapsie' utility.
        The Firefox implementation is mostly borrowed from the Screengrab! Firefox extension. 
        Please see http://www.screengrab.org and http://snapsie.sourceforge.net/ for details." {
		doCommand("captureEntirePageScreenshot",[arguments.filename, arguments.kwargs]);
	}

	public void function rollup(required string rollupName, required string kwargs) 
		hint="Executes a command rollup, which is a series of commands with a unique name, and optionally arguments that control the generation of the set of commands.
		If any one of the rolled-up commands fails, the rollup is considered to have failed. Rollups may also contain nested rollups." {
		doCommand("rollup",[arguments.rollupName, arguments.kwargs]);
	}

	public void function addScript(required string scriptContent, required string scriptTagId) 
		hint="Loads script content into a new script tag in the Selenium document.
		This differs from the runScript command in that runScript adds the script tag to the document of the AUT, not the Selenium document.
		The following entities in the script content are replaced by the characters they represent:
        
            &lt;
            &gt;
            &amp;
        
        The corresponding remove command is removeScript." {
		doCommand("addScript",[arguments.scriptContent, arguments.scriptTagId]);
	}

	public void function removeScript(required string scriptTagId) 
		hint="Loads script content into a new script tag in the Selenium document.
		This differs from the runScript command in that runScript adds the script tag to the document of the AUT, not the Selenium document.
		The following entities in the script content are replaced by the characters they represent:
        
            &lt;
            &gt;
            &amp;
        
        The corresponding remove command is removeScript." {
		doCommand("removeScript",[arguments.scriptTagId]);
	}

	public void function useXpathLibrary(required string libraryName) 
		hint="Allows choice of one of the available libraries.
        
        'libraryName' is name of the desired library Only the following three can be chosen: 
        *   'ajaxslt' - Google's library
        *   'javascript-xpath' - Cybozu Labs' faster library
        *   'default' - The default library.  Currently the default library is 'ajaxslt' .
        
         If libraryName isn't one of these three, then  no change will be made." {
		doCommand("useXpathLibrary",[arguments.libraryName]);
	}

	public void function setContext(required string context) hint="Writes a message to the status bar and adds a note to the browser-side log." {
		doCommand("setContext",[arguments.context]);
	}

	public void function attachFile(required string fieldLocator, required string fileLocator) hint="Sets a file input (upload) field to the file listed in fileLocator" {
		doCommand("attachFile",[arguments.fieldLocator, arguments.fileLocator]);
	}

	public void function captureScreenshot(required string filename) hint="Captures a PNG screenshot to the specified file." {
		doCommand("captureScreenshot",[arguments.filename]);
	}

	public string function captureScreenshotToString() hint="Capture a PNG screenshot.  It then returns the file as a base 64 encoded string." {
		return getString("captureScreenshotToString");
	}

	public string function captureNetworkTraffic(required string type) hint="Returns the network traffic seen by the browser, including headers, AJAX requests, status codes, and timings. When this function is called, the traffic log is cleared, so the returned content is only the traffic seen since the last call." {
		return getString("captureNetworkTraffic",[arguments.type]);
	}

	public void function addCustomRequestHeader(required string key, required string value) hint="Tells the Selenium server to add the specificed key and value as a custom outgoing request header. This only works if the browser is configured to use the built in Selenium proxy." {
		doCommand("addCustomRequestHeader",[arguments.key, arguments.value]);
	}

	public string function captureEntirePageScreenshotToString(required string kwargs) 
		hint="Downloads a screenshot of the browser current window canvas to a based 64 encoded PNG file. 
		The \ *entire* windows canvas is captured, including parts rendered outside of the current view port.
        
        Currently this only works in Mozilla and when running in chrome mode." {
		return getString("captureEntirePageScreenshotToString",[arguments.kwargs]);
	}

	public void function shutDownSeleniumServer() 
		hint="Kills the running Selenium Server and all browser sessions.
		After you run this command, you will no longer be able to send commands to the server; you can't remotely start the server once it has been stopped.
		Normally you should prefer to run the 'stop' command, which terminates the current browser session, rather than shutting down the entire server." {
		doCommand("shutDownSeleniumServer");
	}

	public string function retrieveLastRemoteControlLogs() 
		hint="Retrieve the last messages logged on a specific remote control.
		Useful for error reports, especially when running multiple remote controls in a distributed environment.
		The maximum number of log messages that can be retrieve is configured on remote control startup." {
		return getString("retrieveLastRemoteControlLogs");
	}


	public void function keyDownNative(required string keycode) 
		hint="Simulates a user pressing a key (without releasing it yet) by sending a native operating system keystroke.
        This function uses the java.awt.Robot class to send a keystroke; this more accurately simulates typing a key on the keyboard.
        It does not honor settings from the shiftKeyDown, controlKeyDown, altKeyDown and metaKeyDown commands, and does not target any particular HTML element.
        To send a keystroke to a particular element, focus on the element first before running this command." {
		doCommand("keyDownNative",[arguments.keycode]);
	}

	public void function keyUpNative(required string keycode) 
		hint="Simulates a user releasing a key by sending a native operating system keystroke.
        This function uses the java.awt.Robot class to send a keystroke; this more accurately simulates typing a key on the keyboard.
        It does not honor settings from the shiftKeyDown, controlKeyDown, altKeyDown and metaKeyDown commands, and does not target any particular HTML element.
        To send a keystroke to a particular element, focus on the element first before running this command." {
		doCommand("keyUpNative",[arguments.keycode]);
	}

	public void function keyPressNative(required string keycode) 
		hint="Simulates a user pressing and releasing a key by sending a native operating system keystroke.
        This function uses the java.awt.Robot class to send a keystroke; this more accurately simulates typing a key on the keyboard.
        It does not honor settings from the shiftKeyDown, controlKeyDown, altKeyDown and metaKeyDown commands, and does not target any particular HTML element.
        To send a keystroke to a particular element, focus on the element first before running this command." {
		doCommand("keyPressNative",[arguments.keycode]);
	}

}
	
