const express = require('express');
const cors = require('cors');

const app = express();
const PORT = 4000;

// Jangan pakai IP statis di sini, biarkan 0.0.0.0 agar menerima semua koneksi
const LOCAL_IP = '0.0.0.0';

// Middleware
app.use(express.json());
app.use(cors({
  origin: '*', // Boleh disesuaikan kalau perlu keamanan lebih
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));

// Import routes
const popularDietsRoutes = require('./routes/PopularDiets');
const categoriesRoutes = require('./routes/Categories');

// Use routes
app.use('/api', popularDietsRoutes);
app.use('/api', categoriesRoutes);

// Start server
app.listen(PORT, LOCAL_IP, () => {
  console.log(`✅ Server berjalan di http://localhost:${PORT} atau http://<your-local-ip>:${PORT}`);
});
