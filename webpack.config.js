const path = require('path')
const webpack = require('webpack')
const HtmlWebpackPlugin = require('html-webpack-plugin');
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const CleanWebPackPlugin = require("clean-webpack-plugin");
const CompressionPlugin = require("compression-webpack-plugin")
const root_outPut = path.resolve(__dirname, "./public/");
const root_inPut = path.resolve(__dirname, "./src");
const clean_public_path = path.join(root_outPut, '*');
const Jarvis = require("webpack-jarvis");
const BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin;
const clone = require('clone');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const seo_dir = path.join(__dirname, "./src/seo");

var config = {
    entry: {
        app: path.join(root_inPut, 'apps/app.app.js'),
        //index: path.resolve(root_inPut, 'index/index.app.js'),
    },
    output: {
        path: root_outPut,
        filename: 'js/[name].bundle.js'
    },
    node: {
        fs: 'empty'
    },
    // devtool: 'inline-source-map',
    module: {
        rules: [{
                test: /\.tag$/,
                exclude: /node_modules/,
                use: [{
                    loader: 'riot-tag-loader'
                }]
            }, {
                test: /\.css$/,
                use: ExtractTextPlugin.extract({
                    fallback: 'style-loader',
                    use: [{
                        loader: 'css-loader',
                        options: {
                            minimize: true,
                            // alias:{
                            //     "./icons": path.resolve(__dirname, './libs/ample-admin/ampleadmin-minimal/css-gen/icons')
                            // }
                        }
                    }, ]
                })
            }, {
                test: /\.less$/,
                loader: ExtractTextPlugin.extract({
                    use: [{
                            loader: 'css-loader',
                        },
                        {
                            loader: 'less-loader',
                            options: {
                                paths: [path.resolve(__dirname, "node_modules")],
                            }
                        },
                    ],
                    fallback: 'style-loader'
                })
            }, {
                test: /\.(png|jpg|gif|svg)$/,
                use: [{
                    loader: 'file-loader',
                    options: {
                        name: '[name].[ext]',
                        outputPath: "images",
                        publicPath: "/images"
                    }
                }]
            }, {
                test: /\.(eot|com|json|ttf|woff|woff2)$/,
                use: [{
                    loader: 'file-loader',
                    options: {
                        name: '[name].[ext]',
                        outputPath: "fonts",
                        publicPath: "/fonts/"
                    }
                }]
            }, {
                test: /\.(pdf|doc|docx)$/,
                use: [{
                    loader: 'file-loader',
                    options: {
                        name: '[name].[ext]',
                        outputPath: "docs",
                        publicPath: "/docs/"
                    }
                }]
            }

        ]
    },
    plugins: [
        // new WebpackBar(),
        new ExtractTextPlugin({
            filename: "css/[name].bundle.css"
        }),
        new HtmlWebpackPlugin({
            hash: true,
            chunks: ["app"],
            filename: path.resolve(__dirname, "./public/pages/app.html"),
            title: "Geo Code Yelp",
            template: path.resolve(__dirname, "./src/pages/app.page.html"),
            minify: {
                collapseWhitespace: true
            }
        }),

        // new HtmlWebpackPlugin({
        //     hash: true,
        //     chunks: ["index"],
        //     filename: path.resolve(__dirname, "./public/pages/index.html"),
        //     title: "Authblue - Marketplace For Background Verification",
        //     template: path.resolve(__dirname, "./src/pages/index.page.html"),
        //     minify: {
        //         collapseWhitespace: true
        //     }
        // }),
        // new HtmlWebpackPlugin({
        //     hash: true,
        //     chunks: ["policy"],
        //     filename: path.resolve(__dirname, "./public/pages/policy.html"),
        //     title: "Authblue - Policy And Terms Of Use",
        //     template: path.resolve(__dirname, "./src/pages/policy.page.html"),
        //     minify: {
        //         collapseWhitespace: true
        //     }
        // }),

        new CleanWebPackPlugin([clean_public_path]),
        new webpack.ProvidePlugin({
            $: 'jquery',
            jQuery: 'jquery',
            jquery: 'jquery',
        }),

    ]
};

module.exports = function (env) {
    var webpackConfig = clone(config);
    if (env.production) {
        webpackConfig.plugins.push(
            new CompressionPlugin({
                asset: "[path].gz[query]",
                algorithm: "gzip",
                test: /\.(js|css|png|jpg|jpeg|gif|svg|eot|com|json|ttf|woff|woff2)$/,
                deleteOriginalAssets: false,
                // threshold: 10240,
                // minRatio: 0
            }),
            new webpack.DefinePlugin({
                '__WP_API_URL__': JSON.stringify('https://api.authblue.com/api/v1'),
                '__WP_RZP_KEY__': JSON.stringify('rzp_live_TRnPkeL8p1MfVB')
            })
        );
    } else if (env.staging) {
        webpackConfig.plugins.push(
            new CompressionPlugin({
                asset: "[path].gz[query]",
                algorithm: "gzip",
                test: /\.(js|css|png|jpg|jpeg|gif|svg|eot|com|json|ttf|woff|woff2)$/,
                deleteOriginalAssets: false,
                // threshold: 10240,
                // minRatio: 0
            }),
        );
    } else {
        webpackConfig.plugins.push(
            new Jarvis({
                port: 1337 // optional: set a port
            }),
            new BundleAnalyzerPlugin({
                generateStatsFile: true,
                statsFilename: "./stats/app-stats.json"
            })
        );
    }
    return webpackConfig;
};