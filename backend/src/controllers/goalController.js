const Goal = require("../models/goal");

exports.GetGoals = async (req, res) => {
  try {
    const goals = await Goal.find();

    console.log(goals);

    res.status(200).json({
      status: "success",
      results: goals.length,
      data: {
        goals,
      },
    });
  } catch (err) {}
};

exports.CreateGoal = async (req, res) => {
  try {
    // console.log(req.body);
    const newGoal = await Goal.create(req.body);

    res.status(200).json({
      status: "success",
      data: {
        newGoal,
      },
    });
  } catch (err) {
    console.log(err);
  }
};
