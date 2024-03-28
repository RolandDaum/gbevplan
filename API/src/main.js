import * as fs from 'fs';
import * as https from 'https';
import express from 'express';

var credentials = {
    key: fs.readFileSync('E:/gbevplan/API/certificates/gbevplanapi.key', 'utf-8'), 
    cert: fs.readFileSync('E:/gbevplan/API/certificates/gbevplanapi.csr', 'utf-8')
}

const app = express();
const port = 3000;

app.get('/', (req, res) => {
    res.send('https I hope');
})

var httpsServer = https.createServer(credentials, app);

httpsServer.listen(port, () => {
    console.log('started server on ' + port)
});





// app.get('/', (req, res) => {
//     res.send('Hello World!')
// })
  
// app.listen(port, () => {
//     console.log(`Example app listening on port ${port}`)
// })  