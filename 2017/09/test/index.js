var index = {};

(function(ns) {

    (function() {
        var fileElement = document.getElementById("file");
        fileElement.addEventListener('click', clearHistoryFileName)
        fileElement.addEventListener('change', readFile);
        var tableName = document.querySelector('#tableName');
        tableName.addEventListener('input', inputTextBox);
    }());

    function readFile(e) {
        var data = e.target.files[0];
        
        var tableNameElement = document.querySelector('#tableName');
        if (tableNameElement.value == "") {
            alert('テーブル名を入力してください。');
            return;
        }

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
        var insertSentence = document.getElementById("insertSentence");
        var tableName =  document.querySelector('#tableName').value;
        var columnNames = "";
        lines.forEach(function(element, index) {
            if (index == 0) {//１行目はカラム名の行を期待
                columnNames = element.trim();
                return;
            }
            var insertValue = element.trim();
            if (insertValue == "") return;

            var text = insert(tableName, columnNames, insertValue);
            var li = document.createElement('li');
            li.innerText =text;
            insertSentence.appendChild(li);
        });
    }

    function insert(tableName, columnNames, insertValue) {
        var query = "insert into " +
                    tableName +
                    "(" +
                    columnNames +
                    ")" +
                    " values " +
                    "(" +
                    insertValue +
                    ");"
        return query;
    }

    function inputTextBox(e) {
        var inputValue = e.target.value;
        if (inputValue.length > 0) {
            document.querySelector('#file').disabled = "";
        } else {
            document.querySelector('#file').disabled = true;
        }
    }

    /**
     * 保持しているファイル名を消す。<br>
     * ※ 同じファイルをアップロードするとchangeイベントが発火しない<br>
     * inputイベントはchangイベントより先に発火する
     * @param {*} file 
     */
    function clearHistoryFileName(file) {
        this.value = null;
    }
}(index));