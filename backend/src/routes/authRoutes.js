const express = require('express');
const router = express.Router();
const { loginWithGoogle } = require('../controllers/authController');

router.post('/google', loginWithGoogle);

module.exports = router;