component extends="cfselenium.CFSeleniumTestCase" {

	public void function beforeTests() {
		browserUrl = "http://wiki.mxunit.org/";
		browserCommand = "*firefox";
       	selenium = createobject("component","CFSelenium.selenium").init("localhost", 4444);
       	assertEquals(0, len(selenium.getSessionId()));
        selenium.start(browserUrl,browserCommand);
	    assertFalse(len(selenium.getSessionId()) eq 0);
	}
	
	function tearDown() {   
    	selenium.stop();
    	assertEquals(0, len(selenium.getSessionId()));
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

}

