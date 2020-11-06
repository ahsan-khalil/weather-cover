//
//  WaitingActivityIndicator.swift
//  Weather-Cover
//
//  Created by Ahsan Khalil🤕 on 03/11/2020.
//
//  swiftlint:disable all
import Foundation
import UIKit

class WaitingActivityIndicator {
    var vSpinner: UIView?
    func showSpinner(onView: UIView) {
            let spinnerView = UIView.init(frame: onView.bounds)
            spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .large)
            ai.startAnimating()
            ai.center = spinnerView.center
            DispatchQueue.main.async {
                spinnerView.addSubview(ai)
                onView.addSubview(spinnerView)
            }
            vSpinner = spinnerView
        }
        func removeSpinner() {
            DispatchQueue.main.async {
                self.vSpinner?.removeFromSuperview()
                self.vSpinner = nil
            }
        }
}
