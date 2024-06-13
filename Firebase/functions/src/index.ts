import {onCall, onRequest} from "firebase-functions/v2/https";
// import {log} from "firebase-functions/logger";
import {Builder, By, until} from "selenium-webdriver";
import {Options} from "selenium-webdriver/chrome";
import * as admin from "firebase-admin";
import {log} from "firebase-functions/logger";

// Firebase Admin SDK initialisieren
admin.initializeApp();
const db = admin.database();

export const UUIDFunctionOnCall = onCall({
  memory: "4GiB",
  timeoutSeconds: 60,
  concurrency: 1,
  maxInstances: 1,
}, async () => {
  const starttime = Date.now();
  await uuidFunction();
  const endtime = Date.now();
  log((endtime-starttime).toString() + "ms");
  return;
});
export const UUIDFunctionOnRequest = onRequest({
  memory: "4GiB",
  timeoutSeconds: 60,
  concurrency: 1,
  maxInstances: 1,
}, async (requset, response) => {
  const starttime = Date.now();
  await uuidFunction();
  const endtime = Date.now();
  log((endtime-starttime).toString() + "ms");
  response.send((endtime-starttime).toString() + "ms");
  return;
});

/**
 *
 * @return {void}
 */
async function uuidFunction(): Promise<void> {
  const minDataAgeMS = (120000);
  let timetorefetch = true;

  // checks how old the last datawrite is
  await db.ref("/URL/0").once("value", (snapshot) => {
    if (!snapshot.exists() || snapshot.val() == null ||
    snapshot.val().timestamp == null) {
      timetorefetch = true;
    } else {
      const timeDifference = Date.now() -
      new Date(snapshot.val().timestamp).getTime();
      timetorefetch =
      timeDifference > minDataAgeMS;
    }
  }).catch((error) => {
    log(error);
  });
  // If it is old enough, fetch the uuid's until he gets it or
  // just ends up with 5 missleading try's
  if (!timetorefetch) {
    return;
  }
  const username:string =
    (await db.ref("/credentials/username").once("value")).val();
  const password:string =
    (await db.ref("/credentials/password").once("value")).val();
  let counter = 0;
  let uuids:string[] = [];
  while (uuids.length == 0 && counter < 5) {
    uuids = await fetchUUIDs(username, password);
    counter++;
  }
  if (uuids.length != 0) {
    await saveUUIDsToDatabase(uuids);
  }
  return;
}

/**
 * Fethces all available uuid's and returns them as an string[]
 * @return {string[]} with all uuids
 * @argument {string} username takes the username as a string
 * @argument {string} password takes the password as a string
 */
async function fetchUUIDs(username:string, password:string): Promise<string[]> {
  const options = new Options();
  options.addArguments("--headless");

  const driver = await new Builder()
    .forBrowser("chrome")
    .setChromeOptions(options)
    .build();

  if (username == null || password == null ||
     username.length == 0 || password.length == 0) {
    await driver.quit();
    return [];
  }

  try {
    await driver.get(`https://www.dsbmobile.de/Login.aspx?U=${username}&P=${password}`);
    await driver.wait(until.titleIs("DSBmobile"), 20000).catch((error) => {
      log(error);
    });
    const elements = await driver.findElements(By.css("[data-uuid]"));
    const uuids = await Promise.all(elements.map(async (element) => {
      return await element.getAttribute("data-uuid");
    }));
    return uuids;
  } finally {
    await driver.quit();
  }
}

/**
 *  Takes a string[] and saves it unter /URL/{index}/uuid
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
    ).catch((error) => {
      log(error);
    });
  }
}
