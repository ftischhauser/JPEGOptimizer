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

local LrHttp = import 'LrHttp'
local LrColor = import 'LrColor'

return {
		sectionsForTopOfDialog = function( viewFactory, propertyTable )
		return {
			{
				title = 'Information',
				viewFactory:column {
					viewFactory:static_text {title = 'Author: Flavio Tischhauser <ftischhauser@gmail.com>'},
					viewFactory:spacer {height = 10},
					viewFactory:static_text {title = 'This plugin uses and ships with the following awesome tools:'},
					viewFactory:row {
						viewFactory:static_text {title = 'jpegtran:'},
						viewFactory:static_text {
							title = 'http://www.ijg.org/',
							mouse_down = function() LrHttp.openUrlInBrowser('http://www.ijg.org/') end,
							text_color = LrColor( 0, 0, 1 )
						}
					},
					viewFactory:row {
						viewFactory:static_text {title = 'exiv2:'},
						viewFactory:static_text {
							title = 'http://www.exiv2.org/',
							mouse_down = function() LrHttp.openUrlInBrowser('http://www.exiv2.org/') end,
							text_color = LrColor( 0, 0, 1 )
						}
					}
				}
			}
		}
		end
}
