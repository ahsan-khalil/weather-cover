//
//  CurrentWeatherDetailEntity+CoreDataProperties.swift
//  Weather-Cover
//
//  Created by Ahsan Khalil🤕 on 12/11/2020.
//
//

import Foundation
import CoreData


extension CurrentWeatherDetailEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentWeatherDetailEntity> {
        return NSFetchRequest<CurrentWeatherDetailEntity>(entityName: "CurrentWeatherDetailEntity")
    }

    @NSManaged public var humidity: Int32
    @NSManaged public var temperatureC: Double
    @NSManaged public var timeFetched: Date?
    @NSManaged public var cityDetail: CityDetailEntity?

}

extension CurrentWeatherDetailEntity : Identifiable {

}
