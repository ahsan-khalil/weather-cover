//
//  UserEntity+CoreDataProperties.swift
//  Weather-Cover
//
//  Created by Ahsan Khalil🤕 on 09/11/2020.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var defaultCity: String?
    @NSManaged public var pressureUnit: String?
    @NSManaged public var temperatureUnit: String?
    @NSManaged public var timeFormate: String?
    @NSManaged public var username: String?
    @NSManaged public var windSpeedUnit: String?

}

extension UserEntity : Identifiable {

}
