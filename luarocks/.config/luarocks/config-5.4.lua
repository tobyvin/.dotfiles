---@diagnostic disable: lowercase-global, undefined-global
--# selene: allow(unused_variable, unscoped_variables, undefined_variable)
local_by_default = true
home_tree = home .. "/.local"
rocks_trees = {
	{
		name = "user",
		root = home_tree,
	},
	{
		name = "system",
		root = "/usr",
	},
}
