// src/controllers/authController.js
const User = require('../models/user');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { OAuth2Client } = require('google-auth-library');
const { sendOTPEmail } = require('../utils/emailService');

const googleClient = new OAuth2Client(process.env.GOOGLE_WEB_CLIENT_ID);

// ================= REGISTER =================
exports.register = async (req, res) => {
  try {
    const { name, email, password } = req.body;

    if (!name || !email || !password) {
      return res.status(400).json({ message: 'All fields required' });
    }

    const exist = await User.findOne({ email });
    if (exist) {
      return res.status(400).json({ message: 'Email already registered' });
    }

    const hashed = await bcrypt.hash(password, 10);
    const otp = Math.floor(100000 + Math.random() * 900000).toString();

    // ✅ KIRIM OTP EMAIL
    await sendOTPEmail(email, otp);

    // ✅ SIMPAN USER SETELAH EMAIL BERHASIL
    await User.create({
      name,
      email,
      password: hashed,
      otpCode: otp,
      otpExpire: new Date(Date.now() + 5 * 60 * 1000),
      isVerified: false,
    });

    res.status(201).json({ message: 'OTP sent to email' });
  } catch (err) {
    console.error('EMAIL ERROR:', err);
    res.status(500).json({ message: 'Failed to send OTP email' });
  }
};

// ================= VERIFY OTP =================
exports.verifyOtp = async (req, res) => {
  try {
    const { email, otp } = req.body;

    const user = await User.findOne({ email });
    if (!user)
      return res.status(404).json({ message: 'User not found' });

    if (!user.otpCode || user.otpExpire < new Date())
      return res.status(400).json({ message: 'OTP expired' });

    if (user.otpCode !== otp)
      return res.status(400).json({ message: 'Invalid OTP' });

    user.isVerified = true;
    user.otpCode = null;
    user.otpExpire = null;
    await user.save();

    res.json({ message: 'Email verified' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// ================= LOGIN =================
exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email });
    if (!user)
      return res.status(404).json({ message: 'User not found' });

    if (!user.isVerified)
      return res.status(403).json({ message: 'EMAIL_NOT_VERIFIED' });

    const match = await bcrypt.compare(password, user.password);
    if (!match)
      return res.status(400).json({ message: 'Wrong password' });

    const token = jwt.sign(
      { id: user._id },
      process.env.JWT_SECRET,
      { expiresIn: '1d' }
    );

    res.json({ token });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// ================= GOOGLE LOGIN =================
exports.loginWithGoogle = async (req, res) => {
  try {
    const { idToken } = req.body;

    const ticket = await googleClient.verifyIdToken({
      idToken,
      audience: process.env.GOOGLE_WEB_CLIENT_ID,
    });

    const { sub, email, name } = ticket.getPayload();

    let user = await User.findOne({ googleId: sub });

    if (!user) {
      user = await User.create({
        googleId: sub,
        email,
        name,
        isVerified: true,
      });
    }

    const token = jwt.sign(
      { id: user._id },
      process.env.JWT_SECRET,
      { expiresIn: '1d' }
    );

    res.json({ token });
  } catch (err) {
    res.status(401).json({ message: 'Google login failed' });
  }
};
