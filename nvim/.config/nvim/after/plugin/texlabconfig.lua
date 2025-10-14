local success, texlabconfig = pcall(require, "texlabconfig")
if not success then
	return
end

texlabconfig.setup({})
