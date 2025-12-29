const multer = require('multer');
const { storage } = require('../config/cloudinary');
const upload = multer({ storage: storage });

// Endpoint Upload Baru
router.post('/upload', authMiddleware, upload.single('file'), async (req, res) => {
  try {
    const { title, artist, type, lyrics } = req.body;
    
    const newContent = new Music({
      title,
      artist,
      thumbnail: "https://via.placeholder.com/500", // Bisa diupdate dengan upload image juga
      audioUrl: req.file.path, // URL otomatis dari Cloudinary
      type: type || 'music',
      lyrics: JSON.parse(lyrics),
      uploadedBy: req.user.id
    });

    await newContent.save();
    res.json({ success: true, data: newContent });
  } catch (err) {
    res.status(500).json({ message: "Gagal upload", error: err.message });
  }
});