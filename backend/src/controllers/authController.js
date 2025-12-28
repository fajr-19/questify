const User = require('../models/user');
const jwt = require('jsonwebtoken');
const { OAuth2Client } = require('google-auth-library');
const googleClient = new OAuth2Client(process.env.GOOGLE_WEB_CLIENT_ID);

exports.loginWithGoogle = async (req, res) => {
  try {
    const { idToken } = req.body;
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

    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: '7d' });
    res.json({ success: true, token, isNewUser: !user.onboardingCompleted, user });
  } catch (err) {
    res.status(401).json({ success: false, message: 'Google login failed' });
  }
};

exports.updateOnboarding = async (req, res) => {
  try {
    const { full_name, date_of_birth, gender, favorite_artists, favorite_podcasts } = req.body;
    const user = await User.findById(req.user.id);
    
    if (full_name) user.name = full_name;
    if (date_of_birth) user.dob = new Date(date_of_birth);
    user.gender = gender;
    user.favoriteArtists = favorite_artists;
    user.favoritePodcasts = favorite_podcasts;
    user.onboardingCompleted = true;

    await user.save();
    res.json({ success: true, user });
  } catch (err) {
    res.status(500).json({ success: false, message: 'Gagal update onboarding' });
  }
};