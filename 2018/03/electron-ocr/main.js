const nodeStatic = require("node-static");
const file = new nodeStatic.Server(__dirname);

require("http")
  .createServer(function(request, response) {
    request
      .addListener("end", function() {
        file.serve(request, response);
      })
      .resume();
  })
  .listen(3000); //ポートは空いていそうなところで。

const electron = require("electron");
const app = electron.app;
const BrowserWindow = electron.BrowserWindow;
var mainWindow = null;

app.on("window-all-closed", () => app.quit());
app.on("ready", () => {
  mainWindow = new BrowserWindow({
    width: 800,
    height: 600,
    resizable: true,
    alwaysOnTop: true,
    movable: true
  });

  // デベロッパーツールの起動
  // mainWindow.webContents.openDevTools();

  //ローカルで立てたサーバーにアクセス
  mainWindow.loadURL("http://127.0.0.1:3000");

  // ウィンドウが閉じられたらアプリも終了
  mainWindow.on("closed", () => (mainWindow = null));
});
