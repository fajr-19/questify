// D:\ProjectPPL\questify\backend\src\models\user.js
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

// ==========================================================
// MIDDLEWARE: Logika Level Up Otomatis
// FIX: Hapus parameter 'next' karena menggunakan async/await
// ==========================================================
userSchema.pre('save', async function() {
  const xpNeededPerLevel = 100;
  const calculatedLevel = Math.floor(this.xp / xpNeededPerLevel) + 1;
  
  if (calculatedLevel > this.level) {
    this.level = calculatedLevel;
  }
  // Di Mongoose 5.x ke atas, async function tidak perlu memanggil next()
});

module.exports = mongoose.model('User', userSchema);