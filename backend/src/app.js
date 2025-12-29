require('dotenv').config();
const express = require('express');
const cors = require('cors');
const path = require('path');
const authRoutes = require('./routes/authRoutes');
const userRoutes = require('./routes/userRoutes');
const recommendationRoutes = require('./routes/recommendationRoutes');

const app = express();
app.use(cors());
app.use(express.json());

// Akses file lokal (cadangan jika masih ada file di folder public)
app.use('/uploads', express.static(path.join(__dirname, '../public/uploads')));

// Routes
app.use('/auth', authRoutes);
app.use('/user', userRoutes);

// Gabungkan semua yang berhubungan dengan musik/video di prefix recommendations
app.use('/recommendations', recommendationRoutes);

// Route /artists bisa dihapus jika isinya sama dengan recommendationRoutes 
// agar tidak terjadi tabrakan data (redundant)
// app.use('/artists', recommendationRoutes); 

app.get('/', (req, res) => res.json({ 
    message: 'Questify API Running 🚀',
    storage: 'Cloudinary Enabled',
    db: 'Connected'
}));

module.exports = app;