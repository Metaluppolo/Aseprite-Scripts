-- =========================================================================
-- LUA script for Aseprite: 
-- Export each visible layer into a different sprite sheet organized in rows by tag
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
for i,layer in ipairs(visibleLayers)
do
    local fn = path .. title .. '\\' .. layer.name
    table.insert(msg, '-' .. fn .. '.[png|json]')
end

if app.alert{ 
        title="Export each visible layer into a different sprite sheet", 
        text=msg,
        buttons={ "&Yes", "&No" } } ~= 1 then
    return
end


-- Export sprite sheets
for i,layer in ipairs(visibleLayers)
do
    local fn = path .. '\\' .. title .. '\\' .. layer.name
    app.command.ExportSpriteSheet{
        ui=false,
        type=SpriteSheetType.ROWS,
        textureFilename=fn .. '.png',
        dataFilename=fn .. '.json',
        dataFormat=SpriteSheetDataFormat.JSON_ARRAY,
        layer=layer.name,
        splitTags=true,
        listLayers=false,
        listTags=false,
        listSlices=false,
    }
end
