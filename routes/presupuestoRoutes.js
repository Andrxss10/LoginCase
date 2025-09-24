const express = require('express');
const router = express.Router();
const db = require('../db'); // Si necesitas usar la base de datos
const { isAuthenticated } = require('../middlewares/authMiddleware'); // Utilizamos el middleware de autenticación de sesiones
const multer = require('multer'); // Manejo de imagenes en base de datos

// -------------------------- CREAR PRESUPUESTO -------------------------- //

// Página principal - aplicar el middleware de autenticación
router.get('/crearPresupuesto', isAuthenticated, (req, res) => {
    const alertData = req.session.alertData || {};
    req.session.alertData = null;
    res.render('crearPresupuesto', alertData);
});

router.post('/crearPresupuesto', isAuthenticated, (req, res) => {
    const { nombre, valor, fecha_inicio, fecha_fin, categoria, otraCategoria } = req.body;
    const categoriaFinal = categoria === 'Otros' && otraCategoria.trim() !== '' 
        ? otraCategoria.trim() 
        : categoria;

    // Validación más completa
    if (!nombre || !valor || isNaN(valor) || !fecha_inicio || !fecha_fin || !categoriaFinal) {
        req.session.alertData = {
            alertTitle: 'Error',
            alertMessage: 'Por favor completa todos los campos correctamente',
            alertIcon: 'error'
        };
        return res.redirect('/crearPresupuesto');
    }

    // Usar transacción para asegurar integridad
    db.beginTransaction(err => {
        if (err) {
            console.error('Error al iniciar transacción:', err);
            return res.status(500).send('Error al crear presupuesto');
        }

        // 1. Insertar en la tabla 'presupuesto' con el usuario
        const sqlPresupuesto = `
            INSERT INTO presupuesto (NombreUsuario) 
            VALUES (?)
        `;

        db.query(sqlPresupuesto, [req.session.username], (err, result) => {
            if (err) {
                return db.rollback(() => {
                    console.error('Error al insertar en presupuesto:', err);
                    res.status(500).send('Error al crear presupuesto');
                });
            }

            const idPresupuesto = result.insertId;

            // 2. Insertar en la tabla 'detallePresupuesto'
            const sqlDetalle = `
                INSERT INTO detallePresupuesto 
                (idPresupuesto, nombre, monto, fecha_inicio, fecha_fin, categoria)
                VALUES (?, ?, ?, ?, ?, ?)
            `;

            const valores = [idPresupuesto, nombre, parseFloat(valor), fecha_inicio, fecha_fin, categoriaFinal];

            db.query(sqlDetalle, valores, (err) => {
                if (err) {
                    return db.rollback(() => {
                        console.error('Error al insertar en detallePresupuesto:', err);
                        res.status(500).send('Error al guardar detalle del presupuesto');
                    });
                }

                db.commit(err => {
                    if (err) {
                        return db.rollback(() => {
                            console.error('Error al confirmar transacción:', err);
                            res.status(500).send('Error al guardar presupuesto');
                        });
                    }

                    req.session.alertData = {
                        alertTitle: 'Éxito',
                        alertMessage: 'Presupuesto creado correctamente',
                        alertIcon: 'success'
                    };
                    res.redirect(`/presupuesto/${idPresupuesto}`);
                });
            });
        });
    });
});

// -------------------------- PRESUPUESTO -------------------------- //

router.get('/presupuesto/:id', isAuthenticated, (req, res) => {
    const id = req.params.id;
    
    // Primero verificar que el presupuesto pertenece al usuario
    const verifyQuery = `
        SELECT p.idPresupuesto 
        FROM presupuesto p
        WHERE p.idPresupuesto = ? AND p.NombreUsuario = ?
    `;
    
    db.query(verifyQuery, [id, req.session.username], (err, results) => {
        if (err || results.length === 0) {
            console.error('Acceso no autorizado a presupuesto:', err);
            req.session.alertData = {
                alertTitle: 'Error',
                alertMessage: 'Presupuesto no encontrado o no tienes permiso',
                alertIcon: 'error'
            };
            return res.redirect('/principal');
        }

        // Obtener detalles del presupuesto
        const presupuestoQuery = `
            SELECT d.nombre, d.monto, d.fecha_inicio, d.fecha_fin, d.categoria
            FROM detallepresupuesto d
            WHERE d.idPresupuesto = ?
        `;

        db.query(presupuestoQuery, [id], (err, presupuestoResult) => {
            if (err || presupuestoResult.length === 0) {
                console.error('Error obteniendo presupuesto:', err);
                return res.status(500).send('Error al obtener el presupuesto');
            }

            const presupuesto = presupuestoResult[0];
            
            // Obtener total de gastos e ingresos en paralelo
            const gastosQuery = `
                SELECT idGastos, TipoDeMonto AS tipo, Monto AS valor, Descripcion AS descripcion
                FROM gastos
                WHERE idPresupuesto = ?
            `;
            
            const ingresosQuery = `
                SELECT idIngresos, TipoDeMonto AS tipo, Monto AS valor, Descripcion AS descripcion
                FROM ingresos
                WHERE idPresupuesto = ?
            `;
            
            // Ejecutar ambas consultas en paralelo
            db.query(gastosQuery, [id], (errGastos, gastos) => {
                db.query(ingresosQuery, [id], (errIngresos, ingresos) => {
                    if (errGastos || errIngresos) {
                        console.error('Error obteniendo datos:', {errGastos, errIngresos});
                        return res.status(500).send('Error al obtener datos del presupuesto');
                    }
                    
                    // Calcular totales
                    const totalGastos = gastos.reduce((sum, g) => sum + parseFloat(g.valor), 0);
                    const totalIngresos = ingresos.reduce((sum, i) => sum + parseFloat(i.valor), 0);
                    const balance = totalIngresos - totalGastos;
                    
                    // Formatear fechas
                    const formatearFecha = (fechaISO) => {
                        return new Date(fechaISO).toLocaleDateString('es-CO', {
                            year: 'numeric',
                            month: 'long',
                            day: 'numeric'
                        });
                    };
                    
                    res.render('presupuesto', {
                        presupuesto: {
                            idPresupuesto: id,
                            nombre: presupuesto.nombre,
                            monto: presupuesto.monto,
                            categoria: presupuesto.categoria,
                            fecha_inicio: formatearFecha(presupuesto.fecha_inicio),
                            fecha_fin: formatearFecha(presupuesto.fecha_fin)
                        },
                        gastos,
                        ingresos,
                        totales: {
                            gastos: totalGastos,
                            ingresos: totalIngresos,
                            balance: balance
                        },
                        alertData: req.session.alertData || {}
                    });
                    
                    req.session.alertData = null;
                });
            });
        });
    });
});

// -------------------------- RUTAS PARA MODALES --------------------------

// ACTUALIZAR PRESUPUESTO ---->
router.post('/api/updateBudget', async (req, res) => {
  try {
    const { idPresupuesto, nombre, monto, fecha_inicio, fecha_fin } = req.body;
    
    console.log('Datos recibidos en el backend:', req.body);
    
    await db.query(
      'UPDATE detallepresupuesto SET nombre = ?, monto = ?, fecha_inicio = ?, fecha_fin = ? WHERE idPresupuesto = ?',
      [nombre, parseFloat(monto), fecha_inicio, fecha_fin, idPresupuesto]
    );
    
    res.json({ success: true });
  } catch (error) {
    console.error('Error en updateBudget:', error);
    res.status(500).json({ success: false, message: 'Error al actualizar el presupuesto' });
  }
});

// ELIMINAR PRESUPUESTO ---->
router.delete('/api/deleteBudget/:id', async (req, res) => {
  try {
    const { id } = req.params;
    
    await db.query('DELETE FROM presupuesto WHERE idPresupuesto = ?', [id]);
    
    res.json({ success: true });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Error al eliminar el presupuesto' });
  }
});


module.exports = router;