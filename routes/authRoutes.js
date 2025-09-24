const express = require('express');
const router = express.Router();
const db = require('../db'); // Si necesitas usar la base de datos
const { isAuthenticated } = require('../middlewares/authMiddleware'); // Utilizamos el middleware de autenticación de sesiones
const multer = require('multer'); // Manejo de imagenes en base de datos
const bcrypt = require('bcrypt'); // Encriptado de contraseñas

// Configuración de almacenamiento
const storage = multer.diskStorage({
    destination: 'public/uploads', // Carpeta de destino (no usamos path por ahora)
    filename: (req, file, cb) => {
        // Nombre del archivo: fecha + original
        cb(null, Date.now() + '-' + file.originalname);
    }
});

// Inicializamos multer
const upload = multer({ storage: storage });


// Rutas públicas (no requieren autenticación)
router.get("/", function(req, res) { // Ruta principal - Página de login
    const alertData = req.session.alertData || {};
    req.session.alertData = null; // Limpiar después de mostrar
    res.render("login", alertData);
});

// Ruta explícita para login (redirige a la principal)
router.get("/login", function(req, res) {
    res.redirect('/');
});

// Ruta para el formulario de registro
router.get("/registro", function(req, res) {
    const alertData = req.session.alertData || {};
    req.session.alertData = null;
    res.render("registro", alertData);
});

//Login - Metodo para la autenticacion
router.post('/login', async function(req, res) {
	const email = req.body.email;
	const password = req.body.pass;

	if (email && password) {
		db.query('SELECT * FROM usuario WHERE Correo = ?', [email], async (error, results) => {
			if (results.length == 0 || !(await bcrypt.compare(password, results[0].Contraseña))) {
				
				req.session.alertData = {
					alert: true,
					alertTitle: "Error",
					alertMessage: "USUARIO y/o PASSWORD incorrectas",
					alertIcon: 'error',
					showConfirmButton: true,
					ruta: ""
				};

				return res.redirect('/');
			} else {
				// Guardamos en la sesión los datos importantes
				req.session.loggedin = true;
				req.session.email = results[0].Correo;
				req.session.name = results[0].Nombres;
				req.session.lastName = results[0].Apellidos;
				req.session.rol = results[0].Rol;
				req.session.foto = results[0].Foto;
				req.session.username = results[0].NombreUsuario;
				req.session.profesion = results[0].Profesion;
				req.session.expecs = results[0].Expectativas;
				//req.session.userId = results[0].idUsuario; // O el nombre de tu columna ID

				req.session.alertData = {
					alert: true,
					alertTitle: "¡LOGIN CORRECTO!",
					alertMessage: "¡Bienvenido a la aplicación!",
					alertIcon: 'success',
					showConfirmButton: true,
					ruta: ""
				};

				return res.redirect('/principal');
			}
		});
	} else {
		req.session.alertData = {
			alert: true,
			alertTitle: "Error",
			alertMessage: "Por favor, ingresa usuario y contraseña.",
			alertIcon: 'warning',
			showConfirmButton: true,
			ruta: ""
		};
		return res.redirect('/');
	}
});

// Registro - método de registro
router.post('/registrar', upload.single('foto'), async function(req, res) {

	const datos = req.body;
	
	let username = datos.username;
	let nombres = datos.nom;
	let apellidos = datos.apell;
	let password = datos.pass;
	let email = datos.email;
	let profesion = datos.prof;
	let nacimiento = datos.nacimiento;
	let expectativas = datos.expec;
	
	const imagenNombre = req.file ? req.file.filename : null; // Imagen
	
	try {
		// Hashear la contraseña
		const hashedPassword = await bcrypt.hash(password, 10);

		// Consulta segura con placeholders
		let registrar = `
			INSERT INTO usuario 
			(NombreUsuario, Nombres, Apellidos, Contraseña, Correo, Profesion, FechaDeNacimiento, Expectativas, Foto) 
			VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`;

		let valores = [username, nombres, apellidos, hashedPassword, email, profesion, nacimiento, expectativas, imagenNombre];

		db.query(registrar, valores, function(error) {
			if (error) {
				console.error("Error al registrar:", error);

				// Guardar alerta en sesión y redirigir a "/"
				req.session.alertData = {
					alert: true,
					alertTitle: "Error",
					alertMessage: "Error al registrar los datos.",
					alertIcon: "error",
					showConfirmButton: true,
					ruta: ""
				};
				return res.redirect('/'); 
			} else {
				console.log("Datos almacenados correctamente. Registro satisfactorio.");

				// Guardar alerta en sesión y redirigir a "/"
				req.session.alertData = {
					alert: true,
					alertTitle: "¡Registro exitoso!",
					alertMessage: "Por favor inicia sesión.",
					alertIcon: "success",
					showConfirmButton: true,
					ruta: ""
				};
				return res.redirect('/');
			}
		});
	} catch (err) {
		console.error("Error al procesar la solicitud:", err);

		req.session.alertData = {
			alert: true,
			alertTitle: "Error",
			alertMessage: "Ocurrió un error en el servidor.",
			alertIcon: "error",
			showConfirmButton: true,
			ruta: ""
		};
		return res.redirect('/');
	}
});

// Ruta para cerrar la sesión, es necesario un botón que dirija a está ruta
router.get('/logout', (req, res) => {
    req.session.destroy(() => {
        res.redirect('/');
    });
});

module.exports = router;