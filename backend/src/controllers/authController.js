// D:\ProjectPPL\questify\backend\src\controllers\authController.js
const User = require('../models/user');
const jwt = require('jsonwebtoken');
const { OAuth2Client } = require('google-auth-library');

const googleClient = new OAuth2Client(process.env.GOOGLE_WEB_CLIENT_ID);

exports.loginWithGoogle = async (req, res) => {
  try {
    const { idToken } = req.body;
    if (!idToken) return res.status(400).json({ message: 'idToken is required' });

    const ticket = await googleClient.verifyIdToken({
      idToken,
      audience: process.env.GOOGLE_WEB_CLIENT_ID,
    });

    const { sub, email, name, picture } = ticket.getPayload();

    let user = await User.findOne({ googleId: sub });
    let isNewUser = false;

    if (!user) {
      isNewUser = true; // User benar-benar baru buat akun
      user = await User.create({
        googleId: sub,
        email,
        name,
        avatar: picture,
        onboardingCompleted: false
      });
    } else if (!user.onboardingCompleted) {
      isNewUser = true; // Akun ada tapi belum beresin onboarding
    }

    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: '1d' });

    res.json({
      message: 'Login success',
      token,
      isNewUser, // Ini yang dibaca Flutter
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        avatar: user.avatar,
      },
    });
  } catch (err) {
    console.error(err);
    res.status(401).json({ message: 'Google login failed' });
  }
};