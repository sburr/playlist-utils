parse = require("csv-parse/sync").parse

module.exports = (rawText) ->
    parse rawText, {
        columns: true
        delimiter: "\t"
        ignore_last_delimiters: true
        relax_column_count: true
        relax_quotes: true
        skip_empty_lines: true
        trim: true
    }
