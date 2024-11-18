const express = require("express");
const {
  CreateGoal,
  GetGoals,
  DeleteGoal,
  GetGoal,
} = require("../controllers/goalController");
const router = express.Router();

router.route("/").get(GetGoals).post(CreateGoal);

router.route("/:id").get(GetGoal).delete(DeleteGoal);

module.exports = router;
