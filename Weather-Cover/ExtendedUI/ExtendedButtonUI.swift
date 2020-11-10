//
//  ExtendedButtonUI.swift
//  Weather-Cover
//
//  Created by Ahsan Khalil🤕 on 06/11/2020.
//

import Foundation
import UIKit

@IBDesignable class ExtendedButtonUI: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var shadowOffsetWidth: CGFloat = 0
    @IBInspectable var shadowOffsetHeight: CGFloat = 0
    @IBInspectable var shadowColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    @IBInspectable var shadowOpacity: Float = 0
    @IBInspectable var shadowRadius: CGFloat = 0
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: shadowRadius)
        layer.shadowPath = shadowPath.cgPath
    }
}
