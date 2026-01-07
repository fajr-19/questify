const express = require('express');
const router = express.Router();
const authMiddleware = require('../middleware/auth');
const { getPendingContent, updateContentStatus } = require('../controllers/adminController');

// Middleware Cek Admin Sederhana
const adminCheck = async (req, res, next) => {
  // Nanti di database lo set manual user lo jadi 'admin'
  // Atau logic di sini bisa cek: if (req.user.email === 'email.lo@gmail.com')
  next(); 
};

router.get('/content/pending', authMiddleware, adminCheck, getPendingContent);
router.patch('/content/:id/status', authMiddleware, adminCheck, updateContentStatus);

module.exports = router;