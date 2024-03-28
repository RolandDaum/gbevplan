import * as fs from 'fs';
import * as https from 'https';
import express from 'express';

var credentials = {
    key: fs.readFileSync('E:/gbevplan/API/certificates/private.key', 'utf-8'), 
    cert: fs.readFileSync('E:/gbevplan/API/certificates/certificate.crt', 'utf-8')
    // key: fs.readFileSync('E:/gbevplan/API/certificates/gbevplanapi.key', 'utf-8'), 
    // cert: fs.readFileSync('E:/gbevplan/API/certificates/gbevplanapi.csr', 'utf-8')
}

const app = express();

app.get('/', (req, res) => {
    res.send('https I hope');
})

var httpsServer = https.createServer(credentials, app).listen(3000, () => {
    console.log('started server on ' + 3000)
});