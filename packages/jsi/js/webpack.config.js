const path = require('path');
const { CleanWebpackPlugin } = require('clean-webpack-plugin');
const TerserPlugin = require('terser-webpack-plugin');

module.exports = {
    mode: 'production',
    entry: {
        app: { import: './src/index.js', dependOn: 'shared' },
        shared: ['jquery']
    },
    plugins: [
        new CleanWebpackPlugin(),
    ],
    output: {
        filename: '[name].bundle.js',
        path: path.resolve(__dirname, 'dist'),
    },
    optimization: {
        minimize: true,
        minimizer: [
            new TerserPlugin({
                minify: (file, sourceMap) => {
                    const uglifyJsOptions = {
                        compress: {
                            drop_console: true,
                        },
                        keep_fnames: /^broadcastNotify.*/,
                        toplevel: false,
                        output: {
                            comments: false,
                        },
                    };

                    if (sourceMap) {
                        uglifyJsOptions.sourceMap = {
                            content: sourceMap,
                        };
                    }
                    /*if (file.contains('broadcastNotify') && file.contains('broadcastNotifyCallback')) {
                        uglifyJsOptions.toplevel = true;
                        console.log(file);
                    }*/

                    return require('uglify-js').minify(file, uglifyJsOptions);
                },
                terserOptions: {
                    keep_fnames: /^broadcastNotify.*/,
                    compress: {
                        drop_console: true,
                    },
                    output: {
                        comments: false,
                    },
                },
            }),
        ],
        splitChunks: {
            chunks: 'all',
        },
    },
};