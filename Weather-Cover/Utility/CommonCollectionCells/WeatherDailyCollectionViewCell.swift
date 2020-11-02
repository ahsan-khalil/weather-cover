//
//  WeatherDailyCollectionViewCell.swift
//  Weather-Cover
//
//  Created by Ahsan Khalil🤕 on 29/10/2020.
//

import UIKit

class WeatherDailyCollectionViewCell: ExtendedCollectionViewCell {

    static let reuseIdentifier = "WeatherDailyCollectionViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    static func nib() -> UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }

}
