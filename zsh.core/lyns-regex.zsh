#!/usr/bin/env zsh
alias find-all='function _find_all() {
	msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(cs(html)?|cpp|cxx|h|hpp|cc?|c\+{2}|\w+proj|sln|nuspec|config|conf|resx|props|java|scala|py|go|rs|php|vue|tsx?|jsx?|json|ya?ml|xml|ini|md|ipynb|rst|sh|bat|cmd|psm?1)$|^readme|^make\w+$" -I --s1 1B --s2 3.6MB "$@"
}; _find_all'

alias find-all-def='function _find_all_def() {
	msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(cs(html)?|cpp|cxx|h|hpp|cc?|c\+{2}|\w+proj|sln|nuspec|config|conf|resx|props|java|scala|py|go|rs|php|vue|tsx?|jsx?|json|ya?ml|xml|ini|md|ipynb|rst|sh|bat|cmd|psm?1)$|^readme|^make\w+$" -I --s1 1B --s2 3.6MB --nt "^\s*([a-z0-9]+(\.|->|::)[A-Z]|[^\s\w]|\S+\s*=\s*[a-zA-Z])|^\s*(return|await|throw|except|raise|new|(el)?if|for|from|val)\s+|new\s+$1\s*\(|=\s*$1\s*\(|^\s*p[a-z]+\s+$1\s*\(" -t "^\s*(#\s*define\s+|(p[a-z]+|sealed|internal|readonly|const|static|volatile|final|type)\s+[\w\s,\?<>\[\]]{0,100})\b($1)\b|^\s*\w+[\w\s,\?<>]{0,80}\b($1)\s*(?:[\(\{:<]|extends|implements|$)" "${@:2}"
}; _find_all_def'

alias find-batch='msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(bat|cmd)$" -I --s1 1B --s2 3.6MB "$@"'

alias find-batch-def='function _find_batch_def() {
	msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(bat|cmd)$" -I --s1 1B --s2 3.6MB --nt "^\s*([a-z0-9]+(\.|->|::)[A-Z]|[^\s\w]|\S+\s*=\s*[a-zA-Z])|^\s*(return|await|throw|except|raise|new|(el)?if|for|from|val)\s+|new\s+$1\s*\(|=\s*$1\s*\(|^\s*p[a-z]+\s+$1\s*\(" -t "^\s*:\s*($1)\b|(^|\s)[Ss][Ee][Tt]\s+(/[aApP]\s+)?\"?($1)=" "${@:2}"
}; _find_batch_def'

alias find-batch-ref='function _find_batch_ref() {
	msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(bat|cmd)$" -I --s1 1B --s2 3.6MB -t "\b$1\b" "${@:2}"
}; _find_batch_ref'

alias find-code='msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(cs(html)?|cpp|cxx|h|hpp|cc?|c\+{2}|java|scala|py|go|rs|php|vue|tsx?|jsx?)$" -I --s1 1B --s2 3.6MB "$@"'

alias find-config='function _find_config() {
	msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(config|conf|resx|json|ya?ml|xml|ini)$" -I --s1 1B "$@"
}; _find_config'

alias find-cpp='msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(c\+\+|cpp|cxx|cc|c|hpp|h)$" -I --s1 1B --s2 3.6MB "$@"'

alias find-cpp-def='function _find_cpp_def() {
	msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(c\+\+|cpp|cxx|cc|c|hpp|h)$" -I --s1 1B --s2 3.6MB --nt ";\s*$|^\s*(return|throw|new|case)\s+|new\s+$1\s*\(|=\s*$1\s*\(" -t "^\s*(#\s*define\s+|(p[a-z]+|sealed|internal|readonly|const|static|volatile|final|type)\s+[\w\s,\?<>\[\]]{0,100})\b($1)\b|^\s*\w+[\w\s,\?<>]{0,80}\b($1)\s*(?:[\(\{:<]|extends|implements|$)" "${@:2}"
}; _find_cpp_def'

alias find-cpp-ref='function _find_cpp_ref() {
	msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(c\+\+|cpp|cxx|cc|c|hpp|h)$" -I --s1 1B --s2 3.6MB -t "\b$1\b" "${@:2}"
}; _find_cpp_ref'

alias find-cs='msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(cs|cshtml)$" -I --s1 1B --s2 3.6MB "$@"'

alias find-cs-def='function _find_cs_def() {
	msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(cs|cshtml)$" -I --s1 1B --s2 3.6MB --nt "^\s*([a-z0-9]+(\.|->|::)[A-Z]|[^\s\w]|\S+\s*=\s*[a-zA-Z])|^\s*(return|await|throw|except|raise|new|(el)?if|for|from|val)\s+|new\s+$1\s*\(|=\s*$1\s*\(|^\s*p[a-z]+\s+$1\s*\(" -t "^\s*(#\s*define\s+|(p[a-z]+|sealed|internal|readonly|const|static|volatile|final|type)\s+[\w\s,\?<>\[\]]{0,100})\b($1)\b|^\s*\w+[\w\s,\?<>]{0,80}\b($1)\s*(?:[\(\{:<]|extends|implements|$)" "${@:2}"
}; _find_cs_def'

alias find-cs-ref='function _find_cs_ref() {
	msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(cs|cshtml)$" -I --s1 1B --s2 3.6MB -t "\b$1\b" "${@:2}"
}; _find_cs_ref'

alias find-def='function _find_def() {
	msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(cs(html)?|cpp|cxx|h|hpp|cc?|c\+{2}|\w+proj|sln|nuspec|config|conf|resx|props|java|scala|py|go|rs|php|vue|tsx?|jsx?|json|ya?ml|xml|ini|md|ipynb|rst|sh|bat|cmd|psm?1)$|^readme|^make\w+$" -I --s1 1B --s2 3.6MB --nt "^\s*([a-z0-9]+(\.|->|::)[A-Z]|[^\s\w]|\S+\s*=\s*[a-zA-Z])|^\s*(return|await|throw|except|raise|new|(el)?if|for|from|val)\s+|new\s+$1\s*\(|=\s*$1\s*\(|^\s*p[a-z]+\s+$1\s*\(" -t "^\s*(#\s*define\s+|(p[a-z]+|sealed|internal|readonly|const|static|volatile|final|type)\s+[\w\s,\?<>\[\]]{0,100})\b($1)\b|^\s*\w+[\w\s,\?<>]{0,80}\b($1)\s*(?:[\(\{:<]|extends|implements|$)" "${@:2}"
}; _find_def'

alias find-doc='function _find_doc() {
	msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(md|rst)$|^readme" -I --s1 1B --s2 3.6MB "$@"
}; _find_doc'

alias find-go='msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(go)$" -I --s1 1B --s2 3.6MB "$@"'

alias find-go-def='function _find_go_def() {
	msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(go)$" -I --s1 1B --s2 3.6MB --nt "^\s*([a-z0-9]+(\.|->|::)[A-Z]|[^\s\w]|\S+\s*=\s*[a-zA-Z])|^\s*(return|await|throw|except|raise|new|(el)?if|for|from|val)\s+|new\s+$1\s*\(|=\s*$1\s*\(|^\s*p[a-z]+\s+$1\s*\(" -t "^\s*(#\s*define\s+|(p[a-z]+|sealed|internal|readonly|const|static|volatile|final|type)\s+[\w\s,\?<>\[\]]{0,100})\b($1)\b|^\s*\w+[\w\s,\?<>]{0,80}\b($1)\s*(?:[\(\{:<]|extends|implements|$)" "${@:2}"
}; _find_go_def'

alias find-go-ref='function _find_go_ref() {
	msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(go)$" -I --s1 1B --s2 3.6MB -t "\b$1\b" "${@:2}"
}; _find_go_ref'

alias find-java='msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(java|scala)$" -I --s1 1B --s2 3.6MB "$@"'

alias find-java-def='function _find_java_def() {
	msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(java|scala)$" -I --s1 1B --s2 3.6MB --nt "^\s*([a-z0-9]+(\.|->|::)[A-Z]|[^\s\w]|\S+\s*=\s*[a-zA-Z])|^\s*(return|await|throw|except|raise|new|(el)?if|for|from|val)\s+|new\s+$1\s*\(|=\s*$1\s*\(|^\s*p[a-z]+\s+$1\s*\(" -t "^\s*(#\s*define\s+|(p[a-z]+|sealed|internal|readonly|const|static|volatile|final|type)\s+[\w\s,\?<>\[\]]{0,100})\b($1)\b|^\s*\w+[\w\s,\?<>]{0,80}\b($1)\s*(?:[\(\{:<]|extends|implements|$)" "${@:2}"
}; _find_java_def'

alias find-java-ref='function _find_java_ref() {
	msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(java|scala)$" -I --s1 1B --s2 3.6MB -t "\b$1\b" "${@:2}"
}; _find_java_ref'

alias find-nd='msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" "$@"'

alias find-ndp='function _find_ndp() {
	msr -rp $1 --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" "${@:2}"
}; _find_ndp'

alias find-ps='msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(ps1|psm1)$" -I --s1 1B --s2 3.6MB "$@"'

alias find-ps-def='function _find_ps_def() {
	msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(ps1|psm1)$" -I --s1 1B --s2 3.6MB --nt "^\s*Export-ModuleMember\s+-\w+" -t "(^\s*(function|class)|\[\w+\]\s*)\s*($1)\b|\s*($1)\s*=" "${@:2}"
}; _find_ps_def'

alias find-ps-ref='function _find_ps_ref() {
	msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(ps1|psm1)$" -I --s1 1B --s2 3.6MB -t "\b$1\b" "${@:2}"
}; _find_ps_ref'

alias find-pure-ref='function _find_pure_ref() {
	msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(cs(html)?|cpp|cxx|h|hpp|cc?|c\+{2}|\w+proj|sln|nuspec|config|conf|resx|props|java|scala|py|go|rs|php|vue|tsx?|jsx?|json|ya?ml|xml|ini|md|ipynb|rst|sh|bat|cmd|psm?1)$|^readme|^make\w+$" -I --s1 1B --s2 3.6MB --nt "^\s*(#|/|\*|(or|from|import)\s+)|^.{360,}" -t "\b$1\b" "${@:2}"
}; _find_pure_ref'

alias find-py='msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.py$" -I --s1 1B --s2 3.6MB "$@"'

alias find-py-def='function _find_py_def() {
	msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.py$" -I --s1 1B --s2 3.6MB --nt "^\s*([a-z0-9]+(\.|->|::)[A-Z]|[^\s\w]|\S+\s*=\s*[a-zA-Z])|^\s*(return|await|throw|except|raise|new|(el)?if|for|from|val)\s+|new\s+$1\s*\(|=\s*$1\s*\(|^\s*p[a-z]+\s+$1\s*\(" -t "^\s*(#\s*define\s+|(p[a-z]+|sealed|internal|readonly|const|static|volatile|final|type)\s+[\w\s,\?<>\[\]]{0,100})\b($1)\b|^\s*\w+[\w\s,\?<>]{0,80}\b($1)\s*(?:[\(\{:<]|extends|implements|$)" "${@:2}"
}; _find_py_def'

alias find-py-ref='function _find_py_ref() {
	msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.py$" -I --s1 1B --s2 3.6MB -t "\b$1\b" "${@:2}"
}; _find_py_ref'

alias find-ref='function _find_ref() {
	msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(cs(html)?|cpp|cxx|h|hpp|cc?|c\+{2}|\w+proj|sln|nuspec|config|conf|resx|props|java|scala|py|go|rs|php|vue|tsx?|jsx?|json|ya?ml|xml|ini|md|ipynb|rst|sh|bat|cmd|psm?1)$|^readme|^make\w+$" -I --s1 1B --s2 3.6MB -t "\b$1\b" "${@:2}"
}; _find_ref'

alias find-rs='msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(rs)$" -I --s1 1B --s2 3.6MB "$@"'

alias find-rs-def='function _find_rs_def() {
	msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(rs)$" -I --s1 1B --s2 3.6MB --nt "^\s*([a-z0-9]+(\.|->|::)[A-Z]|[^\s\w]|\S+\s*=\s*[a-zA-Z])|^\s*(return|await|throw|except|raise|new|(el)?if|for|from|val)\s+|new\s+$1\s*\(|=\s*$1\s*\(|^\s*p[a-z]+\s+$1\s*\(" -t "^\s*(#\s*define\s+|(p[a-z]+|sealed|internal|readonly|const|static|volatile|final|type)\s+[\w\s,\?<>\[\]]{0,100})\b($1)\b|^\s*\w+[\w\s,\?<>]{0,80}\b($1)\s*(?:[\(\{:<]|extends|implements|$)" "${@:2}"
}; _find_rs_def'

alias find-rs-ref='function _find_rs_ref() {
	msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(rs)$" -I --s1 1B --s2 3.6MB -t "\b$1\b" "${@:2}"
}; _find_rs_ref'

alias find-script='function _find_script() {
	msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(bat|cmd|psm?1|sh|bash|[kzct]sh)$" -I --s1 1B "$@"
}; _find_script'

alias find-sh='msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(sh|bash|ksh|zsh|csh|tsh)$" -I --s1 1B --s2 3.6MB "$@"'

alias find-sh-def='function _find_sh_def() {
	msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(sh|bash|ksh|zsh|csh|tsh)$" -I --s1 1B --s2 3.6MB --nt "^\s*([a-z0-9]+(\.|->|::)[A-Z]|[^\s\w]|\S+\s*=\s*[a-zA-Z])|^\s*(return|await|throw|except|raise|new|(el)?if|for|from|val)\s+|new\s+$1\s*\(|=\s*$1\s*\(|^\s*p[a-z]+\s+$1\s*\(" -t "(^\s*(function\s+)?)($1)\s*\(|\b(export|let|local)?\s*($1)\s*=|^\s*declare(\s+-\S+)?\s+$1\b" "${@:2}"
}; _find_sh_def'

alias find-sh-ref='function _find_sh_ref() {
	msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(sh|bash|ksh|zsh|csh|tsh)$" -I --s1 1B --s2 3.6MB -t "\b$1\b" "${@:2}"
}; _find_sh_ref'

alias find-small='msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" --s1 1B --s2 1.6MB -I "$@"'

alias find-top-code-folder='msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(cs(html)?|cpp|cxx|h|hpp|cc?|c\+{2}|java|scala|py|go|rs|php)$" -l -PAC --xd -k 18 | nin nul "^([^\\/]+)[\\/]" -p -d  $*'

alias find-top-code-type='msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(cs(html)?|cpp|cxx|h|hpp|cc?|c\+{2}|java|scala|py|go|rs|php)$" -l -PAC --xd -k 18 | nin nul "\.(\w+)$" -p -d  $*'

alias find-top-folder='msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -l -PAC --xd -k 18 | nin nul "^([^\\/]+)[\\/]" -p -d  $*'

alias find-top-source-folder='msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(cs(html)?|cpp|cxx|h|hpp|cc?|c\+{2}|\w+proj|sln|nuspec|config|conf|resx|props|java|scala|py|go|rs|php|vue|tsx?|jsx?|json|ya?ml|xml|ini|md|ipynb|rst|sh|bat|cmd|psm?1)$|^readme|^make\w+$" -l -PAC --xd -k 18 | nin nul "^([^\\/]+)[\\/]" -p -d  $*'

alias find-top-source-type='msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(cs(html)?|cpp|cxx|h|hpp|cc?|c\+{2}|\w+proj|sln|nuspec|config|conf|resx|props|java|scala|py|go|rs|php|vue|tsx?|jsx?|json|ya?ml|xml|ini|md|ipynb|rst|sh|bat|cmd|psm?1)$|^readme|^make\w+$" -l -PAC --xd -k 18 | nin nul "\.(\w+)$" -p -d  $*'

alias find-top-type='msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -l -PAC --xd -k 18 | nin nul "\.(\w+)$" -p -d  $*'

alias find-ui='msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(js|ts|jsx|tsx|vue)$" -I --s1 1B --s2 3.6MB "$@"'

alias find-ui-def='function _find_ui_def() {
	msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(js|ts|jsx|tsx|vue)$" -I --s1 1B --s2 3.6MB --nt "^\s*([a-z0-9]+(\.|->|::)[A-Z]|[^\s\w]|\S+\s*=\s*[a-zA-Z])|^\s*(return|await|throw|except|raise|new|(el)?if|for|from|val)\s+|new\s+$1\s*\(|=\s*$1\s*\(|^\s*p[a-z]+\s+$1\s*\(" -t "^\s*((p[a-z]+|internal|sealed|readonly|const|static|function|volatile)\s+[\w\s,<>\[\]]{0,100})\b($1)\b|^\s*\w+[\w\s<,>]{0,100}\b($1)\s*(?:[\(\{:<]|extends|implements|$)" "${@:2}"
}; _find_ui_def'

alias find-ui-ref='function _find_ui_ref() {
	msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(js|ts|jsx|tsx|vue)$" -I --s1 1B --s2 3.6MB -t "\b$1\b" "${@:2}"
}; _find_ui_ref'

alias malias='function _malias() {
	alias | msr -PI -t "^\s*alias\s+($1)" "${@:2}"
}; _malias'

alias open-.1-alias='code /var/folders/89/drct3dwj67l4qtr1vm4vs7lw0000gp/T/.1..bashrc '

alias open-alias='code $HOME/.bashrc '

alias out-fp='msr -p /var/folders/89/drct3dwj67l4qtr1vm4vs7lw0000gp/T/.1..bashrc  -b "alias find-.*?=.*?function" -Q "^\s*\}" --nt "use-[wr]p|out-[fr]p|find-ndp|\s+-W\s+" -t "^(\s*msr -rp.*?\S+)" -o "\1 -W" -R -c Output full path for functions ; msr -p /var/folders/89/drct3dwj67l4qtr1vm4vs7lw0000gp/T/.1..bashrc  --nt "use-[wr]p|out-[fr]p|find-ndp|\s+-W\s+" -t "(alias find-.*?=.*?msr -rp.*?\S+)" -o "\1 -W" -R -c Output full path ; source /var/folders/89/drct3dwj67l4qtr1vm4vs7lw0000gp/T/.1..bashrc '

alias out-rp='msr -p /var/folders/89/drct3dwj67l4qtr1vm4vs7lw0000gp/T/.1..bashrc  -b "alias find-.*?=.*?function" -Q "^\s*\}" --nt "use-[wr]p|out-[fr]p|find-ndp" -t "^(\s*msr -rp.*?)\s+-W\s+(.*)" -o "\1 \2" -R -c Output relative path for functions ; msr -p /var/folders/89/drct3dwj67l4qtr1vm4vs7lw0000gp/T/.1..bashrc  --nt "use-[wr]p|out-[fr]p|find-ndp" -t "(alias find-.*?=.*?msr -rp.*?)\s+-W\s+(.*)" -o "\1 \2" -R -c Output relative path ; source /var/folders/89/drct3dwj67l4qtr1vm4vs7lw0000gp/T/.1..bashrc '

alias sort-by-size='msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" --sz --wt -l $*'

alias sort-by-time='msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" --wt --sz -l $*'

alias sort-code-by-size='msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(cs(html)?|cpp|cxx|h|hpp|cc?|c\+{2}|java|scala|py|go|rs|php)$" --sz --wt -l $*'

alias sort-code-by-time='msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(cs(html)?|cpp|cxx|h|hpp|cc?|c\+{2}|java|scala|py|go|rs|php)$" --wt --sz -l $*'

alias sort-source-by-size='msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(cs(html)?|cpp|cxx|h|hpp|cc?|c\+{2}|\w+proj|sln|nuspec|config|conf|resx|props|java|scala|py|go|rs|php|vue|tsx?|jsx?|json|ya?ml|xml|ini|md|ipynb|rst|sh|bat|cmd|psm?1)$|^readme|^make\w+$" --sz --wt -l $*'

alias sort-source-by-time='msr -rp . --nd "^([\.\$]|(Release|Debug|objd?|bin|node_modules|bower_components|CVS|static|dist|target|(Js)?Packages|\w+-packages?)$|__pycache__)" -f "\.(cs(html)?|cpp|cxx|h|hpp|cc?|c\+{2}|\w+proj|sln|nuspec|config|conf|resx|props|java|scala|py|go|rs|php|vue|tsx?|jsx?|json|ya?ml|xml|ini|md|ipynb|rst|sh|bat|cmd|psm?1)$|^readme|^make\w+$" --wt --sz -l $*'

alias update-.1-alias='source /var/folders/89/drct3dwj67l4qtr1vm4vs7lw0000gp/T/.1..bashrc '

alias update-alias='source $HOME/.bashrc '

alias use-fp='msr -p /var/folders/89/drct3dwj67l4qtr1vm4vs7lw0000gp/T/.1..bashrc  -b "alias find-.*?=.*?function" -Q "^\s*\}" --nt "use-[wr]p|out-[fr]p|find-ndp" -t "msr -rp . " -o "msr -rp $HOME/.1,$HOME/.1/.hidden " -R -c Use workspace paths for all find-def + find-xxx-def functions ; msr -p /var/folders/89/drct3dwj67l4qtr1vm4vs7lw0000gp/T/.1..bashrc  -b "alias find-.*?=.*?function" -Q "^\s*\}" --nt "use-[wr]p|out-[fr]p|find-ndp|find-\S*def" -t "msr -rp . " -o "msr -rp $HOME/.1,$HOME/.1/.hidden " -R -c Use workspace paths for other functions like find-ref or find-doc etc. ; msr -p /var/folders/89/drct3dwj67l4qtr1vm4vs7lw0000gp/T/.1..bashrc  --nt "use-[wr]p|out-[fr]p|find-ndp" -t "(alias find-\S*def=.*?)msr -rp . " -o "\1msr -rp $HOME/.1,$HOME/.1/.hidden " -R -c Use workspace paths for all find-def + find-xxx-def ; msr -p /var/folders/89/drct3dwj67l4qtr1vm4vs7lw0000gp/T/.1..bashrc  --nt "use-[wr]p|out-[fr]p|find-ndp|find-\S*def" -t "(alias find.*?=.*?)msr -rp . "  -o "\1msr -rp $HOME/.1,$HOME/.1/.hidden " -R -c Use workspace paths for others like find-ref or find-doc etc. ; source /var/folders/89/drct3dwj67l4qtr1vm4vs7lw0000gp/T/.1..bashrc '

alias use-rp='msr -p /var/folders/89/drct3dwj67l4qtr1vm4vs7lw0000gp/T/.1..bashrc  -b "alias find-.*?=.*?function" -Q "^\s*\}" --nt "use-[wr]p|out-[fr]p|find-ndp" -t "^(\s*)msr\s+-rp\s+\S+"  -o "\1msr -rp ."  -R -c Use relative paths for all find-xxx functions ; msr -p /var/folders/89/drct3dwj67l4qtr1vm4vs7lw0000gp/T/.1..bashrc  --nt "use-[wr]p|out-[fr]p|find-ndp" -t "^(\s*alias find-.*?=.*?)msr\s+-rp\s+\S+" -o "\1msr -rp ."  -R -c Use relative paths for all find-xxx ; source /var/folders/89/drct3dwj67l4qtr1vm4vs7lw0000gp/T/.1..bashrc '

