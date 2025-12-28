require('dotenv').config();
const mongoose = require('mongoose');
const Music = require('../models/music');

const seedData = [
  {
    title: "Hati-Hati di Jalan",
    artist: "Tulus",
    thumbnail: "https://www.wowkeren.com/display/images/photo/2022/03/04/00415147.jpg",
    audioUrl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
    type: "music"
  },
  {
    title: "Evaluasi",
    artist: "Hindia",
    thumbnail: "https://asset.kompas.com/crops/O_S5r1G7Q7uI5f0Y_8_yTzS8-6k=/0x0:1000x667/750x500/data/photo/2023/06/16/648be48e89f8d.jpg",
    audioUrl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
    type: "music"
  }
];

mongoose.connect(process.env.MONGO_URI)
  .then(async () => {
    await Music.deleteMany();
    await Music.insertMany(seedData);
    console.log("Data seeded! 🌱");
    process.exit();
  });