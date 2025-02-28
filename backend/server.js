const express = require('express');
const cors = require('cors'); // Import CORS

const app = express();
const PORT = 4000;

// Middleware untuk parsing JSON
app.use(express.json());

// ✅ Middleware CORS
app.use(cors({
  origin: '*', // Izinkan semua origin
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));

// Import route dari folder routes
const popularDietsRoutes = require('./routes/PopularDiets');
const categoriesRoutes = require('./routes/Categories');

// Gunakan route yang sudah dibuat
app.use('/api', popularDietsRoutes);
app.use('/api', categoriesRoutes);

// Jalankan server
app.listen(PORT, () => {
  console.log(`✅ Server berjalan di http://localhost:${PORT}`);
});
