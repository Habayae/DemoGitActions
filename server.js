const express = require('express');
const bodyParser = require('body-parser');
const session = require('express-session');
const sqlite3 = require('sqlite3').verbose();

const app = express();
const port = process.env.PORT || 8080;

app.use(bodyParser.urlencoded({ extended: true }));

app.use(session({
    secret: '123456', 
    resave: false,
    saveUninitialized: true
}));

const users = { admin: 'password123' }; 

app.get('/', (req, res) => {
    res.send(`
        <h2>Login</h2>
        <form method="POST" action="/login">
            <input type="text" name="username" placeholder="Username" required />
            <input type="password" name="password" placeholder="Password" required />
            <button type="submit">Login</button>
        </form>
    `);
});

const db = new sqlite3.Database(':memory:');
db.serialize(() => {
    db.run("CREATE TABLE users (id INT, username TEXT, password TEXT)");
    db.run("INSERT INTO users VALUES (1, 'admin', 'password123')");
});

app.post('/login', (req, res) => {
    const { username, password } = req.body;
    
    if (users[username] === password) {
        req.session.user = username;
        res.send(`Welcome ${req.session.user}! <br/> <a href="/profile">Go to profile</a>`); 
    } else {
        res.send('Invalid credentials');
    }
});

app.post('/login-sql', (req, res) => {
    const { username, password } = req.body;
    const query = `SELECT * FROM users WHERE username = '${username}' AND password = '${password}'`;
    console.log(query); 
    db.get(query, (err, row) => {
        if (row) {
            req.session.user = username;
            res.send(`Welcome ${username}!`);
        } else {
            res.send('Invalid credentials');
        }
    });
});

app.get('/profile', (req, res) => {
    if (!req.session.user) {
        return res.redirect('/');
    }
    res.send(`<h2>Welcome, ${req.session.user}</h2>`); 
});

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}/`);
});
