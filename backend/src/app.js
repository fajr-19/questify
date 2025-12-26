require('dotenv').config();
const express = require('express');
const connectDB = require('./config/db');
const authRoutes = require('./routes/authRoutes');
const User = require('./models/user');
const jwt = require('jsonwebtoken');

const app = express();

// ================= MIDDLEWARE =================
app.use(express.json());

// Middleware Autentikasi (Untuk melindungi rute onboarding)
const authMiddleware = (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader) return res.status(401).json({ message: 'No token provided' });

    const token = authHeader.split(' ')[1];
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded; // Menyimpan id user dari token ke req.user
    next();
  } catch (err) {
    res.status(401).json({ message: 'Invalid or expired token' });
  }
};

// ================= ROUTES =================

// Test route
app.get('/', (req, res) => {
  res.json({
    status: 'OK',
    message: 'Questify Backend is running 🚀',
  });
});

// Route Autentikasi (Google Login)
app.use('/auth', authRoutes);

/**
 * ROUTE ONBOARDING (ALUR PENDAFTARAN BARU)
 * Digunakan oleh Flutter: ApiService.updateOnboardingData
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

    // Cari user berdasarkan ID yang ada di token JWT
    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ message: 'User not found' });

    // Update data profil (Hanya update field yang dikirim dari Flutter)
    if (full_name) user.name = full_name;
    if (date_of_birth) user.dob = new Date(date_of_birth);
    if (gender) user.gender = gender;
    
    // Gunakan $addToSet di MongoDB agar tidak ada artis/podcast duplikat
    if (favorite_artists) user.favoriteArtists = favorite_artists;
    if (favorite_podcasts) user.favoritePodcasts = favorite_podcasts;

    // KUNCI: Tandai onboarding sudah selesai agar besok tidak muncul lagi di Flutter
    user.onboardingCompleted = true;

    await user.save();

    res.json({ 
      message: 'Onboarding data saved successfully', 
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

// ================= DB CONNECT & START =================
connectDB();

module.exports = app;