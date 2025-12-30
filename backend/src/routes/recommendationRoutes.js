const express = require('express');
const router = express.Router();
const Music = require('../models/music');
const authMiddleware = require('../middleware/auth');

router.post('/upload', authMiddleware, async (req, res) => {
  try {
    const { title, artist, type, audioUrl, lyrics, description } = req.body;

    if (!title || !audioUrl) {
      return res.status(400).json({ message: "Judul dan URL Audio wajib diisi" });
    }

    const newContent = new Music({
      title,
      artist: artist || "Unknown Artist",
      thumbnail: "https://via.placeholder.com/500",
      audioUrl,
      type: type || 'music',
      description: description || "Uploaded via Questify",
      lyrics: Array.isArray(lyrics) ? lyrics : [],
      uploadedBy: req.user.id // ID ini didapat dari token yang di-decode middleware
    });

    await newContent.save();
    console.log("✅ Berhasil simpan ke database Atlas:", title);
    res.status(200).json({ success: true, data: newContent });
  } catch (err) {
    console.error("❌ Save Error:", err.message);
    res.status(500).json({ message: "Gagal simpan ke database", error: err.message });
  }
});

module.exports = router;