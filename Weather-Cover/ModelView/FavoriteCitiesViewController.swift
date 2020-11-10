//
//  FavoriteCitiesViewController.swift
//  Weather-Cover
//
//  Created by Ahsan Khalil🤕 on 06/11/2020.
//

import UIKit
import Toast_Swift
class FavoriteCitiesViewController: UIViewController {
    static let identifier = "FavoriteCitiesViewController"
    var cityDataList = [FavoriteCityModel]()
    @IBOutlet weak var labelViewControllerTitle: UILabel!
    @IBOutlet weak var collectionViewCitiesCurrentWeather: UICollectionView!
    @IBOutlet weak var btnAddCity: UIButton!
    override func viewWillAppear(_ animated: Bool) {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewCitiesCurrentWeather.delegate = self
        collectionViewCitiesCurrentWeather.dataSource = self
        collectionViewCitiesCurrentWeather.register(
                        WeatherDailyCollectionViewCell.nib(),
                        forCellWithReuseIdentifier: WeatherDailyCollectionViewCell.reuseIdentifier)
        updateData()
        let longPressGR = UILongPressGestureRecognizer(target: self,
                                                       action: #selector(handleLongPress(longPressGR:)))
        longPressGR.minimumPressDuration = 0.5
        longPressGR.delaysTouchesBegan = true
        self.collectionViewCitiesCurrentWeather.addGestureRecognizer(longPressGR)
    }
    @objc
    func handleLongPress(longPressGR: UILongPressGestureRecognizer) {
        if longPressGR.state == .began {
            print("started")
            let point = longPressGR.location(in: self.collectionViewCitiesCurrentWeather)
            let indexPath = self.collectionViewCitiesCurrentWeather.indexPathForItem(at: point)
            if let indexPath = indexPath {
                let cell = self.collectionViewCitiesCurrentWeather.cellForItem(at: indexPath)
                cell?.backgroundColor = UIColor.darkGray
                print(indexPath.section)
            } else {
                print("Could not find index path")
            }
        }
        if longPressGR.state == .ended {
            print("ended")
            let point = longPressGR.location(in: self.collectionViewCitiesCurrentWeather)
            let indexPath = self.collectionViewCitiesCurrentWeather.indexPathForItem(at: point)
            if let indexPath = indexPath {
                let cell = self.collectionViewCitiesCurrentWeather.cellForItem(at: indexPath)
                cell?.backgroundColor = UIColor.white
                print(indexPath.section)
                ControllerRepository.removeCityData(cityName: cityDataList[indexPath.section].cityName)
                updateData()
            } else {
                print("Could not find index path")
            }
        }
    }
    private func updateData() {
        cityDataList.removeAll()
        cityDataList = ControllerRepository.getFavoriteCityListExceptDefaultCity(day: Date())
        collectionViewCitiesCurrentWeather.reloadData()
    }
    @IBAction func onClickAddCity(_ sender: UIButton) {
        //  swiftlint:disable all
        let vc = storyboard?.instantiateViewController(
                            identifier: SearchCityViewController.identifier) as! SearchCityViewController
        //  swiftlint:enable  all
        vc.completionHandler = { (cityName) in
            print(cityName)
            let handler: ControllerRepository.AddCityCompletionHandler = { (errorEnum) in
                switch errorEnum {
                case .cityNameIsNotCorrect:
                    print("city name is not correct")
                    self.view.makeToast("Enter Correct City Name", duration: 2, position: .bottom)
                case .noError:
                    print("added succesfully")
                    self.view.makeToast("Added Successfully", duration: 2, position: .bottom)
                    self.updateData()
                case .noInternet:
                    print("no internet")
                    self.view.makeToast("No Internet Connection", duration: 2, position: .bottom)
                case .nullPointerException:
                    print("null pointer exception")
                    self.view.makeToast("City Does not Exists", duration: 2, position: .bottom)
                case .cityAllreadyExists:
                    print("city already Exists")
                    self.view.makeToast("City Already Exists", duration: 2, position: .bottom)
                }
            }
            ControllerRepository.addCityToFavoriteListWithData(cityName: cityName, completionHandler: handler)
        }
        navigationController?.pushViewController(vc, animated: false)
    }
}
extension FavoriteCitiesViewController: UICollectionViewDataSource,
                                        UICollectionViewDelegate,
                                        UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        cityDataList.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //  swiftlint:disable all
        let cell = collectionView.dequeueReusableCell(
                                withReuseIdentifier:WeatherDailyCollectionViewCell.reuseIdentifier,
                                for: indexPath) as! WeatherDailyCollectionViewCell
        //  swiftlint:enable all
        let cityData = cityDataList[indexPath.section]
        if let forecastList = cityData.cityDetail?.forecastDetail {
            if forecastList.count != 0 {
                let forecastToday = forecastList[0]
                cell.labelMaxTemp.text = "\(Int(forecastToday.maxTempC))"
                cell.labelMinTemp.text = "\(Int(forecastToday.minTempC))"
                let astro = forecastToday.astronomyModel
                if astro.timeFormate == .twelveHour {
                    let strSunRise = ConversionUtility.convertTimeToTwelveHourFormate(hour: astro.sunRiseHour,
                                                                                      min: astro.sunRiseMin)
                    cell.labelSunRiseTime.text = strSunRise
                } else {
                    cell.labelSunRiseTime.text = String(format: "%02d:%02d", astro.sunRiseHour, astro.sunRiseMin)
                }
                let tempDate = ConversionUtility.convertDateToStr(formate: "E, d MMM yyyy",
                                                                  date: forecastToday.date)
                cell.labelToday.text = "\(tempDate)"
                if let hourList = forecastToday.hourDetailList {
                    let hour = Constants.getCurrentHourTime()
                    let hourDetail = hourList[hour]
                    cell.labelWeatherCondition.text = hourDetail.conditionText
                    let imageName = hourDetail.iconName
                    cell.imgWeatherCondition.image = WeatherIconUtility.getIcon(imageName: imageName)
                    let currentHour = Constants.getCurrentHourTime()
                    if currentHour <= hourList.count {
                        cell.labelRainChance.text = "\(hourList[currentHour].rainChances)" + "%"
                        cell.labelWindSpeed.text = String(format: "%0.2f \(hourList[currentHour].speedUnit)",
                                                          hourList[currentHour].windSpeedMPH)
                    }
                    cell.labelCityName.text = cityData.cityName + ", " + cityData.countryName
                }
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width -
                    collectionView.contentInset.left -
                    collectionView.contentInset.right  -
                    collectionView.safeAreaInsets.left - 20
        let height: CGFloat = 207  // Fallback value
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.section
        //  swiftlint:disable all
        let vc  = storyboard?.instantiateViewController(identifier: HomeViewController.identifier) as! HomeViewController
        vc.viewControllerMode = .individualCityDetailMode
        let cityName = cityDataList[index].cityName
        let cityDetail = ControllerRepository.getCityForecastData(cityName: cityName)
        vc.todayWeatherDetail = cityDetail
        vc.title = "City Detail"
        navigationController?.pushViewController(vc, animated: false)
        //  swiftlint:enable all
    }
}
