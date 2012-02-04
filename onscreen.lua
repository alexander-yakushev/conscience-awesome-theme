-- Onscreen widgets module for Conscience theme

local infojets = require("infojets")
local pango = infojets.util.pango
local wibox = require("wibox")
require('orglendar')

local onscreen = {}

function onscreen.init()
   onscreen.init_logwatcher()
   onscreen.init_processwatcher()
   onscreen.init_calendar()
   onscreen.init_jetclock()
end

function onscreen.init_logwatcher()
   local wheight = 200
   local wb = infojets.create_wibox({ width = 700, height = wheight,
                                      x = 20, y = -20, bg_color = theme.bg_onscreen })
   w = infojets.logwatcher.new()
   w:add_log_directory('/home/unlogic', { { file = '.xsession-errors',
                                            mask = "(.+)" } })
   w:add_log_directory('/var/log', { 
                          { file = 'auth.log', 
                            mask = ".+ (%d%d:%d%d:%d%d )%w+ (.+)",
                            ignore = { "crond:session" } 
                         },
                          { file = 'user.log', 
                            mask = ".+ (%d%d:%d%d:%d%d )%w+ (.+)" 
                         },
                          { file = 'errors.log', 
                            mask = ".+ (%d%d:%d%d:%d%d )%w+ (.+)",
                            ignore = { "dhcpcd" } 
                         },
                          { file = 'kernel.log',
                            mask = ".+ (%d%d:%d%d:%d%d )%w+ (%w+: )%[%s*[%d%.]+%] (.+)" 
                         },
                          { file = 'messages.log',
                            mask = ".+ (%d%d:%d%d:%d%d )%w+ (.+)",
                            ignore = { "\\-\\- MARK \\-\\-" } 
                         },
                          { file = 'wicd/wicd.log',
                            mask = "%d+%/%d+%/%d+ (.+)" 
                         } 
                       })
   w.font = 'Helvetica 9'
   w.title_font = 'Helvetica 9'
   w:calculate_line_count(wheight)
   w.line_length = 120
   w:run()

   wb:set_widget(w.widget)
end

function onscreen.init_processwatcher()
   local wheight = 200
   local wb = infojets.create_wibox({ width = 200, height = wheight,
                                      x = -20, y = -25, bg_color = theme.bg_onscreen })
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
   w.line_length = 40
   w:run()

   wb:set_widget(w.widget)
end

function onscreen.init_calendar()
   local editor = "emc"
   orglendar.files = { "/home/unlogic/Documents/Notes/edu.org" }
   orglendar.today_color = theme.fg_onscreen
   orglendar.event_color = theme.motive
   orglendar.font = "DejaVu Sans Mono 10"
   orglendar.char_width = 9
   
   local cal_box_height = 120
   local cal_box = infojets.create_wibox({ width = 180, height = cal_box_height,
                                           x = -20, y = 30, bg_color = theme.bg_onscreen })
   infojets.reposition_wibox(cal_box)
   local cal_layout = wibox.layout.align.horizontal()
   local cal_tb = wibox.widget.textbox()
   cal_tb:set_valign("top")
   cal_layout:set_right(cal_tb)
   cal_box:set_widget(cal_layout)
   
   local todo_box = infojets.create_wibox({ width = 300, height = 300,
                                            x = -20, y = 30 + cal_box_height, 
                                            bg_color = theme.bg_onscreen })
   local todo_tb = wibox.widget.textbox()
   local todo_layout = wibox.layout.align.horizontal()
   todo_tb:set_valign("top")
   todo_layout:set_right(todo_tb)
   todo_box:set_widget(todo_layout)

   local offset = 0
   local update_calendar =
      function(inc_offset)
         offset = offset + inc_offset
         local caltext = orglendar.generate_calendar(offset).calendar
         cal_tb:set_markup(pango(caltext, { foreground = "#FFFFFF" }))
      end
   
   local update_todo = 
      function()
         local query = os.date("%Y-%m-%d")
         local todotext, _, length = orglendar.create_string(query,motive,"DejaVu Sans Mono 10")
         if todotext == '<span font="DejaVu Sans Mono 10"></span>' then 
            todotext = '<span font="DejaVu Sans Mono 10"> </span>'
         end
         todo_tb:set_markup(pango(todotext, { foreground = "#FFFFFF" }))
         todo_box.width = length * orglendar.char_width
         infojets.reposition_wibox(todo_box)
         update_calendar(0)
      end
   
   cal_tb:buttons(awful.util.table.join(
                     awful.button({ }, 2,
                                  function ()
                                     offset = 0
                                     update_calendar(0)
                                  end),
                     awful.button({ }, 4, 
                                  function ()
                                     update_calendar(-1)
                                  end),
                     awful.button({ }, 5, 
                                  function ()
                                     update_calendar(1)
                                  end)))
   todo_tb:buttons(awful.util.table.join(
                      awful.button({ }, 1,
                                   function ()
                                      awful.util.spawn(editor .. " " .. orglendar.files[1])
                                   end),
                      awful.button({ }, 4, 
                                   function ()
                                      update_calendar(-1)
                                   end),
                      awful.button({ }, 5, 
                                   function ()
                                      update_calendar(1)
                                   end),
                      awful.button({ }, 3, 
                                   function ()
                                      update_todo()
                                   end)))
   update_todo()
   --   repeat_every(update_todo,600)
end

function onscreen.init_jetclock()
   local scrwidth = 1280 -- For current display
   local radius = 150
   local wb = infojets.create_wibox({ width = radius * 2, height = radius * 2 + 100,
                                      x = scrwidth / 2 - radius, y = 50, 
                                      bg_color = theme.bg_onscreen })
   w = infojets.jetclock.new()
   w:set_radius(radius)
   remind = function(...) w:remind(...) end
   
   w:run()
   wb:set_widget(w.widget)
end

return onscreen