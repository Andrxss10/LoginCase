const express = require('express');
const router = express.Router();
const db = require('../db'); // Si necesitas usar la base de datos
const { isAuthenticated } = require('../middlewares/authMiddleware'); // Utilizamos el middleware de autenticación de sesiones
const multer = require('multer'); // Manejo de imagenes en base de datos

// Render ISO login/register
router.get('/normasIso', isAuthenticated, (req, res) => {
    const alertData = req.session.alertData || {};
    req.session.alertData = null;
    res.render('normasIso', alertData);
});

// Render ISO seleccionada
router.get('/IsoSelect', isAuthenticated, (req, res) => {
    const alertData = req.session.alertData || {};
    req.session.alertData = null;
    res.render('IsoSelect', alertData);
});

// Render ISO2
router.get('/IsoForm9001', isAuthenticated, (req, res) => {
    const alertData = req.session.alertData || {};
    req.session.alertData = null;
    res.render('IsoForm9001', alertData);
});

// Render ISO2
router.get('/IsoForm27001', isAuthenticated, (req, res) => {
    const alertData = req.session.alertData || {};
    req.session.alertData = null;
    res.render('IsoForm27001', alertData);
});

// Render ISO2
router.get('/IsoChecklist9001', isAuthenticated, (req, res) => {
    const alertData = req.session.alertData || {};
    req.session.alertData = null;
    res.render('IsoChecklist9001', alertData);
});

// Render ISO2
router.get('/IsoChecklist27001', isAuthenticated, (req, res) => {
    const alertData = req.session.alertData || {};
    req.session.alertData = null;
    res.render('IsoChecklist27001', alertData);
});

module.exports = router;