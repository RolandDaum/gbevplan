import { Builder, Browser, By, Key, until } from 'selenium-webdriver';


vplanSrcaping();


const vplanURL = [];


async function vplanSrcaping() {
    let driver = await new Builder().forBrowser(Browser.CHROME).build();

    await driver.get(`https://www.dsbmobile.de/Login.aspx?U=${process.env.apiUSERNAME}&P=${process.env.apiPASSWORD}`)
    
    console.log(await driver.getTitle())


    // driver.manage().setTimeouts({ implicit: 20000 });
    // await driver.quit()
}