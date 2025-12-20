require('dotenv').config();
const express = require('express');
const connectDB = require('./config/db');
const authRoutes = require('./routes/authRoutes');

const app = express();

// Middleware
app.use(express.json());

// Test route (WAJIB)
app.get('/', (req, res) => {
  res.json({
    status: 'OK',
    message: 'Questify Backend is running 🚀',
  });
});

// Routes
app.use('/auth', authRoutes);

// DB connect
connectDB();

module.exports = app;
