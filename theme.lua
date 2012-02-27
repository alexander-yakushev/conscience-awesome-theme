-- Conscience awesome theme
-- By Unlogic, based on Blazeix nice-and-clean theme and Zhuravlik's theme

local util = require("awful.util")

theme = {}
theme.name = "Conscience v0.2"
theme.theme_dir = awful.util.getdir("config") .. "/themes/conscience"
theme.wallpaper_cmd = { "awsetbg " .. theme.theme_dir .. "/background.png" }
theme.icon_dir = theme.theme_dir .. '/icons'
theme.onscreen_file = "/onscreen.lua"

local function res(res_name)
   return theme.theme_dir .. "/" .. res_name
end

local function png_res(res_name)
   return "png:" .. res(res_name)
end

theme.font          = "sans 8"

theme.bg_normal     = png_res("bg_normal.png")
theme.bg_normal_color = "#222222"
theme.bg_focus      = png_res("bg_focus.png") -- Average color #272727
theme.bg_focus_color = "#444444"
theme.bg_urgent     = "#7f7f7f"
theme.bg_minimize   = "#444444"
theme.bg_onscreen   = "#222222"

theme.fg_normal     = "#dddddd"
theme.fg_focus      = "#ffffff" --"#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"
theme.fg_onscreen   = "#7f7f7f"

theme.border_width  = "1"
theme.border_normal = "#222222"
theme.border_focus  = "#000000"
theme.border_marked = "#91231c"

theme.motive = "#76eec6"--"#46b7b8"--"#7f7f7f"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Display the taglist squares
theme.taglist_squares_sel   = res("/taglist/squarefw.png")
theme.taglist_squares_unsel = res("/taglist/squarew.png")

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = theme.theme_dir .. "/submenu.png"
theme.menu_height = "15"
theme.menu_width  = "110"
theme.menu_border_width = "0"

-- Layout icons
theme.layout_fairh = theme.theme_dir .. "/layouts/fairhw.png"
theme.layout_fairv = theme.theme_dir .. "/layouts/fairvw.png"
theme.layout_floating  = theme.theme_dir .. "/layouts/floatingw.png"
theme.layout_magnifier = theme.theme_dir .. "/layouts/magnifierw.png"
theme.layout_max = theme.theme_dir .. "/layouts/maxw.png"
theme.layout_fullscreen = theme.theme_dir .. "/layouts/fullscreenw.png"
theme.layout_tilebottom = theme.theme_dir .. "/layouts/tilebottomw.png"
theme.layout_tileleft   = theme.theme_dir .. "/layouts/tileleftw.png"
theme.layout_tile = theme.theme_dir .. "/layouts/tilew.png"
theme.layout_tiletop = theme.theme_dir .. "/layouts/tiletopw.png"
theme.layout_spiral  = theme.theme_dir .. "/layouts/spiralw.png"
theme.layout_dwindle = theme.theme_dir .. "/layouts/dwindlew.png"

theme.awesome_icon = theme.theme_dir .. "/awesome16.png"

-- Configure naughty
if naughty then
   local presets = naughty.config.presets
   presets.normal.bg = theme.bg_normal_color
   presets.normal.fg = theme.fg_normal_color
   presets.low.bg = theme.bg_normal_color
   presets.low.fg = theme.fg_normal_color
   presets.normal.border_color = theme.bg_focus_color
   presets.low.border_color = theme.bg_focus_color
   presets.critical.border_color = theme.bg_focus_color
   presets.critical.bg = theme.motive
   presets.critical.fg = "#000000"
end

-- Onscreen widgets
local onscreen_file = theme.theme_dir .. theme.onscreen_file

if util.file_readable(onscreen_file) then
   theme.onscreen = dofile(onscreen_file)
else
   error("E: beautiful: file not found: " .. onscreen_file)
end

return theme
