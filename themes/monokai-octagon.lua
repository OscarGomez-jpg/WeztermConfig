-- monokai_octagon.lua
return {
	colors = {
		-- Colores principales
		foreground = "#eaf2f1",
		background = "#282a39",

		-- Cursor
		cursor_bg = "#ffd86b",
		cursor_fg = "#282a39",
		cursor_border = "#ffd86b",

		-- Selección
		selection_fg = "#282a39",
		selection_bg = "#9cd1bb",

		-- Paleta ANSI (basada en el script)
		ansi = {
			"#282a3a",
			"#ff657a",
			"#bad761",
			"#ffd76d",
			"#ff9b5e",
			"#c39ac9",
			"#9cd1bb",
			"#eaf2f1",
		},
		brights = {
			"#696d77",
			"#ff657a",
			"#bad761",
			"#ffd76d",
			"#ff9b5e",
			"#c39ac9",
			"#9cd1bb",
			"#eaf2f1",
		},

		-- Elementos UI específicos
		scrollbar_thumb = "#444444",
		split = "#303246",
		compose_cursor = "#FFC324",
		copy_mode_active_highlight_bg = { Color = "#FFD76D" },
		quick_select_label_bg = { Color = "#FFBE12" },
		quick_select_match_bg = { Color = "#FF7789" },
	},
}
