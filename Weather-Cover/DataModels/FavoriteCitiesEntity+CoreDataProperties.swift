//
//  FavoriteCitiesEntity+CoreDataProperties.swift
//  Weather-Cover
//
//  Created by Ahsan Khalil🤕 on 04/11/2020.
//
//

import Foundation
import CoreData


extension FavoriteCitiesEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteCitiesEntity> {
        return NSFetchRequest<FavoriteCitiesEntity>(entityName: "FavoriteCitiesEntity")
    }

    @NSManaged public var cityName: String?
    @NSManaged public var cityDetail: CityDetailEntity?

}

extension FavoriteCitiesEntity : Identifiable {

}
