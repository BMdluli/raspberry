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

exports.UpdateGoal = async (req, res) => {
  try {
    const id = { _id: req.params.id }; // Filter to find the document by ID
    const update = req.body; // Update data from the request body

    // Find the document by ID and update it
    const updatedGoal = await Goal.findOneAndUpdate(id, update, { new: true });

    if (!updatedGoal) {
      // Handle case when no document is found
      return res.status(404).json({
        status: "fail",
        message: "Goal not found",
      });
    }

    // Return the updated goal
    res.status(200).json({
      status: "success",
      data: {
        updatedGoal,
      },
    });
  } catch (error) {
    // Log the error and send a 500 Internal Server Error response
    console.error(error);
    res.status(500).json({
      status: "error",
      message: "An error occurred while updating the goal",
    });
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
