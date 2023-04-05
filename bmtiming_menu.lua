local lib = {}

-- Set of sections within a menu
local MENU_SECTIONS = { HEADER = 0, CONTENT = 1, FOOTER = 2 }

-- Last index of header items (above main content) in menu
local header_height = 0

-- Last index of content items (below header, above footer) in menu
local content_height = 0

-- Saved selection on main menu (to restore after configure menu is dismissed)
local main_selection_save

-- Returns the section (from MENU_SECTIONS) and the index within that section
local function menu_section(index)
    if index <= header_height then
        return MENU_SECTIONS.HEADER, index
    elseif index <= content_height then
        return MENU_SECTIONS.CONTENT, index - header_height
    else
        return MENU_SECTIONS.FOOTER, index - content_height
    end
end

function lib:init_menu(config)
    header_height = 0
    content_height = 0
end

function lib:populate_menu(config)
    local ioport = manager.machine.ioport
    local input = manager.machine.input
    local menu = {}
    table.insert(menu, {_p('plugin-bmtiming', 'beatmania timing viewer'), '', 'off'})
    table.insert(menu, {'---', '', ''})
    header_height = #menu

    table.insert(menu, {_p('plugin-bmtiming', 'View timing'), tostring(config.view_timing), config.view_timing and 'l' or 'r'})
    table.insert(menu, {_p('plugin-bmtiming', 'View state'), tostring(config.view_state), config.view_state and 'l' or 'r'})
    table.insert(menu, {_p('plugin-bmtiming', 'Auto SCR'), tostring(config.autoscr), config.autoscr and 'l' or 'r'})
    table.insert(menu, {_p('plugin-bmtiming', 'Auto key'), tostring(config.autokey), config.autokey and 'l' or 'r'})
    table.insert(menu, {_p('plugin-bmtiming', 'Auto timing'), tostring(config.autotiming), 'lr'})
    table.insert(menu, {_p('plugin-bmtiming', 'Rotate angle'), tostring(config.rotate_angle), config.rotate_angle > 0 and 'lr' or 'r'})
    table.insert(menu, {_p('plugin-bmtiming', 'On frames'), tostring(config.on_frames), config.on_frames > 0 and 'lr' or 'r'})
    content_height = #menu

    local selection = main_selection_save
    main_selection_save = nil
    return menu, selection

end

function lib:handle_menu_event(index, event, config)
    local section, adjusted_index = menu_section(index)
    if section == MENU_SECTIONS.CONTENT then
        if event == 'select' then
            main_selection_save = index
            return true
        end
    elseif section == MENU_SECTIONS.FOOTER then
        if event == 'select' then
            main_selection_save = index
            return true
        end
    end

    if index == 3 then
        -- View timing
        if event == 'left' then
            config.view_timing = false
            return true
        elseif event == 'right' then
            config.view_timing = true
            return true
        elseif event == 'clear' then
            config.view_timing = false
            return true
        end
    elseif index == 4 then
        -- View state
        if event == 'left' then
            config.view_state = false
            return true
        elseif event == 'right' then
            config.view_state = true
            return true
        elseif event == 'clear' then
            config.view_state = false
            return true
        end
    elseif index == 5 then
        -- Auto scratch
        manager.machine:popmessage(_p('plugin-bmtiming', 'Auto scratch'))
        if event == 'left' then
            config.autoscr = false
            return true
        elseif event == 'right' then
            config.autoscr = true
            return true
        elseif event == 'clear' then
            config.autoscr = false
            return true
        end
    elseif index == 6 then
        manager.machine:popmessage(_p('plugin-bmtiming', 'Auto keyboard'))
        if event == 'left' then
            config.autokey = false
            return true
        elseif event == 'right' then
            config.autokey = true
            return true
        elseif event == 'clear' then
            config.autokey = false
            return true
        end
    elseif index == 7 then
        manager.machine:popmessage(_p('plugin-bmtiming', 'Number of flames at press timing'))
        if event == 'left' then
            config.autotiming = config.autotiming - 1
            return true
        elseif event == 'right' then
            config.autotiming = config.autotiming + 1
            return true
        elseif event == 'clear' then
            config.autotiming = 0
            return true
        end
    elseif index == 8 then
        manager.machine:popmessage(_p('plugin-bmtiming', 'Amount of turntable rotation'))
        if event == 'left' then
            config.rotate_angle = config.rotate_angle - 1
            return true
        elseif event == 'right' then
            config.rotate_angle = config.rotate_angle + 1
            return true
        elseif event == 'clear' then
            config.rotate_angle = 10
            return true
        end
    elseif index == 9 then
        manager.machine:popmessage(_p('plugin-bmtiming', 'Number of input duration flames'))
        if event == 'left' then
            config.on_frames = config.on_frames - 1
            return true
        elseif event == 'right' then
            config.on_frames = config.on_frames + 1
            return true
        elseif event == 'clear' then
            config.on_frames = 1
            return true
        end
    end
    return false
end

return lib