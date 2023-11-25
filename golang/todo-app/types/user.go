package types

import (
	"time"
)

var uid int = 0

// A User entity
type User struct {
	id        int
	firstName string
	lastName  string
	email     string
	createdAt time.Time
	updatedAt time.Time
}

// Create a user with input provided
func CreateUser(firstName string, lastName string, email string) User {
	uid += 1
	user := User{
		id:        uid,
		firstName: firstName,
		lastName:  lastName,
		email:     email,
		createdAt: time.Now(),
		updatedAt: time.Now(),
	}
	return user
}

// Verify if user exists
func CheckIfUserExists(users []User, email string) bool {
	for _, user := range users {
		if user.email == email {
			return true
		}
	}
	return false
}

// Get user id by email
func GetUserIdByEmail(users []User, email string) int {
	for _, user := range users {
		if user.email == email {
			return user.id
		}
	}
	return -1
}
