local status_ok, lspkind = pcall(require, "lspkind")
if not status_ok then
	return
end

lspkind.init({
	symbol_map = { typeparameter = "" },
})
