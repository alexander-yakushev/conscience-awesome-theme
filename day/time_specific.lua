-- Day mode of Conscience theme

theme.font            = "sans 8"

theme.motive          = "#590900"
theme.motive2         = "#84472a"

theme.bg_normal_color = "#e3dad1"
theme.bg_focus_color  = "#444444"
theme.bg_urgent       = "#c77b4b"
theme.bg_minimize     = "#e3dad1"
theme.bg_onscreen     = "#FFFFFF00"

theme.fg_normal       = "#000000"
theme.fg_focus        = "#ffffff"
theme.fg_urgent       = "#000000"
theme.fg_minimize     = "#000000"
theme.fg_onscreen     = "#7f7f7f"

theme.border_width    = 1
theme.border_normal   = "#222222"
theme.border_focus    = "#000000"
theme.border_marked   = "#91231c"

theme.blingbling = { text_color = theme.fg_focus,
                     graph_color = "#dec9b4",
                     bg_graph_color = "#590900" }

theme.onscreen_config = { logwatcher = { x = -20, y = -20, line_length = 80, width = 470 },
                          processwatcher = { x = -20, y = 30 },
                          clock = { x = 398, y = -1, radius = 160, height = 85,
                                    ring_bg_color = theme.motive2 .. "33",
                                    ring_fg_color = theme.motive2 .. "FF",
                                    hand_color = theme.motive2 .. "CC",
                                    shift = "       ",
                                    shape = "circle" },
                          calendar = { text_color = theme.fg_normal,
                                       today_color = theme.motive2,
                                       cal_x = 15, todo_x = 15,
                                       cal_y = 30, todo_y = 30 } }