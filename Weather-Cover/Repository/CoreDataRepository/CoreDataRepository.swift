//
//  OfflineRepository.swift
//  Weather-Cover
//
//  Created by Ahsan Khalil🤕 on 04/11/2020.
//
//  swiftlint:disable all
import Foundation
class CoreDataRepository {
    static let soureceFileName = #file
    /// Get User Entity Data
    public static func getUserData() -> UserModel {
        var userModel: UserModel = UserModel()
        let context = RepositoryUtility.getWeatherCoverContainerContext()
        do {
            let userEntity: [UserEntity] = try context.fetch(UserEntity.fetchRequest())
            if userEntity.count == 0 {
                Constants.printError(filename: soureceFileName, errorStr: "entity does not exists")
                
            } else {
                userModel.defaultCity = userEntity[0].defaultCity
                userModel.pressureUnit = userEntity[0].pressureUnit
                userModel.temperatureUnit = userEntity[0].temperatureUnit
                userModel.timeFormate = userEntity[0].timeFormate
                userModel.username = userEntity[0].username
                userModel.windSpeed = userEntity[0].windSpeedUnit
                return userModel
            }
        } catch {
            //error occured
            Constants.printError(filename: soureceFileName, errorStr: "Error Occured in reteriving user entity")
        }
        return userModel
    }
    // Get Current City Name
    public static func getDetailCityName() -> String? {
        return getUserData().defaultCity
    }
    /// Will insert user only if there is no user before
    public static func createEmptyStandaloneUser() {
        let context = RepositoryUtility.getWeatherCoverContainerContext()
        do {
            let userEntity: [UserEntity] = try context.fetch(UserEntity.fetchRequest())
            if userEntity.count == 0 {
                Constants.printError(filename: soureceFileName, errorStr: "User Entity doesn't exists")
                _ = UserEntity.init(context: context)
                do {
                    print("Creating new user")
                    try context.save()
                } catch {
                    Constants.printError(filename: soureceFileName, errorStr: "Not saved User Entity")
                }
            }
        } catch {
            Constants.printError(filename: soureceFileName, errorStr: "Error Occured in reteriving user entity")
        }
    }
    /// update user data except default city
    public static func updateUserEntity(userModel: UserModel) -> Bool {
        let context = RepositoryUtility.getWeatherCoverContainerContext()
        do {
            let userEntity: [UserEntity] = try context.fetch(UserEntity.fetchRequest())
            if userEntity.count != 0 {
                userEntity[0].pressureUnit = userModel.pressureUnit
                userEntity[0].temperatureUnit = userModel.temperatureUnit
                userEntity[0].timeFormate = userModel.timeFormate
                userEntity[0].username = userModel.username
                userEntity[0].windSpeedUnit = userModel.windSpeed
                do {
                    try context.save()
                    return true
                } catch {
                    Constants.printError(filename: soureceFileName, errorStr: "Not updated User Entity")
                }
            }
        } catch {
            Constants.printError(filename: soureceFileName, errorStr: "Error Occured in reteriving user entity")
        }
        return false
    }
    /// update user default city
    public static func updateUserDefaultCity(favoriteCityModel:FavoriteCityModel) {
        let context = RepositoryUtility.getWeatherCoverContainerContext()
        do {
            let userEntity: [UserEntity] = try context.fetch(UserEntity.fetchRequest())
            if userEntity.count != 0 {
                if let defaultCityName = userEntity[0].defaultCity {
                    deleteDataOfCity(cityName: defaultCityName)
                }
            }
            // Now Add Details
            AddCityData(favoriteCityModel: favoriteCityModel)
            userEntity[0].defaultCity = favoriteCityModel.cityName
            do {
                try context.save()
            } catch {
                Constants.printError(filename: soureceFileName, errorStr: "Error Occured in updating entity")
            }
        } catch {
            Constants.printError(filename: soureceFileName, errorStr: "Error Occured in reteriving user entity")
        }
    }
    /// delete data by city name
    public static func deleteDataOfCity(cityName: String) {
        let context = RepositoryUtility.getWeatherCoverContainerContext()
        do {
            let favoriteCityEntityList: [FavoriteCityEntity] = try context.fetch(FavoriteCityEntity.fetchRequest())
            for favoriteCityEntity in favoriteCityEntityList {
                if favoriteCityEntity.cityName == cityName {
                    context.delete(favoriteCityEntity)
                }
            }
        } catch {
            Constants.printError(filename: soureceFileName, errorStr: "Error Occured in reteriving favorite city list")
        }
    }
    /// add city data
    public static func AddCityData(favoriteCityModel: FavoriteCityModel) {
        do {
            let context = RepositoryUtility.getWeatherCoverContainerContext()
            let cityEntity = FavoriteCityEntity.init(context: context)
            cityEntity.cityName = favoriteCityModel.cityName
            // city detail
            let cityDetailEntity = CityDetailEntity.init(context: context)
            let currentWeatherEntity = CurrentWeatherDetailEntity.init(context: context)
            if let currentDetailModel = favoriteCityModel.cityDetail?.currentWeatherDetail {
                currentWeatherEntity.temperatureC = currentDetailModel.temperatureC
                currentWeatherEntity.timeFetched = currentDetailModel.timeFetched
            } else {
                Constants.printError(filename: soureceFileName, errorStr: "Current Weather Detail Model is null")
                //return false
            }
            if let forecastDetailList = favoriteCityModel.cityDetail?.forecastDetail {
                for forecastDetail in forecastDetailList {
                    let forecastEntity = ForecastDetailEntity.init(context: context)
                    forecastEntity.sunRiseHour = forecastDetail.astronomyModel.sunRiseHour
                    forecastEntity.sunRiseMin = forecastDetail.astronomyModel.sunRiseMin
                    forecastEntity.sunSetHour = forecastDetail.astronomyModel.sunSetHour
                    forecastEntity.sunsetMin = forecastDetail.astronomyModel.sunSetMin
                    forecastEntity.minTempC = forecastDetail.minTempC
                    forecastEntity.maxTempC = forecastDetail.maxTempC
                    forecastEntity.forecastDate = forecastDetail.date
                   
                    if let hourModelList = forecastDetail.hourDetailList {
                        for hourModel in hourModelList {
                            let hourDetailEntity = HourForecastDetailEntity.init(context: context)
                            hourDetailEntity.dateTime = hourModel.dateTime
                            hourDetailEntity.rainChances = hourModel.rainChances
                            hourDetailEntity.temperatureC = hourModel.temperatureC
                            hourDetailEntity.windspeedMPH = hourModel.windSpeedMPH
                            forecastEntity.addToHourForecastDetail(hourDetailEntity)
                        }
                    } else {
                        Constants.printError(filename: soureceFileName, errorStr: "Current Weather Detail Model hour list is null")
                        //return false
                    }
                    cityDetailEntity.addToForecastDetail(forecastEntity)
                    cityDetailEntity.currentDetail = currentWeatherEntity
                    //cityDetailEntity.favoriteCity = cityEntity
                }
                cityEntity.cityDetail = cityDetailEntity
            } else {
                Constants.printError(filename: soureceFileName, errorStr: "Future Forecast is nil")
                //return false
            }
            try context.save()
        } catch  {
            Constants.printError(filename: soureceFileName, errorStr: "Error in adding city")
            //return false
        }
    }
    public static func isCityExists(cityName: String) -> Bool {
        let context = RepositoryUtility.getWeatherCoverContainerContext()
        do {
            let favoriteCityEntityList: [FavoriteCityEntity] = try context.fetch(FavoriteCityEntity.fetchRequest())
            for favoriteCityEntity in favoriteCityEntityList {
                if favoriteCityEntity.cityName == cityName {
                    return true
                }
            }
        } catch {
            Constants.printError(filename: soureceFileName, errorStr: "Error Occured in reteriving favorite city list")

        }
        return false
    }
    // Convert CurrentWeatherDetain Entity to CurrentWeatherDetailModel
    public static func getCurrentWeatherModel(currentDetailEntity: CurrentWeatherDetailEntity?) -> CurrentWeatherDetailModel? {
        
        if let currentDetailEntity =  currentDetailEntity {
            let currentWeatherModel = CurrentWeatherDetailModel(temperatureC: currentDetailEntity.temperatureC,
                                                                timeFetched: currentDetailEntity.timeFetched!)
            return currentWeatherModel
        }
        return nil
    }
    // Conver HourDetailEntityList to HourDetailModelList
    public static func getHourDetailModelList(hourEntityList: NSOrderedSet?) -> [HourForecastDetailModel]? {
        
        var hourModelList: [HourForecastDetailModel]? = nil
        if let hourEntityList = hourEntityList {
            hourModelList = [HourForecastDetailModel]()
            for hourEntityObj in hourEntityList.array {
                let hourEntity = hourEntityObj as! HourForecastDetailEntity
                let hourModel = HourForecastDetailModel(dateTime: hourEntity.dateTime!,
                                                        rainChances: hourEntity.rainChances,
                                                        temperatureC: hourEntity.temperatureC,
                                                        windSpeedMPH: hourEntity.windspeedMPH)
                hourModelList?.append(hourModel)
            }
        } else {
            Constants.printError(filename: soureceFileName, errorStr: "Error Occured in reteriving hour entity detail list")
        }
        return hourModelList
    }
    // Convert ForecastEntityList to ForecastModelList
    public static func getForecastModelList(forecastDetailEntityList: NSOrderedSet?) -> [ForeCastDetailModel]? {
        var forecastModelList: [ForeCastDetailModel]? = nil
        if let forecastDetailEntityList = forecastDetailEntityList {
            forecastModelList = [ForeCastDetailModel]()
            for forecastDetailEntityObj in forecastDetailEntityList.array {
                let forecastDetailEntity =  forecastDetailEntityObj as! ForecastDetailEntity
                // Get Hour Model List
                let hourModelList: [HourForecastDetailModel]? = getHourDetailModelList(hourEntityList: forecastDetailEntity.hourForecastDetail)
                let astronomyModel = AstronomyModel(sunRiseHour: forecastDetailEntity.sunSetHour,
                                                    sunSetHour: forecastDetailEntity.sunSetHour,
                                                    sunRiseMin: forecastDetailEntity.sunRiseMin,
                                                    sunSetMin: forecastDetailEntity.sunsetMin)
                
                let forecastModel = ForeCastDetailModel(date: forecastDetailEntity.forecastDate!,
                                                        minTempC: forecastDetailEntity.minTempC,
                                                        maxTempC: forecastDetailEntity.maxTempC,
                                                        hourDetailList: hourModelList,
                                                        astronomyModel: astronomyModel)
                forecastModelList?.append(forecastModel)
            }
        } else {
            Constants.printError(filename: soureceFileName, errorStr: "Error Occured in reteriving forecast entity detail list")
        }
        return forecastModelList
    }
    
    // retrive information
    public static func getFavoriteCityEntity(cityName: String) -> FavoriteCityModel? {
        let context = RepositoryUtility.getWeatherCoverContainerContext()
        do {
            let favoriteCityEntityList: [FavoriteCityEntity] = try context.fetch(FavoriteCityEntity.fetchRequest())
            for favoriteCityEntity in favoriteCityEntityList {
                // Get City Detail
                if favoriteCityEntity.cityName == cityName {
                    // Get Current Detail
                    let currentWeaherModel:CurrentWeatherDetailModel? = getCurrentWeatherModel(
                                                        currentDetailEntity: favoriteCityEntity.cityDetail?.currentDetail)
                    // Get Forecast Detail
                    let forecastModelList: [ForeCastDetailModel]? = getForecastModelList(forecastDetailEntityList: favoriteCityEntity.cityDetail?.forecastDetail)
                    let cityDetailModel = CityDetailModel(currentWeatherDetail: currentWeaherModel, forecastDetail: forecastModelList)
                    let favoriteCityModel = FavoriteCityModel(cityName: cityName, cityDetail: cityDetailModel)
                    return favoriteCityModel
                }
            }
        } catch {
            Constants.printError(filename: soureceFileName, errorStr: "Error Occured in reteriving favorite city list")

        }
        return nil
    }
    // retreive all city data
    public static func getFavoriteCityEntityList() -> [FavoriteCityModel] {
        var favoriteCityModelList = [FavoriteCityModel]()
        let context = RepositoryUtility.getWeatherCoverContainerContext()
        do {
            let favoriteCityEntityList: [FavoriteCityEntity] = try context.fetch(FavoriteCityEntity.fetchRequest())
            for favoriteCityEntity in favoriteCityEntityList {
                // Get City Detail
                // Get Current Detail
                let currentWeaherModel:CurrentWeatherDetailModel? = getCurrentWeatherModel(
                                                    currentDetailEntity: favoriteCityEntity.cityDetail?.currentDetail)
                // Get Forecast Detail
                let forecastModelList: [ForeCastDetailModel]? = getForecastModelList(forecastDetailEntityList: favoriteCityEntity.cityDetail?.forecastDetail)
                let cityDetailModel = CityDetailModel(currentWeatherDetail: currentWeaherModel, forecastDetail: forecastModelList)
                let favoriteCityModel = FavoriteCityModel(cityName: favoriteCityEntity.cityName!, cityDetail: cityDetailModel)
                favoriteCityModelList.append(favoriteCityModel)
            }
        } catch {
            Constants.printError(filename: soureceFileName, errorStr: "Error Occured in reteriving favorite city list")

        }
        return favoriteCityModelList
    }
}
//  swiftlint:enable all
