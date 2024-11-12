const express = require("express");
const { CreateGoal, GetGoals } = require("../controllers/goalController");
const router = express.Router();

router.route("/").get(GetGoals).post(CreateGoal);

module.exports = router;
