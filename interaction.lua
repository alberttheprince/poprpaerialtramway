-- Interaction adapters (cabins are local entities, so use the addLocalEntity
-- family). To use your own system: copy 'custom', wire up your exports, and
-- set Config.Interaction = 'custom'.

local OPTION_NAMES = { 'tramway_board', 'tramway_exit' }
local Adapters = {}

-- ox_target (default)
Adapters.ox_target = {
    Add = function(entity, data)
        local options = {}
        for i, o in ipairs(data.options) do
            options[i] = {
                name        = o.name,
                icon        = o.icon,
                label       = o.label,
                distance    = data.distance or 2.5,
                canInteract = o.canInteract,
                onSelect    = o.onSelect,
            }
        end
        exports.ox_target:addLocalEntity(entity, options)
    end,
    Remove = function(entity, _id)
        exports.ox_target:removeLocalEntity(entity, OPTION_NAMES)
    end,
}

-- sleepless_interact
Adapters.sleepless = {
    Add = function(entity, data)
        local options = {}
        for i, o in ipairs(data.options) do
            options[i] = {
                label       = o.label,
                icon        = o.icon,
                canInteract = o.canInteract,
                onSelect    = o.onSelect,
            }
        end
        exports.sleepless_interact:addLocalEntity({
            id             = data.id,
            entity         = entity,
            offset         = data.offset,
            options        = options,
            renderDistance = (data.distance or 2.5) + 3.0,
            activeDistance = data.distance or 2.5,
        })
    end,
    Remove = function(entity, _id)
        exports.sleepless_interact:removeLocalEntity(entity)
    end,
}

-- custom (fill in your own)
Adapters.custom = {
    Add = function(entity, data) end,
    Remove = function(entity, id) end,
}

Interaction = Adapters[Config.Interaction] or Adapters.ox_target
