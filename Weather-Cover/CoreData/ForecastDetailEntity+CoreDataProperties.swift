//
//  ForecastDetailEntity+CoreDataProperties.swift
//  Weather-Cover
//
//  Created by Ahsan Khalil🤕 on 12/11/2020.
//
//

import Foundation
import CoreData


extension ForecastDetailEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ForecastDetailEntity> {
        return NSFetchRequest<ForecastDetailEntity>(entityName: "ForecastDetailEntity")
    }

    @NSManaged public var forecastDate: Date?
    @NSManaged public var maxTempC: Double
    @NSManaged public var minTempC: Double
    @NSManaged public var moonIllumination: Int32
    @NSManaged public var moonPhase: String?
    @NSManaged public var moonRiseHour: Int32
    @NSManaged public var moonRiseMin: Int32
    @NSManaged public var moonSetHour: Int32
    @NSManaged public var moonSetMin: Int32
    @NSManaged public var sunRiseHour: Int32
    @NSManaged public var sunRiseMin: Int32
    @NSManaged public var sunSetHour: Int32
    @NSManaged public var sunsetMin: Int32
    @NSManaged public var cityDetail: CityDetailEntity?
    @NSManaged public var hourForecastDetail: NSOrderedSet?

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
