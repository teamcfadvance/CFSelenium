component extends="cfselenium.CFSeleniumTestCase" {

    public void function beforeTests() {
        browserUrl = "http://localhost/CFSelenium/test/fixture/";
		selenium = createObject("component", "cfselenium.selenium").init(waitTimeout=5000);
    	selenium.start(browserUrl,"*firefox");
        selenium.setTimeout(30000);
    }

	function setup() {
        selenium.open("http://localhost/CFSelenium/test/fixture/waitForFixture.htm");
	}

	function waitForElementPresentShouldFindElementThatIsAlreadyThere() {
		
		selenium.waitForElementPresent("alwaysPresentAndVisible");
		assertEquals("alwaysPresentAndVisible",selenium.getText("alwaysPresentAndVisible"));
		
	}

	function waitForElementPresentShouldThrowIfElementIsNeverThere() expectedException="CFSelenium.elementNotFound" {
		
		selenium.waitForElementPresent("neverPresent");
		
	}

	function waitForElementPresentShouldFindElementThatAppears() {
		
		assertEquals(false,selenium.isElementPresent("presentAfterAPause"));
		selenium.click("createElement");
		selenium.waitForElementPresent("presentAfterAPause");
		assertEquals("presentAfterAPause",selenium.getText("presentAfterAPause"));
		
	}

	function waitForElementVisibleShouldFindElementThatIsAlreadyThere() {
		
		selenium.waitForElementVisible("alwaysPresentAndVisible");
		assertEquals("alwaysPresentAndVisible",selenium.getText("alwaysPresentAndVisible"));
		
	}

	function waitForElementVisibleShouldThrowIfElementIsNeverVisible() expectedException="CFSelenium.elementNotVisible" {
		
		selenium.waitForElementVisible("neverVisible");
		
	}

	function waitForElementVisibleShouldFindElementThatAppears() {
		
		assertEquals(false,selenium.isVisible("becomesVisible"));
		selenium.click("showElement");
		selenium.waitForElementVisible("becomesVisible");
		assertEquals("becomesVisible",selenium.getText("becomesVisible"));
		
	}

	function waitForElementNotVisibleShouldSucceedIfElementIsAlreadyInvisible() {
		
		selenium.waitForElementNotVisible("neverVisible");
		assertEquals("",selenium.getText("neverVisible"));
		
	}

	function waitForElementNotVisibleShouldThrowIfElementIsAlwaysVisible() expectedException="CFSelenium.elementStillVisible" {
		
		selenium.waitForElementNotVisible("alwaysPresentAndVisible");
		
	}

	function waitForElementNotVisibleShouldSucceedIfElementDisappears() {
		
		assertEquals(true,selenium.isVisible("becomesInvisible"));
		selenium.click("hideElement");
		selenium.waitForElementNotVisible("becomesInvisible");
		assertEquals("",selenium.getText("becomesInvisible"));
		
	}

}

