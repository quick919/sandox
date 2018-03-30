import Tesseract from "tesseract.js";

(function() {
  var elm = document.querySelector("#test");
  elm.addEventListener("click", function() {
    Tesseract.workerOptions.workerPath =
      "http://localhost:3000/static/worker.js";
    Tesseract.recognize("sample.jpg").then(function(result) {
      console.log(result);
    });
  });
})();
