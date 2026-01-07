const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  googleId: { type: String, required: true, unique: true },
  name: { type: String, required: true },
  email: { type: String, required: true },
  avatar: String,
  
  // Role Admin/User (TAMBAHAN PENTING)
  role: { type: String, enum: ['user', 'admin'], default: 'user' },

  // Data Onboarding
  dob: Date,
  gender: { type: String, default: null }, 
  favoriteArtists: { type: [String], default: [] },
  favoritePodcasts: { type: [String], default: [] },
  onboardingCompleted: { type: Boolean, default: false },

  // Gamifikasi
  level: { type: Number, default: 1 },
  xp: { type: Number, default: 0 },
  diamonds: { type: Number, default: 0 },

  dailyQuests: [{
    title: String,
    target: Number,
    current: { type: Number, default: 0 },
    isClaimed: { type: Boolean, default: false },
    rewardXP: { type: Number, default: 10 },
    rewardDiamonds: { type: Number, default: 5 }
  }],

  premiumStatus: {
    isPremium: { type: Boolean, default: false },
    expiryDate: Date
  }
}, { timestamps: true });

module.exports = mongoose.model('User', userSchema);