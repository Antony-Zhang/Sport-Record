//
//  TimeManager.swift
//  Sport Record
//
//  Created by EastOS on 2023/5/30.
//

import Foundation
import SwiftUI

class TimeManager: ObservableObject{
//    static func dateTimeInterval(time: Date) -> TimeInterval{
//        //  转String
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let dateFormat = dateFormatter.string(from: time)
//        //  转TimeInterval
//
//    }
    static func timeIntervalString(time: TimeInterval) -> String{
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    //  date转String
    static func dateString(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    static func mmdateString(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        return dateFormatter.string(from: date)
    }
    //  String转date
    static func stringDate(dateString: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)!
    }
    //  time转String
    static func timeString(time: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: time)
    }
    //  String转time
    static func stringTime(timeString: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.date(from: timeString)!
    }
}
