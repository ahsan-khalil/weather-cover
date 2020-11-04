/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ForecastDayDetailAPIModel : Codable {
	let maxtemp_c : Double?
	let maxtemp_f : Double?
	let mintemp_c : Double?
	let mintemp_f : Double?
	let avgtemp_c : Double?
	let avgtemp_f : Double?
	let maxwind_mph : Double?
	let maxwind_kph : Double?
	let totalprecip_mm : Double?
	let totalprecip_in : Double?
	let avgvis_km : Double?
	let avgvis_miles : Double?
	let avghumidity : Double?
	let daily_will_it_rain : Int?
	let daily_chance_of_rain : String?
	let daily_will_it_snow : Int?
	let daily_chance_of_snow : String?
	let condition : WeatherConditionAPIModel?
	let uv : Double?

	enum CodingKeys: String, CodingKey {

		case maxtemp_c = "maxtemp_c"
		case maxtemp_f = "maxtemp_f"
		case mintemp_c = "mintemp_c"
		case mintemp_f = "mintemp_f"
		case avgtemp_c = "avgtemp_c"
		case avgtemp_f = "avgtemp_f"
		case maxwind_mph = "maxwind_mph"
		case maxwind_kph = "maxwind_kph"
		case totalprecip_mm = "totalprecip_mm"
		case totalprecip_in = "totalprecip_in"
		case avgvis_km = "avgvis_km"
		case avgvis_miles = "avgvis_miles"
		case avghumidity = "avghumidity"
		case daily_will_it_rain = "daily_will_it_rain"
		case daily_chance_of_rain = "daily_chance_of_rain"
		case daily_will_it_snow = "daily_will_it_snow"
		case daily_chance_of_snow = "daily_chance_of_snow"
		case condition = "condition"
		case uv = "uv"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		maxtemp_c = try values.decodeIfPresent(Double.self, forKey: .maxtemp_c)
		maxtemp_f = try values.decodeIfPresent(Double.self, forKey: .maxtemp_f)
		mintemp_c = try values.decodeIfPresent(Double.self, forKey: .mintemp_c)
		mintemp_f = try values.decodeIfPresent(Double.self, forKey: .mintemp_f)
		avgtemp_c = try values.decodeIfPresent(Double.self, forKey: .avgtemp_c)
		avgtemp_f = try values.decodeIfPresent(Double.self, forKey: .avgtemp_f)
		maxwind_mph = try values.decodeIfPresent(Double.self, forKey: .maxwind_mph)
		maxwind_kph = try values.decodeIfPresent(Double.self, forKey: .maxwind_kph)
		totalprecip_mm = try values.decodeIfPresent(Double.self, forKey: .totalprecip_mm)
		totalprecip_in = try values.decodeIfPresent(Double.self, forKey: .totalprecip_in)
		avgvis_km = try values.decodeIfPresent(Double.self, forKey: .avgvis_km)
		avgvis_miles = try values.decodeIfPresent(Double.self, forKey: .avgvis_miles)
		avghumidity = try values.decodeIfPresent(Double.self, forKey: .avghumidity)
		daily_will_it_rain = try values.decodeIfPresent(Int.self, forKey: .daily_will_it_rain)
		daily_chance_of_rain = try values.decodeIfPresent(String.self, forKey: .daily_chance_of_rain)
		daily_will_it_snow = try values.decodeIfPresent(Int.self, forKey: .daily_will_it_snow)
		daily_chance_of_snow = try values.decodeIfPresent(String.self, forKey: .daily_chance_of_snow)
		condition = try values.decodeIfPresent(WeatherConditionAPIModel.self, forKey: .condition)
		uv = try values.decodeIfPresent(Double.self, forKey: .uv)
	}

}
