fs = require "fs"
path = require "path"
spawn = require("child_process").spawnSync
mkdirp = require "mkdirp"
sanitizeFilename = require "sanitize-filename"

sanitize = (value) -> sanitizeFilename value ? ""

# format a command line arguemnt for the id3tag program
makeArg = (name, value) -> "--#{name}=#{value}"

module.exports = processTrack = (trackFile, trackInfo, options={}) ->
	outputDir = options.outputDir or process.cwd()
	timeout = options.timeout or 2000  # milliseconds for id3tag operations

	log = (msg) -> console.error msg unless options.quiet

	if fs.existsSync path.resolve(trackFile)

		args = []
		args.push makeArg "artist", trackInfo.Artist    #  Set the artist information
		args.push makeArg "album", trackInfo.Album      #  Set the album title information
		args.push makeArg "song", trackInfo.Name        #  Set the title information
		args.push makeArg "comment", trackInfo.Comments #  Set the comment information
		args.push makeArg "year", trackInfo.Year        #  Set the year
		args.push makeArg "track", trackInfo['Track Number']  #  Set the track number
		args.push makeArg "total", trackInfo['Track Count']   #  Set the total number of tracks
		args.push makeArg "genre", trackInfo.Genre      #  Set the genre
		args.push trackFile

		log "     Audio file: #{trackFile}"
		log "     Writing tags..."
		retval = spawn "id3tag", args, {shell: false, timeout: timeout}
		return log "     Fail: tag writing failed: #{retval}" if retval.status

		unless options.inPlace
			artistSegment = sanitize trackInfo.Artist or "Unknown"  # must have an Artist for the directory structure to work
			albumSegment = sanitize trackInfo.Album                 # can be blank - will just get dumped into Artist dir loosely
			newDirName = path.join(outputDir, artistSegment, albumSegment)
			log "     Creating path '#{newDirName}' if needed..."
			retval = mkdirp.sync newDirName
			log "     Created #{retval} directories" if retval

			newFileName = "#{sanitize trackInfo.Name}.mp3"
			newFileName = "#{trackInfo['Track Number']} #{newFileName}" if trackInfo['Track Number']

			newPath = path.join(newDirName, newFileName)
			if options.moveFiles
				console.error "     Moving to '#{newPath}'"
				retval = fs.renameSync path.resolve(trackFile), newPath
				return log "     Fail: file move failed: #{retval}" if retval
			else
				log "     Copying to '#{newPath}'"
				fs.copyFileSync path.resolve(trackFile), newPath

	else
		return log "     Fail: cannot find audio file: #{trackFile}"

	log "     Success"
	return true
