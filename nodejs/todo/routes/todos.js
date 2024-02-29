const express = require("express");
const router = express.Router();
const { getAllTodos, addTodo, updateTodo } = require("../state/todos");

router.get("/", (req, res) => {
    return res.status(200).json({todos: getAllTodos()});
});

router.post("/", (req, res) => {
    console.log(req);
    const { name, description } = req.body;
    const todo = addTodo(name, description);
    return res.status(200).json(todo);
});

router.put("/:id", (req, res) => {
    return res.status(200).json(updateTodo(id));
});

module.exports = router;