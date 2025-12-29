const express = require('express');
const router = express.Router();
const multer = require('multer');
const { storage } = require('../config/cloudinary');
const Music = require('../models/music');
const authMiddleware = require('../middleware/auth');

// Multer juga harus diberi limit yang sama dengan express
const upload = multer({ 
  storage: storage,
  limits: { fileSize: 100 * 1024 * 1024 } 
});

router.post('/upload', authMiddleware, upload.single('file'), async (req, res) => {
  try {
    if (!req.file) return res.status(400).json({ message: "File tidak terdeteksi" });

    const { title, artist, type, lyrics } = req.body;

    const newContent = new Music({
      title,
      artist,
      thumbnail: "https://via.placeholder.com/500",
      audioUrl: req.file.path, // URL hasil upload Cloudinary
      type: type || 'music',
      lyrics: lyrics ? JSON.parse(lyrics) : [],
      uploadedBy: req.user.id
    });

    await newContent.save();
    res.status(200).json({ success: true, data: newContent });
  } catch (err) {
    console.error("LOG UPLOAD ERROR:", err);
    res.status(500).json({ message: "Gagal simpan konten", error: err.message });
  }
});

module.exports = router;