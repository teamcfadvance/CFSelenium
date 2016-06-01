component output="false" extends="WebDriver" {

	public FireFoxDriver function init() {
		var driver = createJavaObject(
			"org.openqa.selenium.firefox.FirefoxDriver",
			variables.serverLibPath
		);
		return super.init( driver=driver, driverType="Firefox" );
	}

	public void function setFireFoxPath( required string path ) {
		createObject( "java", "java.lang.System" ).setProperty( "webdriver.firefox.bin", arguments.path);
	}

	public void function setUseExistingFireFoxInstance( required string toggle ) {
		createObject( "java", "java.lang.System" ).setProperty( "webdriver.firefox.useExisting", arguments.toggle );
	}

}