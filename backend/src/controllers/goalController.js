const Goal = require("../models/goal");

exports.GetGoals = async (req, res) => {
  try {
    const goals = await Goal.find({ userId: req.headers.authorisation });

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

// Create a new contribution
exports.AddContribution = async (req, res) => {
  try {
    const { id } = req.params;
    const { amount, date, note } = req.body;

    // Validate required fields
    if (!amount || !date || !note) {
      return res.status(400).json({
        status: "fail",
        message: "Amount, date, and note are required.",
      });
    }

    // Find the goal by ID
    const goal = await Goal.findById(id);
    if (!goal) {
      return res.status(404).json({
        status: "fail",
        message: "Goal not found.",
      });
    }

    const contributions = goal.goalAmountContributed.reduce(
      (sum, item) => sum + item.amount,
      0
    );

    if (contributions + amount > goal.goalAmount) {
      return res.status(400).send({
        status: "fail",
        message: "Your contribution cannot exceed your goal amount",
      });
    }

    // Add the new contribution to the goal
    const newContribution = { amount, date, note };
    goal.goalAmountContributed.push(newContribution);

    // Save the updated goal
    await goal.save();

    res.status(201).json({
      status: "success",
      message: "Contribution added successfully.",
      data: goal,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "An error occurred while adding the contribution.",
      error: error.message,
    });
  }
};

// Create a new contribution
exports.WithdrawContribution = async (req, res) => {
  try {
    const { id } = req.params;
    let { amount, date, note } = req.body;

    // Validate required fields
    if (!amount || !date || !note) {
      return res.status(400).json({
        status: "fail",
        message: "Amount, date, and note are required.",
      });
    }

    // Find the goal by ID
    const goal = await Goal.findById(id);
    if (!goal) {
      return res.status(404).json({
        status: "fail",
        message: "Goal not found.",
      });
    }

    const contributions = goal.goalAmountContributed.reduce(
      (sum, item) => sum + item.amount,
      0
    );

    if (contributions - amount < 0) {
      return res.status(400).json({
        status: "fail",
        message: "Amount should not exceed total contributions",
      });
    }

    amount = -amount;

    // Add the new contribution to the goal
    const newContribution = { amount, date, note };
    goal.goalAmountContributed.push(newContribution);

    // Save the updated goal
    await goal.save();

    res.status(201).json({
      status: "success",
      message: "Contribution withdrawn successfully.",
      data: goal,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "An error occurred while withdrawing from contributions.",
      error: error.message,
    });
  }
};
