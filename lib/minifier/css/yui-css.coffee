# Because of an Windows issue (https://github.com/yui/yuicompressor/issues/78), we have to use
# version 2.4.7 instead of 2.4.8.

{BaseMinifier} = require('./../BaseMinifier.coffee')

module.exports =
class YuiCssMinifier extends BaseMinifier

    getName: ()->
        return 'YUI compressor'


    minify: (inputFilename, outputFilename, callback) ->
        minified = undefined
        error = undefined

        @checkJavaInstalled (javaIsInstalled, version) =>
            if not javaIsInstalled
                error = 'You need to install Java in order to use YUI compressor or set a correct path to Java exectuable in options.'
                callback(minified, error)
            else
                exec = require('child_process').exec

                java = if @options.absoluteJavaPath then '"' + @options.absoluteJavaPath + '"' else 'java'
                command = java + ' -jar -Xss2048k "' + __dirname + '/../_bin/yuicompressor-2.4.7.jar" "' + inputFilename + '" -o "' + outputFilename + '" --type css'

                exec command,
                    maxBuffer: @options.buffer,
                    (err, stdout, stderr) =>
                        if err
                            error = err.toString()
                        else
                            fs = require('fs')
                            minified = fs.readFileSync(outputFilename).toString()

                        callback(minified, error)
