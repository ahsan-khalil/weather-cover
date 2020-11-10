//
//  WeatherIcons.swift
//  Weather-Cover
//
//  Created by Ahsan Khalil🤕 on 03/11/2020.
//

import Foundation
import UIKit

struct WeatherIconUtility {
    public static func getIcon(imageName: String) -> UIImage {
        let image = UIImage(named: "WeatherCondition/\(imageName)")
        return image ?? Constants.getNotFoundImage()
    }
    public static func extractIconAddress(imagePath: String) -> String {
        let array = imagePath.components(separatedBy: "/")
        var imageName = array[array.count - 1]
        imageName.removeLast(4)
        let newImagePath = array[array.count - 2] + "/" + imageName
        return newImagePath
    }
}
