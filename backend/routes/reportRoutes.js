import express from "express";
import Report from "../models/Report.js";

const router = express.Router();

router.post("/", async (req, res) => {
  try {
    const { reporterId, reportedId, reason, description } = req.body;

    if (!reporterId || !reportedId || !reason) {
      return res.status(400).json({ message: "Missing required fields" });
    }

    const newReport = new Report({
      reporterId,
      reportedId,
      reason,
      description,
    });

    await newReport.save();
    res.status(201).json({ message: "Report submitted successfully" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Server error" });
  }
});

router.get("/", async (req, res) => {
  try {
    const reports = await Report.find()
      .populate("reporterId", "username email")
      .populate("reportedId", "username email")
      .sort({ createdAt: -1 });
    res.json(reports);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Server error" });
  }
});

export default router;
