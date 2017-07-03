component extends='WebDriver' {
	public WebDriver function init( required string webdriver ) {
		variables.javaSystem.setProperty( 'webdriver.gecko.driver', webdriver );

		var driver = createObject( 'java', 'org.openqa.selenium.firefox.FirefoxDriver' );

		return super.init( driver );
	}
}
