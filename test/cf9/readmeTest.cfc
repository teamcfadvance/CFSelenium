component extends="cfselenium.CFSeleniumTestCase" {

	function setUp(){
		browserURL = "http://github.com/";
		super.setUp();
	}

	function testForReadmePage() {
		selenium.open("/bobsilverberg/CFSelenium");
		assertEquals("bobsilverberg/CFSelenium - GitHub", selenium.getTitle());
		selenium.click("link=readme.md");
		selenium.waitForPageToLoad("30000");
		assertEquals("readme.md at master from bobsilverberg's CFSelenium - GitHub", selenium.getTitle());
		selenium.click("raw-url");
		selenium.waitForPageToLoad("30000");
		assertEquals("", selenium.getTitle());
		assertTrue(selenium.isTextPresent("[CFSelenium]"));
	}

	
}

