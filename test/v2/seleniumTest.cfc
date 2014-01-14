component  extends="mxunit.framework.TestCase" hint="Test Selenium Object" output="false" {

	public void function beforeTests() {
		variables.selenium = new cfselenium.selenium();
	}
	
	public function setup() {
	}
	
	public function defaultDriverIsWebDriverTest() {
		assertIsTypeOf( variables.selenium.getDriver(), "cfselenium.drivers.WebDriver" );
	}
	
	public function isIEDriverTest() {
		variables.selenium.setDriverByType( "ie" );
		assertIsTypeOf( variables.selenium.getDriver(), "cfselenium.drivers.InternetExplorerDriver" );
		variables.selenium.getDriver().quit();
	}
	
	public function isIEDriverOnInitTest() {
		variables.selenium = new selenium( driverType="ie" );
		assertIsTypeOf( variables.selenium.getDriver(), "cfselenium.drivers.InternetExplorerDriver" );
		variables.selenium.getDriver().quit();
	}
	
	public function isFirefoxDriverTest() {
		variables.selenium.setDriverByType( "firefox" );
		assertIsTypeOf( variables.selenium.getDriver(), "cfselenium.drivers.FirefoxDriver" );
		variables.selenium.getDriver().quit();
	}
	
	public function isFirefoxDriverOnInitTest() {
		variables.selenium = new selenium( driverType="firefox" );
		assertIsTypeOf( variables.selenium.getDriver(), "cfselenium.drivers.FirefoxDriver" );
		variables.selenium.getDriver().quit();
	}
	
	public function switchDriverTest() {
		variables.selenium.setDriverByType( "ie" );
		assertIsTypeOf( variables.selenium.getDriver(), "cfselenium.drivers.InternetExplorerDriver" );
		// close IEDriverServer
		variables.selenium.getDriver().quit();
		variables.selenium.setDriverByType( "firefox" );
		assertIsTypeOf( selenium.getDriver(), "cfselenium.drivers.FirefoxDriver" );
		variables.selenium.getDriver().quit();
	}
	
	public function tearDown() {
		// this will try to close anything extraneous from the IEDriverServer
		try {
			variables.selenium.getDriver().close();
		} catch( any error ) {
			// don't do anything
		}
		try {
			variables.selenium.getDriver().quit();
		} catch( any error ) {
			// don't do anything
		}
	}
	
	public void function afterTests() {
		structDelete( variables, "selenium" );
	}

}