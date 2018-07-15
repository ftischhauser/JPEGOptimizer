--[[
Copyright (c) 2017 Flavio Tischhauser <ftischhauser@gmail.com>
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
local LrFileUtils = import'LrFileUtils'
local LrLogger = import 'LrLogger'

local logger = LrLogger('JPEGOptimizer')
logger:enable("print")

quote4Win = function (cmd)
	if (WIN_ENV) then return '"' .. cmd .. '"' else return cmd end
end

outputToLog = function (msg)
--	logger:trace(msg)  -- Uncomment this line to enable logging
end

ObserveFTJO_RemovePreview = function (propertyTable)
	if(propertyTable.FTJO_RemovePreview) then propertyTable.FTJO_StripMetadata = false end
end
ObserveFTJO_StripMetadata = function (propertyTable)
	if(propertyTable.FTJO_StripMetadata) then propertyTable.FTJO_RemovePreview = false end
end

return {
	exportPresetFields = {
		{key = 'FTJO_RemovePreview', default = true},
		{key = 'FTJO_StripMetadata', default = false},
		{key = 'FTJO_Progressive', default = true},
		{key = 'FTJO_Recompress', default = false},
		{key = 'FTJO_JRCQuality', default = 'medium'},
		{key = 'FTJO_JRCMethod', default = 'smallfry'},
		{key = 'FTJO_JRCSubsampling', default = true}
	},
	sectionForFilterInDialog = function(viewFactory, propertyTable)
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
						title = 'Lossless Optimizations',
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
						},
						viewFactory:checkbox {
							title = 'Progressive encoding (smaller)',
							value = LrView.bind 'FTJO_Progressive',
							checked_value = true,
							unchecked_value = false
						},
						viewFactory:column {
							viewFactory:static_text {
								title = 'Powered by mozjpeg and exiv2:'
							},
							viewFactory:static_text {
								title = 'https://github.com/mozilla/mozjpeg/',
								mouse_down = function() LrHttp.openUrlInBrowser('https://github.com/mozilla/mozjpeg/') end,
								text_color = LrColor( 0, 0, 1 )
							},
							viewFactory:static_text {
								title = 'http://www.exiv2.org/',
								mouse_down = function() LrHttp.openUrlInBrowser('http://www.exiv2.org/') end,
								text_color = LrColor( 0, 0, 1 )
							}
						}
					},
					viewFactory:group_box {
						title = 'Recompression',
						viewFactory:checkbox {
							title = 'Recompress JPEG',
							value = LrView.bind 'FTJO_Recompress',
							checked_value = true,
							unchecked_value = false,
						},
						viewFactory:static_text {
							enabled = LrView.bind 'FTJO_Recompress',
							title = "Automatically sets the optimal JPEG compression by measuring the perceived visual quality."
						},
						viewFactory:checkbox {
							enabled = LrView.bind 'FTJO_Recompress',
							title = 'Chroma subsampling (smaller)',
							value = LrView.bind 'FTJO_JRCSubsampling',
							checked_value = true,
							unchecked_value = false,
						},
						viewFactory:row {
							viewFactory:static_text {
								enabled = LrView.bind 'FTJO_Recompress',
								title = "Quality:",
								width = LrView.share "FTJO_Recompress_label_width",
							},
							viewFactory:popup_menu {
								enabled = LrView.bind 'FTJO_Recompress',
								value = LrView.bind 'FTJO_JRCQuality',
								width = LrView.share "FTJO_Recompress_popup_width",
								items = {
									{ title = "Low", value = 'low'},
									{ title = "Medium", value = 'medium'},
									{ title = "High", value = 'high'},
									{ title = "Very High", value = 'veryhigh'}
								}
							}
						},
						viewFactory:row {
							viewFactory:static_text {
								enabled = LrView.bind 'FTJO_Recompress',
								title = "Method:",
								width = LrView.share "FTJO_Recompress_label_width",
							},
							viewFactory:popup_menu {
								enabled = LrView.bind 'FTJO_Recompress',
								value = LrView.bind 'FTJO_JRCMethod',
								width = LrView.share "FTJO_Recompress_popup_width",
								items = {
									{ title = "MPE", value = 'mpe'},
									{ title = "SSIM", value = 'ssim'},
									{ title = "MS-SSIM", value = 'ms-ssim'},
									{ title = "SmallFry", value = 'smallfry'}
								}
							}
						},
						viewFactory:column {
							viewFactory:static_text {
								title = 'Powered by jpeg-archive and ImageMagick:',
								enabled = LrView.bind 'FTJO_Recompress',
							},
							viewFactory:static_text {
								enabled = LrView.bind 'FTJO_Recompress',
								title = 'https://github.com/danielgtaylor/jpeg-archive/',
								mouse_down = function() LrHttp.openUrlInBrowser('https://github.com/danielgtaylor/jpeg-archive/') end,
								text_color = LrColor( 0, 0, 1 )
							},
							viewFactory:static_text {
								enabled = LrView.bind 'FTJO_Recompress',
								title = 'https://www.imagemagick.org/',
								mouse_down = function() LrHttp.openUrlInBrowser('https://www.imagemagick.org/') end,
								text_color = LrColor( 0, 0, 1 )
							}
						}
					}
				}
			}
		}
	end,
	postProcessRenderedPhotos = function(functionContext, filterContext)

		-- Define paths for external tools
		local UPexiv2 = 'exiv2'
		local UPImageMagick = 'ImageMagick'
		local UPjpegrecompress = 'jpeg-archive'
		local UPjpegtran = 'mozjpeg'
		-- Define executable names for external tools
		local UEexiv2 = 'exiv2' .. (WIN_ENV and '.exe' or '')
		local UEImageMagick = MAC_ENV and 'convert' or 'magick.exe'
		local UEjpegrecompress = 'jpeg-recompress' .. (WIN_ENV and '.exe' or '')
		local UEjpegtran = 'jpegtran' .. (WIN_ENV and '.exe' or '')
		-- Define platform-specific path for external tools
		local PlatPath = MAC_ENV and 'macOS' or 'WIN'
		-- Construct commands for external tools (reusing path variables)
		if MAC_ENV then
			local ExivPath = LrPathUtils.child(LrPathUtils.child(_PLUGIN.path, PlatPath), UPexiv2)
			UPexiv2 = 'LD_LIBRARY_PATH="' .. ExivPath .. '" "' .. LrPathUtils.child(ExivPath, UEexiv2) .. '"'
		else
			UPexiv2 = '"' .. LrPathUtils.child(LrPathUtils.child(LrPathUtils.child(_PLUGIN.path, PlatPath), UPexiv2), UEexiv2) .. '"'
		end
		UPImageMagick = '"' .. LrPathUtils.child(LrPathUtils.child(LrPathUtils.child(_PLUGIN.path, PlatPath), UPImageMagick), UEImageMagick) .. '"'
		UPjpegrecompress = '"' .. LrPathUtils.child(LrPathUtils.child(LrPathUtils.child(_PLUGIN.path, PlatPath), UPjpegrecompress), UEjpegrecompress) .. '"'
		UPjpegtran = '"' .. LrPathUtils.child(LrPathUtils.child(LrPathUtils.child(_PLUGIN.path, PlatPath), UPjpegrecompress), UEjpegtran) .. '"'

		local renditionOptions = {
			filterSettings = function( renditionToSatisfy, exportSettings )
				if filterContext.propertyTable.FTJO_Recompress then
					exportSettings.LR_format = 'TIFF'
					exportSettings.LR_export_colorSpace = 'sRGB'
					exportSettings.LR_export_bitDepth = '8'
					exportSettings.LRtiff_compressionMethod = 'compressionMethod_None'
				end
			end,
		}

		for sourceRendition, renditionToSatisfy in filterContext:renditions(renditionOptions) do
			local success, pathOrMessage = sourceRendition:waitForRender()
			if success then
				if filterContext.propertyTable.LR_format ~= 'JPEG' and not filterContext.propertyTable.FTJO_Recompress then
					renditionToSatisfy:renditionIsDone(false, 'Lossless optimizations only work on JPEG files. Please check the image format settings or activate recompression.')
					break
				end

				local ExpFileName = LrPathUtils.standardizePath(pathOrMessage)
				if filterContext.propertyTable.FTJO_Recompress then
					if not filterContext.propertyTable.FTJO_StripMetadata then
						local CmdDumpMetadata = UPexiv2 .. ' -q -f -eX "' .. ExpFileName .. '"'
						outputToLog('Dump metadata: ' .. CmdDumpMetadata)
						if LrTasks.execute(quote4Win(CmdDumpMetadata)) ~= 0 then renditionToSatisfy:renditionIsDone(false, 'Error exporting XMP data.') end
						if not filterContext.propertyTable.FTJO_RemovePreview then
							local CmdRenderPreview = UPImageMagick .. ' "' .. ExpFileName .. '" -resize 256x256 ppm:- | ' .. UPjpegrecompress .. ' --quiet --no-progressive --method smallfry --quality low --strip --ppm - "' .. LrPathUtils.removeExtension(ExpFileName) .. '-thumb.jpg"'
							outputToLog('Render preview: ' .. CmdRenderPreview)
							if LrTasks.execute(quote4Win(CmdRenderPreview)) ~= 0 then renditionToSatisfy:renditionIsDone(false, 'Error creating EXIF thumbnail.') end
						end
					end
					local CmdRecompress = UPImageMagick .. ' "' .. ExpFileName .. '" ppm:- | ' .. UPjpegrecompress .. ' --quiet --accurate --method ' .. filterContext.propertyTable.FTJO_JRCMethod .. ' --quality ' .. filterContext.propertyTable.FTJO_JRCQuality .. ' --strip'
					if not filterContext.propertyTable.FTJO_Progressive then CmdRecompress = CmdRecompress .. ' --no-progressive' end
					if not filterContext.propertyTable.FTJO_JRCSubsampling then CmdRecompress = CmdRecompress .. ' --subsample disable' end
					CmdRecompress = CmdRecompress .. ' --ppm - "' .. ExpFileName ..  '"'
					outputToLog('Recompress: ' .. CmdRecompress)
					if LrTasks.execute(quote4Win(CmdRecompress)) ~= 0 then renditionToSatisfy:renditionIsDone(false, 'Error recompressing JPEG file.') end
					if not filterContext.propertyTable.FTJO_StripMetadata then
						local CmdInsertMetadata = UPexiv2 .. ' -q -f -iX "' .. ExpFileName .. '"' .. (MAC_ENV and ' 2>/dev/null' or ' 2>nul')
						outputToLog('Insert metadata: ' .. CmdInsertMetadata)
						if LrTasks.execute(quote4Win(CmdInsertMetadata)) ~= 0 then renditionToSatisfy:renditionIsDone(false, 'Error importing XMP data.') end
						LrFileUtils.delete(LrPathUtils.replaceExtension(ExpFileName, 'xmp'))
						if not filterContext.propertyTable.FTJO_RemovePreview then
							local CmdInsertPreview = UPexiv2 .. ' -q -f -it "' .. ExpFileName .. '"'
							outputToLog('Insert preview: ' .. CmdInsertPreview)
							if LrTasks.execute(quote4Win(CmdInsertPreview)) ~= 0 then renditionToSatisfy:renditionIsDone(false, 'Error importing EXIF thumbnail.') end
							LrFileUtils.delete(LrPathUtils.removeExtension(ExpFileName) ..'-thumb.jpg')
						end
					end
				else
					if filterContext.propertyTable.FTJO_RemovePreview and not filterContext.propertyTable.FTJO_StripMetadata then
						local CmdRemovePreview = UPexiv2 .. ' -q -f -dt "' .. ExpFileName .. '"'
						outputToLog('Remove preview: ' .. CmdRemovePreview)
						if LrTasks.execute(quote4Win(CmdRemovePreview)) ~= 0 then renditionToSatisfy:renditionIsDone(false, 'Error removing EXIF thumbnail.') end
					end
					local CmdOptimize = filterContext.propertyTable.FTJO_StripMetadata and UPjpegtran .. ' -copy none' or UPjpegtran .. ' -copy all'
					if not filterContext.propertyTable.FTJO_Progressive then CmdOptimize = CmdOptimize .. ' -revert -optimize' end
					CmdOptimize = CmdOptimize .. ' -outfile "' .. ExpFileName .. '" "' .. ExpFileName .. '"'
					outputToLog('Optimize: ' .. CmdOptimize)
					if LrTasks.execute(quote4Win(CmdOptimize)) ~= 0 then renditionToSatisfy:renditionIsDone(false, 'Error optimizing JPEG file.') end
				end
			else
				renditionToSatisfy:renditionIsDone(false, pathOrMessage)
			end
		end
	end
}
