const Music = require('../models/music');
const User = require('../models/user');

exports.getMLRecommendations = async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    const userFavs = [...(user.favoriteArtists || []), ...(user.favoritePodcasts || [])];

    // ML Logic sederhana: Cari musik yang artisnya ada di list favorit user
    let recommendations = await Music.find({
      artist: { $in: userFavs }
    }).limit(10);

    // Jika belum ada yang cocok, kasih musik terbaru secara umum
    if (recommendations.length === 0) {
      recommendations = await Music.find().sort({ createdAt: -1 }).limit(10);
    }

    res.json(recommendations);
  } catch (err) {
    res.status(500).json({ message: 'Error fetching recommendations' });
  }
};

exports.getPopularArtists = async (req, res) => {
  try {
    // Mengambil artis unik dari koleksi Music
    const artists = await Music.find().distinct('artist');
    const formattedArtists = artists.map((name, index) => ({
      id: `art_${index}`,
      artist: name,
      title: "Artis Populer",
      thumbnail: `https://ui-avatars.com/api/?name=${name}&background=random&color=fff&size=512`
    }));
    res.json(formattedArtists);
  } catch (err) {
    res.status(500).json({ message: 'Error fetching artists' });
  }
};