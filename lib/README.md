# Building WebDriverManager Jar

The `webdrivermanager-*-SNAPSHOT-with-dependencies.jar` file (in this directory) was built from source from the [WebDriverManager project](https://github.com/bonigarcia/webdrivermanager).

WebDriverManager manages WebDrivers for different browsers. It downloads them automatically and keeps them up to date.

Since WebDriverManager has many dependencies, an uber-Jar is less awkward to work with in CFSelenium (than a directory full of loose Jars).

To build the uber-Jar in the future:

```bash
git clone https://github.com/bonigarcia/webdrivermanager.git webdrivermanager
cd webdrivermanager
git checkout master
patch pom.xml < /path/to/cfselenium/lib/webdrivermanager.pom.xml.patch
mvn clean install compile package
cp webdrivermanager-*-SNAPSHOT-with-dependencies.jar /path/to/cfselenium/lib/
```

Note: I'm not a Maven guru, so there may be better ways to do this.
