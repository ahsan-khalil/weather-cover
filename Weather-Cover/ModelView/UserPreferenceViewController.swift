//
//  UserPreferenceViewController.swift
//  Weather-Cover
//
//  Created by Ahsan Khalil🤕 on 06/11/2020.
//

import UIKit
import DropDown
import Toast_Swift

class UserPreferenceViewController: UIViewController {
    static let identifier = "UserPreferenceViewController"
    @IBOutlet weak var textUserName: UITextField!
    @IBOutlet weak var btnCity: UIButton!
    @IBOutlet weak var btnTimeFormate: UIButton!
    @IBOutlet weak var btnTempUnit: UIButton!
    @IBOutlet weak var btnWindSpeedUnit: UIButton!
    @IBOutlet weak var btnPressureUnit: UIButton!
    @IBOutlet weak var btnUpdatePreference: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeData()
    }
    override func viewWillAppear(_ animated: Bool) {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    private func initializeData() {
        let userData = ControllerRepository.getUserData()
        btnTimeFormate.setTitle(userData.timeFormate!, for: .normal)
        btnTempUnit.setTitle(userData.temperatureUnit!, for: .normal)
        btnWindSpeedUnit.setTitle(userData.windSpeed!, for: .normal)
        btnPressureUnit.setTitle(userData.pressureUnit!, for: .normal)
        if let cityName = userData.defaultCity {
            btnCity.setTitle(cityName, for: .normal)
        }
        if let username = userData.username {
            textUserName.text = username
        } else {
            textUserName.text = ""
        }
    }
    @IBAction func onClickCity(_ sender: UIButton) {
        //  swiftlint:disable all
        let vc = storyboard?.instantiateViewController(identifier: SearchCityViewController.identifier) as! SearchCityViewController
        vc.completionHandler = { (cityName) in
            print(cityName)
            let handler: ControllerRepository.AddCityCompletionHandler = { (errorEnum) in
                switch errorEnum {
                case .cityNameIsNotCorrect:
                    print("city name is not correct")
                    self.view.makeToast("City Name is not correct", duration: 2, position: .bottom)
                case .noError:
                    print("added succesfully")
                    self.view.makeToast("Updated Successfully", duration: 2, position: .bottom)
                    self.btnCity.setTitle(cityName, for: .normal)
                case .noInternet:
                    print("no internet")
                    self.view.makeToast("No Internet Connection", duration: 2, position: .bottom)
                case .nullPointerException:
                    print("null pointer exception")
                    self.view.makeToast("City Does not exist", duration: 2, position: .bottom)
                case .cityAllreadyExists:
                    print("City Already Exists. Updated to Default")
                    self.view.makeToast("Updated Successfully", duration: 2, position: .bottom)
                    self.btnCity.setTitle(cityName, for: .normal)
                }
            }
            ControllerRepository.updateDefaultCity(cityName: cityName, completionHandler: handler)
        }
        navigationController?.pushViewController(vc, animated: false)
        //  swiftlint:enable all
    }
    @IBAction func onClickTimeFormat(_ sender: UIButton) {
        let handler: Constants.DropDownHandler = { (index, title) in
            print(index)
            print(title)
            sender.setTitle(title, for: .normal)
        }
        let twelveHour = ConversionUtility.TimeFormate.twelveHour.rawValue
        let twentyFourHour = ConversionUtility.TimeFormate.twentyFourHour.rawValue
        Constants.showDropDown(sender: sender, dataSource: [twelveHour, twentyFourHour], completionHandler: handler)
    }
    @IBAction func onClickTemperatureUnit(_ sender: UIButton) {
        let celsius = ConversionUtility.TemperatureUnits.celsius.rawValue
        let fahrenhiet = ConversionUtility.TemperatureUnits.fahrenheit.rawValue
        let kelvin = ConversionUtility.TemperatureUnits.kelvin.rawValue
        let dataSource = [celsius, fahrenhiet, kelvin]
        let handler: Constants.DropDownHandler = { (index, title) in
            print(index)
            print(title)
            sender.setTitle(title, for: .normal)
        }
        Constants.showDropDown(sender: sender, dataSource: dataSource, completionHandler: handler)
    }
    @IBAction func onClickWindSpeedUnit(_ sender: UIButton) {
        let kPH = ConversionUtility.SpeedUnits.kilometersPerHour.rawValue
        let mPH = ConversionUtility.SpeedUnits.milesPerHour.rawValue
        let dataSource = [kPH, mPH]
        let handler: Constants.DropDownHandler = { (index, title) in
            print(index)
            print(title)
            sender.setTitle(title, for: .normal)
        }
        Constants.showDropDown(sender: sender, dataSource: dataSource, completionHandler: handler)
    }
    @IBAction func onClickPressureUnit(_ sender: UIButton) {
        let inchesOfMercury = ConversionUtility.PressureUnits.inchesOfMercury.rawValue
        let milibars = ConversionUtility.PressureUnits.milibar.rawValue
        let hPA = ConversionUtility.PressureUnits.hectoPascal.rawValue
        let kPA = ConversionUtility.PressureUnits.kiloPascal.rawValue
        let dataSource = [inchesOfMercury, milibars, hPA, kPA]
        let handler: Constants.DropDownHandler = { (index, title) in
            print(index)
            print(title)
            sender.setTitle(title, for: .normal)
        }
        Constants.showDropDown(sender: sender, dataSource: dataSource, completionHandler: handler)
    }
    @IBAction func onClickUpdate(_ sender: UIButton) {
        let userModel = self.getUserData()
        if userModel.username!.isEmpty {
            self.view.makeToast("Username can't be empty", duration: 2.0, position: .center)
            return
        }
        if ControllerRepository.updateUserData(userModel: userModel) {
            self.view.makeToast("Updated Successfully", duration: 2, position: .center)
        } else {
            self.view.makeToast("Internal Error Occured", duration: 2, position: .center)
        }
    }
    private func getUserData() -> UserModel {
        let username = (textUserName.text!).trimmingCharacters(in: .whitespacesAndNewlines)
        let timeFormateUnit = btnTimeFormate.title(for: .normal)!
        let tempUnit = btnTempUnit.title(for: .normal)!
        let windSpeedUnit = btnWindSpeedUnit.title(for: .normal)!
        let pressureUnit = btnPressureUnit.title(for: .normal)!
        var userModel = UserModel()
        userModel.pressureUnit = pressureUnit
        userModel.temperatureUnit = tempUnit
        userModel.timeFormate = timeFormateUnit
        userModel.windSpeed = windSpeedUnit
        userModel.username = username
        return userModel
    }
}
