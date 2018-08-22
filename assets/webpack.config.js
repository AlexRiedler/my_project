const path = require("path")
const glob = require("glob")
const webpack = require("webpack")

const CleanWebpackPlugin = require("clean-webpack-plugin")
const CopyWebpackPlugin = require("copy-webpack-plugin");
const MiniCssExtractPlugin = require("mini-css-extract-plugin")
const ManifestPlugin = require("webpack-manifest-plugin")

const projRoot = path.resolve(__dirname, "../")
const distFolder = path.resolve(__dirname, "../priv/static")

module.exports = {
  entry: {
    "js/app": ["./js/app.js"].concat(glob.sync("./vendor/**/*.js")),
    "css/app": ["./css/app.css"]
  },
  output: {
    path: distFolder,
    publicPath: "/assets/", // this should match your lib/my_project_web/endpoint for static plug
    filename: "[name]_[contenthash].bundle.js",
    chunkFilename: "js/[id].[chunkhash].chunk"
  },
  module: {
    rules: [
      {
        test: /\.js$/i,
        exclude: "/node_modules/",
        loader: "babel-loader"
      },
      {
        test: /\.s?css$/i,
        use: [
          MiniCssExtractPlugin.loader,
          "css-loader",
          "sass-loader"
        ]
      }
    ]
  },
  plugins: [
    new CleanWebpackPlugin(["js", "css", "images", "static"], { root: distFolder }),
    new CopyWebpackPlugin([{ from: "static/**/*", to: path.resolve(distFolder, "../")}]),
    new MiniCssExtractPlugin({
      filename: "[name].[chunkhash].css",
      chunkFilename: "css/[id].[chunkhash].chunk"
    }),
    new ManifestPlugin({
      fileName: "manifest.json",
      filter: (file) => {
        if (file.isAsset || file.isInitial) {
          return file
        }
      }
    })
  ]
}
