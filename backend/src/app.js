require('dotenv').config();
const express = require('express');
const cors = require('cors');
const path = require('path'); // Tambahkan ini
const authRoutes = require('./routes/authRoutes');
const userRoutes = require('./routes/userRoutes');
const recommendationRoutes = require('./routes/recommendationRoutes');

const app = express();
app.use(cors());
app.use(express.json());

// AKTIFKAN AKSES FILE MP3 SECARA PUBLIK
app.use('/uploads', express.static(path.join(__dirname, '../public/uploads')));

// Main Routes
app.use('/auth', authRoutes);
app.use('/user', userRoutes);
app.use('/recommendations', recommendationRoutes);
app.use('/artists', recommendationRoutes); 

app.get('/', (req, res) => res.json({ message: 'Questify API Running 🚀' }));

module.exports = app;