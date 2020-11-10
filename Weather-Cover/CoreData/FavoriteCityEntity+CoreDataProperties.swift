//
//  FavoriteCityEntity+CoreDataProperties.swift
//  Weather-Cover
//
//  Created by Ahsan Khalil🤕 on 09/11/2020.
//
//

import Foundation
import CoreData


extension FavoriteCityEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteCityEntity> {
        return NSFetchRequest<FavoriteCityEntity>(entityName: "FavoriteCityEntity")
    }

    @NSManaged public var cityName: String?
    @NSManaged public var countryName: String?
    @NSManaged public var cityDetail: CityDetailEntity?

}

extension FavoriteCityEntity : Identifiable {

}
