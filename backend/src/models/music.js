const mongoose = require('mongoose');

const musicSchema = new mongoose.Schema({
  title: { type: String, required: true },
  artist: { type: String, required: true },
  thumbnail: { type: String, required: true },
  audioUrl: { type: String, required: true }, // Tetap simpan preview iTunes sebagai fallback
  youtubeId: { type: String, default: "" },   // TAMBAHKAN INI: Untuk menyimpan cache ID YouTube
  lyrics: { type: String, default: "" },
  description: { type: String, default: "" },
  type: { type: String, enum: ['music', 'podcast'], default: 'music' },
  genre: [String],
}, { timestamps: true });

module.exports = mongoose.model('Music', musicSchema);