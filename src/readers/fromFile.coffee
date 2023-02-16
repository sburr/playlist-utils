fs = require "fs"
path = require "path"

module.exports = read = (playlistFile) ->
    playlistFile = path.normalize playlistFile
    fs.readFileSync playlistFile, {encoding: "utf8"}
