//
//  UserModel.swift
//  Weather-Cover
//
//  Created by Ahsan Khalil🤕 on 04/11/2020.
//

import Foundation
struct UserModel {
    var username: String?
    var defaultCity: String?
    var pressureUnit: String?
    var temperatureUnit: String?
    var timeFormate: String?
    var windSpeed: String?
}

struct WeatherConditionModel {
    var code: String
    var day: String
    var night: String
    var icon: String
}

struct HourForecastDetailModel {
    var dateTime: Date
    var rainChances: Double
    var temperatureC: Double
    var windSpeedMPH: Double
    var windDirection: String
    var feelsLikeTempC: Double
    var humidity: Double
    var pressureIN: Double
    var iconName: String
    var conditionText: String
    var temperatureUnit: String = "C"
    var speedUnit: String = "MPH"
    var pressureUnit: String = "IN"
}

struct AstronomyModel {
    var sunRiseHour: Int32
    var sunSetHour: Int32
    var sunRiseMin: Int32
    var sunSetMin: Int32
    var timeFormate = ConversionUtility.TimeFormate.twentyFourHour
}

struct ForeCastDetailModel {
    var date: Date
    var minTempC: Double
    var maxTempC: Double
    var hourDetailList: [HourForecastDetailModel]?
    var astronomyModel: AstronomyModel
    var temperatureFormate = "C"
}

struct CurrentWeatherDetailModel {
    var temperatureC: Double
    var timeFetched: Date
}

struct CityDetailModel {
    var currentWeatherDetail: CurrentWeatherDetailModel?
    var forecastDetail: [ForeCastDetailModel]?
}

struct FavoriteCityModel {
    var cityName: String
    var countryName: String
    var cityDetail: CityDetailModel?
}
