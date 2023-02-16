path = require "path"

json = require "./json"
plist = require "./plist"    # better than the (incomplete) xml flavor
tsv = require "./tsv"
m3u = require "./m3u"

loadParser = (type) ->
	switch type.toLowerCase()
		when "json" then json
		when "xml", "plist" then plist
		when "tsv", "txt" then tsv
		when "m3u", "m3u8" then m3u

inferParser = (filename) ->
	loadParser path.extname(filename).toLowerCase().replace(/^\./, "")

module.exports =
	loadParser: loadParser
	inferParser: inferParser
	json: json
	plist: plist
	xml: plist
	tsv: tsv
	txt: tsv
	m3u: m3u
	m3u8: m3u