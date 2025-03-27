const express = require('express');
const cors = require('cors'); 

const app = express();
const PORT = 4000;
const LOCAL_IP = '0.0.0.0'; // Ganti dengan IP lokal dari langkah 1

// Middleware untuk parsing JSON
app.use(express.json());

// ✅ Middleware CORS agar bisa diakses dari HP/laptop lain
app.use(cors({
  origin: '*', 
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));

// Import route dari folder routes
const popularDietsRoutes = require('./routes/PopularDiets');
const categoriesRoutes = require('./routes/Categories');

// Gunakan route yang sudah dibuat
app.use('/api', popularDietsRoutes);
app.use('/api', categoriesRoutes);

// Jalankan server dengan IP lokal
app.listen(PORT, LOCAL_IP, () => {
  console.log(`✅ Server berjalan di http://${LOCAL_IP}:${PORT}`);
});
