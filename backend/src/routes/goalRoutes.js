const express = require("express");
const {
  CreateGoal,
  GetGoals,
  DeleteGoal,
} = require("../controllers/goalController");
const router = express.Router();

router.route("/").get(GetGoals).post(CreateGoal);

router.route("/:id").delete(DeleteGoal);

module.exports = router;
