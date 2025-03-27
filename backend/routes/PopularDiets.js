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
    "cost": 85000,
  },
  {
    "name": "Salmon Nigiri",
    "type": "Sushi",
    "iconPath": "assets/salmon_nigiri.jpeg",
    "level": "Easy",
    "duration": "20mins",
    "calorie": "120kCal",
    "boxIsSelected": true,
    "cost": 150000,
  },
  {
    "name": "Avocado Toast",
    "type": "Breakfast",
    "iconPath": "assets/avocado_toast.jpeg",
    "level": "Easy",
    "duration": "10mins",
    "calorie": "150kCal",
    "boxIsSelected": true,
    "cost": 60000,
  },
  {
    "name": "Greek Yogurt Parfait",
    "type": "Dessert",
    "iconPath": "assets/greek_yogurt_parfait.jpeg",
    "level": "Easy",
    "duration": "5mins",
    "calorie": "100kCal",
    "boxIsSelected": true,
    "cost": 50000,
  },
  {
    "name": "Quinoa Salad",
    "type": "Salad",
    "iconPath": "assets/quinoa_salad.jpeg",
    "level": "Medium",
    "duration": "25mins",
    "calorie": "200kCal",
    "boxIsSelected": true,
    "cost": 100000,
  }
];

// Menambahkan 45 makanan tambahan dengan iconPath "assets/question_mark.jpeg"
for (let i = 1; i <= 45; i++) {
  popularDiets.push({
    "name": `Food Item ${i}`,
    "type": ["Salad", "Dessert", "Sushi", "Breakfast", "Soup", "Healthy", "Vegan", "Pasta", "Protein"][i % 9],
    "iconPath": "assets/question_mark.jpeg",
    "level": ["Easy", "Medium", "Hard"][i % 3],
    "duration": `${(i % 40) + 5}mins`,
    "calorie": `${(i % 400) + 50}kCal`,
    "boxIsSelected": true,
    "cost": ((i % 200) + 40000),
  });
}

// Endpoint untuk mendapatkan data diet populer
router.get('/popular-diets', (req, res) => {
  res.json(popularDiets);
});

module.exports = router;
