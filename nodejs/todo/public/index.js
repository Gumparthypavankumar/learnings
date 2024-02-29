document.getElementById("form").addEventListener("submit", (e) => {
    e.preventDefault();
    const xhr = new XMLHttpRequest();
    xhr.open("POST", "http://localhost:3000/todos/", false);
    const name = document.getElementById("name").value;
    const description = document.getElementById("description").value;
    console.log({name, description});
    xhr.onload = () => {
        if(xhr.status == 200) {
            renderTodos();
        }
    }

    xhr.send(JSON.stringify({name, description}));
});


function renderTodos() {
    const xhr = new XMLHttpRequest();
    xhr.open("GET", "http://localhost:3000/todos/", true);

    xhr.onload = () => {
        if(xhr.status === 200) {
const displayElement = document.getElementById("display");
        console.log(xhr.response);
        const { todos } = xhr.response;
            if(todos) {
                todos.map(todo => {
                    const div = document.createElement("div");
                    const p1 = document.createElement("p");
                    p1.innerHTML = `Name: ${todo.name}`;
                    const p2 = document.createElement("p");
                    p2.innerHTML = `Description: ${todo.description}`;
                    const p3 = document.createElement("p");
                    p3.innerHTML = `IsCompleted: ${todo.isCompleted}`;
                    div.appendChild(p1);
                    div.appendChild(p2);
                    div.appendChild(p3);

                    displayElement.appendChild(div);
                    displayElement.appendChild(document.createElement("hr"));
                    div.style = "margin-bottom: 10px";
                });
            }
        }
    }

    xhr.send();   
}


document.addEventListener('DOMContentLoaded', () => {
    renderTodos();
});