﻿component  extends="mxunit.framework.TestCase" hint="Test the WebDriver" output="false" {

	public void function beforeTests() {
		include "../functions.cfm";
		variables.selenium = new cfselenium.selenium();
		variables.fixtureBaseUrl = "http://#cgi.server_name#:#cgi.server_port#/test/fixture";
	}
	
	public function setup() {
		// reset driver
		variables.selenium.setDriverByType();
		variables.driver = variables.selenium.getDriver();
	}
	
	public function IEGetTest() {
		// set ie driver
		variables.driver = updateDriverByType( variables.selenium, "ie" );

		local.url = "https://www.google.com/";
		variables.driver.get( local.url );
		assertEquals( local.url, variables.driver.getCurrentURL() );
		variables.driver.close();
		variables.driver.quit();
	}
	
	public function IECloseTest() {
		// set ie driver
		variables.driver = updateDriverByType( variables.selenium, "ie" );

		local.url = "http://www.google.com/";
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
	
	public function firefoxGetTest() {
		// set firefox driver
		variables.driver = updateDriverByType( variables.selenium, "firefox" );

		local.url = "#fixtureBaseUrl#/fixture.htm";
		variables.driver.get( local.url );
		assertEquals( local.url, variables.driver.getCurrentURL() );
		variables.driver.quit();
	}
	
	public function firefoxCloseTest() {
		variables.driver = updateDriverByType( variables.selenium, "firefox" );

		local.url = "#fixtureBaseUrl#/fixture.htm";
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
		variables.driver = updateDriverByType( variables.selenium, "firefox" );
		
		local.url = "#fixtureBaseUrl#/fixture.htm";
		variables.driver.get( local.url );

		local.webElement = variables.driver.findElementById( "fixture-body" );

		local.expected = 'body';
		local.actual = local.webElement.getTagName();

		assertEquals( local.expected, local.actual );
	}

	public function missingElementByIdTest() {
		variables.driver = updateDriverByType( variables.selenium, "firefox" );
		
		local.url = "#fixtureBaseUrl#/fixture.htm";
		variables.driver.get( local.url );

		// search for bad ID
		local.webElement = variables.driver.findElementById( "badId" );

		local.expected = false;
		local.actual = local.webElement.foundWebElement();

		assertEquals( local.expected, local.actual );
	}
	
	public function findElementByNameTest() {
		variables.driver = updateDriverByType( variables.selenium, "firefox" );
		
		local.url = "#fixtureBaseUrl#/fixture.htm";
		variables.driver.get( local.url );

		local.webElement = variables.driver.findElementByName( "q" );

		local.expected = 'input';
		local.actual = local.webElement.getTagName();

		assertEquals( local.expected, local.actual );
	}
	
	public function missingElementByNameTest() {
		variables.driver = updateDriverByType( variables.selenium, "firefox" );
		
		local.url = "http://www.google.com/";
		variables.driver.get( local.url );

		// search for bad name
		local.webElement = variables.driver.findElementByName( "badName" );

		local.expected = false;
		local.actual = local.webElement.foundWebElement();

		assertEquals( local.expected, local.actual );
	}
	
	public function findMultipleElementsByNameTest() {
		// this will only pass for sites with the same "name=" elements such as multiple checkboxes or radio buttons
		variables.driver = updateDriverByType( variables.selenium, "firefox" );
		
		local.url = "#fixtureBaseUrl#/fixture.htm";
		variables.driver.get( local.url );

		local.webElements = variables.driver.findElementsByName( "chkYesNo" );

		local.expected = true;
		local.actual = arrayLen( local.webElements ) > 1;

		assertEquals( local.expected, local.actual );
	}
	
	public function missingElementsFindMultipleElementsByNameTest() {
		variables.driver = updateDriverByType( variables.selenium, "firefox" );
		
		local.url = "#fixtureBaseUrl#/fixture.htm";
		variables.driver.get( local.url );

		local.webElements = variables.driver.findElementsByName( "badName" );

		local.expected = true;
		local.actual = arrayLen( local.webElements ) == 0;

		assertEquals( local.expected, local.actual );
	}
	
	public function findElementByNameAndValueTest() {
		variables.driver = updateDriverByType( variables.selenium, "firefox" );
		
		local.url = "#fixtureBaseUrl#/fixture.htm";
		variables.driver.get( local.url );

		local.webElements = variables.driver.findElementByNameAndValue( "output", "search" );

		local.expected = true;
		local.actual = local.webElements.foundWebElement();

		assertEquals( local.expected, local.actual );
	}

	public function missingFindElementByNameAndValueTest() {
		variables.driver = updateDriverByType( variables.selenium, "firefox" );
		
		local.url = "#fixtureBaseUrl#/fixture.htm";
		variables.driver.get( local.url );

		local.webElements = variables.driver.findElementByNameAndValue( "output", "notAValue" );

		local.expected = false;
		local.actual = local.webElements.foundWebElement();

		assertEquals( local.expected, local.actual );
	}
	
	public function getTitleTest() {
		variables.driver = updateDriverByType( variables.selenium, "firefox" );
		
		local.url = "#fixtureBaseUrl#/fixture.htm";
		variables.driver.get( local.url );

		local.expected = "Fixture Title";
		local.actual = variables.driver.getTitle();

		assertEquals( local.expected, local.actual );
	}
	
	public function findElementByLinkTextTest() {
		variables.driver = updateDriverByType( variables.selenium, "firefox" );
		
		local.url = "#fixtureBaseUrl#/fixture.htm";
		variables.driver.get( local.url );

		local.webElement = variables.driver.findElementByLinkText( 'Install Google Chrome' );

		assertTrue( local.webElement.foundWebElement(), '"Install Google Chrome" link text not found' );
	}
	
	public function findElementsByClassTest() {
		variables.driver = updateDriverByType( variables.selenium, "firefox" );
		
		local.url = "#fixtureBaseUrl#/fixture.htm";
		variables.driver.get( local.url );

		local.actual = variables.driver.findElementsByClass( 'padi' );

		assertTrue( arrayLen( local.actual ) > 0, 'class padi not found' );
	}

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