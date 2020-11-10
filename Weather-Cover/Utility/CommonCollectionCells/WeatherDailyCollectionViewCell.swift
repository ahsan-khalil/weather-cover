//
//  WeatherDailyCollectionViewCell.swift
//  Weather-Cover
//
//  Created by Ahsan Khalil🤕 on 29/10/2020.
//

import UIKit

class WeatherDailyCollectionViewCell: ExtendedCollectionViewCell {
    @IBOutlet weak var labelToday: UILabel!
    @IBOutlet weak var labelCityName: UILabel!
    @IBOutlet weak var labelMaxTemp: UILabel!
    @IBOutlet weak var labelMinTemp: UILabel!
    @IBOutlet weak var labelWeatherCondition: UILabel!
    @IBOutlet weak var imgWeatherCondition: UIImageView!
    @IBOutlet weak var labelRainChance: UILabel!
    @IBOutlet weak var labelWindSpeed: UILabel!
    @IBOutlet weak var labelSunRiseTime: UILabel!
    @IBOutlet weak var labelThroughtDay: UILabel!
    static let reuseIdentifier = "WeatherDailyCollectionViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    static func nib() -> UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
}
