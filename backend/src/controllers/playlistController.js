const Playlist = require('../models/playlist');
const User = require('../models/user');

exports.createPlaylist = async (req, res) => {
  try {
    const { name, isCollaborative, isBlend, description } = req.body;
    const user = await User.findById(req.user.id);

    const newPlaylist = await Playlist.create({
      name,
      description,
      isCollaborative,
      isBlend,
      author: user._id,
      authorName: user.name,
      songs: [] // Awalnya kosong
    });

    res.status(201).json(newPlaylist);
  } catch (err) {
    res.status(500).json({ message: "Failed to create playlist", error: err.message });
  }
};

exports.getUserPlaylists = async (req, res) => {
  try {
    // Ambil playlist yang dibuat oleh user ini
    const playlists = await Playlist.find({ author: req.user.id }).sort({ createdAt: -1 });
    res.json(playlists);
  } catch (err) {
    res.status(500).json({ message: "Error fetching playlists", error: err.message });
  }
};