// import library
const passport = require('passport');
const GoogleStrategy = require('passport-google-oauth20').Strategy;
const User = require('../models/User');

// serialize / deserialize user untuk session (walau kita pakai JWT, ini standar)
passport.serializeUser((user, done) => done(null, user.id));
passport.deserializeUser((id, done) => {
  User.findById(id)
    .then(user => done(null, user))
    .catch(err => done(err, null));
});

// Google OAuth2 Strategy
passport.use(
  new GoogleStrategy(
    {
      clientID: process.env.GOOGLE_WEB_CLIENT_ID,        // dari .env
      clientSecret: process.env.GOOGLE_WEB_CLIENT_SECRET || "",  // kosong kalau belum punya
      callbackURL: "/auth/google/callback",             // route callback
    },
    async (accessToken, refreshToken, profile, done) => {
      try {
        // cek apakah user sudah ada di DB
        let user = await User.findOne({ googleId: profile.id });
        if (!user) {
          // buat user baru kalau belum ada
          user = await User.create({
            googleId: profile.id,
            name: profile.displayName,
            email: profile.emails[0].value
          });
        }
        done(null, user);
      } catch (err) {
        done(err, false);
      }
    }
  )
);

module.exports = passport;
