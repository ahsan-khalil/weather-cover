//
//  WeatherAPIModelConverter.swift
//  Weather-Cover
//
//  Created by Ahsan Khalil🤕 on 07/11/2020.
//
//  swiftlint:disable all
import Foundation
struct WeatherAPIModelConverter {
    static let sourceFileName = #file
    public static func convertToFavoriteCityModel(providedAPIModel: WeatherForecastAPIModel) -> FavoriteCityModel? {
        var favoriteCityModel: FavoriteCityModel? = nil
        if let locationName = providedAPIModel.location?.name {
            favoriteCityModel = FavoriteCityModel(cityName: locationName, cityDetail: nil)
            favoriteCityModel?.cityDetail = convertToCityDetailModel(providedAPIModel: providedAPIModel)
        } else {
            Constants.printError(filename: sourceFileName, errorStr: "Provided API model Has nil Location")
            return favoriteCityModel
        }
        return favoriteCityModel
    }

    public static func convertToCityDetailModel(providedAPIModel: WeatherForecastAPIModel) -> CityDetailModel? {
        var cityDetailModel: CityDetailModel? = CityDetailModel(currentWeatherDetail: nil, forecastDetail: nil)
        if let currentWeatherAPIDetail = providedAPIModel.current {
            // get CurrentWeatherDetail First
            let currentWeatherDetail = convertToCurrentWeatherDetailModel(providedAPIModel: currentWeatherAPIDetail)
            cityDetailModel?.currentWeatherDetail = currentWeatherDetail
        }
        if let forecastDetailList = providedAPIModel.dailyForecastList?.forecastday {
            cityDetailModel?.forecastDetail = convertToForecastDetailModelList(providedAPIModel: forecastDetailList)
        }
        return cityDetailModel
    }

    public static func convertToCurrentWeatherDetailModel(providedAPIModel: CurrentWeatherAPIModel) -> CurrentWeatherDetailModel? {
        var currentWeatherDetailModel: CurrentWeatherDetailModel?
        //  swiftlint:disable all
        let temperature = providedAPIModel.temp_c!
        let timeFetchedStr = providedAPIModel.last_updated!
        let dateFormate = WeatherAPI.apiStandardDateFormate
        let dateTimeFetch = ConversionUtility.convertStrToDate(providedFormate: dateFormate, dateStr: timeFetchedStr)
        currentWeatherDetailModel = CurrentWeatherDetailModel(temperatureC: temperature, timeFetched: dateTimeFetch!)
        //  swiftlint:enable all
        return currentWeatherDetailModel
    }
    public static func convertToForecastDetailModelList(providedAPIModel: [ForecastDayAPIModel])
                                                    -> [ForeCastDetailModel]? {
        var forecastModelDetailList = [ForeCastDetailModel]()
        if providedAPIModel.count != 0 {
            for forecastDetail in providedAPIModel {
                if let forecastDetailModel = convertToForeCastDetailModel(providedAPIModel: forecastDetail) {
                    forecastModelDetailList.append(forecastDetailModel)
                }
            }
        }
        return forecastModelDetailList
    }
    public static func convertToForeCastDetailModel(providedAPIModel: ForecastDayAPIModel) -> ForeCastDetailModel? {
        var forecastDetailModel: ForeCastDetailModel?
        var astronomy = AstronomyModel(sunRiseHour: 0, sunSetHour: 0, sunRiseMin: 0, sunSetMin: 0)
        if let astronomyAPI = providedAPIModel.astro {
            let sunRiseArr = ConversionUtility.convertStrTimeToHourAndMin(strTime: astronomyAPI.sunrise ?? "0:00 AM")
            let sunSetArr = ConversionUtility.convertStrTimeToHourAndMin(strTime: astronomyAPI.sunset ?? "0:00 AM")
            astronomy.sunRiseHour = sunRiseArr[0]
            astronomy.sunRiseMin = sunRiseArr[1]
            astronomy.sunSetHour = sunSetArr[0]
            astronomy.sunSetMin = sunSetArr[1]
        }
        let timeFetchedStr = providedAPIModel.date!
        let dateFormate = "yyyy-MM-dd"
        let dateTimeFetch = ConversionUtility.convertStrToDate(providedFormate: dateFormate, dateStr: timeFetchedStr)!
        var maxTempC = 0.0
        var minTempC = 0.0
        if let dayDetail = providedAPIModel.day {
            maxTempC = dayDetail.maxtemp_c!
            minTempC = dayDetail.mintemp_c!
        }
        let hourDetailModelList = convertToHourForecastDetail(hourDetailAPIList: providedAPIModel.hour)
        
        forecastDetailModel = ForeCastDetailModel(date: dateTimeFetch, minTempC: minTempC,
                                                  maxTempC: maxTempC,
                                                  hourDetailList: hourDetailModelList,
                                                  astronomyModel: astronomy)
        return forecastDetailModel
    }
    public static func convertToHourForecastDetail(hourDetailAPIList: [HourForcastDetailAPIModel]?)
                                                -> [HourForecastDetailModel] {
        var hourDetailModelList = [HourForecastDetailModel]()
        if let hourAPIDetailList = hourDetailAPIList {
            for hourAPIDetail in hourAPIDetailList {
                let timeFetchedStr = hourAPIDetail.time! //yyyy-MM-dd 00:00
                let dateFormate = WeatherAPI.apiStandardDateFormate
                let dateHour = ConversionUtility.convertStrToDate(providedFormate: dateFormate,
                                                                  dateStr: timeFetchedStr)!
                let rainChances = Double(hourAPIDetail.chance_of_rain!) ?? 0.0
                let temperatureC = hourAPIDetail.temp_c!
                let windSpeedMPH = hourAPIDetail.wind_mph!
                let hourModelDetail = HourForecastDetailModel(dateTime: dateHour,
                                                              rainChances: rainChances,
                                                              temperatureC: temperatureC,
                                                              windSpeedMPH: windSpeedMPH)
                hourDetailModelList.append(hourModelDetail)
            }
        }
        return hourDetailModelList
    }
}
// swiftlint:enable all
