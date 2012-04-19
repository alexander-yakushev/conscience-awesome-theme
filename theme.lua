-- Conscience awesome theme
-- By Unlogic, based on Blazeix nice-and-clean theme and Zhuravlik's theme

local util = require("awful.util")
local lustrous = require("lustrous")

theme = {}

local function res(res_name)
   return theme.time_spec_dir .. "/" .. res_name
end

local function png_res(res_name)
   return "png:" .. res(res_name)
end

theme.name = "Conscience v0.5"
theme.theme_dir = awful.util.getdir("config") .. "/themes/conscience"
theme.onscreen_file = "/onscreen.lua"

theme.time = lustrous.init({ theme_dir = theme.theme_dir,
                             lat = 50, lon = 30, offset = 3 })

theme.time_spec_dir = theme.theme_dir .. "/" .. theme.time
dofile(res("time_specific.lua"))
lustrous.update_gtk_theme('/home/unlogic/.gtkrc-2.0', res('.gtkrc-2.0'))

theme.wallpaper_cmd = { "awsetbg " .. res("background.jpg") }
theme.icon_dir      = res("icons")

theme.font          = "sans 8"

theme.bg_normal     = png_res("bg_normal.png")
theme.bg_focus      = png_res("bg_focus.png")

-- Display the taglist squares
theme.taglist_squares_sel   = res("taglist/squarefw.png")
theme.taglist_squares_unsel = res("taglist/squarew.png")

-- Menu settings
theme.menu_submenu_icon = res("icons/submenu.png")
theme.menu_height       = 15
theme.menu_width        = 110
theme.menu_border_width = 0

-- Layout icons. I use only four layouts so the rest are not provided
-- and commented here. Add your own icons for missing layouts.
theme.layout_floating   = res("layouts/floating.png")
theme.layout_max        = res("layouts/max.png")
theme.layout_tile       = res("layouts/tile.png")
theme.layout_tilebottom = res("layouts/tilebottom.png")
-- theme.layout_fairh      = res("layouts/fairh.png")
-- theme.layout_fairv      = res("layouts/fairv.png")
-- theme.layout_magnifier  = res("layouts/magnifier.png")
-- theme.layout_fullscreen = res("layouts/fullscreen.png")
-- theme.layout_tileleft   = res("layouts/tileleft.png")
-- theme.layout_tiletop    = res("layouts/tiletop.png")
-- theme.layout_spiral     = res("layouts/spiral.png")
-- theme.layout_dwindle    = res("layouts/dwindle.png")

theme.awesome_icon = res("icons/awesome16.png")

-- Configure naughty
if naughty then
   local presets = naughty.config.presets
   presets.normal.bg = theme.bg_normal_color
   presets.normal.fg = theme.fg_normal_color
   presets.low.bg = theme.bg_normal_color
   presets.low.fg = theme.fg_normal_color
   presets.normal.border_color = theme.bg_focus_color
   presets.low.border_color = theme.bg_focus_color
   presets.critical.border_color = theme.motive
   presets.critical.bg = theme.bg_urgent
   presets.critical.fg = theme.motive
end

-- Onscreen widgets
local onscreen_file = theme.theme_dir .. theme.onscreen_file

if util.file_readable(onscreen_file) then
   theme.onscreen = dofile(onscreen_file)
else
   error("E: beautiful: file not found: " .. onscreen_file)
end

return theme
