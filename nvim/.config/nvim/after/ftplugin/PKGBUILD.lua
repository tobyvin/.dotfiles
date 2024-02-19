vim.cmd("runtime! ftplugin/sh.{vim,lua}")
vim.treesitter.language.register("bash", { "PKGBUILD" })
