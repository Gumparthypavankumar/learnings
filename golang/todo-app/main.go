package main

import (
	"fmt"
	"runtime"

	"todo-app/types"

	"moul.io/banner"
)

var users []types.User = []types.User{}
var todos []types.Todo = []types.Todo{}

func main() {
	fmt.Println(banner.Inline("todo app"))
	fmt.Printf("Go running on %v\n", runtime.GOOS)
	for {
		fmt.Println("1. About")
		fmt.Println("2. Register as a User")
		fmt.Println("3. Create a Todo")
		fmt.Println("4. Update Todo")
		fmt.Println("5. List my todos")

		var choice int
		fmt.Print("Please enter your choice!! ")
		fmt.Scan(&choice)

		var email string
		fmt.Print("\nEnter the email: ")
		fmt.Scan(&email)

		switch choice {
		case 1:
			fmt.Println("A simple Todo management application")
		case 2:
			fmt.Println("Choice is 2")
			var firstName string
			fmt.Print("Enter the firstname: ")
			fmt.Scan(&firstName)
			var lastName string
			fmt.Print("Enter the lastName: ")
			fmt.Scan(&lastName)
			users = append(users, types.CreateUser(firstName, lastName, email))
			for _, user := range users {
				fmt.Println(user)
			}
		case 3:
			fmt.Println("Choice is 3")
			isExist := types.CheckIfUserExists(users, email)
			if !isExist {
				fmt.Println("User does not exist with that email, please create one!!")
				continue
			}
			var todoTitle string
			fmt.Println("Enter todo title")
			fmt.Scan(&todoTitle)
			var todoDesc string
			fmt.Println("Enter todo description")
			fmt.Scan(&todoDesc)
			var todoStatus int
			fmt.Println("Enter todo status as following: \n0. PENDING \n1. SUCCESS \n2. CANCELLED")
			fmt.Scan(&todoStatus)
			todos = append(todos, types.CreateTodo(todoTitle, todoDesc, types.TodoStatus(todoStatus), types.GetUserIdByEmail(users, email)))
		case 4:
			fmt.Println("Choice is 4")
			var todoStatus int
			fmt.Println("Enter todo status as following: \n0. PENDING \n1. SUCCESS \n2. CANCELLED")
			fmt.Scan(&todoStatus)
			var todoId int
			fmt.Println("Enter the todo Id")
			fmt.Scan(&todoId)
			// TODO::
			types.UpdateTodo(todos, types.GetUserIdByEmail(users, email), types.TodoStatus(todoStatus), todoId)
		case 5:
			fmt.Println("Choice is 5")
			types.ListTodos(todos, types.GetUserIdByEmail(users, email))
		default:
			fmt.Println("Default")
		}
	}

}
