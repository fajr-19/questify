require('dotenv').config();
const express = require('express');
const cors = require('cors');
const path = require('path');
const authRoutes = require('./routes/authRoutes');
const userRoutes = require('./routes/userRoutes');
const recommendationRoutes = require('./routes/recommendationRoutes');

const app = express();
app.use(cors());

// Limit ditingkatkan ke 100mb untuk mendukung file video/audio berkualitas tinggi
app.use(express.json({ limit: '100mb' }));
app.use(express.urlencoded({ limit: '100mb', extended: true }));

// Akses file lokal jika diperlukan
app.use('/uploads', express.static(path.join(__dirname, '../public/uploads')));

// Routes
app.use('/auth', authRoutes);
app.use('/user', userRoutes);
app.use('/recommendations', recommendationRoutes);

app.get('/', (req, res) => res.json({ 
    message: 'Questify API Running 🚀',
    storage: 'Cloudinary Enabled',
    status: 'Ready'
}));

module.exports = app;