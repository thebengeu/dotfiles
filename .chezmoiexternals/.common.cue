package dotfiles

#External: {
	executable?:      bool
	path?:            string
	stripComponents?: number
	type:             "archive-file" | "file" | "git-repo"
	url:              string
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
	linux:           ".config"
	windows:         "AppData/\(_localOrRoaming)"
}
_xdgConfigHomeLocal: (#XdgConfigHome & {
	_localOrRoaming: "Local"
})[_os]
_xdgConfigHomeRoaming: (#XdgConfigHome & {
	_localOrRoaming: "Roaming"
})[_os]
