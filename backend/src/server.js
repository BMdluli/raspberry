require("dotenv").config();
const express = require("express");
const cookieParser = require("cookie-parser");
const router = require("./routes");

const app = express();
const PORT = process.env.PORT | 3000;

// MIDDLEWARE
app.use(express.json());
app.use(cookieParser());

// ROUTES
app.use(router);

app.get("/", (req, res) => {
  res.send("Hello World");
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
