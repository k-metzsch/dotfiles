require("full-border"):setup({
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.ROUNDED,
})

require("bookmarks"):setup({
	last_directory = { enable = false, persist = false, mode = "dir" },
	persist = "all",
	desc_format = "parent",
	file_pick_mode = "parent",
	custom_desc_input = true,
	show_keys = true,
	notify = {
		enable = false,
		timeout = 1,
		message = {
			new = "New bookmark '<key>' -> '<folder>'",
			delete = "Deleted bookmark in '<key>'",
			delete_all = "Deleted all bookmarks",
		},
	},
})

require("yatline"):setup({
	show_background = true,

	header_line = {
		left = {
			section_a = {
				{ type = "line", custom = false, name = "tabs", params = { "left" } },
			},
			section_b = {},
			section_c = {},
		},
		right = {
			section_a = {
				{ type = "coloreds", custom = true, name = { { " 󰇥 ", "#3c3836" } } },
			},
			section_b = {},
			section_c = {
				{ type = "coloreds", custom = false, name = "count" },
			},
		},
	},

	status_line = {
		left = {
			section_a = {},
			section_b = {},
			section_c = {},
		},
		right = {
			section_a = {},
			section_b = {},
			section_c = {},
		},
	},
})
