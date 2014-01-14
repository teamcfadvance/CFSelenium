component extends="CFSeleniumTestCase"   {

	// environment needs to be set up for this to work
	function beforeTests() {
    	hostname = "192.168.56.101";
	    selenium = createobject("component","webSelenium").init(hostname, 4444);
		browserUrl = "http://wiki.mxunit.org/";
	}
	
    function shouldBeAbleToStartIEOnWindowsVM() {
	    assertTrue(len(selenium.getSessionId()) eq 0);
        selenium.start(browserUrl, "*iexplore");
	    assertFalse(len(selenium.getSessionId()) eq 0);
	}
	
	function shouldBeAbleToStartFirefoxWindowsVM() {
	    assertTrue(len(selenium.getSessionId()) eq 0);
        selenium.start(browserUrl, "*firefox");
	    assertFalse(len(selenium.getSessionId()) eq 0);
	}
	
}

