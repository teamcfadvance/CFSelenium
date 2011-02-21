component extends="mxunit.framework.TestCase" {

	function setUp() {
		browserUrl = "http://wiki.mxunit.org/";
        selenium = startFireFox(browserUrl);
	}

	function tearDown() {
        selenium.stop();
	    assertTrue(len(selenium.getSessionId()) eq 0);
	}	
	
	private any function startSelenium(browserUrl, browserCommand) {

	    selenium = createobject("component","selenium").init(browserUrl,"localhost", 4444, browserCommand);
	    assertTrue(len(selenium.getSessionId()) eq 0);
        selenium.start();
	    assertFalse(len(selenium.getSessionId()) eq 0);
	    return selenium;
		
	}
	
	private any function startFireFox(browserURL) {

	    return startSelenium(browserUrl,"*firefox");
		
	}
	
    function shouldBeAbleToStartAndStopABrowser() {
    	// the asserts for this are in setUp and tearDown
	}

	function parseCSVShouldWork() {
		
		input = "veni\, vidi\, vici,c:\\foo\\bar,c:\\I came\, I \\saw\\\, I conquered";
		expected = ["veni, vidi, vici", "c:\foo\bar", "c:\i came, i \saw\, i conquered"];
		debug(selenium.parseCSV(input));
		assertEquals(expected,selenium.parseCSV(input));
		
	}

	function testOpen() {
		
		selenium.open("/pages/viewpage.action?pageId=786471");
        //assertEndsWith("html/test_open.html", selenium.getLocation());
        //assertEquals("This is a test of the open command.", selenium.getBodyText());
        debug(selenium.getAllLinks());
        debug(selenium.getLocation());
        debug(selenium.getBodyText());

	}
	
}

