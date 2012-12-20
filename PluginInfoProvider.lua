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