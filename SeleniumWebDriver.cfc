component {
	public SeleniumWebDriver function init( requried string driverType, required string webdriver ) {
		setDriverByType( driverType, webdriver );

		return this;
	}

	public cfselenium.drivers.WebDriver function getDriver() {
		return variables.driver;
	}

	public void function setDriverByType( required string driverType, required string webdriver ) {
		switch( driverType ) {
			case 'firefox':
				variables.driver = new cfselenium.drivers.FireFoxDriver( webdriver );
			break;

			default:
				variables.driver = new cfselenium.drivers.WebDriver( webdriver );
			break;
		}

		return;
	}
}
