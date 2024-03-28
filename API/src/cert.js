import express from 'express';

const response = '2A6E6CC917BB68678413ADB7E77B13C810B0EA50F6B1A8DBFB9E0845CECE9A6A\ncomodoca.com\na6e711cd1227e66';

const app = express();

const port = 3000;


// app.get('/.well-known/pki-validation/', (req, res) => {
//     // res.sendFile('E:/gbevplan/API/src/887B6BCAEE2D068631CED7E9BA907926.txt')
// });

app.use(express.static('./src'));

app.listen(port, () => {
    console.log('started server')
})