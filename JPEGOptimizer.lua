--[[
Copyright (c) 2013 Flavio Tischhauser <ftischhauser@gmail.com>
https://github.com/ftischhauser/JPEGOptimizer

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
--]]

local LrView = import 'LrView'
local LrPathUtils = import 'LrPathUtils'
local LrTasks = import 'LrTasks'
local LrHttp = import 'LrHttp'
local LrColor = import 'LrColor'
local LrDialogs = import 'LrDialogs'

ObserveFTJO_Optimize = function (propertyTable)
	if(propertyTable.FTJO_Optimize) then propertyTable.FTJO_Arithmetic = false end
end
ObserveFTJO_Arithmetic = function (propertyTable)
	if(propertyTable.FTJO_Arithmetic) then propertyTable.FTJO_Optimize = false end
end
ObserveFTJO_RemovePreview = function (propertyTable)
	if(propertyTable.FTJO_RemovePreview) then propertyTable.FTJO_StripMetadata = false end
end
ObserveFTJO_StripMetadata = function (propertyTable)
	if(propertyTable.FTJO_StripMetadata) then propertyTable.FTJO_RemovePreview = false end
end

return {
	exportPresetFields = {
		{key = 'FTJO_RemovePreview', default = false},
		{key = 'FTJO_StripMetadata', default = false},
		{key = 'FTJO_Optimize', default = true},
		{key = 'FTJO_Progressive', default = false},
		{key = 'FTJO_Arithmetic', default = false}
	},
	sectionForFilterInDialog = function(viewFactory, propertyTable)
		if MAC_ENV then
			return {
				title = 'JPEG Optimizer',
				viewFactory:static_text {title = 'Sorry, JPEG Optimizer is not yet supported on OS X!'}
			}
		else
			propertyTable:addObserver('FTJO_Optimize', ObserveFTJO_Optimize)
			propertyTable:addObserver('FTJO_Arithmetic', ObserveFTJO_Arithmetic)
			propertyTable:addObserver('FTJO_RemovePreview', ObserveFTJO_RemovePreview)
			propertyTable:addObserver('FTJO_StripMetadata', ObserveFTJO_StripMetadata)
			return {
				title = 'JPEG Optimizer',
				viewFactory:column {
					spacing = viewFactory:control_spacing(),
					viewFactory:column {
						viewFactory:static_text {title = 'Please visit the homepage for help with these options:'},
						viewFactory:static_text {
							title = 'http://github.com/ftischhauser/JPEGOptimizer',
							mouse_down = function() LrHttp.openUrlInBrowser('http://github.com/ftischhauser/JPEGOptimizer') end,
							text_color = LrColor( 0, 0, 1 )
						},
						viewFactory:spacer {height = 10},
						viewFactory:group_box {
							title = 'Metadata',
							viewFactory:checkbox {
								title = 'Remove EXIF thumbnail',
								value = LrView.bind 'FTJO_RemovePreview',
								checked_value = true,
								unchecked_value = false
							},
							viewFactory:checkbox {
								title = 'Strip ALL metadata (including thumbnail)',
								value = LrView.bind 'FTJO_StripMetadata',
								checked_value = true,
								unchecked_value = false
							}
						},
						viewFactory:group_box {
							title = 'Optimizations',
							viewFactory:static_text {title = 'All optimizations are lossless!'},
							viewFactory:checkbox {
								title = 'Optimize Huffman table',
								value = LrView.bind 'FTJO_Optimize',
								checked_value = true,
								unchecked_value = false
							},
							viewFactory:checkbox {
								title = 'Convert to progressive JPEG',
								value = LrView.bind 'FTJO_Progressive',
								checked_value = true,
								unchecked_value = false
							},
							viewFactory:checkbox {
								title = 'Use arithmetic coding instead of Huffman (not widely supported yet!)',
								value = LrView.bind 'FTJO_Arithmetic',
								checked_value = true,
								unchecked_value = false
							}
						}
					}
				}
			}
		end
	end,
	postProcessRenderedPhotos = function(functionContext, filterContext)
		if MAC_ENV then
			for sourceRendition, renditionToSatisfy in filterContext:renditions() do
				sourceRendition:waitForRender()
				renditionToSatisfy:renditionIsDone(false, 'Sorry, JPEG Optimizer is not yet supported on OS X!')
			end
			return
		end

		local JpegtranCMD
		local JpegtranNeeded = filterContext.propertyTable.FTJO_StripMetadata or filterContext.propertyTable.FTJO_Optimize or filterContext.propertyTable.FTJO_Progressive or filterContext.propertyTable.FTJO_Arithmetic
		if JpegtranNeeded then
			JpegtranCMD = '"' .. LrPathUtils.child(_PLUGIN.path, 'jpegtran.exe') .. '" '
			JpegtranCMD = filterContext.propertyTable.FTJO_StripMetadata and JpegtranCMD .. '-copy none ' or JpegtranCMD .. '-copy all '
			if filterContext.propertyTable.FTJO_Optimize and not filterContext.propertyTable.FTJO_Arithmetic then JpegtranCMD = JpegtranCMD .. '-optimize ' end
			if filterContext.propertyTable.FTJO_Progressive then JpegtranCMD = JpegtranCMD .. '-progressive ' end
			if filterContext.propertyTable.FTJO_Arithmetic then JpegtranCMD = JpegtranCMD .. '-arithmetic ' end
		end
		for sourceRendition, renditionToSatisfy in filterContext:renditions() do
			local success, pathOrMessage = sourceRendition:waitForRender()
			if success then
				if filterContext.propertyTable.LR_format ~= 'JPEG' then
					renditionToSatisfy:renditionIsDone(false, 'JPEG Optimizer only works with JPEGs (check the image format settings).')
					break
				end
				if JpegtranNeeded then
					local JpegtranCMD = JpegtranCMD .. '"' .. LrPathUtils.standardizePath(pathOrMessage) .. '" "' .. LrPathUtils.standardizePath(pathOrMessage) .. '"'
					if LrTasks.execute('"' .. JpegtranCMD .. '"') ~= 0 then renditionToSatisfy:renditionIsDone(false, 'Jpegtran encountered an error.') end
				end
				if filterContext.propertyTable.FTJO_RemovePreview and not filterContext.propertyTable.FTJO_StripMetadata then
					if LrTasks.execute('""' .. LrPathUtils.child(_PLUGIN.path, 'exiv2.exe') .. '" -d t rm "' .. LrPathUtils.standardizePath(pathOrMessage) .. '""') ~= 0 then renditionToSatisfy:renditionIsDone(false, 'Exiv2 encountered an error.') end
				end
			else
				renditionToSatisfy:renditionIsDone(false, pathOrMessage)
			end
		end
	end
}
