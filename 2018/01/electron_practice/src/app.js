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
          _hideDisplay(this.list, item);
        },
        editTask: function(item) {
          _editTask(item.id, item.task);
        },
        doneTask: function(item) {
          _doneTask(item);
          //_hideDisplay(this.list, item);
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
    var obj = {
      id: id,
      task: newTaskText,
      edit: false,
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

  function _doneTask(item) {
    DbOperation.doneTask(item);
  }

  function _hideDisplay(list, item) {
    var index = list.indexOf(item);
    list.splice(index, 1);
  }
})(app);
