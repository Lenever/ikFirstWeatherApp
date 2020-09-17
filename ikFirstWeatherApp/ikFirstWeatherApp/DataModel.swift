//
//  DataModel.swift
//  ikFirstWeatherApp
//
//  Created by Mac on 14/09/2020.
//  Copyright © 2020 Ikechukwu. All rights reserved.
//

import Foundation

//  Current Weather Data Model
struct Main: Codable {
    let temp, minTemp, maxTemp: Double
    
    private enum CodingKeys : String, CodingKey {
        case temp, minTemp = "temp_min", maxTemp = "temp_max"
    }
}

struct Weather: Codable {
    let main: String
}

struct CurrentWeather: Codable {
    let weather: [Weather]
    let main: Main
}


//  Forecasted TableView Data Model
struct FiveDayWeather: Codable {
    let list: [List]
}

struct List: Codable {
    let main: MainClass
    let dateText: String
    let dayWeather: [Weather]
    
    private enum CodingKeys : String, CodingKey {
        case main, dateText = "dt_txt", dayWeather = "weather"
    }
}

struct MainClass: Codable {
    let temp: Double
}
