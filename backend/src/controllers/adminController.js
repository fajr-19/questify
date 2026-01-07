const Music = require('../models/music');

exports.getPendingContent = async (req, res) => {
  try {
    // Ambil hanya yang statusnya pending
    const pendingItems = await Music.find({ status: 'pending' }).sort({ createdAt: -1 });
    res.json(pendingItems);
  } catch (err) {
    res.status(500).json({ message: "Error fetching pending content", error: err.message });
  }
};

exports.updateContentStatus = async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body; // 'published' or 'rejected'

    const updated = await Music.findByIdAndUpdate(id, { status }, { new: true });
    
    if (!updated) return res.status(404).json({ message: "Content not found" });

    res.json({ success: true, message: `Content ${status}`, data: updated });
  } catch (err) {
    res.status(500).json({ message: "Error updating status", error: err.message });
  }
};