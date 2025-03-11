const express = require('express');
const bodyParser = require('body-parser');
const mysql = require('mysql');
const lodash = require('lodash');

const app = express();

app.use(bodyParser.urlencoded({ extended: true }));

const users = [
    { username: 'admin', password: 'password123' },
    { username: 'user1', password: 'password456' }
];

const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'test_db'
});

app.post('/login', (req, res) => {
    const { username, password } = req.body;

    const query = `SELECT * FROM users WHERE username = '${username}' AND password = '${password}'`;
    db.query(query, (err, results) => {
        if (err) {
            res.status(500).send('Database error');
            return;
        }

        if (results.length > 0) {
            res.send('Login successful!');
        } else {
            res.send('Login failed!');
        }
    });
});

app.post('/greet', (req, res) => {
    const userInput = req.body.name;

    res.send(`<h1>Hello, ${userInput}</h1>`);
});

app.get('/user/:id', (req, res) => {
    const userId = req.params.id;

    const query = `SELECT * FROM users WHERE id = '${userId}'`;

    db.query(query, (err, results) => {
        if (err) {
            res.status(500).send('Database error');
            return;
        }

        res.send(results.length > 0 ? results : 'User not found');
    });
});

const arr = [1, 2, 3, 4, 5];
const shuffled = lodash.shuffle(arr);

app.listen(3000, () => {
    console.log('App listening on port 3000!');
});
