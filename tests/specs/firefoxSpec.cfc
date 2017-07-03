component extends='tests.basetests.BaseSpecTest' {
// setup
	function beforeAll() {
		super.beforeAll();

		switch( listFirst( server.os.name, ' ' ) ) {
			case 'Mac':
				var webDriverFilename = 'geckodriver-v0.16.1-macos';
			break;

			case 'Windows':
				var webDriverFilename = 'geckodriver-v0.16.1-win64.exe';
			break;

			case 'Linux':
				var webDriverFilename = 'geckodriver';
			break;

			default:
// I need to figure out how to get TestBox to end the test
// suite if the operating system isn't supported
			break;
		}

// https://github.com/mozilla/geckodriver/releases
		var webDriverFilePathname = getDirectoryFromPath( getCurrentTemplatePath() ) & '../../webdrivers/#webDriverFilename#';

		var selenium = new cfselenium.SeleniumWebDriver(
			 driverType='firefox'
			,webdriver=webDriverFilePathname
		);

		driver = selenium.getDriver();
	}

// teardown
	function afterAll() {
		super.afterAll();

		driver.close();
	}

	function run( testResults, testBox ) {
// suite...
		describe( 'Firefox tests...', function() {
			beforeEach( function( currentSpec ) {
			});

			afterEach( function( currentSpec ) {
			});

			aroundEach( function( spec, suite ){
				arguments.spec.body();
			});

////////////////////////////////////////////////////////////////////////////////
// test browser
////////////////////////////////////////////////////////////////////////////////
			it( title='...expect the Example website (http://example.net/) title to be "Example Domain" ', body=function( data ) {
				driver.get( 'http://example.net/' );

				pageTitle = driver.getTitle();

				expect( pageTitle ).toBe( 'Example Domain' );
			}, data={} );

			it( title='...get the current Example website URL', body=function( data ) {
				driver.get( 'http://example.net/' );

				currentURL = driver.getCurrentUrl();

				expect( currentURL ).toBe( 'http://example.net/' );
			}, data={} );

			it( title='...find an element on the Example website by it''s link text', body=function( data ) {
				driver.get( 'http://example.net/' );

				element = driver.findElementByLinkText( 'More information...' );

				expect( element.getTagName() ).toBe( 'a' );
				expect( element.getText() ).toBe( 'More information...' );
				expect( element.getAttribute( 'href' ) ).toBe( 'http://www.iana.org/domains/example' );
			}, data={} );
		});
	}

////////////////////////////////////////////////////////////////////////////////
// common tests
////////////////////////////////////////////////////////////////////////////////

}
