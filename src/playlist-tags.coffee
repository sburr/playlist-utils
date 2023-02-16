path = require "path"
program = require("commander").program
processTrack = require "./worker"
read = require "./readers/fromFile"

program
	.description "Apply the ID3 tags implied by from Apple Music playlist to a sequence of audio files and then move or copy those files to a more organized directory structure"
	.argument "<playlist>", "Playlist file name to process"
	.option "-d, --output-dir <directory>", "Output directory for audio files", process.cwd()
	.option "-f, --format <format>", "Playlist format ('json', 'xml', 'txt', 'tsv', 'm3u', 'm3u8') Inferred from file extension if not supplied"
	.option "-i, --in-place", "Update audio files with ID3 tags in place and do not copy, move, or rename them"
	.option "-m, --move-files", "Actually move the audio files to the output directory"
	.option "-n, --base-name <name>", "Base filename of the audio files", "Recording"
	.option "-q, --quiet", "Suppress informational output"

program.parse()
opts = program.opts()
args = program.args

playlistFile = args[0]
program.help {error: true} unless playlistFile

baseName = opts.baseName
program.help {error: true} unless baseName

console.error "===> Parsing playlist..." unless opts.quiet
rawPlaylist = read playlistFile

parsers = require "./parsers"
parse = if opts.format then parsers.loadParser opts.format else parsers.inferParser playlistFile
playlist = parse rawPlaylist

n = 0   # counter
nn = 0  # success counter
console.error "===> Processing playlist..." unless opts.quiet
for trackInfo, index in playlist
	console.error "---> Playlist item [#{index+1}] - #{trackInfo.Name}" unless opts.quiet
	trackFile = "#{baseName} #{index+1}.mp3"
	success = processTrack trackFile, trackInfo, opts
	n += 1
	nn += 1 if success

console.error() unless opts.quiet
console.log "#{n} playlist tracks processed"
console.log "#{nn} audio files successfully updated and filed under output directory"
console.log "#{n-nn} errors" if n > nn
