component output="false" extends="WebDriver" {

	public FireFoxDriver function init() {
		return super.init( driver=createObject( "java", "org.openqa.selenium.firefox.FirefoxDriver", "#ExpandPath('../../Selenium-RC/selenium-server-standalone-2.37.0.jar')#" ), driverType="Firefox" );
	}

	public void function setFireFoxPath( required string path ) {
		createObject( "java", "java.lang.System" ).setProperty( "webdriver.firefox.bin", arguments.path);
	}

	public void function setUseExistingFireFoxInstance( required string toggle ) {
		createObject( "java", "java.lang.System" ).setProperty( "webdriver.firefox.useExisting", arguments.toggle );
	}

}