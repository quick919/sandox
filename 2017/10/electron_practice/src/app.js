var app = {};
(function(ns) {
  const shortId = require("shortid");
  const moment = require("moment");
  inittialize();

  function inittialize() {
    setTimeout(fetchInitialData, 500);
  }

  function fetchInitialData() {
    var objects = DbOperation.fetchInitialData();
    if (objects.length == 0) {
      objects = [];
    }

    var totalFibonacci = 0;
    objects.forEach(obj => {
      if (typeof obj.doneWeeks === "undefined") {
        return;
      }

      if (moment().weeks() === obj.doneWeeks) {
        totalFibonacci += Number(obj.fibonacci);
      }
    });

    app2 = new Vue({
      el: "#taskArea",
      data: function() {
        return {
          list: objects,
          totalFibonacci: totalFibonacci
        };
      },
      methods: {
        addTask: function(e) {
          var obj = _addTask();
          this.list.push(obj);
        },
        deleteTask: function(item) {
          _deleteTask(item.id);
          _hideDisplay(this.list, item);
        },
        editTask: function(item) {
          _editTask(item.id, item.task);
        },
        editFibonacci: function(item) {
          _editFibonacci(item.id, item.fibonacci);
        },
        doneTask: function(item) {
          _doneTask(item.id);
          this.totalFibonacci += Number(item.fibonacci);
          _hideDisplay(this.list, item);
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
      edit: false,
      editfibonacci: false,
      done: false
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

  function _editFibonacci(id, fibonacci) {
    DbOperation.editFibonacci(id, fibonacci);
  }

  function _doneTask(id) {
    DbOperation.doneTask(id, moment().weeks());
  }

  function _hideDisplay(list, item) {
    var index = list.indexOf(item);
    list.splice(index, 1);
  }
})(app);
