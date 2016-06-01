component hint="Represents an element in a page" output="false" {

	public WebElement function init() {
		// default to "we haven't found this web element"
		variables._foundWebElement = false;

		return this;
	}
	
	public any function getWebElement() {
		return variables.webElement;
	}
	
	public void function setWebElement( required any webElement ) {
		variables.webElement = arguments.webElement;
	}

	//TODO: Accept int as 2nd param, which indicates mouse and keyboard events - KEYPRESS.KEYDOWN ...
	public void function sendKeys( required any keys ) {
		local.localKeys = [];
		arrayAppend( localKeys, toString( arguments.keys ) );
		variables.webElement.sendKeys( local.localKeys );
	}
	
	public void function setFoundWebElement( required boolean value ) {
		variables._foundWebElement = arguments.value;
	}
	
	public boolean function foundWebElement() {
		return variables._foundWebElement;
	}

	public void function submit() {
		variables.webElement.submit();
	}  

	public string function getText() {
		return this.webElement.getText();
	}

	public void function clear() {
		variables.webElement.clear();
	}

	public void function click() {
		variables.webElement.click();
	}

	public boolean function isEnabled() {
		return variables.webElement.isEnabled();
	}

	public boolean function isSelected() {
		return variables.webElement.isSelected();
	}
	
	public string function getTagName() {
		return variables.webElement.getTagName();
	}
	
	public string function getAttribute( required string attribute ) {
		return variables.webElement.getAttribute( arguments.attribute );
	}
	
	// helper function for getting value
	public string function getValue() {
		return getAttribute( "value" );
	}

	//TODO ---------------------------------------
	function dragAndDropBy(x,y){} //}(int, int) void 
	function dragAndDropOn(renderedElement){} //}(org.openqa.selenium.RenderedWebElement) void 
	function findElement(by){} //}(org.openqa.selenium.By) org.openqa.selenium.WebElement 
	function findElements(by){} //}(org.openqa.selenium.By) java.util.List 
	function getChildrenOfType(strElement){} //}(java.lang.String) java.util.List 
	function getLocation() {} //}ava.awt.Point 
	function getSize() {} //}java.awt.Dimension 
	function getValueOfCssProperty(css){} //}(java.lang.String) java.lang.String 
	function isDisplayed() {} //}boolean 
	
	// DEPRECATED --------------------------------
	// toggle
	// setSelected

}