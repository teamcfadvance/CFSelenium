component extends="CFSeleniumTestCase"   {

	// environment needs to be set up for this to work
	function beforeTests() {
		// TODO: JAJ: Find out what this test configuration (for Mac?) is supposed to be.
		// hostname = "192.168.56.101";
    	hostname = "localhost";
	    selenium = createobject("component","webSelenium").init(hostname, 4444);
		browserUrl = "http://wiki.mxunit.org/";
	}
	
    function shouldBeAbleToStartIEOnWindowsVM() {
	    assertTrue(len(selenium.getSessionId()) eq 0);
        selenium.start(browserUrl, "*iexplore");
	    assertFalse(len(selenium.getSessionId()) eq 0);
		// TODO: JAJ: Needed?
	    selenium.stop();
	}
	
	function shouldBeAbleToStartFirefoxWindowsVM() {
	    assertTrue(len(selenium.getSessionId()) eq 0);
        selenium.start(browserUrl, "*firefox");
	    assertFalse(len(selenium.getSessionId()) eq 0);
		// TODO: JAJ: Needed?
	    selenium.stop();
	}
	
}

