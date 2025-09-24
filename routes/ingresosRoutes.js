const express = require('express');
const router = express.Router();
const db = require('../db'); // Si necesitas usar la base de datos
const { isAuthenticated } = require('../middlewares/authMiddleware'); // Utilizamos el middleware de autenticación de sesiones
const multer = require('multer'); // Manejo de imagenes en base de datos

// -------------------------- INGRESOS -------------------------- //


// Mostrar formulario de registro de ingresos
router.get('/ingresos/nuevo/:idPresupuesto', isAuthenticated, (req, res) => {
  res.render('registroIngresos', {
    idPresupuesto: req.params.idPresupuesto,
    name: req.session.name,
    foto: req.session.foto
  });
});

// Procesar registro de ingresos
router.post('/ingresos/nuevo/:idPresupuesto', isAuthenticated, (req, res) => {
  const { tipo, otroTipo, valor, descripcion, fecha } = req.body;
  const idPresupuesto = req.params.idPresupuesto;

  // Validaciones básicas
  if (!valor || isNaN(valor)) {
    return res.status(400).send('Monto inválido');
  }
  
  if (tipo === 'Otro' && (!otroTipo || otroTipo.trim() === '')) {
    return res.status(400).send('Debe especificar el tipo de ingreso');
  }

  // Determinar el valor final para TipoDeMonto y TipoDeMontoDetalle
  const tipoMonto = tipo;
  const tipoMontoDetalle = tipo === 'Otro' ? otroTipo.trim() : null;

  // Formatear fecha (usar fecha actual si no se proporciona)
  const fechaRegistro = fecha || new Date().toISOString().slice(0, 19).replace('T', ' ');

  const query = `
    INSERT INTO ingresos 
    (idPresupuesto, TipoDeMonto, TipoDeMontoDetalle, Monto, Descripcion, FechaDeRegistro) 
    VALUES (?, ?, ?, ?, ?, ?)
  `;

  db.query(query, 
    [idPresupuesto, tipoMonto, tipoMontoDetalle, valor, descripcion, fechaRegistro], 
    (err, result) => {
      if (err) {
        console.error('Error al registrar ingreso:', err);
        
        // Manejar error específico de ENUM si es necesario
        if (err.code === 'TRUNCATED_WRONG_VALUE_FOR_FIELD') {
          return res.status(400).send('Tipo de ingreso no válido');
        }
        
        return res.status(500).send('Error al registrar el ingreso');
      }
      
      res.redirect(`/presupuesto/${idPresupuesto}`);
    }
  );
});

// Ruta para editar los ingresos
router.put('/ingresos/editar/:id', isAuthenticated, express.json(), (req, res) => {
  const { descripcion, valor } = req.body;
  
  db.query(
    'UPDATE ingresos SET TipoDeMonto = ?, Monto = ? WHERE idIngresos = ?',
    [descripcion, valor, req.params.id],
    (err) => {
      if (err) {
        console.error('Error al actualizar ingreso:', err);
        return res.status(500).json({ error: 'Error al actualizar' });
      }
      res.json({ success: true });
    }
  );
});

// Ruta para eliminar los ingresos
router.delete('/ingresos/:id', isAuthenticated, (req, res) => {
  db.query(
    'DELETE FROM ingresos WHERE idIngresos = ?',
    [req.params.id],
    (err) => {
      if (err) {
        console.error('Error al eliminar ingreso:', err);
        return res.status(500).json({ error: 'Error al eliminar' });
      }
      res.json({ success: true });
    }
  );
});

module.exports = router;