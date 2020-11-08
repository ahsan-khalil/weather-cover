//
//  HourlyForecastTableViewCell.swift
//  Weather-Cover
//
//  Created by Ahsan Khalil🤕 on 04/11/2020.
//

import UIKit
class HourlyForecastTableViewCell: UITableViewCell {
    static let reuseIdentifier = "HourlyForecastTableViewCell"
    @IBOutlet weak var labelDateTime: UILabel!
    @IBOutlet weak var labelRainPercentage: UILabel!
    @IBOutlet weak var labelWindSpeed: UILabel!
    @IBOutlet weak var labelTemperature: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        layer.borderWidth = 0.5
        layer.cornerRadius = 5
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    static func nib() -> UINib {
        return UINib(nibName: self.reuseIdentifier, bundle: nil)
    }
}
