-- Onscreen widgets module for Conscience theme

local infojets = require("infojets")
local pango = infojets.util.pango
local wibox = require("wibox")
local asyncshell = require("asyncshell")

local onscreen = {}
local config = {}

function onscreen.init()
   if theme.onscreen_config then
      config = theme.onscreen_config
   end
   onscreen.init_logwatcher()
   onscreen.init_processwatcher()
   onscreen.init_calendar()
   onscreen.init_jetclock()
end

function onscreen.init_logwatcher()
   local c = config.logwatcher or {}
   local wheight = c.height or 195
   local wb = infojets.create_wibox({ width = c.width or 695,
                                      height = wheight,
                                      x = c.x or 23,
                                      y = c.y or -29,
                                      bg_color = theme.bg_onscreen })
   w = infojets.logwatcher.new()
   -- w:add_log_directory('/home/unlogic', { { file = '.xsession-errors',
   --                                          mask = "(.+)" } })
   w:add_log_directory('/var/log', {
                          { file = 'auth.log',
                            mask = ".+ (%d%d:%d%d:%d%d )%w+ (.+)",
                            ignore = { "crond:session" }
                         },
                         --  { file = 'user.log',
                         --    mask = ".+ (%d%d:%d%d:%d%d )%w+ (.+)",
                         --    ignore = { "mtp-probe:" }
                         -- },
                          { file = 'errors.log',
                            mask = ".+ (%d%d:%d%d:%d%d )%w+ (.+)",
                            ignore = { "dhcpcd", "sendmail" }
                         },
                          { file = 'kernel.log',
                            mask = ".+ (%d%d:%d%d:%d%d )%w+ (%w+: )%[%s*[%d%.]+%] (.+)"
                         },
                          { file = 'messages.log',
                            mask = ".+ (%d%d:%d%d:%d%d )%w+ (.+)",
                            ignore = { "\\-\\- MARK \\-\\-",
                                       " kernel: " }
                         },
                          { file = 'pacman.log',
                            mask = "%[(%d%d%d%d%-%d%d%-%d%d %d%d:%d%d)%](.+)" ,
                            ignore = { "Running " }
                         }
                       })
   w.font = 'Helvetica 9'
   w.title_font = 'Helvetica 9'
   w:calculate_line_count(wheight)
   w.line_length = c.line_length or 120
   w:run()

   wb:set_widget(w.widget)
end

function onscreen.init_processwatcher()
   local c = config.processwatcher or {}
   local wheight = c.height or 193
   local wb = infojets.create_wibox({ width = c.width or 200, height = wheight,
                                      x = c.x or -26, y = c.y or -31,
                                      bg_color = theme.bg_onscreen })
   infojets.processwatcher.default.current_file = 2
   w = infojets.processwatcher.new()
   w:set_process_sorters({ { name = "Top CPU",
                             sort_by = "pcpu",
                             ignore = { "defunct", "migration" } },
                           { name = "Top memory",
                             sort_by = "rss",
                             ignore = { "defunct", "migration" } } })

   w.font = 'DejaVu Sans Mono 10'
   w.title_font = 'Helvetica 10'
   w:calculate_line_count(wheight)
   w.line_length = c.line_length or 40
   w:run()

   wb:set_widget(w.widget)
end

function onscreen.init_calendar()
   local c = config.calendar or {}
   local editor = "emacsclient -c"
   local gcal_org = "/home/unlogic/Documents/Notes/gcal.org"

   require('orglendar')
   orglendar.files = { "/home/unlogic/Documents/Notes/edu.org",
                        gcal_org }
   orglendar.text_color = c.text_color or theme.fg_focus
   orglendar.today_color = c.today_color or theme.fg_onscreen
   orglendar.event_color = theme.motive
   orglendar.font = "DejaVu Sans Mono 10"
   orglendar.char_width = 8.20
   orglendar.limit_todo_length = c.limit_todo_length or 50
   orglendar.parse_on_show = false

   local cal_box_height = c.cal_height or 120
   local cal_box = infojets.create_wibox({ width = c.cal_width or 170, height = cal_box_height,
                                           x = c.cal_x or -35, y = c.cal_y or 45,
                                           bg_color = theme.bg_onscreen })
   infojets.reposition_wibox(cal_box)
   local cal_layout = wibox.layout.align.horizontal()
   local cal_tb = wibox.widget.textbox()
   cal_tb:set_valign("top")
   cal_layout:set_right(cal_tb)
   cal_box:set_widget(cal_layout)

   local todo_box = infojets.create_wibox({ width = c.todo_width or 300,
                                            height = c.todo_height or 290,
                                            x = c.todo_x or -30, y = (c.todo_y or 47) + cal_box_height,
                                            bg_color = theme.bg_onscreen })
   local todo_tb = wibox.widget.textbox()
   local todo_layout = wibox.layout.align.horizontal()
   todo_tb:set_valign("top")
   todo_layout:set_left(todo_tb)
   todo_box:set_widget(todo_layout)

   local offset = 0

   local update_orglendar =
      function(inc_offset)
         offset = offset + (inc_offset or 0)
         local cal, todo = orglendar.get_calendar_and_todo_text(offset)

         cal_tb:set_markup(cal)
         todo_tb:set_markup(todo)
         todo_box.width = orglendar.limit_todo_length * orglendar.char_width
         infojets.reposition_wibox(todo_box)
      end

   local update_gcal_file =
      function()
         local ical_script = "/home/unlogic/scripts/ical2org"
         local private_link = private.gcal_link
         local dest = gcal_org
         local req = "wget " .. private_link .. " -O /tmp/gcal.ics"
         print(req)
         asyncshell.request(req,
                            function()
                               os.execute(ical_script .. " < /tmp/gcal.ics > " .. dest)
                               orglendar.parse_agenda()
                               update_orglendar()
                            end)
      end

   update_gcal_file()

   cal_tb:buttons(awful.util.table.join(
                     awful.button({ }, 2,
                                  function ()
                                     offset = 0
                                     update_orglendar()
                                  end),
                     awful.button({ }, 4,
                                  function ()
                                     update_orglendar(-1)
                                  end),
                     awful.button({ }, 5,
                                  function ()
                                     update_orglendar(1)
                                  end)))
   todo_tb:buttons(awful.util.table.join(
                      awful.button({ }, 1,
                                   function ()
                                      awful.util.spawn(editor .. " " .. orglendar.files[1])
                                   end),
                      awful.button({ }, 4,
                                   function ()
                                      update_orglendar(-1)
                                   end),
                      awful.button({ }, 5,
                                   function ()
                                      update_orglendar(1)
                                   end),
                      awful.button({ }, 3,
                                   function ()
                                      update_gcal_file()
                                      orglendar.parse_agenda()
                                      update_orglendar()
                                   end)))
   update_orglendar()
   --   repeat_every(update_todo,600)
end

function onscreen.init_jetclock()
   local c = config.clock or {}
   local scrwidth = c.scrwidth or 1280 -- For current display

   local radius = c.radius or 132
   local clock_width = c.clock_hard_width or (radius * 2)
   local clock_height = c.clock_hard_height or (radius * 2)
   local info_height = c.height or 95
   local wb = infojets.create_wibox({ width = clock_width,
                                      height = clock_height + info_height,
                                      x = c.x or (scrwidth / 2 - radius - 2),
                                      y = c.y or 100,
                                      bg_color = theme.bg_onscreen})

   infojets.jetclock.bg_color      = c.bg_color or "#222222CC"
   infojets.jetclock.ring_bg_color = c.ring_bg_color or "#AAAAAA33"
   infojets.jetclock.ring_fg_color = c.ring_fg_color or "#AAAAAAFF"
   infojets.jetclock.hand_color    = c.hand_color or "#CCCCCCCC"
   infojets.jetclock.hand_motive   = c.hand_motive or "#76eec6CC"
   infojets.jetclock.text_hlight   = c.text_hlight or theme.motive
   infojets.jetclock.text_font     = c.text_font or "Helvetica 11"
   infojets.jetclock.shift_str     = c.shift or "    "
   infojets.jetclock.shape         = c.shape or "circle"

   w = infojets.jetclock.new(clock_width, clock_height, info_height, radius)

   remind = function(...) w:remind(...) end

   w:run()
   wb:set_widget(w.widget)
end

return onscreen