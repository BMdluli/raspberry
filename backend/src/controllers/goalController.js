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

exports.GetGoal = async (req, res) => {
  try {
    const id = req.params.id;

    const goal = await Goal.findById(id);

    res.status(200).json({
      status: "success",
      data: goal,
    });

    console.log(id);
  } catch (error) {
    console.log(error);
  }
};

exports.CreateGoal = async (req, res) => {
  try {
    console.log(req.body);
    const newGoal = await Goal.create(req.body);

    res.status(200).json({
      status: "success",
      data: {
        newGoal,
      },
    });

    // console.log(req.body.goalDeadline + 556959600 * 1000);
  } catch (err) {
    console.log(err);
  }
};

exports.DeleteGoal = async (req, res) => {
  try {
    const result = await Goal.findByIdAndDelete(req.params.id);

    if (!result) {
      res.status(404).json({
        status: "fail",
        message: "Goal could not be found",
      });
    }

    res.status(204).json({
      status: "success",
    });
  } catch (err) {
    res.status(404).json({
      status: "fail",
      message: err,
    });
  }
};
