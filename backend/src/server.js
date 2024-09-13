require("dotenv").config();
const express = require("express");
const authRouter = require("./routes/authRoutes");

// Clerk({ apiKey: process.env.CLERK_SECRET_KEY });

const app = express();
const PORT = process.env.PORT | 3000;

// MIDDLEWARE
app.use(express.json());

// ROUTES
app.use("/api", authRouter);

app.get("/", (req, res) => {
  res.send("Hello World");
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
