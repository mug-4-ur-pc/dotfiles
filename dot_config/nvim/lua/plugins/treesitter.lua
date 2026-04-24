vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
		end
	end,
})

vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
})

local parsers = {
	"bash",
	"bibtex",
	"c",
	"cmake",
	"cpp",
	"csv",
	"diff",
	"dockerfile",
	"editorconfig",
	"go",
	"gomod",
	"gosum",
	"gowork",
	"html",
	"ini",
	"json",
	"json5",
	"lua",
	"luadoc",
	"luap",
	"make",
	"markdown",
	"markdown_inline",
	"python",
	"query",
	"regex",
	"sql",
	"tmux",
	"toml",
	"vim",
	"vimdoc",
	"yaml",
	"zsh",
}

require("nvim-treesitter").install(parsers)

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local buf, filetype = args.buf, args.match
		if string.find(filetype, "chezmoitmpl") then
			return
		end

		local language = vim.treesitter.language.get_lang(filetype)
		if not language then
			return
		end
		if not vim.treesitter.language.add(language) then
			return
		end

		vim.treesitter.start(buf, language)
		vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.wo.foldmethod = "expr"
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

require("treesitter-context").setup({
	enable = true,
	multiwindow = true,
	max_lines = 3,
	min_window_height = 0,
	line_numbers = true,
	multiline_threshold = 20,
	trim_scope = "outer",
	mode = "topline",
	separator = nil,
})
