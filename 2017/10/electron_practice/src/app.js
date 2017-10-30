var app = {};
(function(ns) {
  const shortId = require("shortid");
  inittialize();

  function inittialize() {
    setTimeout(fetchInitialData, 500);
  }

  function fetchInitialData() {
    var objects = DbOperation.fetchInitialData();
    if (objects.length == 0) return;

    app2 = new Vue({
      el: "#taskArea",
      data: {
        list: objects
      },
      methods: {
        addTask: function(e) {
          var obj = _addTask();
          this.list.push(obj);
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
      task: newTaskText
    };
    DbOperation.insert(obj);
    return obj;
  }
})(app);
