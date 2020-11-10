//
//  RepositoryUtility.swift
//  Weather-Cover
//
//  Created by Ahsan Khalil🤕 on 04/11/2020.
//

import Foundation
import CoreData
class RepositoryUtility {
    private static let weatherCoverContainer: NSPersistentContainer = {
                let container = NSPersistentContainer(name: "Weather_Cover")
        container.loadPersistentStores { _, error in
                    if let error = error {
                        fatalError("Unable to load persistent stores: \(error)")
                    }
                }
                return container
            }()
    static func getWeatherCoverContainerContext() -> NSManagedObjectContext {
        return self.weatherCoverContainer.viewContext
    }
    static func saveContext() {
        let context = self.getWeatherCoverContainerContext()
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                //You should not use this function in a shipping application,
                //although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
