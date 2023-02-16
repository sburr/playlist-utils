plist = require "plist"

module.exports = parse = (rawXml) ->
	data = plist.parse rawXml

	# need to get them in playlist order, so a naive
	#   ( track for key, track of data.Tracks )
	# will not work. So we look them up individually. Note that we
	# concatenate multiple playlists head-to-tail if there are multiple in the file

	tracks = []

	# verbose version
	#n = 0
	#for playlist in data.Playlists
	#	for item in playlist["Playlist Items"]
	#		n += 1
	#		track = data.Tracks[item["Track ID"]]
	#		console.error "     Found track [#{n}] - #{track.Artist} - #{track.Name}"
	#		tracks.push track

	tracks.push data.Tracks[item["Track ID"]] for item in playlist["Playlist Items"] for playlist in data.Playlists

	tracks
