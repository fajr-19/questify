const express = require('express');
const router = express.Router();
const authMiddleware = require('../middleware/auth');
const { updateOnboarding } = require('../controllers/authController');
const User = require('../models/user');
const Music = require('../models/music');

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

module.exports = router;