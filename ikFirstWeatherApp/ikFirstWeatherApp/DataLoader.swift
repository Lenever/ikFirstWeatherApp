//
//  DataLoader.swift
//  ikFirstWeatherApp
//
//  Created by Mac on 14/09/2020.
//  Copyright © 2020 Ikechukwu. All rights reserved.
//

import Foundation

class DataLoader {
    let apiKey = "d65f4bf6765845088d7b98bd0fec7555"
    let lat = 4.8869
    let lon = 7.1252
    
    //  Today's weather network Closure
    func loadData(currentWeatherClosure: @escaping (CurrentWeather) -> ()) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric") else { return }
        
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, response, error) in
            
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let dataFromJson = try jsonDecoder.decode(CurrentWeather.self, from: data)
                    currentWeatherClosure(dataFromJson)
                    
                    print(data)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    //  Forcasted's weather network Closure
    func loadFiveDays(fiveDayWeatherClosure: @escaping (FiveDayWeather) -> ()) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric") else { return }
        
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, response, error) in
            
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let dataFromJson = try jsonDecoder.decode(FiveDayWeather.self, from: data)
                    fiveDayWeatherClosure(dataFromJson)
                    print(data)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}

