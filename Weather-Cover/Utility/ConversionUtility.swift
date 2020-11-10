//
//  ConversionUtility.swift
//  Weather-Cover
//
//  Created by Ahsan Khalil🤕 on 02/11/2020.
//

import Foundation
class ConversionUtility {
    enum SpeedUnits: String {
        case kilometersPerHour = "KPH"
        case milesPerHour = "MPH"
    }
    enum TemperatureUnits: String {
        case celsius = "Celsius (C)"
        case fahrenheit = "Fahrenheit (f)"
        case kelvin = "Kelvin (K)"
    }
    enum TimeFormate: String {
        case twelveHour = "12 Hour"
        case twentyFourHour = "24 Hour"
    }
    enum PressureUnits: String {
        case inchesOfMercury = "IN"
        case milibar = "MB"
        case hectoPascal = "hPA"
        case kiloPascal = "kPA"
    }
    static public func convertDateToStr(formate: String, date: Date) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = formate
        let resultString = inputFormatter.string(from: date)
        return resultString
    }
    static public func convertDateStrToOtherStr
                (providedFormate: String, requiredFormate: String, date: String) -> String {
        let inputFormater = DateFormatter()
        inputFormater.dateFormat = providedFormate
        let providedDate = inputFormater.date(from: date)
        inputFormater.dateFormat = requiredFormate
        let requiredDateStr = inputFormater.string(from: providedDate!)
        return requiredDateStr
    }
    static public func convertStrToDate(providedFormate: String, dateStr: String) -> Date? {
        let inputFormater = DateFormatter()
        inputFormater.dateFormat = providedFormate
        let date = inputFormater.date(from: dateStr)
        return date
    }
    /// strTimeFormate = 06:24 AM
    static public func convertStrTimeToHourAndMin(strTime: String) -> [Int32] {
        // 06:12 am
        let handler: (Character) throws -> Bool = { (character) in
            if character == ":" || character == " " {
                return true
            }
            return false
        }
        do {
            let arr = try strTime.split(whereSeparator: handler)
            if arr.count == 3 {
                var hour = Int32(arr[0])!, min = Int32(arr[1])!
                if arr[2] == "PM" {
                    if hour != 12 {
                        hour += 12
                    }
                }
                if arr[2] == "AM" {
                    if hour == 12 {
                        hour = 0
                    }
                }
                return [hour, min]
            }
        } catch {
            return [0, 0]
        }
        return [0, 0]
    }
    static public func convertTimeToTwelveHourFormate(hour: Int32, min: Int32) -> String {
        var str = ""
        let minStr = String(format: "%02d", min)
        if hour == 0 {
            str = "12:\(minStr) AM"
        } else if hour > 0 && hour < 12 {
            str = "\(hour):\(minStr) AM"
        } else if hour == 12 {
            str = "12:\(minStr) PM"
        } else if hour > 12 && hour <= 23 {
            str = "\(hour - 12):\(minStr) PM"
        }
        return str
    }
    static public func convertCelsiusToFahrenheit(temperatureC: Double) -> Double {
        var temp = Measurement(value: temperatureC, unit: UnitTemperature.celsius)
        temp.convert(to: .fahrenheit)
        return temp.value
    }
    static public func convertCelsiusToKelvin(temperatureC: Double) -> Double {
        var temp = Measurement(value: temperatureC, unit: UnitTemperature.celsius)
        temp.convert(to: .kelvin)
        return temp.value
    }
    static public func convertMPHtoKPH(mpHSpeed: Double) -> Double {
        var temp = Measurement(value: mpHSpeed, unit: UnitSpeed.milesPerHour)
        temp.convert(to: .kilometersPerHour)
        return temp.value
    }
    static public func convertPressueINtoMB(pressurIN: Double) -> Double {
        var temp = Measurement(value: pressurIN, unit: UnitPressure.inchesOfMercury)
        temp.convert(to: .millibars)
        return temp.value
    }
    static public func convertPressueINtoHPA(pressurIN: Double) -> Double {
        var temp = Measurement(value: pressurIN, unit: UnitPressure.inchesOfMercury)
        temp.convert(to: .hectopascals)
        return temp.value
    }
    static public func convertPressueINtoKPA(pressurIN: Double) -> Double {
        var temp = Measurement(value: pressurIN, unit: UnitPressure.inchesOfMercury)
        temp.convert(to: .kilopascals)
        return temp.value
    }
}
