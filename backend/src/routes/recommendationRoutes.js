const express = require('express');
const router = express.Router();
const Music = require('../models/music');
const authMiddleware = require('../middleware/auth');

// --- 1. GET ALL RECOMMENDATIONS (ML) ---
// Ini yang dipanggil Flutter di fetchMLRecommendations()
router.get('/ml', authMiddleware, async (req, res) => {
  try {
    // Mengambil semua musik, diurutkan dari yang terbaru
    const songs = await Music.find().sort({ createdAt: -1 });
    res.status(200).json(songs);
  } catch (err) {
    res.status(500).json({ message: "Gagal mengambil data", error: err.message });
  }
});

// --- 2. GET POPULAR ARTISTS ---
router.get('/popular', authMiddleware, async (req, res) => {
  try {
    const popular = await Music.find().limit(10);
    res.status(200).json(popular);
  } catch (err) {
    res.status(500).json({ message: "Gagal mengambil data populer", error: err.message });
  }
});

// --- 3. POST UPLOAD (Sudah Benar) ---
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
      uploadedBy: req.user.id 
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