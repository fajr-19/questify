const express = require('express');
const router = express.Router();
const Music = require('../models/music');
const authMiddleware = require('../middleware/auth');

// Endpoint: POST /recommendations/upload
router.post('/upload', authMiddleware, async (req, res) => {
  try {
    // Backend sekarang menerima audioUrl yang sudah diupload Flutter ke Cloudinary
    const { title, artist, type, audioUrl, lyrics } = req.body;

    if (!title || !audioUrl) {
      return res.status(400).json({ message: "Judul dan File Audio wajib ada" });
    }

    const newContent = new Music({
      title,
      artist: artist || "Unknown Artist",
      thumbnail: "https://via.placeholder.com/500", // Bisa diupdate nanti
      audioUrl: audioUrl,
      type: type || 'music',
      lyrics: lyrics ? (typeof lyrics === 'string' ? JSON.parse(lyrics) : lyrics) : [],
      uploadedBy: req.user.id
    });

    await newContent.save();
    res.status(200).json({ success: true, data: newContent });
  } catch (err) {
    console.error("Save Error:", err);
    res.status(500).json({ message: "Gagal simpan konten", error: err.message });
  }
});

module.exports = router;