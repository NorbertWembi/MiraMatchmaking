import mongoose from "mongoose";

const reportSchema = new mongoose.Schema({
  reporterId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
  reportedId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
  reason: { type: String, required: true },
  description: { type: String },
  createdAt: { type: Date, default: Date.now },
  resolved: { type: Boolean, default: false }
});

const Report = mongoose.model("Report", reportSchema);
export default Report;
