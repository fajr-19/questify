require('dotenv').config();
const express = require('express');
const connectDB = require('./config/db');
const passport = require('passport');
require('./config/passport'); // passport strategy
const session = require('cookie-session'); // kalau pakai session
const authRoutes = require('./routes/authRoutes');

const app = express();

// Middleware
app.use(express.json());
app.use(session({
  maxAge: 24*60*60*1000,
  keys: [process.env.SESSION_KEY || 'secretkey'] // fallback key
}));
app.use(passport.initialize());
app.use(passport.session());

// Routes
app.use('/auth', authRoutes);

module.exports = app; // export app
