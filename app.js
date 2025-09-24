// Librerías necesarias para el funcionamiento
const express = require('express');
const db = require('./db'); // Conexión a la base de datos local
const bcrypt = require('bcrypt'); // Encriptado de contraseñas
const session = require('express-session'); // Manejo de sesiones
const multer = require('multer'); // Manejo de imagenes en base de datos

// Instanciamos app y creamos una constante para el puerto por si cambia
const app = express();
const port = 3000;

// Creación de sesión para cada usuario:
app.use(session({
    secret: 'PruebaSxcrxtx', // Puedes cambiarla por una más segura
    resave: false,
    saveUninitialized: false
}));

// Configurar EJS
app.set('view engine', 'ejs');

// Permitimos almacenar los datos para que no queden como indefinidos / Middleware para leer datos de formulario
app.use(express.urlencoded({extended:true}));
app.use(express.json());

// Llamamos las rutas de creditos
const creditos = require('./routes/creditos');
app.use('/', creditos);

// Llamamos las rutas de otherRoutes
const isoRoutes = require('./routes/isoRoutes');
app.use('/', isoRoutes);

// Llamamos las rutas de otherRoutes
const otherRoutes = require('./routes/otherRoutes');
app.use('/', otherRoutes);

// Llamamos las rutas de authRoutes
const authRoutes = require('./routes/authRoutes');
app.use('/', authRoutes);

// Llamamos las rutas de presupuestoRoutes
const presupuestoRoutes = require('./routes/presupuestoRoutes');
app.use('/', presupuestoRoutes);

// Llamamos las rutas de gastosRoutes
const gastosRoutes = require('./routes/gastosRoutes');
app.use('/', gastosRoutes);

// Llamamos las rutas de ingresosRoutes
const ingresosRoutes = require('./routes/ingresosRoutes');
app.use('/', ingresosRoutes);

// Llamamos las rutas de passRoutes
const passRoutes = require('./routes/passRoutes');
app.use('/', passRoutes);


// Servir archivos estáticos desde 'public' (CSS, imágenes, JS frontend)
app.use(express.static('public'));


// Localhost:
app.listen(port, () => {
    console.log(`Servidor corriendo en http://localhost:${port}`);
});
