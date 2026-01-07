const mongoose = require('mongoose');

const musicSchema = new mongoose.Schema({
  title: { type: String, required: true },
  artist: { type: String, default: "Unknown Artist" }, 
  
  // Sinkronisasi dengan Frontend (coverUrl)
  thumbnail: { type: String, default: "https://via.placeholder.com/500" }, 
  coverUrl: { type: String }, // Tambahan biar fleksibel

  audioUrl: { type: String, required: true }, 
  lyrics: { type: Array, default: [] }, 
  type: { type: String, enum: ['music', 'podcast', 'video'], default: 'music' },
  aboutArtist: { type: String, default: "" }, 
  credits: { type: String, default: "" },
  genre: [String],
  
  uploadedBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  uploaderName: { type: String }, // Biar admin tau siapa yang upload

  // SISTEM REVIEW (TAMBAHAN PENTING)
  status: { type: String, enum: ['pending', 'published', 'rejected'], default: 'published' } 
}, { timestamps: true });

module.exports = mongoose.model('Music', musicSchema);