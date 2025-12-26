const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  // --- Data Autentikasi & Dasar ---
  googleId: { 
    type: String, 
    required: true, 
    unique: true 
  },
  name: { 
    type: String, 
    required: true 
  },
  email: { 
    type: String, 
    required: true 
  },
  avatar: String,

  // --- Data Onboarding (Dari Create Account Screen) ---
  dob: Date,
  gender: { 
    type: String, 
    enum: ['Male', 'Female', 'Other', null],
    default: null 
  },
  favoriteArtists: [String],
  favoritePodcasts: [String],
  onboardingCompleted: { 
    type: Boolean, 
    default: false 
  },

  // --- Fitur Utama: Gamifikasi (Questify Core) ---
  level: { 
    type: Number, 
    default: 1 
  },
  xp: { 
    type: Number, 
    default: 0 
  },
  diamonds: { 
    type: Number, 
    default: 0 
  },

  // Sistem Misi Harian (Daily Quests)
  dailyQuests: [
    {
      title: String,       // Contoh: "Dengarkan 3 Lagu"
      target: Number,      // Contoh: 3
      current: { 
        type: Number, 
        default: 0 
      },
      isClaimed: { 
        type: Boolean, 
        default: false 
      },
      rewardXP: { 
        type: Number, 
        default: 10 
      },
      rewardDiamonds: { 
        type: Number, 
        default: 5 
      }
    }
  ],

  // --- Fitur Musik ---
  premiumStatus: {
    isPremium: { type: Boolean, default: false },
    expiryDate: Date
  },
  playlists: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Playlist'
  }]

}, { 
  timestamps: true // Otomatis membuat createdAt dan updatedAt
});

// Middleware pre-save untuk logika Level Up otomatis (Opsional)
userSchema.pre('save', function(next) {
  // Contoh logika: Setiap 100 XP naik 1 level
  const xpNeededPerLevel = 100;
  const calculatedLevel = Math.floor(this.xp / xpNeededPerLevel) + 1;
  
  if (calculatedLevel > this.level) {
    this.level = calculatedLevel;
    // Bisa tambah bonus diamond otomatis di sini jika mau
  }
  next();
});

module.exports = mongoose.model('User', userSchema);