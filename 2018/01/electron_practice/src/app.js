var app = {};
(function(ns) {
  const shortId = require("shortid");

  DbOperation.initialize().then(objects => {
    app2 = new Vue({
      el: "#taskArea",
      data: function() {
        return {
          list: objects,
          newTask: ""
        };
      },
      methods: {
        addTask: function() {
          var obj = _addTask(this.newTask);
          this.list.push(obj);
          this.newTask = "";
        },
        deleteTask: function() {
          if (!confirm("delete checked tasks?")) {
            return;
          }

          const workObj = [];
          this.list.forEach(obj => {
            if (obj.done == false) {
              return;
            }
            workObj.push(obj);
          });
          workObj.forEach(obj => {
            _deleteTask(obj.id);
            _hideDisplay(this.list, obj);
          });
        },
        editTask: function(item) {
          _editTask(item.id, item.task);
        },
        doneTask: function(item) {
          _doneTask(item);
        }
      }
    });
  });

  function _addTask(newTaskText) {
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
