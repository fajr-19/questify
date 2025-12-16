const mongoose = require('mongoose');

const connectDB = async () => {
  if (!process.env.MONGO_URI) {
    console.error('Error: MONGO_URI is not defined!');
    process.exit(1);
  }

  try {
    await mongoose.connect(process.env.MONGO_URI, {
      tls: true,               // pastikan TLS dipaksa, optional di Atlas
      tlsAllowInvalidCertificates: false, // bisa true buat testing lokal
    });
    console.log('MongoDB Atlas connected');
  } catch (error) {
    console.error('MongoDB connection failed:', error);
    process.exit(1);
  }
};

module.exports = connectDB;
