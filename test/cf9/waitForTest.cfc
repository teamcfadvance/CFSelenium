component extends="CFSeleniumTestCase" {

    public void function beforeTests() {
    	variables.baseTestURL = mid(cgi.request_url, 1, findNoCase("/test/", cgi.request_url)) & "CFSelenium/test/";
		variables.selenium = createObject("component", "webSelenium").init(waitTimeout=5000);
    	variables.selenium.start(browserUrl,"*firefox");
        variables.selenium.setTimeout(30000);
    }

	function setup() {
        selenium.open(variables.baseTestURL & "fixture/waitForFixture.htm");
	}

	function waitForElementPresentShouldFindElementThatIsAlreadyThere() {
		
		variables.selenium.waitForElementPresent("alwaysPresentAndVisible");
		assertEquals("alwaysPresentAndVisible", variables.selenium.getText("alwaysPresentAndVisible"));
		
	}

	function waitForElementPresentShouldThrowIfElementIsNeverThere() expectedException="elementNotFound" {
		
		variables.selenium.waitForElementPresent("neverPresent");
		
	}

	function waitForElementPresentShouldFindElementThatAppears() {

		assertEquals(false,selenium.isElementPresent("presentAfterAPause"));
		variables.selenium.click("createElement");
		variables.selenium.waitForElementPresent("presentAfterAPause");
		assertEquals("presentAfterAPause", variables.selenium.getText("presentAfterAPause"));

	}

	function waitForElementVisibleShouldFindElementThatIsAlreadyThere() {

		variables.selenium.waitForElementVisible("alwaysPresentAndVisible");
		assertEquals("alwaysPresentAndVisible", variables.selenium.getText("alwaysPresentAndVisible"));

	}

	function waitForElementVisibleShouldThrowIfElementIsNeverVisible() expectedException="elementNotVisible" {

		variables.selenium.waitForElementVisible("neverVisible");

	}

	function waitForElementVisibleShouldFindElementThatAppears() {

		assertEquals(false, variables.selenium.isVisible("becomesVisible"));
		variables.selenium.click("showElement");
		variables.selenium.waitForElementVisible("becomesVisible");
		assertEquals("becomesVisible", variables.selenium.getText("becomesVisible"));

	}

	function waitForElementNotVisibleShouldSucceedIfElementIsAlreadyInvisible() {

		variables.selenium.waitForElementNotVisible("neverVisible");
		assertEquals("", variables.selenium.getText("neverVisible"));

	}

	function waitForElementNotVisibleShouldThrowIfElementIsAlwaysVisible() expectedException="elementStillVisible" {

		variables.selenium.waitForElementNotVisible("alwaysPresentAndVisible");

	}

	function waitForElementNotVisibleShouldSucceedIfElementDisappears() {

		assertEquals(true, variables.selenium.isVisible("becomesInvisible"));
		variables.selenium.click("hideElement");
		variables.selenium.waitForElementNotVisible("becomesInvisible");
		assertEquals("", variables.selenium.getText("becomesInvisible"));

	}
	
	function afterTests() {
		variables.selenium.stopServer();
	}

}

