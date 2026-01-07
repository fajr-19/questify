require('dotenv').config();
const express = require('express');
const cors = require('cors');
const path = require('path');
const authRoutes = require('./routes/authRoutes');
const userRoutes = require('./routes/userRoutes');
const recommendationRoutes = require('./routes/recommendationRoutes');
const adminRoutes = require('./routes/adminRoutes'); // TAMBAHAN

const app = express();
app.use(cors());

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use('/uploads', express.static(path.join(__dirname, '../public/uploads')));

// Routing
app.use('/auth', authRoutes);
app.use('/user', userRoutes);
app.use('/recommendations', recommendationRoutes);
app.use('/admin', adminRoutes); // REGISTER ROUTE ADMIN

app.get('/', (req, res) => res.json({ status: 'Questify API Running 🚀' }));

module.exports = app;