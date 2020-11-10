//
//  Constants.swift
//  Weather-Cover
//
//  Created by Ahsan Khalil🤕 on 28/10/2020.
//

import Foundation
import UIKit
import DropDown
struct Constants {
    static let PlacesAPIKey = "AIzaSyAC20gS8mRGFZq_8EmhJxkRysOpfZUDpU4"
    typealias DropDownHandler = (_ index: Int, _ title: String) -> Void
    public static func getNotFoundImage() -> UIImage {
        return UIImage(named: "WeatherCondition/day/119")!
    }
    public static func printError(filename: String, errorStr: String) {
        print("\(filename): \(errorStr)")
    }
    public static func showDropDown(sender: UIView,
                                    dataSource: [String],
                                    completionHandler: @escaping DropDownHandler) {
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = dataSource
        dropDown.selectionAction = { (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            dropDown.hide()
                completionHandler(index, item)
        }
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height)! + 7)
        dropDown.topOffset = CGPoint(x: 0, y: -(dropDown.anchorView?.plainView.bounds.height)! + 7)
        dropDown.show()
    }
    public static func isSameDay(day1: Date, day2: Date) -> Bool {
        let order = Calendar.current.compare(day1, to: day2, toGranularity: .day)
        switch order {
        case .orderedDescending:
            return false
        case .orderedAscending:
            return false
        case .orderedSame:
            return true
        }
    }
    public static func getCurrentHourTime() -> Int {
        let hour = Calendar.current.component(.hour, from: Date())
        return hour
    }
}
