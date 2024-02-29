const mongoose = require('mongoose');

const Product = new mongoose.Schema({
    name: {
        type: String,
        required: true
    },
    price: {
        type: Number,
        required: true
    },
    quantity: {
        type: Number,
        required: true
    },
    category: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'categories'
    }
});

// async function createProductNameIndex() {
//     try {
//         await mongoose.model("products", Product).collection.createIndexes([{name: 1}],{
//             name: "idx_product_name",
//             unique: true,
//             sparse: true
//         });
//         console.log("Index created");
//     } catch (err) {
//         console.error({err});
//     }
// }

// createProductNameIndex();
mongoose.model('products', Product);