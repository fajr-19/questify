require('dotenv').config();
const express = require('express');
const cors = require('cors');
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

// 1. Get Profile (PENTING untuk HomeScreen Flutter)
app.get('/user/me', authMiddleware, async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ message: 'User not found' });
    res.json(user);
  } catch (err) {
    res.status(500).json({ message: 'Server error' });
  }
});

// 2. Onboarding Route
app.post('/user/onboarding', authMiddleware, async (req, res) => {
  try {
    const { full_name, date_of_birth, gender, favorite_artists, favorite_podcasts } = req.body;
    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ message: 'User not found' });

    if (full_name) user.name = full_name;
    if (date_of_birth) user.dob = new Date(date_of_birth);
    if (gender) user.gender = gender;
    if (favorite_artists) user.favoriteArtists = favorite_artists;
    if (favorite_podcasts) user.favoritePodcasts = favorite_podcasts;

    // Selesaikan onboarding jika user sudah sampai tahap pilih artis/podcast
    user.onboardingCompleted = true;
    await user.save();

    res.json({ success: true, user });
  } catch (err) {
    res.status(500).json({ message: 'Server error' });
  }
});

// 3. Add XP Route (Gamifikasi)
app.post('/user/add-xp', authMiddleware, async (req, res) => {
  try {
    const { xpAmount } = req.body;
    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ message: 'User not found' });

    user.xp += (xpAmount || 10); // Default nambah 10 XP
    await user.save(); // Level up otomatis dihandle oleh userSchema.pre('save')

    res.json({ success: true, xp: user.xp, level: user.level });
  } catch (err) {
    res.status(500).json({ message: 'Server error' });
  }
});

// 4. Dummy Recommendations & Artists (Agar App tidak kosong)
app.get('/recommendations/ml', authMiddleware, async (req, res) => {
  res.json([
    { id: "1", title: "Midnight City", artist: "M83", imageUrl: "https://placehold.co/400x400/png?text=M83" },
    { id: "2", title: "Starboy", artist: "The Weeknd", imageUrl: "https://placehold.co/400x400/png?text=Weeknd" },
    { id: "3", title: "Blinding Lights", artist: "The Weeknd", imageUrl: "https://placehold.co/400x400/png?text=Music" }
  ]);
});

app.get('/artists', authMiddleware, async (req, res) => {
  res.json([
    { id: "a1", artist: "Taylor Swift", imageUrl: "https://placehold.co/400x400/png?text=Taylor" },
    { id: "a2", artist: "Tulus", imageUrl: "https://placehold.co/400x400/png?text=Tulus" },
    { id: "a3", artist: "NIKI", imageUrl: "https://placehold.co/400x400/png?text=NIKI" }
  ]);
});

module.exports = app;