//
//  ContentRefereshOperations.swift
//  Weather-Cover
//
//  Created by Ahsan Khalil🤕 on 13/11/2020.
//

import Foundation
import CoreData

struct ContentRefereshOperations {
}

class UpdateCityWeatherOperation: Operation {
    var fetchDate: Date?
    private let totalForecastDays: Int
    var downloadResult: WeatherForecastAPIModel?
    private var downloading = false
    private let cityName: String
    init(totalForecastDays: Int, cityName: String) {
        self.totalForecastDays = totalForecastDays
        self.cityName = cityName
    }
    convenience init(totalForecastDays: Int, cityName: String, fetchDate: Date) {
        self.init(totalForecastDays: totalForecastDays, cityName: cityName)
        self.fetchDate = fetchDate
    }
    override var isAsynchronous: Bool {
        return true
    }
    override var isExecuting: Bool {
        return downloading
    }
    override var isFinished: Bool {
        return !downloading
    }
    override func main() {
        if isCancelled {
            print("printing from operation main cancelled line 43")
            return
        }
        willChangeValue(forKey: #keyPath(isExecuting))
        downloading = true
        didChangeValue(forKey: #keyPath(isExecuting))
        let handler: WeatherAPI.WeatherForecastHandler = { (weatherForecastAPIModel) in
            self.willChangeValue(forKey: #keyPath(isExecuting))
            self.willChangeValue(forKey: #keyPath(isFinished))
            self.downloadResult = weatherForecastAPIModel
            self.downloading = false
            print("printing from operation main")
            if self.isCancelled {
                return
            }
            if weatherForecastAPIModel == nil {
                print("Operation got nil value from API")
                return
            }
            if let weatherForecastModel = WeatherAPIModelConverter.convertToFavoriteCityModel(
                            providedAPIModel: weatherForecastAPIModel!) {
                print("got api model")
                if self.isCancelled {
                    return
                }
                CoreDataRepository.updateCityData(favoriteCityModel: weatherForecastModel)
            } else {
                print("can't convert properly")
            }
            self.didChangeValue(forKey: #keyPath(isFinished))
            self.didChangeValue(forKey: #keyPath(isExecuting))
        }
        if isCancelled {
            print("printing from operation main cancelled line 64")
            return
        }
        WeatherAPI.getFutureForecast(days: totalForecastDays, value: cityName, completionHandler: handler)
        if isCancelled {
            print("printing from operation main cancelled line 69")
            return
        }
    }
}
class UpdateEntityInCoreData: Operation {
    let weatherForecastModel: FavoriteCityModel
    var saving = false
    init(weatherForecastModel: FavoriteCityModel) {
        self.weatherForecastModel = weatherForecastModel
        self.saving = true
    }
    override var isFinished: Bool {
        return !saving
    }
    override var isExecuting: Bool {
        return saving
    }
    override func main() {
        saving = true
        if isCancelled {
            return
        }
        self.willChangeValue(forKey: #keyPath(isExecuting))
        self.willChangeValue(forKey: #keyPath(isFinished))
        CoreDataRepository.updateCityData(favoriteCityModel: weatherForecastModel)
        self.saving = false
        self.willChangeValue(forKey: #keyPath(isExecuting))
        self.willChangeValue(forKey: #keyPath(isFinished))
    }
}
