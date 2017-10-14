var DbOperation = {};

(function(ns) {
  ns.insert = insert;
  var Datastore = require("nedb");
  var db = new Datastore({
    filename: "./db/test.db",
    autoload: true
  });
  function insert(obj) {
    db.insert(obj);
  }
})(DbOperation);
