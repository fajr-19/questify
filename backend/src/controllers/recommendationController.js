const Music = require('../models/music');
const User = require('../models/user');

exports.getMLRecommendations = async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    const userFavs = [...(user.favoriteArtists || []), ...(user.favoritePodcasts || [])];

    let recommendations;

    if (userFavs.length > 0) {
      // ML Logic: Cari musik yang cocok dengan favorit user, ambil secara acak 15 lagu
      recommendations = await Music.aggregate([
        { $match: { artist: { $in: userFavs } } },
        { $sample: { size: 15 } }
      ]);
    }

    // Jika user belum punya favorit atau hasil favorit sedikit (< 5), tambahkan musik random
    if (!recommendations || recommendations.length < 5) {
      const randomSongs = await Music.aggregate([
        { $sample: { size: 15 } }
      ]);
      recommendations = recommendations ? [...recommendations, ...randomSongs] : randomSongs;
    }

    // Pastikan tidak ada duplikat ID dan batasi total 20 lagu
    const uniqueRecommendations = Array.from(new Set(recommendations.map(a => a._id.toString())))
      .map(id => recommendations.find(a => a._id.toString() === id))
      .slice(0, 20);

    res.json(uniqueRecommendations);
  } catch (err) {
    console.error("ML Recommendation Error:", err);
    res.status(500).json({ message: 'Error fetching recommendations' });
  }
};

exports.getPopularArtists = async (req, res) => {
  try {
    // 1. Ambil list artis unik dari database
    // Menggunakan aggregate agar lebih cepat pada data besar
    const artists = await Music.aggregate([
      { $group: { _id: "$artist", thumbnail: { $first: "$thumbnail" } } },
      { $sample: { size: 12 } } // Ambil 12 artis populer secara acak agar UI variatif
    ]);

    const formattedArtists = artists.map((item, index) => ({
      id: `art_${index}_${Date.now()}`,
      artist: item._id,
      title: "Artis Populer",
      // Gunakan thumbnail asli dari lagu mereka sebagai cover artis
      thumbnail: item.thumbnail || `https://ui-avatars.com/api/?name=${item._id}&background=random&color=fff&size=512`
    }));

    res.json(formattedArtists);
  } catch (err) {
    console.error("Popular Artists Error:", err);
    res.status(500).json({ message: 'Error fetching artists' });
  }
};

// TAMBAHKAN INI: Fitur Search untuk mendukung 1000 lagu kamu
exports.searchMusic = async (req, res) => {
  try {
    const query = req.query.q;
    if (!query) return res.json([]);

    const results = await Music.find({
      $or: [
        { title: { $regex: query, $options: 'i' } },
        { artist: { $regex: query, $options: 'i' } }
      ]
    }).limit(20);

    res.json(results);
  } catch (err) {
    res.status(500).json({ message: 'Search error' });
  }
};