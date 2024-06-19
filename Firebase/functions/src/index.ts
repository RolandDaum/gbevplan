import {CallableOptions, onCall, onRequest} from "firebase-functions/v2/https";
import {onSchedule} from "firebase-functions/v2/scheduler";
// import {onValueUpdated} from "firebase-functions/v2/database";
import {Builder, By, until} from "selenium-webdriver";
import {Options} from "selenium-webdriver/chrome";
import * as admin from "firebase-admin";
import {log} from "firebase-functions/logger";
import {Message} from "firebase-admin/lib/messaging/messaging-api";

// Firebase Admin SDK initialisieren
admin.initializeApp();
const db = admin.database();

const defaultConfig: CallableOptions = {
  memory: "4GiB",
  timeoutSeconds: 60,
  concurrency: 1,
  cpu: 1,
  maxInstances: 1,
};

export const UUIDFunctionSchedule = onSchedule({
  schedule: "0 */1 * * *", // every hour
  memory: defaultConfig.memory,
  timeoutSeconds: defaultConfig.timeoutSeconds,
  concurrency: defaultConfig.concurrency,
  maxInstances: defaultConfig.maxInstances,
}, async () => {
  const times:number[] = await uuidFunction();
  log("R U N T I M E : " + (times[1]-times[0]).toString() + "ms");
  return;
});
export const UUIDFunctionOnCall = onCall(defaultConfig, async () => {
  const times:number[] = await uuidFunction();
  log("R U N T I M E : " + (times[1]-times[0]).toString() + "ms");
  return;
});
export const UUIDFunctionOnRequest =
onRequest(defaultConfig, async (requset, response) => {
  const times:number[] = await uuidFunction();
  log("R U N T I M E : " + (times[1]-times[0]).toString() + "ms");
  response.send((times[1]-times[0]).toString() + "ms");
  return;
});

/**
 * Main Function which gets executed by all cloud functions
 * @return {number[]} An array containing the start and end time of the runtime
 */
async function uuidFunction(): Promise<number[]> {
  const starttime = Date.now();

  const minDataAgeMS = (120000);
  // const minDataAgeMS = (0);
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
  if (!timetorefetch) {
    const endtime = Date.now();
    return [starttime, endtime];
  }

  // auth credentials
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

  if (uuids.length > 0) {
    // ---- THIS DID NOT WORK ---- unessesary don't use it again
    const previousUUIDS: string[] = [];
    try {
      const snapshot = await admin.database().ref("/URL").once("value");
      snapshot.forEach((childSnapshot) => {
        const uuid = childSnapshot.child("uuid").val();
        if (uuid) {
          previousUUIDS.push(uuid);
        }
      });
    } catch (error) {
      log("E R R O R : " + error);
    }
    await saveUUIDsToDatabase(uuids);
    log(uuids.toString() != previousUUIDS.toString() +
    " -> if true, sending notification");
    if (uuids.toString() != previousUUIDS.toString()) {
      sendNotification(uuids);
    }
  }
  const endtime = Date.now();
  return [starttime, endtime];
}

/**
 * Fethces all available uuid's and returns them yas an string[]
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
  log("saving new uuids");
  const timestamp = Date.now();
  const ref = db.ref("/URL");
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

/**
 * Takes the uuids and sends them with the notification
 * @param {string[]} uuids
 */
async function sendNotification(uuids:string[]) {
  const message:Message = {
    notification: {
      title: "New VPlan",
      body: "new data",
    },
    data: {
      uuids: uuids.toString(),
    },
    topic: "everyone",
    android: {
      notification: {
        icon: "https://cdn.discordapp.com/attachments/1131545299291222037/1252956973335318559/Frame_6.png?ex=66741a9d&is=6672c91d&hm=559603924d4e07a5bbc4add388a4b8687438a1914be81d599df6246685e62215&",
      },
    },
  };
  await admin.messaging().send(message).catch((error) => {
    log(`Error: ${error}`);
  });
}
