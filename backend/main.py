from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

todos = []
counter = 1

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/todos")
def get_todos():
    return todos


@app.post("/todos")
def add_todo(text: str):
    global counter

    todo = {
        "id": counter,
        "text": text,
        "done": False
    }

    todos.append(todo)
    counter += 1

    return todo


@app.put("/todos/{todo_id}")
def toggle(todo_id: int):

    for t in todos:
        if t["id"] == todo_id:
            t["done"] = not t["done"]
            return t


@app.delete("/todos/{todo_id}")
def delete(todo_id: int):

    global todos
    todos = [t for t in todos if t["id"] != todo_id]

    return {"status": "deleted"}