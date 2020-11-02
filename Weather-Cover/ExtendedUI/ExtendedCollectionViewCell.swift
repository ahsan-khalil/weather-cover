//
//  ExtendedCollectionViewCell.swift
//  Weather-Cover
//
//  Created by Ahsan Khalil🤕 on 30/10/2020.
//

import Foundation
import UIKit

@IBDesignable
class ExtendedCollectionViewCell: UICollectionViewCell {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var shadowOffsetWidth: CGFloat = 0 {
        didSet {
            updateShadowOffsets()
        }
    }
    @IBInspectable var shadowOffsetHeight: CGFloat = 0 {
        didSet {
            updateShadowOffsets()
        }
    }
    @IBInspectable var shadowColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    @IBInspectable var shadowOpacity: Float = 0 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: shadowRadius)
        layer.shadowPath = shadowPath.cgPath
        clipsToBounds = false
    }
    func updateShadowOffsets() {
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
    }
}
