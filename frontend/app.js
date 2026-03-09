const API = "http://localhost:8000"

async function loadTasks(){

const res = await fetch(API + "/todos")
const data = await res.json()

const list = document.getElementById("tasks")
list.innerHTML=""

data.forEach(t=>{

const li = document.createElement("li")

const text = document.createElement("span")
text.innerText = t.text

if(t.done){
text.classList.add("done")
}

text.onclick = ()=>toggleTask(t.id)

const del = document.createElement("button")
del.innerText="X"
del.onclick = ()=>deleteTask(t.id)

li.appendChild(text)
li.appendChild(del)

list.appendChild(li)

})

}

async function addTask(){

const input = document.getElementById("taskInput")

await fetch(API + "/todos?text=" + input.value,{
method:"POST"
})

input.value=""

loadTasks()

}

async function toggleTask(id){

await fetch(API + "/todos/" + id,{
method:"PUT"
})

loadTasks()

}

async function deleteTask(id){

await fetch(API + "/todos/" + id,{
method:"DELETE"
})

loadTasks()

}

loadTasks()