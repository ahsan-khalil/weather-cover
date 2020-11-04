//
//  WeatherConditionEntity+CoreDataProperties.swift
//  Weather-Cover
//
//  Created by Ahsan Khalil🤕 on 04/11/2020.
//
//

import Foundation
import CoreData


extension WeatherConditionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherConditionEntity> {
        return NSFetchRequest<WeatherConditionEntity>(entityName: "WeatherConditionEntity")
    }

    @NSManaged public var code: String?
    @NSManaged public var day: String?
    @NSManaged public var icon: String?
    @NSManaged public var night: String?

}

extension WeatherConditionEntity : Identifiable {

}
