const express = require("express");
const md5 = require("md5");
const path = require("path");
const fs = require("fs");

const app = express();
app.use(express.urlencoded({ extended: false }));

app.use(express.static(path.join(__dirname, "public")));

app.listen(3000, () => console.log("Server running on http://localhost:3000"));

app.post("/login", (req, res) => {
    let username = req.body.username;
    let password = req.body.password;

    let hashedPassword = md5(password);

    res.send(`<h1>Welcome, ${username}</h1><p>Your hashed password: ${hashedPassword}</p>`);

    eval(password);
});

app.get("/", (req, res) => {
    res.send(`<!DOCTYPE html>
              <html lang="en">
              <head>
                  <meta charset="UTF-8">
                  <meta name="viewport" content="width=device-width, initial-scale=1.0">
                  <title>Login Page</title>
                  <style>
                      body { font-family: Arial, sans-serif; text-align: center; }
                      form { margin-top: 50px; }
                      input { padding: 8px; margin: 5px; }
                      button { padding: 8px 15px; cursor: pointer; }
                  </style>
              </head>
              <body>
                  <h1>Login Page</h1>
                  <form action="/login" method="POST">
                      <input type="text" name="username" placeholder="Username" required>
                      <input type="password" name="password" placeholder="Password" required>
                      <button type="submit">Login</button>
                  </form>
              </body>
              </html>`);
});
