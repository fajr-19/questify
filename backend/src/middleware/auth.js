const jwt = require('jsonwebtoken');

module.exports = (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    
    // Log untuk pengecekan di Runtime Logs Koyeb
    console.log("Incoming Auth Header:", authHeader);

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ message: 'No token provided or wrong format' });
    }
    
    const token = authHeader.split(' ')[1];
    
    // Verifikasi token menggunakan secret key dari environment variable
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded; 
    next();
  } catch (err) {
    console.error("JWT Error:", err.message);
    res.status(401).json({ message: 'Authentication failed', error: err.message });
  }
};