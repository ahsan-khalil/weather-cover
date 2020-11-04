//
//  HourForecastDetailEntity+CoreDataProperties.swift
//  Weather-Cover
//
//  Created by Ahsan Khalil🤕 on 04/11/2020.
//
//

import Foundation
import CoreData


extension HourForecastDetailEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HourForecastDetailEntity> {
        return NSFetchRequest<HourForecastDetailEntity>(entityName: "HourForecastDetailEntity")
    }

    @NSManaged public var dateTime: Date?
    @NSManaged public var rainChances: Double
    @NSManaged public var temperatureC: Double
    @NSManaged public var windspeedMPH: Double
    @NSManaged public var forecastDetail: ForecastDetailEntity?

}

extension HourForecastDetailEntity : Identifiable {

}
