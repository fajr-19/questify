require('dotenv').config();
const mongoose = require('mongoose');
const axios = require('axios');
const Music = require('../models/music');

// Kategori pencarian agar dapet banyak variasi lagu
const searchTerms = [
  'Indonesian Pop', 'Tulus', 'Hindia', 'Lofi Girl', 
  'Jazz Chill', 'Top Hits 2024', 'Podcast Self Improvement'
];

const seedMusic = async () => {
  try {
    // 1. Koneksi ke Database
    console.log("Connecting to MongoDB...");
    await mongoose.connect(process.env.MONGO_URI);
    console.log("Connected! 🌱");

    // 2. Bersihkan data lama (Opsional)
    console.log("Clearing old music data...");
    await Music.deleteMany();

    let allSongs = [];

    // 3. Loop pencarian ke iTunes API
    for (const term of searchTerms) {
      console.log(`Searching for: ${term}...`);
      
      // Kita ambil 150 lagu per term
      const response = await axios.get(
        `https://itunes.apple.com/search?term=${encodeURIComponent(term)}&entity=song&limit=150`
      );

      const results = response.data.results;
      
      const mappedSongs = results.map(item => ({
        title: item.trackName || "Unknown Title",
        artist: item.artistName || "Unknown Artist",
        // Mengubah resolusi gambar dari 100x100 ke 500x500 agar tidak pecah di HP
        thumbnail: item.artworkUrl100 ? item.artworkUrl100.replace('100x100', '500x500') : "https://via.placeholder.com/500",
        audioUrl: item.previewUrl, // Link MP3 legal (30 detik preview)
        type: term.toLowerCase().includes('podcast') ? 'podcast' : 'music',
        genre: [item.primaryGenreName || "Music"],
        lyrics: `This is a preview of ${item.trackName}. Full lyrics available on premium.`,
        description: `Album: ${item.collectionName}. Released: ${new Date(item.releaseDate).getFullYear()}`
      }));

      allSongs.push(...mappedSongs);
      console.log(`Fetched ${mappedSongs.length} items for ${term}`);
    }

    // 4. Simpan ke MongoDB
    console.log(`Inserting ${allSongs.length} total items into Database...`);
    await Music.insertMany(allSongs);

    console.log("✅ SUCCESS: 1000+ Songs Seeded! 🌱");
    process.exit();
    
  } catch (error) {
    console.error("❌ SEED ERROR:", error);
    process.exit(1);
  }
};

seedMusic();