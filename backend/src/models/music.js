const mongoose = require('mongoose');

const musicSchema = new mongoose.Schema({
  title: { type: String, required: true },
  artist: { type: String, required: true },
  thumbnail: { type: String, required: true },
  audioUrl: { type: String, required: true },
  type: { type: String, enum: ['music', 'podcast'], default: 'music' },
  genre: [String],
}, { timestamps: true });

module.exports = mongoose.model('Music', musicSchema);