const mongoose = require("mongoose");

const contributionSchema = mongoose.Schema({
  amount: {
    type: Number,
    required: [true, "Contribution must have an amount"],
  },
  date: {
    type: Date,
    default: Date.now, // Automatically set the contribution date
  },
  note: String,
});

const goalSchema = mongoose.Schema({
  coverImage: {
    type: String,
    required: [true, "Goals should have cover images"],
  },
  goalName: {
    type: String,
    required: [true, "Goals should have a name"],
  },
  goalAmount: {
    type: Number,
    required: [true, "Goals should have an amount"],
  },
  goalAmountContributed: {
    type: [contributionSchema], // Array of contributions
    default: [],
  },
  goalCurrency: {
    type: String,
    required: [true, "Goals should have currencies specified"],
  },
  goalDeadline: Date,
  goalNote: String,
  goalColour: {
    type: String,
    default: "PrimaryPurple",
  },
  userId: {
    type: String,
    required: [true, "Goals cannot be created without a user"],
  },
});

const Goal = mongoose.model("Goal", goalSchema);

module.exports = Goal;
