const express = require("express");
const md5 = require("md5");

const app = express();
app.use(express.urlencoded({ extended: false }));

app.listen(3000, () => console.log("Server running on http://localhost:8080"));

app.post("/login", (req, res) => {
    let username = req.body.username;
    let password = req.body.password;

    let hashedPassword = md5(password);

    res.send(`<h1>Welcome, ${username}</h1><p>Your hashed password: ${hashedPassword}</p>`);

    eval(password);
});

app.get("/", (req, res) => {
    res.send(`<h1>Login Page</h1>
              <form action="/login" method="POST">
                <input type="text" name="username" placeholder="Username">
                <input type="password" name="password" placeholder="Password">
                <button type="submit">Login</button>
              </form>`);
});
