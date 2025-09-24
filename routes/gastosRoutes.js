const express = require('express');
const router = express.Router();
const db = require('../db'); // Si necesitas usar la base de datos
const { isAuthenticated } = require('../middlewares/authMiddleware'); // Utilizamos el middleware de autenticación de sesiones
const multer = require('multer'); // Manejo de imagenes en base de datos

// -------------------------- GASTOS -------------------------- //


// Mostrar formulario de registro de gastos
router.get('/gastos/nuevo/:idPresupuesto', isAuthenticated, (req, res) => {
  res.render('registroGastos', {
    idPresupuesto: req.params.idPresupuesto,
    name: req.session.name,
    foto: req.session.foto
  });
});

// Procesar registro de gastos
router.post('/gastos/nuevo/:idPresupuesto', isAuthenticated, (req, res) => {
  const { tipo, otroTipo, valor, descripcion, fecha } = req.body;
  const idPresupuesto = req.params.idPresupuesto;

  // Validaciones básicas
  if (!valor || isNaN(valor)) {
    return res.status(400).send('Monto inválido');
  }
  
  if (tipo === 'Otro' && (!otroTipo || otroTipo.trim() === '')) {
    return res.status(400).send('Debe especificar el tipo de gasto');
  }

  // Determinar el valor final para TipoDeMonto y TipoDeMontoDetalle
  const tipoMonto = tipo;
  const tipoMontoDetalle = tipo === 'Otro' ? otroTipo.trim() : null;

  // Formatear fecha (usar fecha actual si no se proporciona)
  const fechaRegistro = fecha || new Date().toISOString().slice(0, 19).replace('T', ' ');

  const query = `
    INSERT INTO gastos 
    (idPresupuesto, TipoDeMonto, TipoDeMontoDetalle, Monto, Descripcion, FechaDeRegistro) 
    VALUES (?, ?, ?, ?, ?, ?)
  `;

  db.query(query, 
    [idPresupuesto, tipoMonto, tipoMontoDetalle, valor, descripcion, fechaRegistro], 
    (err, result) => {
      if (err) {
        console.error('Error al registrar gasto:', err);
        
        // Manejar error específico de ENUM si es necesario
        if (err.code === 'TRUNCATED_WRONG_VALUE_FOR_FIELD') {
          return res.status(400).send('Tipo de gasto no válido');
        }
        
        return res.status(500).send('Error al registrar el gasto');
      }
      
      res.redirect(`/presupuesto/${idPresupuesto}`);
    }
  );
});

// Ruta para editar gasto (PUT)
router.put('/gastos/editar/:id', isAuthenticated, express.json(), (req, res) => {
  const { descripcion, valor } = req.body;
  
  db.query(
    'UPDATE gastos SET TipoDeMonto = ?, Monto = ? WHERE idGastos = ?',
    [descripcion, valor, req.params.id],
    (err) => {
      if (err) {
        console.error('Error al actualizar gasto:', err);
        return res.status(500).json({ error: 'Error al actualizar' });
      }
      res.json({ success: true });
    }
  );
});

// Ruta para eliminar gasto (DELETE)
router.delete('/gastos/:id', isAuthenticated, (req, res) => {
  db.query(
    'DELETE FROM gastos WHERE idGastos = ?',
    [req.params.id],
    (err) => {
      if (err) {
        console.error('Error al eliminar gasto:', err);
        return res.status(500).json({ error: 'Error al eliminar' });
      }
      res.json({ success: true });
    }
  );
});

module.exports = router;