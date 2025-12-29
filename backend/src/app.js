// D:\ProjectPPL\questify\backend\src\app.js
require('dotenv').config();
const express = require('express');
const cors = require('cors');
const path = require('path');
const authRoutes = require('./routes/authRoutes');
const userRoutes = require('./routes/userRoutes');
const recommendationRoutes = require('./routes/recommendationRoutes');

const app = express();
app.use(cors());

// PERBAIKAN: Tambahkan limit 50MB (atau sesuaikan kebutuhan)
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ limit: '50mb', extended: true }));

app.use('/uploads', express.static(path.join(__dirname, '../public/uploads')));

app.use('/auth', authRoutes);
app.use('/user', userRoutes);
app.use('/recommendations', recommendationRoutes);

app.get('/', (req, res) => res.json({ 
    message: 'Questify API Running 🚀',
    storage: 'Cloudinary Enabled',
    status: 'Ready'
}));

module.exports = app;