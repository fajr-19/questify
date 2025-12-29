const mongoose = require('mongoose');

const musicSchema = new mongoose.Schema({
  title: { type: String, required: true },
  artist: { type: String, required: true },
  thumbnail: { type: String, required: true },
  audioUrl: { type: String, required: true }, 
  lyrics: [
    {
      time: { type: Number, required: true },
      text: { type: String, required: true }
    }
  ],
  type: { type: String, enum: ['music', 'podcast', 'video'], default: 'music' },
  genre: [String],
  uploadedBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' }, // Menyimpan ID user yang upload
}, { timestamps: true });

module.exports = mongoose.model('Music', musicSchema);