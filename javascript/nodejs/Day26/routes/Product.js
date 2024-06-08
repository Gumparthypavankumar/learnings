const router = require('express').Router();
const mongoose = require('mongoose');
require("../model/Product");
require("../model/Category");

const Product = mongoose.model('products');
const Category = mongoose.model('categories');

router.get("/", async (req, res) => {
    const products = await Product.find().populate('category');
    return res.status(200).json({products});
});

router.post("/", async (req, res) => {
    const { name, price, quantity, category } = req.body;
    const cat = await Category.create({
        name: category
    });
    const product = await Product.create({
        name,
        price,
        quantity,
        category: cat
    });
    return res.status(201).json({product});
})

router.put("/:id", async (req, res) => {
    const id = req.params.id;
    const { name, price, quantity } = req.body;
    const product = await Product.findByIdAndUpdate(id, {name, price, quantity});
    return res.status(201).json({product});
})

router.delete("/:id", async (req, res) => {
    const id = req.params.id;
    await Product.findByIdAndDelete(id);
    return res.status(410).json({"message": `Deleted product having id: ${id}`});
});

router.get('/statistics', async (req, res) => {
   const result =await Product.aggregate([{
    $group: {
        _id: null,
        totalProducts: { $sum: 1 },
        averagePrice: { $avg : "$price"},
        highestQuantity: { $max: "$quantity"}
    }
   }]);
   return res.status(200).json({result}); 
});

module.exports = router;