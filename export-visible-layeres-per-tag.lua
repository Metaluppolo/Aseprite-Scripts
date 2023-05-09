-- =========================================================================
-- LUA script for Aseprite: 
-- Export each tag for each visible layer into a different sprite sheet
-- =========================================================================

local spr = app.activeSprite
if not spr then 
    return print('No active sprite') 
end


local path,title = spr.filename:match("^(.+[/\\])(.-).([^.]*)$")
local msg = { "Do you want to export/overwrite the following files?" }

local visibleLayers = {}
local checkVisibility = false


-- Export only visible layers
for i,layer in ipairs(spr.layers)
do
    if layer.isVisible then
        table.insert(visibleLayers, layer)
        checkVisibility = true
    end
end
if not checkVisibility then
    return print('No visible layers') 
end


-- Show alert dialog
for j,layer in ipairs(visibleLayers)
do
    for i,tag in ipairs(spr.tags) 
    do
        local fn = path .. title .. '\\' .. tag.name .. '\\' .. layer.name
        table.insert(msg, '-' .. fn .. '.[png|json]')
    end
end

if app.alert{ 
        title="Export each tag for each visible layer into a different sprite sheet", 
        text=msg,
        buttons={ "&Yes", "&No" } } ~= 1 then
    return
end


-- Export sprite sheets
for j,layer in ipairs(visibleLayers)
do
    for i,tag in ipairs(spr.tags) 
    do
        local fn = path .. '\\' .. title .. '\\' .. tag.name .. '\\' .. layer.name
        app.command.ExportSpriteSheet{
            ui=false,
            type=SpriteSheetType.HORIZONTAL,
            textureFilename=fn .. '.png',
            dataFilename=fn .. '.json',
            dataFormat=SpriteSheetDataFormat.JSON_ARRAY,
            layer=layer.name,
            tag=tag.name,
            listLayers=false,
            listTags=false,
            listSlices=false,
        }
    end
end
