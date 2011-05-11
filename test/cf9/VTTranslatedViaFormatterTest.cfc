component extends="cfselenium.CFSeleniumTestCase" displayName="EndToEndServernewValidations" {

    public void function beforeTests() {
        browserUrl = "http://localhost/validatethis/samples/StructureDemo/index.cfm";
        super.beforeTests();
    }

    public void function testEndToEndServernewValidations() {
        selenium.open("http://localhost/validatethis/tests/selenium/FacadeDemo/index.cfm?init=true&noJS=true&context=newValidations-server");
        assertEquals("ValidateThis Demo Page", selenium.getTitle());
        selenium.type("UserName", "");
        selenium.type("UserPass", "");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("ValidateThis Demo Page", selenium.getTitle());
        assertEquals("The Email Address is required.#chr(10)#The Email Address must be a date between 2010-01-01 and 2011-12-31.#chr(10)#The Email Address must be a date in the future. The date entered must come after 2010-12-31.#chr(10)#The Email Address must be a date in the past. The date entered must come before 2011-02-01.#chr(10)#The Email Address was not found in the list: 2011-01-30,2011-01-29.", selenium.getText("error-UserName"));
        assertEquals("The Password is required.#chr(10)#The Password must be a valid boolean.#chr(10)#The Password must be a true boolean.#chr(10)#The Password must be a false boolean.", selenium.getText("error-UserPass"));
        assertEquals("The User Group Name is required.", selenium.getText("//form[@id='frm-Main2']/fieldset[1]/div[5]/p[1]"));
        selenium.type("UserName", "b");
        selenium.type("Nickname", "abcd");
        selenium.type("UserPass", "c");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("The Nickname must not contain the values of properties named: UserName,UserPass.#chr(10)#1 patterns were matched but 3 were required.#chr(10)#The Nickname must be a valid URL.", selenium.getText("//form[@id='frm-Main2']/fieldset[1]/div[2]/p[1]"));
        assertEquals("The Email Address must be a date between 2010-01-01 and 2011-12-31.#chr(10)#The Email Address must be a date in the future. The date entered must come after 2010-12-31.#chr(10)#The Email Address must be a date in the past. The date entered must come before 2011-02-01.#chr(10)#The Email Address was not found in the list: 2011-01-30,2011-01-29.", selenium.getText("error-UserName"));
        selenium.type("UserName", "2010-02-02");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("The Email Address must be a date in the future. The date entered must come after 2010-12-31.#chr(10)#The Email Address was not found in the list: 2011-01-30,2011-01-29.", selenium.getText("error-UserName"));
        selenium.type("UserName", "2011-02-02");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("The Email Address must be a date in the past. The date entered must come before 2011-02-01.#chr(10)#The Email Address was not found in the list: 2011-01-30,2011-01-29.", selenium.getText("error-UserName"));
        selenium.type("UserName", "2011-01-31");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("The Email Address was not found in the list: 2011-01-30,2011-01-29.", selenium.getText("error-UserName"));
        selenium.type("UserName", "2011-01-29");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("The Email Address was found in the list: 2011-01-29,2011-01-28.", selenium.getText("error-UserName"));
        selenium.type("UserName", "2011-01-30");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertFalse(selenium.isElementPresent("error-UserName"));
        selenium.type("UserName", "2011-01-29");
        selenium.type("Nickname", "<a href=2011-01-29>");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("The Nickname cannot contain HTML tags.#chr(10)#The Nickname must not contain the values of properties named: UserName,UserPass.#chr(10)#The Nickname must be a valid URL.", selenium.getText("//form[@id='frm-Main2']/fieldset[1]/div[2]/p[1]"));
        selenium.type("Nickname", "2011-01-29");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("The Nickname must not contain the values of properties named: UserName,UserPass.#chr(10)#2 patterns were matched but 3 were required.#chr(10)#The Nickname must be a valid URL.", selenium.getText("error-Nickname"));
        selenium.type("Nickname", "http://www.Abc.com");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertFalse(selenium.isElementPresent("error-Nickname"));
        selenium.type("UserPass", "abc");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("The Password must be a valid boolean.#chr(10)#The Password must be a true boolean.#chr(10)#The Password must be a false boolean.", selenium.getText("//form[@id='frm-Main2']/fieldset[1]/div[3]/p[1]"));
        selenium.type("UserPass", "yes");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("The Password must be a false boolean.", selenium.getText("//form[@id='frm-Main2']/fieldset[1]/div[3]/p[1]"));
        selenium.type("UserPass", "0");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("The Password must be a true boolean.", selenium.getText("//form[@id='frm-Main2']/fieldset[1]/div[3]/p[1]"));
        selenium.type("VerifyPassword", "ab");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("The Verify Password size is not between 3 and 10.", selenium.getText("//form[@id='frm-Main2']/fieldset[1]/div[4]/p[1]"));
        selenium.type("VerifyPassword", "abc");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertFalse(selenium.isElementPresent("error-VerifyPassword"));
        selenium.type("VerifyPassword", "a,b");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("The Verify Password size is not between 3 and 10.", selenium.getText("//form[@id='frm-Main2']/fieldset[1]/div[4]/p[1]"));
        selenium.type("VerifyPassword", "a,b,c");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertFalse(selenium.isElementPresent("error-VerifyPassword"));
        selenium.type("VerifyPassword", "structbad");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("The Verify Password size is not between 3 and 10.", selenium.getText("//form[@id='frm-Main2']/fieldset[1]/div[4]/p[1]"));
        selenium.type("VerifyPassword", "structok");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertFalse(selenium.isElementPresent("error-VerifyPassword"));
        selenium.type("VerifyPassword", "arraybad");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("The Verify Password size is not between 3 and 10.", selenium.getText("//form[@id='frm-Main2']/fieldset[1]/div[4]/p[1]"));
        selenium.type("VerifyPassword", "arrayok");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertFalse(selenium.isElementPresent("error-VerifyPassword"));
    }
}


