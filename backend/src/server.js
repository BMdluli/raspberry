if (process.env.NODE_ENV !== "production") {
  require("dotenv").config();
}
const express = require("express");
const goalRouter = require("./routes/goalRoutes");
const mongoose = require("mongoose");

const app = express();
const PORT = process.env.PORT | 3000;

// MIDDLEWARE
app.use(express.json());

let DB_CONNECTION = process.env.DB_CONNECTION;

if (process.env.NODE_ENV === "production")
  DB_CONNECTION = process.env.DB_CONNECTION_PROD;

mongoose.connect(DB_CONNECTION).then(() => {
  console.log("Database connected successfully");
});

// ROUTES
app.use("/api/v1/goals", goalRouter);

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
