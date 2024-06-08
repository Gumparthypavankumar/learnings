const router = require('express').Router();
const mongoose = require('mongoose');
require("../model/Product");

const Product = mongoose.model('products');

router.get("/", async (req, res) => {
    const products = await Product.find();
    return res.status(200).json({products});
});

router.post("/", async (req, res) => {
    const { name, price, quantity } = req.body;
    const product = await Product.create({
        name,
        price,
        quantity
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

module.exports = router;