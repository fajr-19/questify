const express = require('express');
const router = express.Router();
const { register, login, loginWithGoogle, verifyOtp } = require('../controllers/authController');
const authMiddleware = require('../middleware/authMiddleware');

router.post('/register', register);
router.post('/login', login);
router.post('/google', loginWithGoogle);
router.post('/verify-otp', verifyOtp);

router.get('/profile', authMiddleware, (req, res) => {
  res.json({ message: 'Authorized', userId: req.user });
});

module.exports = router;
