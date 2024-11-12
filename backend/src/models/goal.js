const mongoose = require("mongoose");

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
    required: [true, "Goals can not be created without a user"],
  },
});

const Goal = mongoose.model("Goal", goalSchema);

module.exports = Goal;
