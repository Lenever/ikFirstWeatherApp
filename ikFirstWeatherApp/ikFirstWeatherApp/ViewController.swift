//
//  ViewController.swift
//  ikFirstWeatherApp
//
//  Created by Mac on 13/09/2020.
//  Copyright © 2020 Ikechukwu. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let reuseIdentifier = "firstTableCell"
    
    @IBOutlet var fiveDayTableView: UITableView!
    @IBOutlet var currentTemp: UILabel!
    @IBOutlet var currentTemp1: UILabel!
    @IBOutlet var tempDesc: UILabel!
    @IBOutlet var currentMinTemp: UILabel!
    @IBOutlet var currentMaxTemp: UILabel!
    @IBOutlet var currentWeatherImage: UIImageView!
    

    //  Data Source for loading labels and views
    var todayWeatherData: CurrentWeather?
    var forecastedWeatherData: [List]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.todayDataFromUserDefault()
        self.passDataToUILabels()
        self.forecastedDataFromUserDefault()

        //  Closure for Today's Data
        DataLoader.init().loadData { (todayWeather) in
            self.todayWeatherData = todayWeather
            self.passDataToUILabels()
            
            if let encoded = try? JSONEncoder().encode(todayWeather) {
                UserDefaults.standard.set(encoded, forKey: "weatherToday")
            }
        }
        
        //  Closure for Forecasted Data
        DataLoader.init().loadFiveDays { (fiveDays) in
            self.forecastedWeatherData = fiveDays.list.filter {$0.dateText.contains(" 12:00:00")}

            if let encoded = try? JSONEncoder().encode(fiveDays) {
                UserDefaults.standard.set(encoded, forKey: "weatherData")
            }

            self.tableViewReload()
        }
    }
    
    func todayDataFromUserDefault () {
        DispatchQueue.main.async {
            if let loadData = UserDefaults.standard.data(forKey: "weatherToday"),
                let dayLog = try? JSONDecoder().decode(CurrentWeather.self, from: loadData) {
                self.todayWeatherData = dayLog
            }
        }
    }
    
    func forecastedDataFromUserDefault () {
        DispatchQueue.main.async {
            if let blogData = UserDefaults.standard.data(forKey: "weatherData"),
                let blog = try? JSONDecoder().decode(FiveDayWeather.self, from: blogData) {
                self.forecastedWeatherData = blog.list.filter {$0.dateText.contains(" 12:00:00")}
                self.tableViewReload()
            }
        }
    }
    
    func tableViewReload () {
        DispatchQueue.main.async {
            self.fiveDayTableView.reloadData()
        }
    }
    
    func passDataToUILabels() {
        let queue = DispatchQueue(label: "")
        queue.async {
            DispatchQueue.main.async {
                if let data = self.todayWeatherData {
                    self.currentTemp.text = String(Int(data.main.temp)) + "°"
                    self.currentTemp1.text = String(Int(data.main.temp)) + "°"
                    self.tempDesc.text = String(data.weather[0].main).uppercased()
                    self.currentMaxTemp.text = String(Int(data.main.maxTemp)) + "°"
                    self.currentMinTemp.text = String(Int(data.main.minTemp)) + "°"
                    
                    if self.tempDesc.text == "CLOUDS" || self.tempDesc.text == "MIST" {
                        self.currentWeatherImage.image = UIImage(named: "sea_cloudy")
                        self.view.backgroundColor = #colorLiteral(red: 0.3294117647, green: 0.4431372549, blue: 0.4784313725, alpha: 1)
                    } else if self.tempDesc.text == "RAINS" || self.tempDesc.text == "THUNDERSTORM" || self.tempDesc.text == "DRIZZLE" {
                        self.currentWeatherImage.image = UIImage(named: "sea_rainy")
                        self.view.backgroundColor = #colorLiteral(red: 0.3411764706, green: 0.3411764706, blue: 0.3647058824, alpha: 1)
                    } else {
                        self.currentWeatherImage.image = UIImage(named: "sunny_sea")
                        self.view.backgroundColor = #colorLiteral(red: 0.2747907639, green: 0.5571715236, blue: 0.8975776434, alpha: 1)
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        forecastedWeatherData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? FirstTableViewCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
        
        let indexData = forecastedWeatherData?[indexPath.row]
        cell.dayOfWeek.text = dateFormatter(indexData?.dateText ?? "")
        cell.weekDayTemp.text = String(Int(indexData?.main.temp ?? 0)) + "°"
        
        if indexData?.dayWeather[0].main.uppercased() == "CLOUDS" || indexData?.dayWeather[0].main.uppercased() == "MIST" {
            cell.weatherIcon.image = UIImage(named: "partlysunny")
        } else if indexData?.dayWeather[0].main.uppercased() == "RAIN" || indexData?.dayWeather[0].main.uppercased() == "THUNDERSTORM" {
            cell.weatherIcon.image = UIImage(named: "rain")
        } else {
            cell.weatherIcon.image = UIImage(named: "sunny")
        }

        return cell
    }
}
