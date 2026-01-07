const express = require('express');
const router = express.Router();
const authMiddleware = require('../middleware/auth');
const { updateOnboarding } = require('../controllers/authController');
const { createPlaylist, getUserPlaylists } = require('../controllers/playlistController');
const User = require('../models/user');

// Get Profile
router.get('/me', authMiddleware, async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    res.json(user);
  } catch (err) { res.status(500).send("Error"); }
});

// Post Onboarding
router.post('/onboarding', authMiddleware, updateOnboarding);

// Add XP
router.post('/add-xp', authMiddleware, async (req, res) => {
  try {
    const { xpAmount } = req.body;
    const user = await User.findById(req.user.id);
    user.xp += (xpAmount || 10);
    await user.save();
    res.json({ success: true, xp: user.xp, level: user.level });
  } catch (err) { res.status(500).send("Error"); }
});

// --- PLAYLIST ROUTES (BARU) ---
router.get('/playlists', authMiddleware, getUserPlaylists);
router.post('/playlists/create', authMiddleware, createPlaylist);

// --- PREMIUM ROUTE (BARU) ---
router.post('/premium/subscribe', authMiddleware, async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    user.premiumStatus.isPremium = true;
    user.premiumStatus.expiryDate = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000); // +30 Hari
    await user.save();
    res.json({ success: true, message: "Premium activated!" });
  } catch (err) {
    res.status(500).json({ message: "Failed to subscribe" });
  }
});

// --- LEADERBOARD & QUESTS (MOCK/REAL) ---
router.get('/leaderboard', authMiddleware, async (req, res) => {
  const users = await User.find().sort({ xp: -1 }).limit(10).select('name xp avatar');
  // Tambah ranking manual
  const rankedUsers = users.map((u, index) => ({
    name: u.name, xp: u.xp, avatar: u.avatar, rank: index + 1
  }));
  res.json(rankedUsers);
});

router.get('/quests', authMiddleware, async (req, res) => {
  // Return quests dummy atau dari DB user
  const user = await User.findById(req.user.id);
  // Kalau kosong, isi default (Logic simple)
  if (!user.dailyQuests || user.dailyQuests.length === 0) {
     res.json([
       { _id: 'q1', title: 'Dengar 3 Lagu', description: 'Dapatkan 20 XP', progress: 1, goal: 3, isCompleted: false, icon: 'fire' },
       { _id: 'q2', title: 'Upload Karya', description: 'Dapatkan 50 XP', progress: 0, goal: 1, isCompleted: false, icon: 'lightning' }
     ]);
  } else {
     res.json(user.dailyQuests);
  }
});

router.post('/quests/claim', authMiddleware, (req, res) => {
  // Logic simple claim sukses
  res.json({ success: true });
});

module.exports = router;