var DbOperation = {};

(function(ns) {
  ns.insert = insert;
  ns.fetchInitialData = fetchInitialData;
  ns.deleteObj = deleteObj;
  ns.editTask = editTask;
  ns.editFibonacci = editFibonacci;
  ns.objects = "";

  var Datastore = require("nedb");
  var db = new Datastore({
    filename: "./db/test.db",
    autoload: true
  });
  initialize();

  function initialize() {
    db.find({}, function(err, docs) {
      ns.objects = docs;
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

  function editFibonacci(objId, fibonacci) {
    db.update({ id: objId }, { $set: { fibonacci: fibonacci } });
  }
})(DbOperation);
