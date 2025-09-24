// routes/creditos.js
const express = require('express');
const router = express.Router();
const db = require('../db'); // Si necesitas usar la base de datos
const { isAuthenticated } = require('../middlewares/authMiddleware'); // Utilizamos el middleware de autenticación de sesiones
const multer = require('multer');
const upload = multer({ dest: 'uploads/creditos/' });

// Mostrar formulario
router.get('/crearCredito', async (req, res) => {
  // Si usas sesiones: const userId = req.session.userId
  res.render('crearCredito', { user: req.session?.user || null });
});

// Procesar formulario
router.post('/crearCredito', upload.single('adjunto'), async (req, res) => {
  try {
    const userId = req.session?.user?.id || 1; // ajustar según auth

    const {
      nombre,
      monto,
      tasa_interes = 0,
      tipo_interes = 'fijo',
      plazo_meses = null,
      cuotas = 1,
      fecha_inicio,
      fecha_pago,
      notas,
      // campos de recordatorio
      frecuencia,
      canal,
      hora_recordatorio,
      fecha_recordatorio,
      dia_mes,
      dia_semana
    } = req.body;

    // Validaciones básicas (server-side)
    if (!nombre || !monto || !fecha_inicio || !fecha_pago) {
      return res.status(400).render('creditos/crear', { error: 'Completa los campos obligatorios' });
    }

    // Cálculo simple del valor de cuota si se solicita
    let valor_cuota = null;
    const montoNum = parseFloat(monto);
    const cuotasNum = parseInt(cuotas) || 1;
    if (cuotasNum > 1) {
      valor_cuota = +(montoNum / cuotasNum).toFixed(2);
    }

    // Guardar crédito
    const insertCredito = `INSERT INTO creditos
      (usuario_id, nombre, monto, tasa_interes, tipo_interes, plazo_meses, cuotas, valor_cuota, fecha_inicio, fecha_pago, notas, adjunto)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;

    const adjunto = req.file ? req.file.filename : null;

    const result = await query(insertCredito, [
      userId, nombre, montoNum, parseFloat(tasa_interes) || 0, tipo_interes, plazo_meses || null, cuotasNum, valor_cuota, fecha_inicio, fecha_pago, notas || null, adjunto
    ]);

    const creditoId = result.insertId;

    // Si el usuario definió un recordatorio, guardarlo
    if (frecuencia) {
      const insertRecord = `INSERT INTO recordatorios
        (credito_id, tipo, canal, frecuencia, dia_semana, dia_mes, fecha_programada, tiempo, activo)
        VALUES (?, 'pago', ?, ?, ?, ?, ?, ?, 1)`;

      await query(insertRecord, [
        creditoId,
        canal || 'inapp',
        frecuencia,
        dia_semana || null,
        dia_mes || null,
        fecha_recordatorio || null,
        hora_recordatorio || null
      ]);
    }

    // TODO: programar job para enviar recordatorios (cron o cola)

    res.redirect('/creditos');
  } catch (err) {
    console.error(err);
    res.status(500).render('creditos/crear', { error: 'Error al crear el crédito' });
  }
});

module.exports = router;