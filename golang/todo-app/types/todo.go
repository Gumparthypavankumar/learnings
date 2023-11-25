package types

import (
	"fmt"
	"time"
)

type TodoStatus int

const (
	PENDING TodoStatus = iota
	SUCCESS
	CANCELLED
)

var tid int = 0

// A Todo entity
type Todo struct {
	id          int
	title       string
	description string
	status      TodoStatus
	user_id     int
	createdAt   time.Time
	updatedAt   time.Time
}

// Create a Todo
func CreateTodo(title string, description string, status TodoStatus, user_id int) Todo {
	tid += 1
	todo := Todo{
		id:          tid,
		title:       title,
		description: description,
		status:      status,
		user_id:     user_id,
		createdAt:   time.Now(),
		updatedAt:   time.Now(),
	}
	return todo
}

// Update a Todo
func UpdateTodo(todos []Todo, user_id int, status TodoStatus, todo_id int) {
	for _, todo := range todos {
		if user_id == todo.user_id && todo_id == todo.id {
			todo.status = status
			break
		}
	}
}

// List all todos that belong to user_id provided
func ListTodos(todos []Todo, user_id int) {
	for _, todo := range todos {
		if user_id == todo.user_id {
			fmt.Println(todo)
		}
	}
}
