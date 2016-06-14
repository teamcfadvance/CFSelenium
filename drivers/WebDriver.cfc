/**

  WebDriver
  @author bill
  @modifiedBy garch
  @description ColdFusion wrapper for webdriver (http://code.google.com/p/webdriver)
  
  @todo: lots - subclass driver types

*/

component displayname="WebDriver" output="true"
	accessors=true
{
	property name="driver" type="any";
	property name="webElement" type="any";

	variables.javaFactory = new JavaFactory();
	variables.javaSystem = createObject("java", "java.lang.System");
	variables.defaultLocalDriverRepoPath = 
		javaSystem.getProperty("java.io.tmpdir")
		& "webdriver/";
	
	public WebDriver function init(
		any driver=variables.JavaFactory.createObject("org.openqa.selenium.WebDriver")
	) {
		// this is the java selenium driver, not the CFC driver
		setDriver( driver );
		setWebElement("");
		
		return this;
	}

	public void function get( required string url ) {
		variables.driver.get( arguments.url );
	}  

	public void function close() {
		variables.driver.close();
	}

	public void function quit() {
		variables.driver.quit();
	}

	public any function executeScript() {
		throwNotImplementedException("executeScript");
	} //java.lang.String, java.lang.Object[] :: java.lang.Object 

	public WebElement function findElement( required any by ) {
		local.webElement = new WebElement();

		try {
			local.webElement.setWebElement( variables.driver.findElement( arguments.by ) );
			// error is thrown if element is not found, so set "found"
			local.webElement.setFoundWebElement( true );
		} catch( any error ) {
			// "not found" error, so set not found
			if ( error.type == "org.openqa.selenium.NoSuchElementException" ) {
				local.webElement.setFoundWebElement( false );
			// else we have some other error so rethrow it
			} else {
				rethrow;
			}
		}
		
		return local.webElement;
	}

	public WebElement function findElementByLinkText( required string text ) {
		local.webElement = new WebElement();
		
		try {
			local.webElement.setWebElement( variables.driver.findElementByLinkText( arguments.text ) );
			// error is thrown if element is not found, so set "found"
			local.webElement.setFoundWebElement( true );
		} catch( any error ) {
			// "not found" error, so set not found
			if ( error.type == "org.openqa.selenium.NoSuchElementException" ) {
				local.webElement.setFoundWebElement( false );
			// else we have some other error so rethrow it
			} else {
				rethrow;
			}
		}
		
		return local.webElement;
	}

	public string function getTitle() {
		return variables.driver.getTitle();
	}

	public string function getPageSource() {
		return variables.driver.getPageSource();
	}
	
	public string function getCurrentUrl() {
		return variables.driver.getCurrentUrl();
	}

	public WebElement function findElementByName( required string name, any by=getBy() ) {
		return findElement( by.name(name) );
	}

	public WebElement function findElementById( required string id, any by=getBy() ) {
		return findElement( by.id(id) );
	}

	public WebElement function findElementByXPath( required string xpath, any by=getBy() ) {
		return findElement( arguments.by.xPath( arguments.xpath ) );
	} 

	public WebElement[] function findElements( required any by ) {
		// returns an array of Java web elements
		try {
			local.elements = variables.driver.findElements( arguments.by );
		} catch( any error ) {
			// "not found" error, so return empty array
			if ( error.type == "org.openqa.selenium.NoSuchElementException" ) {
				return [];
			// else we have some other error so rethrow it
			} else {
				rethrow;
			}
		}
		
		// if at this point, must have an array of web elements
		local.arrReturn = [];
		for ( local.javaWebElement in local.elements ) {
			local.webElement = new WebElement();
			local.webElement.setWebElement( local.javaWebElement );
			local.webElement.setFoundWebElement( true );
			arrayAppend( local.arrReturn, local.webElement );
		}

		return local.arrReturn;
	}
	
	private WebElement function findElementByAttributeValue( required string attribute, required string value, required array webElements ) {
		for ( local.webElement in arguments.webElements ) {
			// if the attribute exists and the value is the same, then "matched"
			if ( !isNull( local.webElement.getAttribute( arguments.attribute ) ) && ( local.webElement.getAttribute( arguments.attribute ) == arguments.value ) ) {
				return local.webElement;
			}
		}
		
		return new WebElement();
	}
	
	// helper method when trying to find a specific element but has the same names and different values such as radio buttons
	public webElement function findElementByNameAndValue( required string name, required string value, any by=getBy() ) {
		local.elements = findElements( arguments.by.name( arguments.name ) );
		
		return findElementByAttributeValue( "value", arguments.value, local.elements );
	}

	public WebElement[] function findElementsByName( required string name, any by=getBy() ) {
		local.elements = [];
		local.webElements = findElements( arguments.by.name( arguments.name ) );
		for( local.i = 1; local.i <= arrayLen( webElements ); local.i++ ){
			arrayAppend( local.elements, createObject( "component", "WebElement" ).init( local.webElements[ local.i ] ) );
		}
		return local.elements;
	}

	public WebElement[] function findElementsByXPath( required string xpath ) {
		local.elements = [];
		local.webElements = variables.driver.findElements( variables.by.xPath( arguments.xpath ) );
		for( local.i = 1; local.i <= arrayLen( webElements ); local.i++ ){
			arrayAppend( local.elements, createObject( "component", "WebElement" ).init( local.webElements[ local.i ] ) );
		}
		return local.elements;
	}
	
	public WebElement[] function findElementsByClass( required string class, any by=getBy() ) {
		return findElements( by.className(class) );
	}

	public boolean function getVisible() {
		return variables.driver.getVisible();
	}

	public void function setVisible( required boolean visible ) {
		variables.driver.setVisible( javacast("boolean",visible) );
	}

	// TODO - need to revisit this one
	public any function navigate( location ){
	//throwNotImplementedException("navigate ... not sure best how to implement this");	
		variables.driver.get(location);
	} //org.openqa.selenium.WebDriver$Navigation 

	// TODO - revisit this - Not tested.
	public void function setProxy( required string proxyUrl, required string port ) {
		variables.driver.setProxy( arguments.proxyUrl, arguments.port );
	} 

	// TODO - revisit, may need a return, not a void
	//authenticateAs(String username, String password, String host, int port, String clientHost, String domain) 
	public void function authenticateAs( required string username, required string password,
							required string host, required string port, required string clientHost, required string domain ) {
		variables.driver.authenticateAs( arguments.username, arguments.password, arguments.host, arguments.port, arguments.clientHost, arguments.domain );
	}

	// TODO - need to look into return value
	public any function switchTo() {
		return variables.driver.switchTo();
	} //org.openqa.selenium.WebDriver$TargetLocator 


	// TODO - revisit - has a return value not implemented
	public void function manage(){
		throwNotImplementedException("manage");
	} //org.openqa.selenium.WebDriver$Options 

	private void function throwNotImplementedException( required string methodName ) {
		throw (
			message="The method you called has not yet been implemented",
			type="org.mxunit.exception.NotImplementedException",
			detail="Method name: " & arguments.methodName );
	}

	private void function throwException( required string type, required string message, required string detail ) {
		throw (
			message=arguments.message,
			type=arguments.type,
			detail=arguments.detail );
	}
	
	private function getBy() {
		return variables.JavaFactory.createObject("org.openqa.selenium.By");
	}
	
	private void function setupDefaultPropertiesForAllDrivers() {
		if (!structKeyExists(application, "cfselenium")) {
			application.cfselenium = {};
		}
		/* This is cached in application scope, because (i think) we sometimes 
		* run into api.github.com rate limiting errors while checking for latest
		* drivers and downloading them. I think it's best to do it only once.
		*/
		if (!structKeyExists(
			application.cfselenium,
			"webDriverManagerDefaultPropertiesAreSetup"
		)) {
			/* I don't know why I have to jump through these hoops. I landed on this
			* solution by trial and error.
			* Overview: Library sets up some properties, but seemingly, only
			* in its classloader. This "exports" those "wdm.*" keys into the
			* CFML engine's JVM.
			*/
			// get an arbitrary object from the wdm library
			var webDriverManager = javaFactory.createObject("io.github.bonigarcia.wdm.WebDriverManager");
			// get its classloader
			var classLoader = webDriverManager.getClass().getClassLoader();
			// get a properties object from the classloader
			var props = classLoader.loadClass("java.util.Properties").newInstance();
			
			// get the application.properties file from the jar
			var propsFileStream = webDriverManager.getClass().getResourceAsStream("/application.properties");
			// load the properties into the jar's classloader's props
			props.load(propsFileStream);
			
			// get cfml engine's java system
			var system = createObject("java", "java.lang.System");
			// load jar's classloader's props into cfml engine's'
			for (prop in props) {
				if (isNull(system.getProperty(prop))) { // don't clobber
					system.setProperty(prop, props[prop]);
				}
			}
			
			application.cfselenium.webDriverManagerDefaultPropertiesAreSetup = true;
			
		}
	}

	private void function setupDriver(
		required string driverName,
		string localDriverRepoPath = variables.defaultLocalDriverRepoPath
	) {
		variables.javaSystem.setProperty("wdm.targetPath", localDriverRepoPath);
		setupDefaultPropertiesForAllDrivers();

		if (!structKeyExists(application, "cfselenium")) {
			application.cfselenium = {};
		}
		if (!structKeyExists(application.cfselenium, "drivers")) {
			application.cfselenium.drivers = {};
		}
		if (!structKeyExists(application.cfselenium.drivers, driverName)) {
			application.cfselenium.drivers[driverName] = {};
		}
		if (!structKeyExists(application.cfselenium.drivers[driverName], "isSetup")) {
			/* This downloads drivers and sets the JVM properties that WebDriver
			* and WebDriverManager need.
			*/
			javaFactory.createObject(
				"io.github.bonigarcia.wdm.#driverName#DriverManager"
			).getInstance().setup();
			
			application.cfselenium.drivers[driverName]["isSetup"] = true;
		}
			
	}

}