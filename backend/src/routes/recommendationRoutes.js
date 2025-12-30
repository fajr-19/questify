const express = require('express');
const router = express.Router();
const Music = require('../models/music');
const authMiddleware = require('../middleware/auth');

router.post('/upload', authMiddleware, async (req, res) => {
  try {
    const { title, artist, type, audioUrl, lyrics, description } = req.body;

    // Validasi input wajib
    if (!title || !audioUrl) {
      return res.status(400).json({ message: "Judul dan URL Audio wajib diisi" });
    }

    const newContent = new Music({
      title: title,
      artist: artist || "Unknown Artist",
      // Menggunakan placeholder jika thumbnail tidak dikirim
      thumbnail: "https://via.placeholder.com/500", 
      audioUrl: audioUrl,
      type: type || 'music',
      description: description || "Uploaded via Questify App",
      // Memastikan lirik tersimpan dalam format array
      lyrics: Array.isArray(lyrics) ? lyrics : [], 
      uploadedBy: req.user.id // Diambil dari token hasil login
    });

    await newContent.save();
    
    console.log("✅ Berhasil simpan ke MongoDB Atlas:", title);
    res.status(200).json({ success: true, data: newContent });

  } catch (err) {
    // Log ini sangat penting untuk melihat detail error di dashboard Koyeb
    console.error("❌ MongoDB Save Error Detail:", err.message); 
    res.status(500).json({ 
      success: false, 
      message: "Gagal simpan ke database", 
      error: err.message 
    });
  }
});

module.exports = router;