component {
	public SeleniumWebDriver function init( requried string driverType, required string webdriver ) {
		variables.driver = setDriverByType( driverType, webdriver );

		return this;
	}

	public cfselenium.drivers.WebDriver function getDriver() {
		return variables.driver;
	}

	public any function setDriverByType( required string driverType, required string webdriver ) {
		switch( driverType ) {
			case 'firefox':
				var driver = new cfselenium.drivers.FireFoxDriver( webdriver );
			break;

			default:
				var driver = new cfselenium.drivers.WebDriver( webdriver );
			break;
		}

		return driver;
	}
}
