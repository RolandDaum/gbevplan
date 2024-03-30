import * as fs from 'fs';
import * as https from 'https';
import express from 'express';
import { Builder, Browser, By, Key, until } from 'selenium-webdriver';

const resText = {
    400: 'missing header',
    401: 'unauthorized',
    404: 'content not found'
}
const jahrgangsPlanPath = {
    12: './src/data/Jahrgang12.json',
    13: './src/data/Jahrgang13.json'
}
const jahrgangsKursPath = {
    12: './src/data/Jahrgang12Kurse.json',
}

const credentials = {
    key: fs.readFileSync('./certificates/private.key', 'utf-8'), 
    cert: fs.readFileSync('./certificates/certificate.crt', 'utf-8')
}
const app = express();
const PORT = 3000;


app.get('/verify', (req, res) => {
    const verify = verifyReq(req, res);
    switch (verify) {
        case 200:
            res.status(verify);
            res.send('verified');
            break;
    }
});
// checks username + password and autoresponse if wrong or missing, else return 200
function verifyReq(req, res) {
    const reqUsername = req.headers.username;
    const reqPassword = req.headers.password;

    if (reqUsername == process.env.apiUSERNAME && reqPassword == process.env.apiPASSWORD) {
        return 200;
    } else {
        if (reqUsername == null || reqPassword == null) {
            res.status(400);
            res.send(resText[400]);
            return 400;
        } else {
            res.status(401);
            res.send(resText[401]);
            return 401
        }
    }
}


app.get('/jahrgangsplan', (req, res) => {
    if (verifyReq(req, res) != 200) {}

    const jahrgang = req.headers.jahrgang;
    if (jahrgang == null) {
        res.status(400);
        res.send(resText[400]);
        return;
    }

    try {
        fs.readFile(jahrgangsPlanPath[jahrgang], 'utf8', (err, data) => {
            res.status(200);
            res.type('json');
            res.send(data);
        })
    } catch (error) {
        res.status(404);
        res.send(resText[404]);
    }
});
app.get('/jahrgangskurse', (req, res) => {
    if (verifyReq(req, res) != 200) {}

    const jahrgang = req.headers.jahrgang;
    if (jahrgang == null) {
        res.status(400);
        res.send(resText[400]);
        return;
    }

    try {
        fs.readFile(jahrgangsKursPath[jahrgang], 'utf8', (err, data) => {
            res.status(200);
            res.type('json');
            res.send(data);
        })
    } catch (error) {
        res.status(404);
        res.send(resText[404]);
    }
});


app.get('/news', (req, res) => {
    if (verifyReq(req, res) != 200) {}
    res.status(200);
    res.send('news');
})


app.get('/vplan', (req, res) => {
    if (verifyReq(req, res) != 200) {}
    res.status(200);

    const jahrgang = req.headers.jahrgang;
    if (jahrgang == null) {
        res.status(400);
        res.send(resText[400]);
        return;
    }
    res.send('VPlan für Jahrgang ' + jahrgang);
})


var httpsServer = https.createServer(credentials, app).listen(PORT, () => {
    console.log('Started API Server on port: ' + PORT);
});


async function vplanSrcaping() {
    let driver = await new Builder().forBrowser(Browser.CHROME).build();
    try {
        await driver.get(`https://www.dsbmobile.de/Login.aspx?U=${process.env.apiUSERNAME}&P=${process.env.apiPASSWORD}`)
        console.log(await driver.getTitle())
      } finally {
        await driver.quit()
      }
}