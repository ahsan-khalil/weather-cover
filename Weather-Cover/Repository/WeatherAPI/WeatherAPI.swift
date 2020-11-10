//
//  WeatherAPI.swift
//  Weather-Cover
//
//  Created by Ahsan Khalil🤕 on 02/11/2020.
//
//  swiftlint:disable all
import Foundation
import Alamofire
/// WeatherAPI.com provides access to weather and geo data via a JSON/XML restful API. It allows developers to create desktop, web and mobile applications using this data very easy.
class WeatherAPI {
    static let baseURL = "https://api.weatherapi.com/v1/"
    static let apiKey = "be83dbd3063f4e06877105417202710"
    static let apiStandardDateFormate:String = "yyyy-MM-dd HH:mm"
    enum CallMethod: String {
        case currentWeather = "current.json"
        case forecast = "forecast.json"
        case search = "search.json"
        case history = "history.json"
        case timeZone = "timezone.json"
        case sports = "sports.json"
        case astronomy = "astronomy.json"
        case ipLookup = "ip.json"
    }
    static func buildCompleteBaseUrl(callMethodName: CallMethod) -> String {
        return baseURL + callMethodName.rawValue + "?key=" + apiKey
    }
    typealias WeatherForecastHandler = (_ weatherForecast:WeatherForecastAPIModel?) -> Void
    
    
    
    /// - Parameter value: Pass US Zipcode, UK Postcode, Canada Postalcode, IP address, Latitude/Longitude (decimal degree) or city name.
    /// - Parameter completionHandler: accepts WeatherForecast optional and returns nothing
    static func getCurrentDayWeather(value: String,
                                    completionHandler: @escaping WeatherForecastHandler) {
        let completeBaseUrl = buildCompleteBaseUrl(callMethodName: .currentWeather)
        guard let completeUrl = URL(string: completeBaseUrl)
        else {
            completionHandler(nil)
            return
        }
        
        AF.request(completeUrl,method: .get, parameters: ["q":value])
            .validate()
            .responseDecodable(of: WeatherForecastAPIModel.self) {
            (response) in
            guard let data = response.value else {
                print("Nothing retrieved in get CurrentDayWeather")
                completionHandler(nil)
                return
            }
            completionHandler(data)
        }
    }
    /// - Parameter value: Pass US Zipcode, UK Postcode, Canada Postalcode, IP address, Latitude/Longitude (decimal degree) or city name.
    /// - Parameter days: no. of days for which you want to retrieve data. Max = 5, Min 1
    /// - Parameter completionHandler: accepts WeatherForecast optional and returns nothing
    static func getFutureForecast(days:Int ,value: String,
                                    completionHandler: @escaping WeatherForecastHandler) {
        let completeBaseUrl = buildCompleteBaseUrl(callMethodName: .forecast)
        guard let completeUrl = URL(string: completeBaseUrl)
        else {
            completionHandler(nil)
            return
        }
        
        AF.request(completeUrl,method: .get,parameters: ["q":value,"days":days])
            .validate()
            .responseDecodable(of: WeatherForecastAPIModel.self) {
            (response) in
            guard let data = response.value else {
                print("Error in converting result to data")
                completionHandler(nil)
                return
            }
            completionHandler(data)
        }
    }
    typealias WeatherConditionListHandler = (_ weatherConditionList:[WeatherConditionListAPIModel]?) -> Void
    static func getWeatherConditions(completionHandler: @escaping WeatherConditionListHandler) {
        guard let completeUrl = URL(string: "https://www.weatherapi.com/docs/weather_conditions.json")
        else {
            completionHandler(nil)
            return
        }
        AF.request(completeUrl,method: .get)
            .validate()
            .responseDecodable(of: [WeatherConditionListAPIModel].self) {
            (response) in
            guard let data = response.value else {
                print("Error in converting result to data")
                completionHandler(nil)
                return
            }
                completionHandler(data)
        }
    }
}
