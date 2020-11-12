//
//  HourForecastDetailEntity+CoreDataProperties.swift
//  Weather-Cover
//
//  Created by Ahsan Khalil🤕 on 12/11/2020.
//
//

import Foundation
import CoreData


extension HourForecastDetailEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HourForecastDetailEntity> {
        return NSFetchRequest<HourForecastDetailEntity>(entityName: "HourForecastDetailEntity")
    }

    @NSManaged public var conditionText: String?
    @NSManaged public var dateTime: Date?
    @NSManaged public var feelsLikeTempC: Double
    @NSManaged public var humidity: Double
    @NSManaged public var iconName: String?
    @NSManaged public var pressureIN: Double
    @NSManaged public var rainChances: Double
    @NSManaged public var temperatureC: Double
    @NSManaged public var windDirection: String?
    @NSManaged public var windspeedMPH: Double
    @NSManaged public var forecastDetail: ForecastDetailEntity?

}

extension HourForecastDetailEntity : Identifiable {

}
