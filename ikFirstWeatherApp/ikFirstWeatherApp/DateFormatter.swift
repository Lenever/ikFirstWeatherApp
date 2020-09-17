//
//  DateFormatter.swift
//  ikFirstWeatherApp
//
//  Created by Mac on 15/09/2020.
//  Copyright © 2020 Ikechukwu. All rights reserved.
//

import Foundation

func dateFormatter (_ dateString: String) -> String {
    let dateFormatterGet = DateFormatter()
    dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.dateFormat = "EEEE"

    if let date = dateFormatterGet.date(from: dateString) {
        return dateFormatterPrint.string(from: date)
    } else {
       print("There was an error decoding the string")
    }
    
    return ""
}
