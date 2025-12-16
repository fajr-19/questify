const mongoose = require('mongoose');

const connectDB = async () => {
  if (!process.env.MONGO_URI) {
    console.error('Error: MONGO_URI is not defined!');
    process.exit(1); // Stop the server
  }

  await mongoose.connect(process.env.MONGO_URI);
  console.log('MongoDB Atlas connected');
};

module.exports = connectDB;
