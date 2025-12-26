require('dotenv').config();
const express = require('express');
const cors = require('cors');
const connectDB = require('./config/db');
const authRoutes = require('./routes/authRoutes');
const User = require('./models/user');
const jwt = require('jsonwebtoken');

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Auth Middleware Internal
const authMiddleware = (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ message: 'Unauthorized' });
    }
    const token = authHeader.split(' ')[1];
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (err) {
    res.status(401).json({ message: 'Invalid token' });
  }
};

// Routes
app.get('/', (req, res) => res.json({ message: 'Questify API Running 🚀' }));
app.use('/auth', authRoutes);

// Onboarding Route
app.post('/user/onboarding', authMiddleware, async (req, res) => {
  try {
    const { 
      full_name, 
      date_of_birth, 
      gender, 
      favorite_artists, 
      favorite_podcasts 
    } = req.body;

    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ message: 'User not found' });

    // Update data profile
    if (full_name) user.name = full_name;
    if (date_of_birth) user.dob = new Date(date_of_birth);
    if (gender) user.gender = gender;
    
    // Update minat
    if (favorite_artists) user.favoriteArtists = favorite_artists;
    if (favorite_podcasts) user.favoritePodcasts = favorite_podcasts;

    // Selesai jika minimal ada artis yang dipilih (Tahap akhir onboarding)
    if (favorite_artists && favorite_artists.length > 0) {
      user.onboardingCompleted = true;
    }

    await user.save();

    res.json({ 
      success: true, 
      message: 'Onboarding success',
      user: { name: user.name, onboardingCompleted: user.onboardingCompleted }
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

module.exports = app;