const mysql = require('mysql2');

const connection = mysql.createConnection({
    host:'localhost',
    user:'root',
    pass:'',
    database:'note_easy'
});

module.exports = connection;
