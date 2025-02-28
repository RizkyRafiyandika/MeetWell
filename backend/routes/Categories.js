const express = require('express');
const router = express.Router();

// Data makanan berdasarkan kategori
const foodCategories = {
  salad: [
    {
      name: "Quinoa Salad",
      iconPath: "assets/quinoa_salad.jpeg",
      level: "Medium",
      duration: "25mins",
      calorie: "200kCal",
      boxIsSelected: true,
    },
    {
      name: "Greek Salad",
      iconPath: "assets/greek_salad.jpeg",
      level: "Easy",
      duration: "15mins",
      calorie: "180kCal",
      boxIsSelected: true,
    },
  ],
  dessert: [
    {
      name: "Blueberry Pancake",
      iconPath: "assets/blueberry_pancake.jpeg",
      level: "Medium",
      duration: "30mins",
      calorie: "230kCal",
      boxIsSelected: true,
    },
    {
      name: "Greek Yogurt Parfait",
      iconPath: "assets/greek_yogurt_parfait.jpeg",
      level: "Easy",
      duration: "5mins",
      calorie: "100kCal",
      boxIsSelected: true,
    },
  ],
  sushi: [
    {
      name: "Salmon Nigiri",
      iconPath: "assets/salmon_nigiri.jpeg",
      level: "Easy",
      duration: "20mins",
      calorie: "120kCal",
      boxIsSelected: true,
    },
    {
      name: "Tuna Roll",
      iconPath: "assets/tuna_roll.jpeg",
      level: "Medium",
      duration: "25mins",
      calorie: "140kCal",
      boxIsSelected: true,
    },
  ],
  breakfast: [
    {
      name: "Avocado Toast",
      iconPath: "assets/avocado_toast.jpeg",
      level: "Easy",
      duration: "10mins",
      calorie: "150kCal",
      boxIsSelected: true,
    },
    {
      name: "Oatmeal Bowl",
      iconPath: "assets/oatmeal_bowl.jpeg",
      level: "Easy",
      duration: "10mins",
      calorie: "180kCal",
      boxIsSelected: true,
    },
  ],
};

// Endpoint untuk mendapatkan semua kategori
router.get('/categories', (req, res) => {
  res.json(Object.keys(foodCategories));
});

// Endpoint untuk mendaapaatkan makanan berdasarkan category
router.get('/categories/:category',(req, res) =>{
    const category = req.params.category.toLowerCase();
    if(foodCategories[category]){
        res.json(foodCategories[category]);
    }else{
        res.status(404).json({error: "Category Not Found"});
    }
});

module.exports = router;