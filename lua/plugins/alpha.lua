return {
	"goolord/alpha-nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.startify")
		dashboard.section.header.val = {
			[[  ____|   ]],
			[[  __|    __| _ \_  /  ]],
			[[  |     |    __/  /   ]],
			[[ _____|_|  \___|___| ]],
		}
    alpha.setup(dashboard.opts)
	end,
}
