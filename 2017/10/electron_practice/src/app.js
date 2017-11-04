var app = {};
(function(ns) {
  const shortId = require("shortid");
  inittialize();

  function inittialize() {
    setTimeout(fetchInitialData, 500);
  }

  function fetchInitialData() {
    var objects = DbOperation.fetchInitialData();
    if (objects.length == 0) {
      objects = [];
    }

    app2 = new Vue({
      el: "#taskArea",
      data: function() {
        return {
          list: objects
        };
      },
      methods: {
        addTask: function(e) {
          var obj = _addTask();
          this.list.push(obj);
        },
        deleteTask: function(item) {
          _deleteTask(item.id);
          var index = this.list.indexOf(item);
          this.list.splice(index, 1);
        },
        editTask: function(item) {
          _editTask(item.id, item.task);
        }
      }
    });
  }

  function _addTask() {
    var newTaskTextElement = document.querySelector("#newTaskText");
    var newTaskText = newTaskTextElement.value;
    if (newTaskText == "") {
      alert("task is empty!");
      return;
    }

    var id = shortId.generate();
    var fibonacciNumberElement = document.querySelector("#fibonacciNumber");
    var fibonacciValue = fibonacciNumberElement.value;
    var obj = {
      id: id,
      fibonacci: fibonacciValue,
      task: newTaskText,
      edit: false
    };
    DbOperation.insert(obj);
    return obj;
  }

  function _deleteTask(id) {
    DbOperation.deleteObj(id);
  }

  function _editTask(id, task) {
    DbOperation.editTask(id, task);
  }
})(app);
