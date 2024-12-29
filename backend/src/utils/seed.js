const mongoose = require("mongoose");
const Goal = require("../models/goal");
const goalSeeds = require("../seed/GoalSeed");
require("dotenv").config({ path: "../.../.env" });

let DB_CONNECTION = process.env.DB_CONNECTION;

if (process.env.NODE_ENV === "production") console.log(DB_CONNECTION);
DB_CONNECTION = process.env.DB_CONNECTION_PROD;

mongoose
  .connect(DB_CONNECTION)
  .then(() => {
    console.log("Connected to MongoDB");
    return Goal.deleteMany({}); // Clear existing data in the goals collection
  })
  .then(() => {
    console.log("Old goals data cleared");
    return Goal.insertMany(goalSeeds); // Insert the seed data
  })
  .then(() => {
    console.log("Goal data seeded successfully");
    mongoose.connection.close();
  })
  .catch((err) => {
    console.error("Error seeding goal data:", err);
    mongoose.connection.close();
  });
