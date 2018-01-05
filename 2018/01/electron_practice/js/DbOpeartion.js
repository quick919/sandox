var DbOperation = {};

(function(ns) {
  ns.insert = insert;
  ns.fetchInitialData = fetchInitialData;
  ns.deleteObj = deleteObj;
  ns.editTask = editTask;
  ns.doneTask = doneTask;
  ns.initialize = initialize;
  ns.objects = "";

  var Datastore = require("nedb");
  var db = new Datastore({
    filename: "./db/mytodo.db",
    autoload: true
  });

  function initialize() {
    return new Promise((resolve, reject) => {
      db.find({}, function(err, docs) {
        ns.objects = docs;
        resolve(ns.objects);
      });
    });
  }

  function insert(obj) {
    db.insert(obj);
  }

  function fetchInitialData() {
    setTimeout(function() {}, 1000);
    return DbOperation.objects;
  }

  function deleteObj(objId) {
    db.remove({ id: objId }, {}, function(err, numRemoved) {});
  }

  function editTask(objId, task) {
    db.update({ id: objId }, { $set: { task: task } });
  }

  function doneTask(obj) {
    db.update({ id: obj.id }, { $set: { done: obj.done } });
  }
})(DbOperation);
