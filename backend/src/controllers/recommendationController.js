const axios = require('axios');
const Music = require('../models/music');

exports.searchMusic = async (req, res) => {
  try {
    const query = req.query.q;
    if (!query) return res.json([]);

    // 1. Cari dulu di database lokal (1000 lagu hasil seeder)
    let results = await Music.find({
      $or: [
        { title: { $regex: query, $options: 'i' } },
        { artist: { $regex: query, $options: 'i' } }
      ]
    }).limit(20);

    // 2. Jika di database lokal tidak ada, cari ke iTunes API secara LIVE
    if (results.length < 5) {
      const itunesResponse = await axios.get(
        `https://itunes.apple.com/search?term=${encodeURIComponent(query)}&entity=song&limit=10`
      );
      
      const liveResults = itunesResponse.data.results.map(item => ({
        title: item.trackName,
        artist: item.artistName,
        thumbnail: item.artworkUrl100.replace('100x100', '500x500'),
        audioUrl: item.previewUrl,
        type: 'music'
      }));
      
      // Gabungkan hasil lokal dan live
      results = [...results, ...liveResults];
    }

    res.json(results);
  } catch (err) {
    console.error("Search Error:", err);
    res.status(500).json({ message: 'Search error' });
  }
};