local success, ui2 = pcall(require, "vim._core.ui2")
if not success then
	success, ui2 = pcall(require, "vim._extui")
end

ui2.enable({})
