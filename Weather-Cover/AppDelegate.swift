//
//  AppDelegate.swift
//  Weather-Cover
//
//  Created by Ahsan Khalil🤕 on 26/10/2020.
//

import UIKit
import CoreData
import GooglePlaces
import DropDown
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSPlacesClient.provideAPIKey(Constants.PlacesAPIKey)
        DropDown.startListeningToKeyboard()
        ControllerRepository.createIfUserEntityNotExists()
        // Delete All past irrelevent forecast data
        let operationQueue = OperationQueue()
        operationQueue.addOperation {
            let date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
            CoreDataRepository.deleteAllDataBefore(date: date)
        }
        BGTaskScheduler.shared.register(forTaskWithIdentifier: Constants.BackgroundRefereshDataID,
                                        using: nil) { (task) in
                self.handleAppWeatherReferesh(task: task as! BGAppRefreshTask)
        }
        return true
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        scheduleAppWeatherReferesh()
    }
    // MARK: Scheduling tasks
    func scheduleAppWeatherReferesh() {
        let request = BGAppRefreshTaskRequest(identifier: Constants.BackgroundRefereshDataID)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 0) // 4 hours from now
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("could not referesh data at this time")
        }
    }
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Weather_Cover")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    // MARK: APP Referesh Handler
    func handleAppWeatherReferesh(task: BGAppRefreshTask) {
        scheduleAppWeatherReferesh()
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        if let cityName = CoreDataRepository.getDetailCityName() {
            let downloadOperation = UpdateCityWeatherOperation(totalForecastDays: 3, cityName: cityName)
            downloadOperation.completionBlock = {
                print("data refereshed successfully")
            }
            queue.addOperation(downloadOperation)
        } else {
            print("city name not exists so no operation is going to start")
        }
        task.expirationHandler = {
            print("time expired")
            queue.cancelAllOperations()
        }
        task.setTaskCompleted(success: true)
    }

}

