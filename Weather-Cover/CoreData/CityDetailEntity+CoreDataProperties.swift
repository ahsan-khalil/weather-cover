//
//  CityDetailEntity+CoreDataProperties.swift
//  Weather-Cover
//
//  Created by Ahsan Khalil🤕 on 09/11/2020.
//
//

import Foundation
import CoreData


extension CityDetailEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityDetailEntity> {
        return NSFetchRequest<CityDetailEntity>(entityName: "CityDetailEntity")
    }

    @NSManaged public var currentDetail: CurrentWeatherDetailEntity?
    @NSManaged public var favoriteCity: FavoriteCityEntity?
    @NSManaged public var forecastDetail: NSOrderedSet?

}

// MARK: Generated accessors for forecastDetail
extension CityDetailEntity {

    @objc(insertObject:inForecastDetailAtIndex:)
    @NSManaged public func insertIntoForecastDetail(_ value: ForecastDetailEntity, at idx: Int)

    @objc(removeObjectFromForecastDetailAtIndex:)
    @NSManaged public func removeFromForecastDetail(at idx: Int)

    @objc(insertForecastDetail:atIndexes:)
    @NSManaged public func insertIntoForecastDetail(_ values: [ForecastDetailEntity], at indexes: NSIndexSet)

    @objc(removeForecastDetailAtIndexes:)
    @NSManaged public func removeFromForecastDetail(at indexes: NSIndexSet)

    @objc(replaceObjectInForecastDetailAtIndex:withObject:)
    @NSManaged public func replaceForecastDetail(at idx: Int, with value: ForecastDetailEntity)

    @objc(replaceForecastDetailAtIndexes:withForecastDetail:)
    @NSManaged public func replaceForecastDetail(at indexes: NSIndexSet, with values: [ForecastDetailEntity])

    @objc(addForecastDetailObject:)
    @NSManaged public func addToForecastDetail(_ value: ForecastDetailEntity)

    @objc(removeForecastDetailObject:)
    @NSManaged public func removeFromForecastDetail(_ value: ForecastDetailEntity)

    @objc(addForecastDetail:)
    @NSManaged public func addToForecastDetail(_ values: NSOrderedSet)

    @objc(removeForecastDetail:)
    @NSManaged public func removeFromForecastDetail(_ values: NSOrderedSet)

}

extension CityDetailEntity : Identifiable {

}
