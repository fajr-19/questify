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
    
    if (!user) {
      user = await User.create({
        googleId: sub,
        email,
        name,
        avatar: picture,
        onboardingCompleted: false
      });
    }

    // Buat token JWT
    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: '7d' });

    res.json({
      success: true,
      token,
      isNewUser: !user.onboardingCompleted, // Jika onboarding belum kelar, dianggap user baru
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        avatar: user.avatar,
        onboardingCompleted: user.onboardingCompleted
      },
    });
  } catch (err) {
    console.error("Google Login Error:", err);
    res.status(401).json({ success: false, message: 'Google login failed' });
  }
};