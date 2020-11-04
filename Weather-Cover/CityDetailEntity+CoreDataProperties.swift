//
//  CityDetailEntity+CoreDataProperties.swift
//  Weather-Cover
//
//  Created by Ahsan Khalil🤕 on 04/11/2020.
//
//

import Foundation
import CoreData


extension CityDetailEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityDetailEntity> {
        return NSFetchRequest<CityDetailEntity>(entityName: "CityDetailEntity")
    }

    @NSManaged public var currentDetail: CurrentWeatherDetailEntity?
    @NSManaged public var favoriteCity: FavoriteCitiesEntity?
    @NSManaged public var forecastDetail: ForecastDetailEntity?

}

extension CityDetailEntity : Identifiable {

}
