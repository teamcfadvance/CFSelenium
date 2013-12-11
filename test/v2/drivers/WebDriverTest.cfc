component  extends="mxunit.framework.TestCase" hint="Test the WebDriver" output="false" {

	public void function beforeTests() {
		include "../functions.cfm";
		variables.selenium = new selenium();
	}
	
	public function setup() {
		// reset driver
		variables.selenium.setDriverByType();
		variables.driver = selenium.getDriver();
	}
	
	public function testIEGet() {
		// set ie driver
		variables.driver = updateDriverByType( variables.selenium, "ie" );

		local.url = "http://rmdev.kforce.com/";
		variables.driver.get( local.url );
		assertEquals( local.url, variables.driver.getCurrentURL() );
		variables.driver.close();
		variables.driver.quit();
	}
	
	public function testIEClose() {
		// set ie driver
		variables.driver = updateDriverByType( variables.selenium, "ie" );

		local.url = "http://rmdev.kforce.com/";
		variables.driver.get( local.url );
		variables.driver.close();
		// now try opening a page to make sure "browser" has actually closed
		try {
			variables.driver.getTitle();
		} catch( any error ) {
			local.noSession = structKeyExists( error, "Type" ) && ( error.Type == "org.openqa.selenium.remote.SessionNotFoundException" );
			assertTrue( noSession, "session still exists - IE has not quit" );
			variables.driver.quit();
		}
	}
	
	public function testFirefoxGet() {
		// set firefox driver
		variables.driver = updateDriverByType( variables.selenium, "firefox" );

		local.url = "http://rmdev.kforce.com/";
		variables.driver.get( local.url );
		assertEquals( local.url, variables.driver.getCurrentURL() );
		variables.driver.quit();
	}
	
	public function testFirefoxClose() {
		variables.driver = updateDriverByType( variables.selenium, "firefox" );

		local.url = "http://rmdev.kforce.com/";
		variables.driver.get( local.url );
		variables.driver.close();
		// now try opening a page to make sure "browser" has actually closed
		try {
			variables.driver.getTitle();
		} catch( any error ) {
			local.noSession = structKeyExists( error, "Type" ) && ( error.Type == "org.openqa.selenium.remote.SessionNotFoundException" );
			assertTrue( noSession, "session still exists - firefox has not quit" );
			variables.driver.quit();
		}
	}
	
	public function findElementByIdTest() {
		variables.driver = updateDriverByType( variables.selenium, "ie" );
		
		local.url = "http://rmdev.kforce.com/";
		variables.driver.get( local.url );

		local.webElement = variables.driver.findElementById( "Agreement" );

		local.expected = 'div';
		local.actual = local.webElement.getTagName();

		assertEquals( local.expected, local.actual );
	}
	
	public function missingElementByIdTest() {
		variables.driver = updateDriverByType( variables.selenium, "ie" );
		
		local.url = "http://rmdev.kforce.com/";
		variables.driver.get( local.url );

		// search for bad ID
		local.webElement = variables.driver.findElementById( "badId" );

		local.expected = false;
		local.actual = local.webElement.foundWebElement();

		assertEquals( local.expected, local.actual );
	}
	
	public function findElementByNameTest() {
		variables.driver = updateDriverByType( variables.selenium, "ie" );
		
		local.url = "http://rmdev.kforce.com/";
		variables.driver.get( local.url );

		local.webElement = variables.driver.findElementByName( "chkYesNo" );

		local.expected = 'input';
		local.actual = local.webElement.getTagName();

		assertEquals( local.expected, local.actual );
	}
	
	public function missingElementByNameTest() {
		variables.driver = updateDriverByType( variables.selenium, "ie" );
		
		local.url = "http://rmdev.kforce.com/";
		variables.driver.get( local.url );

		// search for bad name
		local.webElement = variables.driver.findElementByName( "badName" );

		local.expected = false;
		local.actual = local.webElement.foundWebElement();

		assertEquals( local.expected, local.actual );
	}
	
	public function findMultipleElementsByNameTest() {
		variables.driver = updateDriverByType( variables.selenium, "ie" );
		
		local.url = "http://rmdev.kforce.com/";
		variables.driver.get( local.url );

		local.webElements = variables.driver.findElementsByName( "chkYesNo" );

		local.expected = true;
		local.actual = arrayLen( local.webElements ) > 1;

		assertEquals( local.expected, local.actual );
	}

	public function missingElementsFindMultipleElementsByNameTest() {
		variables.driver = updateDriverByType( variables.selenium, "ie" );
		
		local.url = "http://rmdev.kforce.com/";
		variables.driver.get( local.url );

		local.webElements = variables.driver.findElementsByName( "badName" );

		local.expected = true;
		local.actual = arrayLen( local.webElements ) == 0;

		assertEquals( local.expected, local.actual );
	}
	
	public function findElementByNameAndValueTest() {
		variables.driver = updateDriverByType( variables.selenium, "ie" );
		
		local.url = "http://rmdev.kforce.com/";
		variables.driver.get( local.url );

		local.webElements = variables.driver.findElementByNameAndValue( "chkYesNo", 1 );

		local.expected = true;
		local.actual = local.webElements.foundWebElement();

		assertEquals( local.expected, local.actual );
	}

	public function missingFindElementByNameAndValueTest() {
		variables.driver = updateDriverByType( variables.selenium, "ie" );
		
		local.url = "http://rmdev.kforce.com/";
		variables.driver.get( local.url );

		local.webElements = variables.driver.findElementByNameAndValue( "chkYesNo", 2 );

		local.expected = false;
		local.actual = local.webElements.foundWebElement();

		assertEquals( local.expected, local.actual );
	}
	
	public function getTitleTest() {
		variables.driver = updateDriverByType( variables.selenium, "ie" );
		
		local.url = "http://rmdev.kforce.com/";
		variables.driver.get( local.url );

		local.expected = "Recruitmax ProStaff Web Edition";
		local.actual = variables.driver.getTitle();

		assertEquals( local.expected, local.actual );
	}
	
	// need a link to test this
	/*public function findElementByLinkTextText() {
		variables.driver = updateDriverByType( variables.selenium, "ie" );
		
		local.url = "http://rmdev.kforce.com/";
		variables.driver.get( local.url );

		local.webElement = variables.driver.findElementByLinkText( 'marketing@kforce.com' );

		assertTrue( local.webElement.foundWebElement(), 'link text not found' );
	}*/
	
	// need to add a class to main login page to test this
	/*public function findElementsByClassTest() {
		variables.driver = updateDriverByType( variables.selenium, "ie" );
		
		local.url = "http://rmdev.kforce.com/";
		variables.driver.get( local.url );

		local.expected = "Recruitmax ProStaff Web Edition";
		local.actual = variables.driver.findElementsByClass( 'test' );

		assertEquals( local.expected, local.actual );
	}*/

	public function tearDown() {
		try {
			variables.driver.close();
		} catch( any error ) {
			// don't do anything
		}
		try {
			variables.driver.quit();
		} catch( any error ) {
			// don't do anything
		}

		structDelete( variables, "driver" );
	}
	
	public void function afterTests() {
		structDelete( variables, "selenium" );
	}

}