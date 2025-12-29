require('dotenv').config();
const express = require('express');
const cors = require('cors');
const path = require('path');
const authRoutes = require('./routes/authRoutes');
const userRoutes = require('./routes/userRoutes');
const recommendationRoutes = require('./routes/recommendationRoutes');

const app = express();
app.use(cors());

// Limit diatur 100MB agar tidak terjadi 'Connection reset' pada file besar
app.use(express.json({ limit: '100mb' }));
app.use(express.urlencoded({ limit: '100mb', extended: true }));

app.use('/uploads', express.static(path.join(__dirname, '../public/uploads')));

// Routing
app.use('/auth', authRoutes);
app.use('/user', userRoutes);
app.use('/recommendations', recommendationRoutes);

app.get('/', (req, res) => res.json({ status: 'Questify API Running 🚀' }));

module.exports = app;