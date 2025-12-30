const express = require('express');
const router = express.Router();
const Music = require('../models/music');
const authMiddleware = require('../middleware/auth');

router.post('/upload', authMiddleware, async (req, res) => {
  try {
    const { title, artist, type, audioUrl, lyrics } = req.body;

    // Validasi input minimal
    if (!title || !audioUrl) {
      return res.status(400).json({ message: "Judul dan URL Audio wajib diisi" });
    }

    // Pastikan thumbnail dikirim karena di Model itu 'required: true'
    const newContent = new Music({
      title: title,
      artist: artist || "Unknown Artist",
      thumbnail: "https://via.placeholder.com/500", 
      audioUrl: audioUrl,
      type: type || 'music',
      // Jika lyrics kosong atau bukan format yang benar, kirim array kosong
      lyrics: Array.isArray(lyrics) ? lyrics : [], 
      uploadedBy: req.user.id
    });

    await newContent.save();
    
    console.log("✅ Berhasil simpan ke MongoDB:", title);
    res.status(200).json({ success: true, data: newContent });

  } catch (err) {
    // Ini akan memunculkan detail error di Runtime Logs Koyeb kamu
    console.error("❌ MongoDB Save Error Detail:", err.errors || err); 
    res.status(500).json({ 
      success: false, 
      message: "Gagal simpan ke database", 
      error: err.message 
    });
  }
});

module.exports = router;