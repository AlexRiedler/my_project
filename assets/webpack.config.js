const path = require("path")
const glob = require("glob")
const webpack = require("webpack")

const CleanWebpackPlugin = require("clean-webpack-plugin")
const CopyWebpackPlugin = require("copy-webpack-plugin");
const MiniCssExtractPlugin = require("mini-css-extract-plugin")
const WebpackAssetsManifest = require("webpack-assets-manifest")

const projRoot = path.resolve(__dirname, "../")
const distFolder = path.resolve(__dirname, "../priv/static")

module.exports = (env, argv) => {
 let dev = (argv.mode !== 'production')
 return {
   entry: {
     "js/app": ["./js/app.js"].concat(glob.sync("./vendor/**/*.js")),
     "css/app": ["./css/app.css"]
   },
   output: {
     path: distFolder,
     publicPath: "/assets/", // this should match your lib/my_project_web/endpoint for static plug
     filename: dev ? "[name].js" : "[name]_[contenthash].bundle.js",
     chunkFilename: dev ? "js/[id].chunk" : "js/[id].[chunkhash].chunk"
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
       filename: dev ? "[name].css" : "[name].[chunkhash].css",
       chunkFilename: dev ? "css/[id].chunk" : "[id].[chunkhash].chunk"
     }),
     new WebpackAssetsManifest({
       output: "manifest.json",
       publicPath: true,
       writeToDisk: true,
       merge: dev ? true : false
     })
   ]
 }
}
