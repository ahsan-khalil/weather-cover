//
//  ViewController.swift
//  Weather-Cover
//
//  Created by Ahsan Khalil🤕 on 26/10/2020.
//

import UIKit
import CoreLocation
import MapKit

class HomeViewController: UIViewController {
    static let identifier = "HomeViewController"
    private var locationManager: CLLocationManager?
    enum CurrentMode {
        case homeMode
        case individualCityDetailMode
    }
    @IBOutlet weak var lableSummarytxt: UILabel!
    @IBOutlet weak var labelTodayCondition: UILabel!
    @IBOutlet weak var imageTodayCondition: UIImageView!
    @IBOutlet weak var viewOfSummary: UIView!
    @IBOutlet weak var collectionViewTemperature: UICollectionView!
    @IBOutlet weak var tableViewTodayTemperature: UITableView!
    @IBOutlet weak var labelTodayTemperature: UILabel!
    @IBOutlet weak var labelSensibleTemperature: UILabel!
    @IBOutlet weak var labelHumidity: UILabel!
    @IBOutlet weak var labelWindDirection: UILabel!
    @IBOutlet weak var labelPressure: UILabel!
    @IBOutlet weak var labelSunRise: UILabel!
    @IBOutlet weak var labelSunSet: UILabel!
    var currentForecastIndex = -1
    var todayWeatherDetail: FavoriteCityModel?
    var hourList = [HourForecastDetailModel]()
    var forecastList = [ForeCastDetailModel]()
    var viewControllerMode = CurrentMode.homeMode
    override func viewDidLoad() {
        super.viewDidLoad()
        setAllUICollors()
        setAllDelegation()
        collectionViewTemperature.register(WeatherDailyCollectionViewCell.nib(),
                                           forCellWithReuseIdentifier: WeatherDailyCollectionViewCell.reuseIdentifier)
        tableViewTodayTemperature.register(HourlyForecastTableViewCell.nib(),
                                           forCellReuseIdentifier: HourlyForecastTableViewCell.reuseIdentifier)
        loadData()
        setUserLocationData()
    }
    override func viewWillAppear(_ animated: Bool) {
        if viewControllerMode == .individualCityDetailMode {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }
    private func setUserLocationData() {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.delegate = self
            locationManager?.startUpdatingLocation()
        }
    }
    private func setAllDelegation() {
        collectionViewTemperature.delegate = self
        collectionViewTemperature.dataSource = self
        tableViewTodayTemperature.delegate = self
        tableViewTodayTemperature.dataSource = self
    }
    private func loadData() {
        if viewControllerMode == .homeMode {
            if ControllerRepository.isDefaultCityExists() {
                loadDataInUI()
            } else {
                // ask for location
            }
            todayWeatherDetail = ControllerRepository.getDefaultCityWeatherData()
        } else if viewControllerMode == .individualCityDetailMode {
            setTodayForecastIndex()
            // initialize Today Data
            initializeCurrentData()
            // initialize Hour Data
            initializeHourForecastData()
            // initialize Forecast List
            initializeForecastList()
            // initalize Current Hour Detail Data
            initializeCurrentHourDetail()
        }
    }
    private func loadDataInUI() {
        todayWeatherDetail = ControllerRepository.getDefaultCityWeatherData()
        setTodayForecastIndex()
        // initialize Today Data
        initializeCurrentData()
        // initialize Hour Data
        initializeHourForecastData()
        // initialize Forecast List
        initializeForecastList()
        // initalize Current Hour Detail Data
        initializeCurrentHourDetail()
    }
    private func setTodayForecastIndex() {
        if let todayDetailList = todayWeatherDetail?.cityDetail?.forecastDetail {
            //  swiftlint:disable all
            var i = 0
            let todayDate = Date()
            for todayDetail in todayDetailList {
                if Constants.isSameDay(day1: todayDate, day2: todayDetail.date) {
                    currentForecastIndex = i
                }
                i += 1
            }
            //  swiftlint:enable all
        }
    }
    private func initializeCurrentData() {
        if let currentDetail = todayWeatherDetail?.cityDetail?.currentWeatherDetail {
            labelTodayTemperature.text = "\(currentDetail.temperatureC)"
        }
        if let todayDetailList = todayWeatherDetail?.cityDetail?.forecastDetail {
            if currentForecastIndex == -1 {
                print("No data for Today")
                // Ask For Internet
            } else {
                let todayDetail = todayDetailList[currentForecastIndex]
                let sunRiseHour = todayDetail.astronomyModel.sunRiseHour
                let sunRiseMin = todayDetail.astronomyModel.sunRiseMin
                let sunSetHour = todayDetail.astronomyModel.sunSetHour
                let sunSetMin = todayDetail.astronomyModel.sunSetMin
                if todayDetail.astronomyModel.timeFormate == .twelveHour {
                    let strSunRise = ConversionUtility.convertTimeToTwelveHourFormate(hour: sunRiseHour,
                                                                                      min: sunRiseMin)
                    let strSunSet = ConversionUtility.convertTimeToTwelveHourFormate(hour: sunSetHour,
                                                                                     min: sunSetMin)
                    labelSunRise.text = strSunRise
                    labelSunSet.text = strSunSet
                } else {
                    labelSunRise.text = String(format: "%02d:%02d", sunRiseHour, sunRiseMin)
                    labelSunSet.text = String(format: "%02d:%02d", sunSetHour, sunSetMin)
                }
            }
        }
    }
    private func initializeHourForecastData() {
        if currentForecastIndex != -1 {
            let forecastList = (todayWeatherDetail?.cityDetail?.forecastDetail)!
            if let temphourList = forecastList[currentForecastIndex].hourDetailList {
                hourList = temphourList
                tableViewTodayTemperature.reloadData()
            }
        }
    }
    private func initializeForecastList() {
        if currentForecastIndex != -1 {
            forecastList.removeAll()
            let tempArr = (todayWeatherDetail?.cityDetail?.forecastDetail)!
            //  swiftlint:disable all
            for i in currentForecastIndex..<tempArr.count {
                forecastList.append(tempArr[i])
            }
            //  swiftlint:enable all
            collectionViewTemperature.reloadData()
        }
    }
    private func initializeCurrentHourDetail() {
        if currentForecastIndex != -1 {
            let hour = Constants.getCurrentHourTime()
            let hourDetail = hourList[hour]
            labelSensibleTemperature.text = String(format: "%.2f \(hourDetail.temperatureUnit)",
                                                   hourDetail.feelsLikeTempC)
            labelPressure.text = String(format: "%.2f \(hourDetail.pressureUnit)",
                                        hourDetail.pressureIN)
            labelHumidity.text = "\(hourDetail.humidity)"
            labelWindDirection.text = "\(hourDetail.windDirection)"
            labelTodayCondition.text = hourDetail.conditionText
            imageTodayCondition.image = WeatherIconUtility.getIcon(imageName: hourDetail.iconName)
        }
    }
}
//For Appearance
extension HomeViewController {
    //Here we will set All UI Element colors
    func setAllUICollors() {
        setFontColor()
        setBackgroundColor()
    }
    func setFontColor() {
        lableSummarytxt.textColor = ColorsConstant.textColor
        labelTodayCondition.textColor = ColorsConstant.textColor
        imageTodayCondition.tintColor = ColorsConstant.textColor
    }
    func setBackgroundColor() {
        view.backgroundColor = ColorsConstant.backgroundColor
        viewOfSummary.backgroundColor = ColorsConstant.Fulltransparent
        collectionViewTemperature.backgroundColor = ColorsConstant.Fulltransparent
    }
}

extension HomeViewController: UICollectionViewDelegate,
                          UICollectionViewDataSource,
                          UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        forecastList.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable force_cast
        let cell = collectionView.dequeueReusableCell(
                                withReuseIdentifier: WeatherDailyCollectionViewCell.reuseIdentifier,
                                for: indexPath) as! WeatherDailyCollectionViewCell
        // swiftlint:enable force_cast
        let forecastToday = forecastList[indexPath.section]
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
        if currentForecastIndex != -1 {
            let hour = Constants.getCurrentHourTime()
            let hourDetail = hourList[hour]
            cell.labelWeatherCondition.text = hourDetail.conditionText
            let imageName = hourDetail.iconName
            cell.imgWeatherCondition.image = WeatherIconUtility.getIcon(imageName: imageName)
        }

        let currentHour = Constants.getCurrentHourTime()
        if currentHour <= hourList.count {
            if indexPath.section == 0 {
                labelTodayTemperature.text = String(format: "%.2f \(hourList[currentHour].temperatureUnit)",
                                                    hourList[currentHour].temperatureC)
            }
            cell.labelRainChance.text = "\(hourList[currentHour].rainChances)" + "%"
            cell.labelWindSpeed.text = String(format: "%0.2f \(hourList[currentHour].speedUnit)",
                                              hourList[currentHour].windSpeedMPH)
        }
        if let todayWeather = todayWeatherDetail {
            cell.labelCityName.text = todayWeather.cityName + ", " + todayWeather.countryName
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
        let height = collectionView.frame.height -
                        collectionView.contentInset.top -
                        collectionView.contentInset.bottom -
                        collectionView.safeAreaInsets.top - 20
        return CGSize(width: width, height: height)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        hourList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: HourlyForecastTableViewCell.reuseIdentifier,
                                                 for: indexPath) as! HourlyForecastTableViewCell
        let tempDate = ConversionUtility.convertDateToStr(formate: "yyyy-MM-dd HH:mm",
                                                          date: hourList[indexPath.row].dateTime)
        cell.labelDateTime.text = "\(tempDate)"
        cell.labelRainPercentage.text = "\(hourList[indexPath.row].rainChances)"
        cell.labelTemperature.text = String(format: "%.1f \(hourList[indexPath.row].temperatureUnit)",
                                            hourList[indexPath.row].temperatureC)
        cell.labelWindSpeed.text = String(format: "%0.2f \(hourList[indexPath.row].speedUnit)",
                                          hourList[indexPath.row].windSpeedMPH)
        // swiftlint:enable force_cast
        return cell
    }
}
extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print(location.coordinate.latitude, location.coordinate.longitude)
            let geocoder = CLGeocoder()
                geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                    if error != nil {
                        print("error in reverseGeocode")
                    }
                    let placemark = placemarks! as [CLPlacemark]
                    if placemark.count>0 {
                        let placemark = placemarks![0]
                        print(placemark.locality!)
                        print(placemark.administrativeArea!)
                        print(placemark.country!)
                        print(placemark.name!)
                        print(placemark.region!)

                         let str = "\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
                        print(str)
                    }
                }
        }
    }
}
