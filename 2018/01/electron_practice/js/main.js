// var main = {};

// (function() {
//   var addTaskElement = document.querySelector("#addNewTask");
//   addTaskElement.addEventListener("click", addTask);
//   inittialize();
//   const shortId = require("shortid");

//   function inittialize() {
//     setTimeout(fetchInitialData, 100);
//   }

//   function fetchInitialData() {
//     var objects = DbOperation.fetchInitialData();
//     if (objects.length == 0) return;

//     var ul = document.createElement("ul");
//     objects.forEach(function(obj) {
//       createtTaskElement(ul, obj.id, obj.task, obj.fibonacci);
//     });
//     var taskArea = document.querySelector("#taskArea");
//     taskArea.appendChild(ul);
//   }

//   function addTask() {
//     var newTaskTextElement = document.querySelector("#newTaskText");
//     var newTaskText = newTaskTextElement.value;
//     if (newTaskText == "") {
//       alert("task is empty!");
//       return;
//     }

//     var id = shortId.generate();
//     var fibonacciNumberElement = document.querySelector("#fibonacciNumber");
//     var fibonacciValue = fibonacciNumberElement.value;
//     var obj = {
//       id: id,
//       fibonacci: fibonacciValue,
//       task: newTaskText
//     };
//     DbOperation.insert(obj);

//     var ul = document.createElement("ul");
//     var changedUl = createtTaskElement(ul, id, newTaskText, fibonacciValue);
//     var taskArea = document.querySelector("#taskArea");
//     taskArea.appendChild(changedUl);
//   }

//   function createtTaskElement(ul, id, task, fibonacciNumber) {
//     var li = document.createElement("ll");
//     var outerDiv = document.createElement("div");
//     outerDiv.className = "line";
//     var innerDiv = document.createElement("div");
//     innerDiv.className = "box";
//     var fiboSpan = document.createElement("span");
//     fiboSpan.className = "fibo-label";
//     var taskSpan = document.createElement("span");
//     taskSpan.className = "task-label";
//     var input = document.createElement("input");

//     fiboSpan.innerText = "fibonacci" + fibonacciNumber;
//     p.innerText = task;
//     input.type = "button";
//     input.onclick = function() {
//       deleteTask(id);
//     };
//     input.value = "delete";
//     li.appendChild(outerDiv);
//     li.appendChild(label);
//     li.appendChild(p);
//     li.appendChild(input);
//     ul.appendChild(li);
//     return ul;
//   }

//   function deleteTask(id) {
//     DbOperation.deleteObj(id);
//   }
// })(main);
