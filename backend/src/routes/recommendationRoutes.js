const express = require('express');
const router = express.Router();
const authMiddleware = require('../middleware/auth');
const Music = require('../models/music');
const User = require('../models/user');

// Endpoint untuk mendapatkan rekomendasi berdasarkan favorit user (ML Logic)
router.get('/ml', authMiddleware, async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    const favs = [...(user.favoriteArtists || []), ...(user.favoritePodcasts || [])];
    
    // Cari musik yang artisnya ada di daftar favorit user
    let result = await Music.find({ artist: { $in: favs } });
    
    // Jika tidak ada kecocokan, ambil 10 lagu random sebagai fallback
    if (result.length === 0) result = await Music.find().limit(10);
    
    res.json(result);
  } catch (err) { 
    res.status(500).send("Error fetching recommendations"); 
  }
});

// Endpoint untuk mendapatkan daftar artis unik
router.get('/artists', authMiddleware, async (req, res) => {
    try {
      const artists = await Music.find().distinct('artist');
      res.json(artists.map(name => ({
        id: name,
        artist: name,
        title: "Artis",
        thumbnail: `https://ui-avatars.com/api/?name=${name}&background=random`
      })));
    } catch (err) { 
      res.status(500).send("Error fetching artists"); 
    }
});

/**
 * TAMBAHAN UNTUK SISTEM HYBRID SERIUS
 * Endpoint: POST /recommendations/cache-youtube
 * Fungsi: Menyimpan youtubeId ke dokumen Music agar pemutaran selanjutnya instan
 */
router.post('/cache-youtube', authMiddleware, async (req, res) => {
  try {
    const { musicId, youtubeId } = req.body;
    
    // Update dokumen musik berdasarkan ID dan masukkan youtubeId-nya
    const updatedMusic = await Music.findByIdAndUpdate(
      musicId, 
      { youtubeId: youtubeId }, 
      { new: true }
    );

    if (!updatedMusic) {
      return res.status(404).json({ message: "Lagu tidak ditemukan" });
    }

    res.json({ success: true, message: "YouTube ID berhasil dicache" });
  } catch (err) {
    console.error("Cache YouTube Error:", err);
    res.status(500).json({ message: "Gagal menyimpan cache YouTube" });
  }
});

module.exports = router;