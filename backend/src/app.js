// D:\ProjectPPL\questify\backend\src\app.js
require('dotenv').config();
const express = require('express');
const cors = require('cors'); // Tambahan Wajib
const connectDB = require('./config/db');
const authRoutes = require('./routes/authRoutes');
const User = require('./models/user');
const jwt = require('jsonwebtoken');

const app = express();

// ================= MIDDLEWARE =================
app.use(cors()); // Tambahan Wajib: Agar Flutter tidak kena blokir
app.use(express.json());

// Middleware Autentikasi
const authMiddleware = (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader) return res.status(401).json({ message: 'No token provided' });

    const token = authHeader.split(' ')[1];
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (err) {
    res.status(401).json({ message: 'Invalid or expired token' });
  }
};

// ================= ROUTES =================
app.get('/', (req, res) => {
  res.json({ status: 'OK', message: 'Questify Backend is running 🚀' });
});

app.use('/auth', authRoutes);

/**
 * ROUTE ONBOARDING
 * Logika diperbaiki: Onboarding dianggap selesai HANYA jika user sudah pilih artis.
 */
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

    // 1. Update Profile (Tahap 1)
    if (full_name) user.name = full_name;
    if (date_of_birth) user.dob = new Date(date_of_birth);
    if (gender) user.gender = gender;
    
    // 2. Update Artists (Tahap 2)
    if (favorite_artists) user.favoriteArtists = favorite_artists;
    if (favorite_podcasts) user.favoritePodcasts = favorite_podcasts;

    // KUNCI PERBAIKAN: Hanya tandai selesai jika artis sudah diisi
    // Jadi saat isi nama (CreateAccountScreen), status masih false.
    // Saat pilih artis (ChooseArtistScreen), status jadi true.
    if (favorite_artists && favorite_artists.length > 0) {
       user.onboardingCompleted = true;
    }

    await user.save();

    res.json({ 
      message: 'Data saved successfully', 
      user: {
        id: user._id,
        name: user.name,
        onboardingCompleted: user.onboardingCompleted
      } 
    });
  } catch (err) {
    console.error('Onboarding Error:', err);
    res.status(500).json({ message: 'Failed to save onboarding data' });
  }
});

connectDB();
module.exports = app;