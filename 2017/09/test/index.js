var index = {};

(function () {
    var fileElement = document.getElementById("file");
    fileElement.addEventListener('click', clearHistoryFileName)
    fileElement.addEventListener('change', uploadFile);
    fileElement.addEventListener('dragover', cancelDefaultEvent);
    fileElement.addEventListener('drop', dnd);
    var tableName = document.querySelector('#tableName');
    tableName.addEventListener('input', inputTextBox);
    var clearElement = document.querySelector('#clear');
    clearElement.addEventListener('click', clear);

    function uploadFile(e) {
        var data = e.target.files[0];
        readFile(data);
    }

    function readFile(data) {
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
        reader.onload = function () {
            generateInsertSententce(reader.result);
        }
        reader.readAsText(data);
    }

    function generateInsertSententce(file) {
        var lines = file.split('\n');
        var insertSentence = document.getElementById("insertSentence");
        var tableName = document.querySelector('#tableName').value;
        var columnNames = "";
        var textArray = [];
        lines.forEach(function (element, index) {
            if (index == 0) {//１行目はカラム名の行を期待
                columnNames = element.trim();
                return;
            }
            var insertValue = element.trim();
            if (insertValue == "") return;

            var text = insert(tableName, columnNames, insertValue);
            textArray.push(text);
            var li = document.createElement('li');
            li.innerText = text;
            insertSentence.appendChild(li);
        });
        var button = document.createElement('input');
        button.type = "button"
        button.value = "Conpy to Clipboard";
        button.onclick = function () {
            copyToClipboard(textArray);
        }
        insertSentence.appendChild(button);
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
    function clearHistoryFileName() {
        this.value = null;
    }

    function cancelDefaultEvent(e) {
        e.preventDefault();
    }

    function dnd(e) {
        cancelDefaultEvent(e);
        readFile(e.dataTransfer.files[0]);
    }

    function clear() {
        if (!confirm("画面上の入力内容と出力内容を全て削除します。よろしいですか？")) return;
        var fileElement = document.querySelector('#file');
        var tableNameElement = document.querySelector('#tableName');
        fileElement.value = null;
        fileElement.disabled = true;
        tableNameElement.value = null;
        var insertSentenceElement = document.querySelector("#insertSentence");
        while (insertSentenceElement.firstChild) {
            insertSentenceElement.removeChild(insertSentenceElement.firstChild);
        }
    }

    function copyToClipboard(targetValue) {
        var textarea = document.createElement("textarea");
        textarea.value = targetValue.join('\n');
        document.body.appendChild(textarea);
        textarea.select();
        document.execCommand("copy");
        textarea.parentNode.removeChild(textarea);
    }
}(index));