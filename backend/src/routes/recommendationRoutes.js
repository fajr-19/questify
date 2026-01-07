const express = require('express');
const router = express.Router();
const Music = require('../models/music');
const User = require('../models/user'); // Tambah ini
const authMiddleware = require('../middleware/auth');

// GET ML (Hanya tampilkan yang published)
router.get('/ml', authMiddleware, async (req, res) => {
  try {
    const songs = await Music.find({ status: 'published' }).sort({ createdAt: -1 });
    res.status(200).json(songs);
  } catch (err) {
    res.status(500).json({ message: "Gagal mengambil data", error: err.message });
  }
});

// GET POPULAR (Hanya tampilkan yang published)
router.get('/popular', authMiddleware, async (req, res) => {
  try {
    const popular = await Music.find({ status: 'published' }).limit(10);
    res.status(200).json(popular);
  } catch (err) {
    res.status(500).json({ message: "Gagal mengambil data populer", error: err.message });
  }
});

// POST UPLOAD (REVISI LENGKAP)
router.post('/upload', authMiddleware, async (req, res) => {
  try {
    const { title, artist, type, audioUrl, coverUrl, lyrics, aboutArtist, credits } = req.body;
    
    // Ambil nama uploader
    const uploader = await User.findById(req.user.id);

    const newContent = new Music({
      title,
      artist: artist || uploader.name,
      thumbnail: coverUrl || "https://via.placeholder.com/500",
      coverUrl: coverUrl,
      audioUrl,
      type: type || 'music',
      aboutArtist,
      credits,
      lyrics: Array.isArray(lyrics) ? lyrics : [],
      uploadedBy: req.user.id,
      uploaderName: uploader.name,
      status: 'pending' // Default PENDING biar direview admin
    });

    await newContent.save();
    res.status(201).json({ message: "Berhasil upload, menunggu review admin", data: newContent });
  } catch (err) {
    res.status(500).json({ message: "Gagal upload", error: err.message });
  }
});

module.exports = router;