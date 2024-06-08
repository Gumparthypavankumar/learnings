const uuid = require("uuid");

const todos = [];

function getAllTodos() {
    return todos;
}

function addTodo(name, description) {
    console.log({name, description});
    const todo = {id: uuid.v4(), name, description, isCompleted: false};
    todos.push(todo);
    return todo;
}

function updateTodo(id) {
    todos.map(t => {
        t.isCompleted = true;
    });
    return todos.find(todo => todo.id === id);
}

module.exports = {
    getAllTodos,
    addTodo,
    updateTodo
}