import { Builder, Browser, By, Key, until } from 'selenium-webdriver';
import chrome from 'selenium-webdriver/chrome.js'

main();

async function main() {
    const uris = await getVplanURL(1);
    await getVPlanJson(uris);
};

async function getVplanURL(attemps) {
    // Set up Chrome options
    const chromeOptions = new chrome.Options();
    chromeOptions.addArguments('--headless'); // optional: run headless
    chromeOptions.addArguments('--silent');

    let driver = await new Builder()
        .forBrowser(Browser.CHROME)
        .setChromeOptions(chromeOptions)
        .build();


    await driver.get(`https://www.dsbmobile.de/Login.aspx?U=${process.env.apiUSERNAME}&P=${process.env.apiPASSWORD}`).catch( (error) => {
        console.log(error);
    });

    let vplanURL = [];
    const elements = await driver.findElements(By.css('[data-uuid]'));

    for (let i = 0; i < elements.length; i++) {
        const uuid = await elements.at(i).getAttribute('data-uuid');
        vplanURL.push(`https://dsbmobile.de/data/a2223098-b91f-4526-b48d-55af00305b46/${uuid}/${uuid}.htm`);
    }

    driver.quit();

    if (vplanURL.length <= 0 && attemps <= 10) {
        return await getVplanURL(attemps+1)
    } else {
        console.log(`Attemps: ${attemps}`);
        return vplanURL;
    }
}

async function getVPlanJson(uriList) {
    // Set up Chrome options
    const chromeOptions = new chrome.Options();
    chromeOptions.addArguments('--headless'); // optional: run headless
    chromeOptions.addArguments('--silent');

    let driver = await new Builder()
        .forBrowser(Browser.CHROME)
        .setChromeOptions(chromeOptions)
        .build();

    uriList.forEach(async (url) => {
        await driver.get(url).catch( (error) => {
            console.log(error);
        });
        
        const title = await driver.getCurrentUrl();

        console.log('TT: ' + title);
    })
};