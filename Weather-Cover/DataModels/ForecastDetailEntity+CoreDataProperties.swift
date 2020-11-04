//
//  ForecastDetailEntity+CoreDataProperties.swift
//  Weather-Cover
//
//  Created by Ahsan Khalil🤕 on 04/11/2020.
//
//

import Foundation
import CoreData


extension ForecastDetailEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ForecastDetailEntity> {
        return NSFetchRequest<ForecastDetailEntity>(entityName: "ForecastDetailEntity")
    }

    @NSManaged public var sunRise: Int32
    @NSManaged public var sunSet: Int32
    @NSManaged public var moonSet: Int32
    @NSManaged public var moonRise: Int32
    @NSManaged public var moonPhase: String?
    @NSManaged public var moonIllumination: Int32
    @NSManaged public var temperatureC: Double
    @NSManaged public var humidity: Double
    @NSManaged public var windDirection: String?
    @NSManaged public var pressureIN: Double
    @NSManaged public var hourForecastDetail: NSOrderedSet?
    @NSManaged public var cityDetail: CityDetailEntity?

}

// MARK: Generated accessors for hourForecastDetail
extension ForecastDetailEntity {

    @objc(insertObject:inHourForecastDetailAtIndex:)
    @NSManaged public func insertIntoHourForecastDetail(_ value: HourForecastDetailEntity, at idx: Int)

    @objc(removeObjectFromHourForecastDetailAtIndex:)
    @NSManaged public func removeFromHourForecastDetail(at idx: Int)

    @objc(insertHourForecastDetail:atIndexes:)
    @NSManaged public func insertIntoHourForecastDetail(_ values: [HourForecastDetailEntity], at indexes: NSIndexSet)

    @objc(removeHourForecastDetailAtIndexes:)
    @NSManaged public func removeFromHourForecastDetail(at indexes: NSIndexSet)

    @objc(replaceObjectInHourForecastDetailAtIndex:withObject:)
    @NSManaged public func replaceHourForecastDetail(at idx: Int, with value: HourForecastDetailEntity)

    @objc(replaceHourForecastDetailAtIndexes:withHourForecastDetail:)
    @NSManaged public func replaceHourForecastDetail(at indexes: NSIndexSet, with values: [HourForecastDetailEntity])

    @objc(addHourForecastDetailObject:)
    @NSManaged public func addToHourForecastDetail(_ value: HourForecastDetailEntity)

    @objc(removeHourForecastDetailObject:)
    @NSManaged public func removeFromHourForecastDetail(_ value: HourForecastDetailEntity)

    @objc(addHourForecastDetail:)
    @NSManaged public func addToHourForecastDetail(_ values: NSOrderedSet)

    @objc(removeHourForecastDetail:)
    @NSManaged public func removeFromHourForecastDetail(_ values: NSOrderedSet)

}

extension ForecastDetailEntity : Identifiable {

}
