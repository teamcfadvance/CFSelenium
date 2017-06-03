component output="false" extends="WebDriver" {

	public ChromeDriver function init() {
		var driver = createJavaObject(
			"org.openqa.selenium.chrome.ChromeDriver",
			variables.serverLibPath
		);
		return super.init( driver=driver, driverType="Chrome" );
	}

	public void function setChromePath( required string path ) {
		createObject( "java", "java.lang.System" ).setProperty( "webdriver.chrome.bin", arguments.path);
	}

	public void function setUseExistingChromeInstance( required string toggle ) {
		createObject( "java", "java.lang.System" ).setProperty( "webdriver.chrome.useExisting", arguments.toggle );
	}

}