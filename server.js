const express = require('express');
const bodyParser = require('body-parser');
const session = require('express-session');

const app = express();
const port = process.env.PORT || 8080;

app.use(bodyParser.urlencoded({ extended: true }));

app.use(session({
    secret: '123456',
    resave: true,
    saveUninitialized: true,
    cookie: { secure: false }
}));

const users = { admin: 'password123' };

app.get('/', (req, res) => {
    res.send(
        `<h2>Login</h2>
        <form method="POST" action="/login">
            <input type="text" name="username" placeholder="Username" required />
            <input type="password" name="password" placeholder="Password" required />
            <button type="submit">Login</button>
        </form>`
    );
});

app.post('/login', (req, res) => {
    const { username, password } = req.body;
    
    if (users[username] === password) {
        req.session.user = username;
        res.send(`Welcome ${username}! <br/> <a href="/profile">Go to profile</a>`);
    } else {
        res.send('Invalid credentials');
    }
});

app.get('/profile', (req, res) => {
    if (!req.session.user) {
        return res.redirect('/');
    }
    res.send(`<h2>Welcome, ${req.session.user}!</h2>`);
});

app.get('/admin', (req, res) => {
    if (req.query.token) {
        res.send('Admin Access Granted');
    } else {
        res.send('Access Denied');
    }
});

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}/`);
});
