import {onSchedule} from "firebase-functions/v2/scheduler";
import {onRequest} from "firebase-functions/v2/https";
import {log} from "firebase-functions/logger";
import {Builder, By, until} from "selenium-webdriver";
import {Options} from "selenium-webdriver/chrome";
import * as admin from "firebase-admin";

// Firebase Admin SDK initialisieren
admin.initializeApp();
const db = admin.database();

// 0 0/5 11-16 ? * * *
export const UUIDFunction = onSchedule("*/15 * * * *", async () => {
  await uuidFunction();
  return;
});

export const UUIDFunctionOnRequest = onRequest(async () => {
  await uuidFunction();
  return;
});

/**
 *
 * @return {void}
 */
async function uuidFunction() {
  const minDataAge = 12;
  let timetorefetch = true;

  await db.ref("/URL/0").once("value", (snapshot) => {
    if (!snapshot || snapshot.val() === null || !snapshot.exists()) {
      timetorefetch = true;
    } else {
      const timeDifference = Date.now() -
      new Date(snapshot.val().timestamp).getTime();
      timetorefetch =
      timeDifference > (minDataAge * 3600000);
      // log("TimeDiff: " + timeDifference + " | ReadTimeStamp: "
      // + snapshot.val().timestamp + " | TimeToReFetch: " + timetorefetch);
    }
  });

  if (!timetorefetch) {
    log(`Data is not older than ${minDataAge}`);
    return;
  } else if (timetorefetch) {
    let counter = 0;
    let uuids:string[] = [];
    while (uuids.length == 0 && counter < 10) {
      uuids = await fetchUUIDs();
      counter++;
    }
    log(`Successfully fetched all uuid's \n ${uuids.toString()}`);
    await saveUUIDsToDatabase(uuids);
  }
}

/**
 *
 * @return {String[]} with all uuids
 */
async function fetchUUIDs(): Promise<string[]> {
  // Chrome-Optionen für den Headless-Modus einstellen
  const options = new Options();
  options.addArguments("--headless"); // Headless-Modus aktivieren

  // WebDriver für Chrome erstellen
  const driver = await new Builder()
    .forBrowser("chrome")
    .setChromeOptions(options)
    .build();

  try {
    // Zur angegebenen URL navigieren
    await driver.get("https://www.dsbmobile.de/Login.aspx?U=346481&P=gbevplan");

    // Sicherstellen, dass die Seite geladen ist
    await driver.wait(until.titleIs("DSBmobile"), 20000);

    // Alle Elemente mit data-uuid Attribut finden
    const elements = await driver.findElements(By.css("[data-uuid]"));

    // data-uuid Attribute extrahieren
    const uuids = await Promise.all(elements.map(async (element) => {
      return await element.getAttribute("data-uuid");
    }));

    // data-uuid Werte ausgeben
    return uuids;
  } finally {
    // Browser schließen
    await driver.quit();
  }
}

/**
 *
 * @param {string[]} uuids with all uuids and saves it into RTDB
 */
async function saveUUIDsToDatabase(uuids: string[]): Promise<void> {
  // const timestamp = admin.database.ServerValue.TIMESTAMP;
  const timestamp = Date.now();

  const ref = db.ref("/URL");
  // clears URL db
  await ref.remove();

  for (let i = 0; i < uuids.length; i++) {
    const value = uuids[i];
    await db.ref(`/URL/${i.toString()}`).set(
      {
        uuid: value,
        timestamp: timestamp,
      }
    );
  }
}
