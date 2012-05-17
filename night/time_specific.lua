-- Night mode of Conscience theme

theme.font            = "sans 8"

theme.motive          = "#76eec6"

theme.bg_normal_color = "#222222"
theme.bg_focus_color  = "#444444"
theme.bg_urgent       = "#7f7f7f"
theme.bg_minimize     = "#444444"
theme.bg_onscreen     = "#22222200"

theme.fg_normal       = "#dddddd"
theme.fg_focus        = "#ffffff"
theme.fg_urgent       = "#ffffff"
theme.fg_minimize     = "#ffffff"
theme.fg_onscreen     = "#7f7f7f"

theme.border_width    = 1
theme.border_normal   = "#222222"
theme.border_focus    = "#000000"
theme.border_marked   = "#91231c"

theme.blingbling = { text_color = theme.bg_focus_color,
                     graph_color = theme.motive,
                     bg_graph_color = theme.bg_normal_color }

theme.onscreen_config = { logwatcher = { x = -20, y = -20, line_length = 80, width = 470 },
                          processwatcher = { x = -20, y = 30 },
                          clock = { x = 490, y = -172, radius = 123.25, height = 85,
                                    clock_hard_width = 300,
                                    clock_hard_height = 90 * 2.5,
                                    ring_bg_color = theme.fg_normal .. "33",
                                    ring_fg_color = theme.motive .. "FF",
                                    hand_color = theme.motive .. "CC",
                                    shape = "triangle",
                                    shift = "        "},
                          calendar = { text_color = theme.fg_normal,
                                       today_color = theme.fg_onscreen,
                                       cal_x = 15, todo_x = 15,
                                       cal_y = 30, todo_y = 30 } }