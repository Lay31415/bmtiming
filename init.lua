local exports = {
  name = "bmtiming",
  description = "beatmania timing viewer",
  version = "0.1.1",
  author = { name = "Lay31415" },
  license = "MIT"
}

local bmtiming = exports

function bmtiming.startplugin()
  local config = {
    autoscr = false,
    autokey = false,
    autotiming = 0,
    rotate_angle = 10,
    on_frames = 1,
    view_timing = false,
    view_state = false,
  }

  -- Memory address where each version of timing is stored
  local game_addresses = {
    bm1stmix = {0x40709D, 0x4070A9, 0x4070B5, 0x4070C1, 0x4070CD, 0x4070D9, 0x4070A3, 0x4070AF, 0x4070BB, 0x4070C7, 0x4070D3, 0x4070DF},
    bm2ndmix = {0x4072AD, 0x4072B9, 0x4072C5, 0x4072D1, 0x4072DD, 0x4072E9, 0x4072B3, 0x4072BF, 0x4072CB, 0x4072D7, 0x4072E3, 0x4072EF},
    bm3rdmix = {0x407697, 0x4076A3, 0x4076AF, 0x4076BB, 0x4076C7, 0x4076D3, 0x40769D, 0x4076A9, 0x4076B5, 0x4076C1, 0x4076CD, 0x4076D9},
    bmcompmx = {0x40781D, 0x407829, 0x407835, 0x407841, 0x40784D, 0x407859, 0x407823, 0x40782F, 0x40783B, 0x407847, 0x407853, 0x40785F},
    bmcompmxb = {0x40781D, 0x407829, 0x407835, 0x407841, 0x40784D, 0x407859, 0x407823, 0x40782F, 0x40783B, 0x407847, 0x407853, 0x40785F},
    hmcompmx = {0x407813, 0x40781F, 0x40782B, 0x407837, 0x407843, 0x40784F, 0x407819, 0x407825, 0x407831, 0x40783D, 0x407849, 0x407855},
    bm4thmix = {0x407CA1, 0x407CAD, 0x407CB9, 0x407CC5, 0x407CD1, 0x407CDD, 0x407CA7, 0x407CB3, 0x407CBF, 0x407CCB, 0x407CD7, 0x407CE3},
    bm5thmix = {0x407C07, 0x407C13, 0x407C1F, 0x407C2B, 0x407C37, 0x407C43, 0x407C0D, 0x407C19, 0x407C25, 0x407C31, 0x407C3D, 0x407C49},
    bmcompm2 = {0x407C47, 0x407C53, 0x407C5F, 0x407C6B, 0x407C77, 0x407C83, 0x407C4D, 0x407C59, 0x407C65, 0x407C71, 0x407C7D, 0x407C89},
    hmcompm2 = {0x407C47, 0x407C53, 0x407C5F, 0x407C6B, 0x407C77, 0x407C83, 0x407C4D, 0x407C59, 0x407C65, 0x407C71, 0x407C7D, 0x407C89},
    bmclubmx = {0x407C47, 0x407C53, 0x407C5F, 0x407C6B, 0x407C77, 0x407C83, 0x407C4D, 0x407C59, 0x407C65, 0x407C71, 0x407C7D, 0x407C89},
    bmdct    = {0x407C47, 0x407C53, 0x407C5F, 0x407C6B, 0x407C77, 0x407C83, 0x407C4D, 0x407C59, 0x407C65, 0x407C71, 0x407C7D, 0x407C89},
    bmcorerm = {0x407C49, 0x407C59, 0x407C69, 0x407C79, 0x407C89, 0x407C99, 0x407C51, 0x407C61, 0x407C71, 0x407C81, 0x407C91, 0x407CA1},
    bm6thmix = {0x4079AF, 0x4079BF, 0x4079CF, 0x4079DF, 0x4079EF, 0x4079FF, 0x4079B7, 0x4079C7, 0x4079D7, 0x4079E7, 0x4079F7, 0x407A07},
    bm7thmix = {0x407CAF, 0x407CBF, 0x407CCF, 0x407CDF, 0x407CEF, 0x407CFF, 0x407CB7, 0x407CC7, 0x407CD7, 0x407CE7, 0x407CF7, 0x407D07},
    bmfinal  = {0x407CAF, 0x407CBF, 0x407CCF, 0x407CDF, 0x407CEF, 0x407CFF, 0x407CB7, 0x407CC7, 0x407CD7, 0x407CE7, 0x407CF7, 0x407D07}
  }
  -- Timing offset per version
  local offset = {
    bm1stmix = -1, bm2ndmix = -1, bm3rdmix = -1, bmcompmx = -1, bmcompmxb = -1, hmcompmx = -1,
    bm4thmix = -1, bm5thmix = -1, bmcompm2 = -1, hmcompm2 = -1, bmclubmx = -1, bmdct = -1, bmcorerm = -1,
    bm6thmix = 0, bm7thmix = 0, bmfinal = 0
  }
  -- Address to determine playing in progress
  local playing = {
    bm1stmix = 0x408a78,
    bm2ndmix = 0x409375,
    bm3rdmix = 0x409737,
    bmcompmx = 0x409915,
    bmcompmxb = 0x409915,
    hmcompmx = 0x409907,
    bm4thmix = 0x409ed7,
    bm5thmix = 0x40a035,
    bmcompm2 = 0x40a087,
    hmcompm2 = 0x40a087,
    bmclubmx = 0x40a0b7,
    bmdct = 0x40a0a5,
    bmcorerm = 0x4081c0,
    bm6thmix = 0x4098a7,
    bm7thmix = 0x409bb5,
    bmfinal = 0x409bb5
  }

  -- Display position in screen
  local locations = {
    {x =  16, y = 335},
    {x =  26, y = 320},
    {x =  36, y = 335},
    {x =  46, y = 320},
    {x =  56, y = 335},
    {x =  76, y = 328},
    {x = 385, y = 335},
    {x = 395, y = 320},
    {x = 405, y = 335},
    {x = 415, y = 320},
    {x = 425, y = 335},
    {x = 445, y = 328}
  }

  -- Correspondence between keymap and memory index
  local buttons_map = {
    Key11 = 1,
    Key12 = 2,
    Key13 = 3,
    Key14 = 4,
    Key15 = 5,
    Key21 = 7,
    Key22 = 8,
    Key23 = 9,
    Key24 = 10,
    Key25 = 11
  }

  -- Variables
  local game
  local addresses
  local mem
  local s
  local TT
  local turn = {0,0,0,0,0, true, 0,0,0,0,0, true}
  local ioport
  local buttons = {}
  local menu_handler

  local function TTrotate(value, turn)
    if turn then
      value = value + config.rotate_angle
      if value > 256 then
        value = value - 256
      end
    else
      value = value - config.rotate_angle
      if value < 1 then
        value = value + 256
      end
    end
    return value
  end

  -- At game startup
  local function init_load()
    -- Get rom name
    game = emu.romname()
    -- Set the address map for that version
    addresses = game_addresses[game]

    -- Disable autoplay if the address is not known during play.
    if not playing[game] then
      config.autoscr = false
      config.autokey = false
    end

    -- Set variable only for beatmania titles
    if addresses then
      -- Set memory
      mem = manager.machine.devices[":maincpu"].spaces["program"]
      -- Set screen
      s = manager.machine.screens[":screen"]

      -- Set buttons
      ioport = manager.machine.ioport
      buttons = {
        ioport.ports[":BTN1"]:field(0x10),
        ioport.ports[":BTN1"]:field(0x08),
        ioport.ports[":BTN1"]:field(0x04),
        ioport.ports[":BTN1"]:field(0x02),
        ioport.ports[":BTN1"]:field(0x01),
        ioport.ports[":TT1"]:field(0xff),
        ioport.ports[":BTN1"]:field(0x40),
        ioport.ports[":BTN1"]:field(0x80),
        ioport.ports[":BTN2"]:field(0x01),
        ioport.ports[":BTN2"]:field(0x02),
        ioport.ports[":BTN2"]:field(0x04),
        ioport.ports[":TT2"]:field(0xff),
      }
    end
  end

  local function draw_value()
    -- Draws every frame on screen

    -- If it's not a beatmania title, it's over.
    if not addresses then
      return false
    end

    if playing[game] and mem:read_i8(playing[game]) == 0 then
      -- Turntable control is released except during performance
      for i,button in ipairs(buttons) do
        button:clear_value()
      end
      return
    end

    -- View autotiming
    if config.view_timing and (config.autoscr or config.autokey) then
      s:draw_text(
        0, 320,
        string.format("%d", config.autotiming),
        0xffff00ff, 0xcf000000
      )
    end

    -- Processing for each key
    for key, address in pairs(addresses) do
      -- Read memory
      local timing = mem:read_i8(address) + offset[game]
      local state = mem:read_i8(address - 1)
      
      -- Set color
      local color
      if state == 4 then
        -- Transparency because there is no timing to show
        color = 0x00000000
      elseif -31 < timing and timing < 0 then
        -- Early
        -- Set color cyan
        color = 0xff00ffff
      elseif 0 < timing and timing < 31 then
        -- Late
        -- Set color red
        color = 0xffff0000
      elseif timing == 0 then
        -- Just set color green
        color = 0xff00ff00
      else
        -- Transparency because there is no timing to show
        color = 0x00000000
      end

      -- Draw timing
      if config.view_timing then
        s:draw_text(
          locations[key]["x"], locations[key]["y"],
          string.format("%4d", timing),
          color, 0xcc000000
        )
      end

      -- Draw state
      if config.view_state then
        s:draw_text(
          locations[key]["x"], locations[key]["y"]+30,
          string.format("%4d", state),
          0xffffff00, 0xcc000000
        )
      end

      -- Auto play
      if state ~= 4 then
        if config.autoscr and (key == 6 or key == 12) then
          -- Scratch
          -- Set TT
          if key == 6 then
            TT = 1
          elseif key == 12 then
            TT = 2
          end
          -- Check timing
          if config.autotiming - 1 <= timing and timing < config.autotiming + config.on_frames then
            if config.autotiming - 1 == timing then
              -- Reverse direction of rotation for the first time only
              turn[TT] = not turn[TT]
            end
            buttons[key]:set_value(TTrotate(ioport.ports[":TT" .. TT]:read(), turn[TT]))
          end
        elseif config.autokey and key ~=6 and key ~= 12 then
          -- Keys
          if config.autotiming - 1 <= timing and timing < config.autotiming + config.on_frames then
            buttons[key]:set_value(1)
          else
            buttons[key]:clear_value()
          end
        end
      elseif key ~=6 and key ~= 12 then
        buttons[key]:clear_value()
      end
    end
  end

  -- When to quit the game
  local function stop()
    -- Set to be other than beatmania
    addresses = nil
  end

  -- Menu
  local function menu_callback(index, event)
    if menu_handler then
      return menu_handler:handle_menu_event(index, event, config)
    else
      return false
    end
  end
  
  local function menu_populate()
    if not menu_handler then
      local status, msg = pcall(function () menu_handler = require('bmtiming/bmtiming_menu') end)
      if not status then
        emu.print_error(string.format('Error loading bmtiming menu: %s', msg))
      end
      if menu_handler then
        menu_handler:init_menu(config)
      end
    end
    if menu_handler then
      return menu_handler:populate_menu(config)
    else
      return {{_p('plugin-bmtiming', 'Failed to load bmtiming menu'), '', 'off'}}
    end
  end

  -- Callback Registration
  emu.register_prestart(init_load)
  emu.register_stop(stop)
  emu.register_frame_done(draw_value)
  emu.register_menu(menu_callback, menu_populate, 'bmtiming')
end

return exports