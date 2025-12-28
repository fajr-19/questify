const mongoose = require('mongoose');

const musicSchema = new mongoose.Schema({
  title: { type: String, required: true },
  artist: { type: String, required: true },
  thumbnail: { type: String, required: true }, // Ini akan dipetakan ke coverUrl di Flutter
  audioUrl: { type: String, required: true },
  lyrics: { type: String, default: "" }, // Tambahan lirik
  description: { type: String, default: "" }, // Tambahan deskripsi
  type: { type: String, enum: ['music', 'podcast'], default: 'music' },
  genre: [String],
}, { timestamps: true });

module.exports = mongoose.model('Music', musicSchema);