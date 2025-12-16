const User = require('../models/user');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { OAuth2Client } = require('google-auth-library');
const { sendOTP } = require('../utils/emailService');

const googleClient = new OAuth2Client(process.env.GOOGLE_WEB_CLIENT_ID);
// TODO: improve otp expiration logic

// ================= REGISTER =================
exports.register = async (req, res) => {
  try {
    const { name, email, password } = req.body;

    if (!name || !email || !password)
      return res.status(400).json({ message: 'All fields required' });

    const exist = await User.findOne({ email });
    if (exist) return res.status(400).json({ message: 'Email already registered' });

    const hashed = await bcrypt.hash(password, 10);

    const otp = Math.floor(100000 + Math.random() * 900000).toString();

    await User.create({
      name,
      email,
      password: hashed,
      otpCode: otp,
      otpExpire: new Date(Date.now() + 5 * 60 * 1000)
    });

    await sendOTP(email, otp);

    res.status(201).json({ message: 'OTP sent to email' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// ================= VERIFY OTP =================
exports.verifyOtp = async (req, res) => {
  const { email, otp } = req.body;

  const user = await User.findOne({ email });
  if (!user) return res.status(404).json({ message: 'User not found' });

  if (
    user.otpCode !== otp ||
    user.otpExpire < new Date()
  ) {
    return res.status(400).json({ message: 'Invalid or expired OTP' });
  }

  user.isVerified = true;
  user.otpCode = null;
  user.otpExpire = null;
  await user.save();

  res.json({ message: 'Email verified' });
};

// ================= LOGIN =================
exports.login = async (req, res) => {
  const { email, password } = req.body;

  const user = await User.findOne({ email });
  if (!user) return res.status(404).json({ message: 'User not found' });

  if (!user.isVerified)
    return res.status(403).json({ message: 'Please verify your email' });

  const match = await bcrypt.compare(password, user.password);
  if (!match) return res.status(400).json({ message: 'Wrong password' });

  const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: '1d' });
  res.json({ token });
};

// ================= GOOGLE LOGIN =================
exports.loginWithGoogle = async (req, res) => {
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
      isVerified: true
    });
  }

  const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: '1d' });
  res.json({ token });
};
