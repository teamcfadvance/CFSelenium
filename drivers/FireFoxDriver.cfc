component output="false" extends="WebDriver" {

	public FireFoxDriver function init(
		string localDriverRepoPath = variables.defaultLocalDriverRepoPath
	) {
		setupDriver(
			driverName = "Marionette",
			localDriverRepoPath = localDriverRepoPath
		);
		var driver = variables.JavaFactory.createObject(
			"org.openqa.selenium.firefox.MarionetteDriver"
		);
		return super.init( driver=driver );
	}

	public void function setUseExistingFireFoxInstance( required string toggle ) {
		createObject( "java", "java.lang.System" ).setProperty( "webdriver.firefox.useExisting", arguments.toggle );
	}

}