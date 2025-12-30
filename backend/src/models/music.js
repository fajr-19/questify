const mongoose = require('mongoose');

const musicSchema = new mongoose.Schema({
  title: { type: String, required: true },
  artist: { type: String, default: "Unknown Artist" }, 
  thumbnail: { type: String, default: "https://via.placeholder.com/500" }, 
  audioUrl: { type: String, required: true }, 
  // Dibuat array biasa agar fleksibel jika format lirik dari Flutter berubah
  lyrics: { type: Array, default: [] }, 
  type: { type: String, default: 'music' },
  // Menambahkan description karena field ini ada di dokumen Atlas kamu
  description: { type: String, default: "" }, 
  genre: [String],
  // Pastikan ID user yang upload tersimpan sebagai relasi
  uploadedBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' }, 
}, { timestamps: true });

module.exports = mongoose.model('Music', musicSchema);