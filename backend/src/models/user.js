const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  googleId: { type: String, required: true, unique: true },
  name: { type: String, required: true },
  email: { type: String, required: true },
  avatar: String,

  // Data Onboarding
  dob: Date,
  gender: { type: String, default: null }, // Enum dihapus agar lebih fleksibel
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

// Middleware Level Up
userSchema.pre('save', async function() {
  const xpNeededPerLevel = 100;
  const calculatedLevel = Math.floor(this.xp / xpNeededPerLevel) + 1;
  if (calculatedLevel > this.level) {
    this.level = calculatedLevel;
  }
});

module.exports = mongoose.model('User', userSchema);