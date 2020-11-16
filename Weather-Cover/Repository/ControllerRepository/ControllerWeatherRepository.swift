//
//  ControllerWeatherRepository.swift
//  Weather-Cover
//
//  Created by Ahsan Khalil🤕 on 07/11/2020.
//

import Foundation
class ControllerRepository {
    static let sourceFileName = #file
    typealias AddCityCompletionHandler = (ErrorHandlerEnum) -> Void
    static func getCityForecastData(cityName: String) -> FavoriteCityModel? {
        let cityName = cityName.trimmingCharacters(in: .whitespacesAndNewlines)
        if cityName.isEmpty {
            Constants.printError(filename: sourceFileName, errorStr: "Provided City Name is Empty")
            return nil
        }
        if let cityDetail = CoreDataRepository.getFavoriteCityEntity(cityName: cityName) {
            return cityDetail
        } else {
            Constants.printError(filename: sourceFileName, errorStr: "City Doesn't exists in CoreData")
        }
        return nil
    }
    static func getFavoriteCityList() -> [FavoriteCityModel] {
        return CoreDataRepository.getFavoriteCityEntityList()
    }
    static func getFavoriteCityListExceptDefaultCity(day: Date) -> [FavoriteCityModel] {
        var exceptionCityList = [String]()
        if let defaultCityName = CoreDataRepository.getDetailCityName() {
            exceptionCityList.append(defaultCityName)
        }
        return CoreDataRepository.getFavoriteCityEntityList(day: day, exceptionCityList: exceptionCityList)
    }
    static func createIfUserEntityNotExists() {
        CoreDataRepository.createEmptyStandaloneUser()
    }
    static func getUserData() -> UserModel {
        let userData = CoreDataRepository.getUserData()
        return userData
    }
    static func updateUserData(userModel: UserModel) -> Bool {
        return CoreDataRepository.updateUserEntity(userModel: userModel)
    }
    static func getDefaultCityWeatherData() -> FavoriteCityModel? {
        if let cityName =  CoreDataRepository.getDetailCityName() {
            return getCityForecastData(cityName: cityName)
        }
        return nil
    }
    private static func setDefaultCity(cityDetail: FavoriteCityModel) {
        CoreDataRepository.updateUserDefaultCity(favoriteCityModel: cityDetail)
    }
    private static func addCityDetail(cityData: FavoriteCityModel) {
        CoreDataRepository.AddCityData(favoriteCityModel: cityData)
    }
    static func removeCityData(cityName: String) {
        let cityName = cityName.trimmingCharacters(in: .whitespacesAndNewlines)
        if cityName.isEmpty {
            Constants.printError(filename: sourceFileName, errorStr: "Provided City Name is Empty")
            return
        }
        CoreDataRepository.deleteDataOfCity(cityName: cityName)
    }
    static func addCityToFavoriteListWithData(cityName: String, completionHandler: @escaping AddCityCompletionHandler) {
        let cityName = cityName.trimmingCharacters(in: .whitespacesAndNewlines)
        if cityName.isEmpty {
            Constants.printError(filename: sourceFileName, errorStr: "Provided City Name is Empty")
            completionHandler(.cityNameIsNotCorrect)
        }
        if CoreDataRepository.isCityExists(cityName: cityName) {
            completionHandler(.cityAllreadyExists)
            return
        }
        let handler: WeatherAPI.WeatherForecastHandler = { (weatherForecast) in
            if let weatherForecast = weatherForecast {
                // Convert to Model Data
                if let cityDataModel = WeatherAPIModelConverter.convertToFavoriteCityModel(
                                                                providedAPIModel: weatherForecast) {
                    addCityDetail(cityData: cityDataModel)
                    completionHandler(.noError)
                } else {
                    completionHandler(.nullPointerException)
                }
            } else {
                completionHandler(.nullPointerException)
            }
        }
        WeatherAPI.getFutureForecast(days: 3, value: cityName, completionHandler: handler)
    }
    static func updateDefaultCity(cityName: String, completionHandler: @escaping AddCityCompletionHandler) {
        let cityName = cityName.trimmingCharacters(in: .whitespacesAndNewlines)
        if cityName.isEmpty {
            Constants.printError(filename: sourceFileName, errorStr: "Provided City Name is Empty")
            completionHandler(.cityNameIsNotCorrect)
        }
        let handler: WeatherAPI.WeatherForecastHandler = { (weatherForecast) in
            if let weatherForecast = weatherForecast {
                // Convert to Model Data
                if let cityDataModel = WeatherAPIModelConverter.convertToFavoriteCityModel(
                                        providedAPIModel: weatherForecast) {
                    setDefaultCity(cityDetail: cityDataModel)
                    completionHandler(.noError)
                } else {
                    completionHandler(.nullPointerException)
                }
            } else {
                completionHandler(.nullPointerException)
            }
        }
        WeatherAPI.getFutureForecast(days: 3, value: cityName, completionHandler: handler)
    }
    static func isDefaultCityExists() -> Bool {
        if CoreDataRepository.getDetailCityName() == nil {
            return false
        }
        return true
    }
    static func updateCityData(cityName: String, totalForecastDays: Int = 3,
                               completionHandler: @escaping (Bool) -> Void) {
        let handler: WeatherAPI.WeatherForecastHandler = { (weatherForecastAPIModel) in
            print("printing from operation main")
            if weatherForecastAPIModel == nil {
                print("Operation got nil value from API")
                completionHandler(false)
                return
            }
            if let weatherForecastModel = WeatherAPIModelConverter.convertToFavoriteCityModel(
                            providedAPIModel: weatherForecastAPIModel!) {
                print("got api model")
                CoreDataRepository.updateCityData(favoriteCityModel: weatherForecastModel)
                completionHandler(true)
            } else {
                print("can't convert properly")
                completionHandler(false)
            }
        }
        WeatherAPI.getFutureForecast(days: totalForecastDays, value: cityName, completionHandler: handler)
    }
    static func getWeatherForecastFromInternet(latitute: Double, longitute: Double, completionHandler: @escaping (_ cityData: FavoriteCityModel?) -> Void) {
        let str = "\(latitute),\(longitute)"
        let handler: WeatherAPI.WeatherForecastHandler = { (weatherForecastAPIModel) in
            print("printing from operation main")
            if weatherForecastAPIModel == nil {
                print("Operation got nil value from API")
                completionHandler(nil)
                return
            }
            if let weatherForecastModel = WeatherAPIModelConverter.convertToFavoriteCityModel(
                            providedAPIModel: weatherForecastAPIModel!) {
                print("got api model")
                CoreDataRepository.updateCityData(favoriteCityModel: weatherForecastModel)
                completionHandler(weatherForecastModel)
            } else {
                print("can't convert properly")
                completionHandler(nil)
            }
        }
        WeatherAPI.getFutureForecast(days: 3, value: str, completionHandler: handler)
    }
}
