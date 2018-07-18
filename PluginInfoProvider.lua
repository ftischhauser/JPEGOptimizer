--[[
Copyright (c) 2018 Flavio Tischhauser <ftischhauser@gmail.com>
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

local LrHttp = import 'LrHttp'
local LrColor = import 'LrColor'
local LrView = import 'LrView'

return {
		sectionsForTopOfDialog = function( viewFactory, propertyTable )
		return {
			{
				title = 'Information',
				viewFactory:column {
					viewFactory:static_text {title = 'Author: Flavio Tischhauser <ftischhauser@gmail.com>'},
					viewFactory:static_text {title = 'Contributors: Giles Winstanley (macOS support and other fixes)'},
					viewFactory:spacer {height = 10},
					viewFactory:static_text {title = 'This plugin ships with the following awesome tools:'},
					viewFactory:row {
						viewFactory:static_text {
							title = 'exiv2:',
							width = LrView.share "FTJO_PIL_width"
						},
						viewFactory:static_text {
							title = 'http://www.exiv2.org/',
							mouse_down = function() LrHttp.openUrlInBrowser('http://www.exiv2.org/') end,
							text_color = LrColor( 0, 0, 1 )
						}
					},
					viewFactory:row {
						viewFactory:static_text {
							title = 'ImageMagick:',
							width = LrView.share "FTJO_PIL_width"
						},
						viewFactory:static_text {
							title = 'https://www.imagemagick.org/',
							mouse_down = function() LrHttp.openUrlInBrowser('https://www.imagemagick.org/') end,
							text_color = LrColor( 0, 0, 1 )
						}
					},
					viewFactory:row {
						viewFactory:static_text {
							title = 'jpeg-archive:',
							width = LrView.share "FTJO_PIL_width"
						},
						viewFactory:static_text {
							title = 'https://github.com/danielgtaylor/jpeg-archive/',
							mouse_down = function() LrHttp.openUrlInBrowser('https://github.com/danielgtaylor/jpeg-archive/') end,
							text_color = LrColor( 0, 0, 1 )
						}
					},
					viewFactory:row {
						viewFactory:static_text {
							title = 'mozjpeg:',
							width = LrView.share "FTJO_PIL_width"
						},
						viewFactory:static_text {
							title = 'https://github.com/mozilla/mozjpeg/',
							mouse_down = function() LrHttp.openUrlInBrowser('https://github.com/mozilla/mozjpeg/') end,
							text_color = LrColor( 0, 0, 1 )
						}
					}
				}
			}
		}
		end
}
