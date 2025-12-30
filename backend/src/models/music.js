const mongoose = require('mongoose');

const musicSchema = new mongoose.Schema({
  title: { type: String, required: true },
  artist: { type: String, default: "Unknown Artist" }, 
  thumbnail: { type: String, default: "https://via.placeholder.com/500" }, 
  audioUrl: { type: String, required: true }, 
  lyrics: { type: Array, default: [] }, // Menggunakan array fleksibel
  type: { type: String, enum: ['music', 'podcast', 'video'], default: 'music' },
  description: { type: String, default: "" }, 
  genre: [String],
  uploadedBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
}, { timestamps: true });

module.exports = mongoose.model('Music', musicSchema);