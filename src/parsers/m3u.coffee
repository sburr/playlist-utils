eol = require "eol"
parsers = require "playlist-parser"
m3u = parsers.M3U

module.exports = parse = (rawText) ->
	text = eol.auto rawText
	playlist = m3u.parse text
	playlist.map (track) ->
		# coming from Apple Music playlist m3u and m3u8 exports, 
		# artist and title are reversed, and trackId and other info are missing
		# we just fixup and return what we have
		{ 
			Name: (track.artist ? "").trim(),
			Artist: (track.title ? "").trim(),
		}