import * as fs from 'fs';
import * as https from 'https';
import express from 'express';


var privateKey = fs.readFileSync('E:/gbevplan/API/certificates/key.pem', 'utf-8');
var certificate = fs.readFileSync('E:/gbevplan/API/certificates/cert.pem', 'utf-8');
var credentials = { key: privateKey, cert: certificate };


const app = express();

const port = 3000;

app.get('/', (req, res) => {
    res.send('https I hope');
});

var httpsServer = https.createServer(credentials, app);

httpsServer.listen(port, () => {
    console.log('started server on ' + port);
});