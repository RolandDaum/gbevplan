const {onValueUpdated} = require("firebase-functions/v2/database");
// const functions = require("firebase-functions");
const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");
admin.initializeApp();

const {Builder, Browser, By} = require("selenium-webdriver");
const chrome = require("selenium-webdriver/chrome.js");

exports.dasisteinefunkton = onValueUpdated(
    "/URL", async (event) => {
      try {
        const vplanURLList = await getVplanURL();
        if (vplanURLList != null && vplanURLList.length != 0) {
          await admin.database().ref("/URL").set(vplanURLList);
        }
      } catch (error) {
        logger.error("Error fetching data from database: ", error);
      }
    });

/**
 * Funktion zur Abfrage der Vplan-URLs.
 * @param {number} attempts - Anzahl der Versuche, die URL zu erhalten.
 * @param {Array} vplanURLList - Liste der erhaltenen Vplan-URLs.
 * @return {Array} - Eine Liste der Vplan-URLs.
 */
async function getVplanURL(attempts = 0, vplanURLList = []) {
  // Set up Chrome options
  const chromeOptions = new chrome.Options();
  chromeOptions.addArguments("--headless"); // optional: run headless
  chromeOptions.addArguments("--silent");
  const driver = await new Builder()
      .forBrowser(Browser.CHROME)
      .setChromeOptions(chromeOptions)
      .build();
  await driver.get(`https://www.dsbmobile.de/Login.aspx?U=346481&P=gbevplan`).catch( (error) => {
    logger.log(error);
  });
  const elements = await driver.findElements(By.css("[data-uuid]"));
  for (let i = 0; i < elements.length; i++) {
    const uuid = await elements.at(i).getAttribute("data-uuid");
    vplanURLList.push(`https://dsbmobile.de/data/a2223098-b91f-4526-b48d-55af00305b46/${uuid}/${uuid}.htm`);
  }
  await driver.quit();
  if (vplanURLList.length <= 0 && attempts <= 10) {
    return await getVplanURL(attempts +1);
  } else {
    logger.log(`Attempts to get URL: ${attempts}`);
    return vplanURLList;
  }
}
