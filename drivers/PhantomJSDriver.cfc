component output="false" extends="WebDriver" {

	public PhantomJSDriver function init() {
		var driver = createJavaObject(
			"org.openqa.selenium.phantomjs.PhantomJSDriver",
			variables.serverLibPath
		);
		return super.init( driver=driver, driverType="PhantomJS" );
	}

	public void function setPhantomJSPath( required string path ) {
		createObject( "java", "java.lang.System" ).setProperty( "webdriver.phantomjs.bin", arguments.path);
	}

	public void function setUseExistingPhantomJSInstance( required string toggle ) {
		createObject( "java", "java.lang.System" ).setProperty( "webdriver.phantomjs.useExisting", arguments.toggle );
	}

}