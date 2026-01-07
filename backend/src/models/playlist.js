const mongoose = require('mongoose');

const playlistSchema = new mongoose.Schema({
  name: { type: String, required: true },
  description: { type: String, default: "" },
  coverUrl: { type: String, default: "" },
  
  author: { type: mongoose.Schema.Types.ObjectId, ref: 'User' }, // Pembuat
  authorName: { type: String },

  isCollaborative: { type: Boolean, default: false },
  isBlend: { type: Boolean, default: false },

  // Daftar lagu di playlist
  songs: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Music' }],
}, { timestamps: true });

module.exports = mongoose.model('Playlist', playlistSchema);