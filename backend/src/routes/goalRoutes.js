const express = require("express");
const {
  CreateGoal,
  GetGoals,
  DeleteGoal,
  GetGoal,
  UpdateGoal,
  AddContribution,
} = require("../controllers/goalController");
const router = express.Router();

router.route("/").get(GetGoals).post(CreateGoal);

router.route("/:id").get(GetGoal).patch(UpdateGoal).delete(DeleteGoal);

router.route("/:id/contributions").post(AddContribution);

module.exports = router;
