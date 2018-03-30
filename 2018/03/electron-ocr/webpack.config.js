const path = require("path");

module.exports = {
  mode: "development",
  entry: "./src/js/app.js",
  output: {
    filename: "bundle.js",
    path: path.join(__dirname, "dist")
  },
  node: {
    __dirname: false
  }
};
