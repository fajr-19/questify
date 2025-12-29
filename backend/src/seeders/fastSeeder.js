require('dotenv').config();
const mongoose = require('mongoose');
const Music = require('../models/music');

const seedData = [
  {
    title: "Every Summertime",
    artist: "NIKI",
    thumbnail: "https://is1-ssl.mzstatic.com/image/thumb/Music126/v4/a5/97/a2/a597a212-bcc5-3db5-e020-fad26aa6217d/500x500bb.jpg",
    audioUrl: "PASTE_LINK_CLOUDINARY_DISINI_1.mp3",
    type: "music",
    genre: ["Pop"],
    lyrics: [
      { time: 0, text: "Instrumental Intro" },
      { time: 5, text: "Sipping on a coke and a rum" },
      { time: 10, text: "I'm a little drunk" },
      { time: 15, text: "Every summertime..." }
    ]
  },
  {
    title: "Podcast Self Improvement",
    artist: "Coach Justin",
    thumbnail: "https://via.placeholder.com/500",
    audioUrl: "PASTE_LINK_CLOUDINARY_DISINI_2.mp3",
    type: "podcast",
    genre: ["Education"],
    lyrics: [
      { time: 0, text: "Selamat datang di Podcast Self Improvement" },
      { time: 5, text: "Hari ini kita bahas cara konsisten belajar Flutter" }
    ]
  }
];

const fastSeed = async () => {
  try {
    console.log("Menghubungkan ke MongoDB Atlas...");
    await mongoose.connect(process.env.MONGO_URI);
    
    console.log("Membersihkan data lama...");
    await Music.deleteMany({}); // Hapus semua agar rapi
    
    console.log(`Memasukkan ${seedData.length} data baru...`);
    await Music.insertMany(seedData);

    console.log("✅ SEEDING BERHASIL!");
    process.exit();
  } catch (error) {
    console.error("❌ ERROR SEEDING:", error);
    process.exit(1);
  }
};

fastSeed();