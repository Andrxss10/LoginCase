const express = require('express');
const router = express.Router();
const db = require('../db'); // Si necesitas usar la base de datos
const { isAuthenticated } = require('../middlewares/authMiddleware'); // Utilizamos el middleware de autenticación de sesiones
const multer = require('multer'); // Manejo de imagenes en base de datos

router.get('/principal', isAuthenticated, (req, res) => {
    // 1. Primero verificar que el usuario existe
    const verifyUserQuery = 'SELECT NombreUsuario FROM usuario WHERE Correo = ?';
    
    db.query(verifyUserQuery, [req.session.email], (err, userResults) => {
        if (err) {
            console.error('Error al verificar usuario:', err);
            return res.status(500).send('Error al verificar usuario');
        }

        if (userResults.length === 0) {
            console.error('Usuario no encontrado para el correo:', req.session.email);
            return res.status(401).redirect('/logout'); // Forzar logout si el usuario no existe
        }

        const username = userResults[0].NombreUsuario;

		const presupuestosQuery = `
			SELECT 
				p.idPresupuesto,
				d.nombre,
				d.fecha_inicio,
				d.fecha_fin,
				d.monto AS totalPresupuesto,
				d.categoria,
				COALESCE(SUM(g.Monto), 0) AS totalGastado
			FROM presupuesto p
			JOIN detallePresupuesto d ON p.idPresupuesto = d.idPresupuesto
			LEFT JOIN gastos g ON g.idPresupuesto = p.idPresupuesto
			WHERE p.NombreUsuario = ?
			GROUP BY 
				p.idPresupuesto,
				d.nombre,
				d.fecha_inicio,
				d.fecha_fin,
				d.monto,
				d.categoria
		`;


        
        db.query(presupuestosQuery, [username], (err, presupuestos) => {
            if (err) {
                console.error('Error al obtener presupuestos:', err);
                return res.status(500).render('error', {
                    message: 'Error al cargar presupuestos',
                    error: err
                });
            }

            // Formatear fechas si es necesario
            const presupuestosFormateados = Array.isArray(presupuestos) ? presupuestos.map(p => ({
                ...p,
                fecha_inicio: new Date(p.fecha_inicio).toLocaleDateString('es-CO'),
                fecha_fin: new Date(p.fecha_fin).toLocaleDateString('es-CO')
            })) : [];

            res.render('principal', {
                name: req.session.name,
                foto: req.session.foto,
                rol: req.session.rol,
                presupuestos: presupuestosFormateados,
                alertData: req.session.alertData || {}
            });
            
            // Limpiar alertas después de mostrarlas
            req.session.alertData = null;
        });
    });
});


// Página principal - aplicar el middleware de autenticación
router.get('/Reportes', isAuthenticated, (req, res) => {
    const alertData = req.session.alertData || {};
    req.session.alertData = null;
    res.render('Reportes', alertData);
});

// Página principal - aplicar el middleware de autenticación
router.get('/registroCredito', isAuthenticated, (req, res) => {
    const alertData = req.session.alertData || {};
    req.session.alertData = null;
    res.render('registroCredito', alertData);
});

// Página principal - aplicar el middleware de autenticación
router.get('/TiposRecordatorios', isAuthenticated, (req, res) => {
    const alertData = req.session.alertData || {};
    req.session.alertData = null;
    res.render('TiposRecordatorios', alertData);
});

// Página principal - aplicar el middleware de autenticación
router.get('/RecuperarContraseña', isAuthenticated, (req, res) => {
    const alertData = req.session.alertData || {};
    req.session.alertData = null;
    res.render('RecuperarContraseña', alertData);
});

router.get('/cuenta', isAuthenticated, (req, res) => {
  const alertData = req.session.alertData || {};
  req.session.alertData = null;
  res.render('cuenta', {
    ...alertData,
    name: req.session.name,
	lastName: req.session.lastName,
	profesion: req.session.profesion,
	expecs: req.session.expecs, // Extracción de datos de base de datos
    email: req.session.email, // 👈 AGREGAR ESTA LÍNEA
    rol: req.session.rol,
	foto: req.session.foto,
	username: req.session.username,
	moneda: "USD" // REMPLAZAR AL CREAR CAMPO EN LA BASE DE DATOS
	//presupuestos: req.session.idPresupuesto
  });
});




module.exports = router;