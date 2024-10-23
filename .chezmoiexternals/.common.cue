package dotfiles

#External: {
	executable?: bool
	type:        "archive" | "archive-file" | "file" | "git-repo"
	url:         string
}

#Archive: {
	#External
	include: [...string]
	stripComponents?: number
	type:             "archive"
}

#ArchiveFile: {
	#External
	path:             string
	stripComponents?: number
	type:             "archive-file"
}

#File: {
	#External
	type: "file"
}

#ExecutableFile: {
	#File
	executable: true
}

#GitRepo: {
	#External
	_gitRepo:      string
	refreshPeriod: "168h"
	type:          "git-repo"
	url:           "https://github.com/\(_gitRepo)"
}

_os: string | *"" @tag(os,var=os)

#XdgConfigHome: {
	darwin:  *".config" | "Library/Application Support"
	linux:   ".config"
	windows: "AppData/Local" | *"AppData/Roaming"
}
_xdgConfigHomeLocal: (#XdgConfigHome & {
	windows: "AppData/Local"
})[_os]
_xdgConfigHomeRoaming: #XdgConfigHome[_os]
