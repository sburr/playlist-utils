# Deprecated in favor of plist

XMLParser = require("fast-xml-parser").XMLParser  # re-add dependency if using

parser = new XMLParser()

module.exports = parse = (rawXml) ->
    plist = parser.parse rawXml
    # still TODO: parse the stupid plist format
