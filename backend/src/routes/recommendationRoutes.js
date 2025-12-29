const express = require('express');
const router = express.Router();
const multer = require('multer');
const { storage } = require('../config/cloudinary');
const Music = require('../models/music');
const authMiddleware = require('../middleware/auth');

// Konfigurasi Multer dengan limit 100MB
const upload = multer({ 
    storage: storage,
    limits: { fileSize: 100 * 1024 * 1024 } 
});

/**
 * @route   POST /recommendations/upload
 */
router.post('/upload', authMiddleware, upload.single('file'), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ message: "File tidak ditemukan." });
    }

    const { title, artist, type, lyrics } = req.body;
    
    if (!title || !artist) {
      return res.status(400).json({ message: "Title dan Artist wajib diisi" });
    }

    const newContent = new Music({
      title,
      artist,
      thumbnail: "https://via.placeholder.com/500", 
      audioUrl: req.file.path, // URL dari Cloudinary
      type: type || 'music',
      lyrics: lyrics ? JSON.parse(lyrics) : [],
      uploadedBy: req.user.id 
    });

    await newContent.save();
    
    res.status(200).json({ 
      success: true, 
      message: "Konten berhasil diunggah",
      data: newContent 
    });

  } catch (err) {
    console.error("Upload Error:", err);
    res.status(500).json({ 
      success: false, 
      message: "Gagal upload konten", 
      error: err.message 
    });
  }
});

module.exports = router;