---@param findstart 0|1
---@param base string
---@return string[] | integer | nil
function _G.thesaurusfunc(findstart, base)
	if findstart == 1 then
		local start = vim.fn.searchpos("\\<", "bnW", vim.fn.line("."))[2] - 1
		return start
	end

	local words = { base }
	local obj = vim.system({ "dict", "--formatted", "-d", "moby-thesaurus", base }, {
		text = true,
		stdout = function(err, data)
			if not err and data then
				for _, line in ipairs(vim.split(data, "\n", { trimempty = true })) do
					if line:match("^%s+%a") then
						vim.list_extend(words, vim.split(vim.trim(line), ", ?", { trimempty = true }))
					end
				end
			end
		end,
	}):wait(10000)

	if obj.code ~= 0 then
		return { base }
	elseif base:match("^%u") then
		return vim.iter(words)
			:map(function(s)
				s = s:gsub("^(%l)(%w*)", function(a, b)
					return a:upper() .. b
				end)
				return s
			end)
			:totable()
	else
		return words
	end
end

vim.opt.thesaurusfunc = "v:lua._G.thesaurusfunc"
