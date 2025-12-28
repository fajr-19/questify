require('dotenv').config();
const express = require('express');
const cors = require('cors');
const authRoutes = require('./routes/authRoutes');
const userRoutes = require('./routes/userRoutes');
const recommendationRoutes = require('./routes/recommendationRoutes');

const app = express();
app.use(cors());
app.use(express.json());

// Main Routes
app.use('/auth', authRoutes);
app.use('/user', userRoutes);
app.use('/recommendations', recommendationRoutes);
// Alias agar sinkron dengan lib/api_service.dart kamu
app.use('/artists', recommendationRoutes); 

app.get('/', (req, res) => res.json({ message: 'Questify API Running 🚀' }));

module.exports = app;