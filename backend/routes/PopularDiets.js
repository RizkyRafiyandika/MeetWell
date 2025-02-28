const express = require('express');
const router = express.Router();

// Data dummy untuk popular diets
const popularDiets = [
  {
    "name": "Blueberry Fiego",
    "type": "Dessert",
    "iconPath": "assets/blueberry_pancake.jpeg",
    "level": "Medium",
    "duration": "30mins",
    "calorie": "230kCal",
    "boxIsSelected": true,
    "cost": 85000, // Harga dalam IDR
  },
  {
    "name": "Salmon Nigiri",
    "type": "Sushi",
    "iconPath": "assets/salmon_nigiri.jpeg",
    "level": "Easy",
    "duration": "20mins",
    "calorie": "120kCal",
    "boxIsSelected": true,
    "cost": 150000, // Lebih mahal karena ikan segar
  },
  {
    "name": "Avocado Toast",
    "type": "Breakfast",
    "iconPath": "assets/avocado_toast.jpeg",
    "level": "Easy",
    "duration": "10mins",
    "calorie": "150kCal",
    "boxIsSelected": true,
    "cost": 60000, // Avocado cukup mahal di Indonesia
  },
  {
    "name": "Greek Yogurt Parfait",
    "type": "Dessert",
    "iconPath": "assets/greek_yogurt_parfait.jpeg",
    "level": "Easy",
    "duration": "5mins",
    "calorie": "100kCal",
    "boxIsSelected": true,
    "cost": 50000, // Greek yogurt lebih murah dibanding makanan utama
  },
  {
    "name": "Quinoa Salad",
    "type": "Salad",
    "iconPath": "assets/quinoa_salad.jpeg",
    "level": "Medium",
    "duration": "25mins",
    "calorie": "200kCal",
    "boxIsSelected": true,
    "cost": 100000, // Quinoa cukup mahal di Indonesia
  },
];


// Endpoint untuk mendapatkan data diet populer
router.get('/popular-diets', (req, res) => {
  res.json(popularDiets);
});

module.exports = router;
