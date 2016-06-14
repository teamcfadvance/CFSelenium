component output="false" extends="WebDriver" {

	setupDriver("Marionette");

	public FireFoxDriver function init() {
		var driver = variables.JavaFactory.createObject(
			"org.openqa.selenium.firefox.MarionetteDriver"
		);
		return super.init( driver=driver );
	}

	public void function setUseExistingFireFoxInstance( required string toggle ) {
		createObject( "java", "java.lang.System" ).setProperty( "webdriver.firefox.useExisting", arguments.toggle );
	}

}