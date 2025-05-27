
rockspec_format = "3.0"
package = "lua"
version = "0.1.0-1"

description = {
summary = "A luxurious package manager for Lua",
license = "MIT",
maintainer = "vhyrro",
labels = {
"luarocks",
"package-manager",
},
}

dependencies = {
"lua ==5.1",
"toml-edit ==0.6.1",
"nvim-nio ==1.10.1",
"rtp.nvim ==1.2.0",
"fzy ==1.0.3",
"fidget.nvim ==1.6.0",
}

source = {
url = "https://example.com/what.tar",
}

build = {
type = "builtin",
}
