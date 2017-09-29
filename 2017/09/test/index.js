var index = {};

(function(ns) {

    (function() {
        var fileElement = document.getElementById("file");
        fileElement.addEventListener('change', readFile);
    }());

    function readFile(e) {
        var data = e.target.files[0];
        
        if (!data.type.match("text/plain")) {
            alert("テキストファイルを指定してください。");
            return;
        }

        var reader = new FileReader();
        reader.onload = function() {
            generateInsertSententce(reader.result);
        }
        reader.readAsText(data);
    }

    function generateInsertSententce(file) {
        var lines = file.split('\n');
        lines.forEach(function(element) {
            console.log(element);
        });
    }
}(index));