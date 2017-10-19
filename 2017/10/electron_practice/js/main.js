var main = {};

(function() {
  var addTaskElement = document.querySelector("#addNewTask");
  addTaskElement.addEventListener("click", addTask);
  inittialize();

  function inittialize() {
    setTimeout(fetchInitialData, 100);
  }

  function fetchInitialData() {
    var objects = DbOperation.fetchInitialData();
    if (objects.length == 0) return;

    var ul = document.createElement("ul");
    objects.forEach(function(obj) {
      createtTaskElement(ul, obj.task, obj.fibonacci);
    });
    var taskArea = document.querySelector("#taskArea");
    taskArea.appendChild(ul);
  }

  function addTask() {
    var newTaskTextElement = document.querySelector("#newTaskText");
    var newTaskText = newTaskTextElement.value;
    if (newTaskText == "") {
      alert("task is empty!");
      return;
    }

    var fibonacciNumberElement = document.querySelector("#fibonacciNumber");
    var fibonacciValue = fibonacciNumberElement.value;
    var ul = document.createElement("ul");
    var changedUl = createtTaskElement(ul, newTaskText, fibonacciValue);
    var taskArea = document.querySelector("#taskArea");
    var obj = {
      fibonacci: fibonacciValue,
      task: newTaskText
    };
    DbOperation.insert(obj);
    taskArea.appendChild(changedUl);
  }

  function createtTaskElement(ul, task, fibonacciNumber) {
    var li = document.createElement("ll");
    var label = document.createElement("label");
    var p = document.createElement("p");
    label.innerText = "fibonacci" + fibonacciNumber;
    p.innerText = task;
    li.appendChild(label);
    li.appendChild(p);
    ul.appendChild(li);
    return ul;
  }
})(main);
