const mongoose = require("mongoose");
const Goal = require("../models/goal");
const goalSeeds = require("../seed/GoalSeed");
require("dotenv").config({ path: "../.env" });

const MONGODB_URI = process.env.DB_CONNECTION;

mongoose
  .connect(MONGODB_URI)
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
