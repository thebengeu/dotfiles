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
	_localOrRoaming: "Local" | "Roaming"
	darwin:          ".config"
	linux:           ".config"
	windows:         "AppData/\(_localOrRoaming)"
}
_xdgConfigHomeLocal: (#XdgConfigHome & {
	_localOrRoaming: "Local"
})[_os]
_xdgConfigHomeRoaming: (#XdgConfigHome & {
	_localOrRoaming: "Roaming"
})[_os]
