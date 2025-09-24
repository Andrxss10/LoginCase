const express = require('express');
const router = express.Router();
const db = require('../db'); // Si necesitas usar la base de datos
const { isAuthenticated } = require('../middlewares/authMiddleware'); // Utilizamos el middleware de autenticación de sesiones
const multer = require('multer'); // Manejo de imagenes en base de datos
const bcrypt = require('bcrypt'); // Encriptado de contraseñas
const nodemailer = require('nodemailer');
const crypto = require('crypto');

// Configuración de Gmail (usa "Contraseña de aplicación")
const transporter = nodemailer.createTransport({
  service: 'Gmail',
  auth: {
    user: 'bossbudgetproyect@gmail.com', // El correo del grupo
    pass: 'ipobxfavjakwqyge', // La de 16 chars generada en Google
  },
});

// ------ RUTAS DE RECUPERACIÓN DE CONTRASEÑA -------- //

// VISTA
router.get('/forgot-password', (req, res) => {
  res.render('forgot-password', { error: null, success: null });
});

router.post('/forgot-password', (req, res) => {
  const { email } = req.body;

  // 1. Verificar si el usuario existe y obtener su NombreUsuario
  db.query(
    'SELECT Correo, NombreUsuario FROM usuario WHERE Correo = ?',
    [email],
    (err, results) => {
      if (err) {
        console.error('Error al buscar usuario:', err);
        return res.render('forgot-password', {
          error: 'Error interno. Por favor, intenta más tarde.',
          success: null
        });
      }

      if (results.length === 0) {
        return res.render('forgot-password', {
          error: 'No hay cuenta asociada a este correo.',
          success: null,
        });
      }

      const usuario = results[0];
      const token = crypto.randomBytes(32).toString('hex');
      const expiresAt = new Date(Date.now() + 3600000); // 1 hora

      // 2. Guardar token en la tabla password_reset_tokens usando NombreUsuario
      db.query(
        'INSERT INTO password_reset_tokens (NombreUsuario, token, expires_at) VALUES (?, ?, ?)',
        [usuario.NombreUsuario, token, expiresAt], // Usamos NombreUsuario aquí
        (err) => {
          if (err) {
            console.error('Error al guardar token:', err);
            return res.render('forgot-password', {
              error: 'Error interno. Por favor, intenta más tarde.',
              success: null
            });
          }

          // 3. Enviar correo con el enlace
          const resetLink = `http://${req.headers.host}/reset-password?token=${token}`;
          transporter.sendMail({
            to: email,
            subject: 'Recuperación de contraseña',
            html: `
              <p>Haz clic <a href="${resetLink}">aquí</a> para restablecer tu contraseña.</p>
              <p>El enlace expira en 1 hora.</p>
            `,
          }, (err) => {
            if (err) {
              console.error('Error al enviar correo:', err);
              return res.render('forgot-password', {
                error: 'Error al enviar el correo. Intenta nuevamente.',
                success: null,
              });
            }

            res.render('forgot-password', {
              success: '¡Revisa tu correo para el enlace de recuperación!',
              error: null,
            });
          });
        }
      );
    }
  );
});


// ------ RUTAS DE RESETEO DE CONTRASEÑA -------- //

// VISTA
router.get('/reset-password', (req, res) => {
  const { token } = req.query;

  // Verificar si el token es válido y no ha expirado
  db.query(
    'SELECT * FROM password_reset_tokens WHERE token = ? AND expires_at > NOW()',
    [token],
    (err, tokenData) => {
      if (err) throw err;

      if (tokenData.length === 0) {
        return res.render('reset-password', {
          error: 'El enlace es inválido o ha expirado.',
          success: null,
          token: null,
        });
      }

      res.render('reset-password', {
        error: null,
        success: null,
        token,
      });
    }
  );
});


// MANEJO DE DATOS
router.post('/reset-password', (req, res) => {
  const { token, password, confirmPassword } = req.body;

  // 1. Validar que las contraseñas coincidan
  if (password !== confirmPassword) {
    return res.render('reset-password', {
      error: 'Las contraseñas no coinciden.',
      success: null,
      token: token
    });
  }

  // 2. Verificar token válido
  db.query(
    'SELECT NombreUsuario FROM password_reset_tokens WHERE token = ? AND expires_at > NOW()',
    [token],
    (err, tokenData) => {
      if (err) {
        console.error('Error al verificar token:', err);
        return res.render('reset-password', {
          error: 'Error interno. Por favor, intente más tarde.',
          success: null,
          token: token
        });
      }

      if (tokenData.length === 0) {
        return res.render('reset-password', {
          error: 'El enlace es inválido o ha expirado.',
          success: null,
          token: null
        });
      }

      const NombreUsuario = tokenData[0].NombreUsuario;

      // 3. Hashear la nueva contraseña
      bcrypt.hash(password, 10, (err, hashedPassword) => {
        if (err) {
          console.error('Error al hashear contraseña:', err);
          return res.render('reset-password', {
            error: 'Error interno. Por favor, intente más tarde.',
            success: null,
            token: token
          });
        }

        // 4. Actualizar contraseña
        db.query(
          'UPDATE usuario SET Contraseña = ? WHERE NombreUsuario = ?',
          [hashedPassword, NombreUsuario],
          (err) => {
            if (err) {
              console.error('Error al actualizar contraseña:', err);
              return res.render('reset-password', {
                error: 'Error interno. Por favor, intente más tarde.',
                success: null,
                token: token
              });
            }

            // 5. Eliminar token
            db.query(
              'DELETE FROM password_reset_tokens WHERE token = ?',
              [token],
              (err) => {
                if (err) console.error('Error al eliminar token:', err);
                
                // Renderizar la vista con mensaje de éxito
                return res.render('reset-password', {
                  success: '¡Contraseña actualizada correctamente! Redirigiendo al login...',
                  error: null,
                  token: null
                });
              }
            );
          }
        );
      });
    }
  );
});

module.exports = router;