program = require("commander").program

program
	.name "playlist"
	.version require("../package.json").version
	.description "Process Apple Music playlists"
	.command "convert <playlist>", "Convert playlist into JSON format"
	.command "tags <playlist>", "Process and tag audio files with playlist info"

program.parse()
