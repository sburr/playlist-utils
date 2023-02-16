path = require "path"
program = require("commander").program
read = require "./readers/fromFile"

program
	.description "Convert Apple Music playlists to JSON"
	.argument "<playlist>", "Playlist file name to process"
	.option "-f, --format <format>", "Playlist format ('json', 'xml', 'txt', 'tsv', 'm3u', 'm3u8') Inferred from file extension if not supplied"
	.option "-q, --quiet", "Suppress informational output"

program.parse()
opts = program.opts()
args = program.args

playlistFile = args[0]
program.help {error: true} unless playlistFile

#console.error "===> Parsing playlist..." unless opts.quiet
rawPlaylist = read playlistFile

parsers = require "./parsers"
parse = if opts.format then parsers.loadParser opts.format else parsers.inferParser playlistFile
playlist = parse rawPlaylist

console.log JSON.stringify playlist

process.exit 0
