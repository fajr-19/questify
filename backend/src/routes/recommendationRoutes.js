const express = require('express');
const router = express.Router();
const authMiddleware = require('../middleware/auth');
const Music = require('../models/music');
const User = require('../models/user');

router.get('/ml', authMiddleware, async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    const favs = [...(user.favoriteArtists || []), ...(user.favoritePodcasts || [])];
    
    let result = await Music.find({ artist: { $in: favs } });
    if (result.length === 0) result = await Music.find().limit(10);
    
    res.json(result);
  } catch (err) { res.status(500).send("Error"); }
});

router.get('/artists', authMiddleware, async (req, res) => {
    try {
      const artists = await Music.find().distinct('artist');
      res.json(artists.map(name => ({
        id: name,
        artist: name,
        title: "Artis",
        thumbnail: `https://ui-avatars.com/api/?name=${name}&background=random`
      })));
    } catch (err) { res.status(500).send("Error"); }
});

module.exports = router;