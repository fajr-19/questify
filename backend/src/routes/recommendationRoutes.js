const express = require('express');
const router = express.Router();
const multer = require('multer');
const { storage } = require('../config/cloudinary');
const Music = require('../models/music'); // Pastikan path model sudah benar
const authMiddleware = require('../middleware/auth'); // Pastikan path middleware sudah benar

// Konfigurasi Multer menggunakan storage Cloudinary
const upload = multer({ storage: storage });

/**
 * @route   POST /recommendations/upload
 * @desc    Upload music/video/podcast to Cloudinary and save metadata to MongoDB
 * @access  Private (User/Admin)
 */
router.post('/upload', authMiddleware, upload.single('file'), async (req, res) => {
  try {
    // Pastikan ada file yang diupload
    if (!req.file) {
      return res.status(400).json({ message: "File tidak ditemukan. Pastikan field input adalah 'file'" });
    }

    const { title, artist, type, lyrics } = req.body;
    
    // Validasi data dasar
    if (!title || !artist) {
      return res.status(400).json({ message: "Title dan Artist wajib diisi" });
    }

    const newContent = new Music({
      title,
      artist,
      thumbnail: "https://via.placeholder.com/500", // Placeholder default
      audioUrl: req.file.path, // URL otomatis yang dihasilkan oleh Cloudinary
      type: type || 'music',
      // Parsing lirik karena dikirim sebagai string JSON dari Flutter
      lyrics: lyrics ? JSON.parse(lyrics) : [],
      uploadedBy: req.user.id // Diambil dari authMiddleware
    });

    await newContent.save();
    
    res.status(200).json({ 
      success: true, 
      message: "Konten berhasil diunggah ke Cloudinary dan MongoDB",
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