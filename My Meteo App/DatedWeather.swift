//
//  DatedWeather.swift
//  My Meteo App
//
//  Created by Aurélien Fontaine on 16/06/2016.
//  Copyright © 2016 Diavo Lab. All rights reserved.
//

import UIKit

///Structure with both weather data and associated date.
struct DatedWeather {
    let date: NSDate
    let weather: WeatherData
    
    init?(date: NSDate?, weatherData: WeatherData?) {
        guard let dateLet = date
            else { return nil }
        
        guard let weather = weatherData
            else { return nil }
        
        self.date = dateLet
        self.weather = weather
    }
    
    init?(dico: NSDictionary) {
        guard let temperature = dico["temperature"] as? Double
            else { return nil }
        
        guard let windAverage = dico["windAverage"] as? Double
            else { return nil }
        
        guard let windMax = dico["windMax"] as? Double
            else { return nil }
        
        guard let rain = dico["rain"] as? Double
            else { return nil }
        
        guard let humidity = dico["humidity"] as? Double
            else { return nil }
        
        guard let date = dico["date"] as? NSDate
            else { return nil }
        
        self.date = date
        self.weather = WeatherData(temperature: temperature, windAverage: windAverage, windMax: windMax, rain: rain, humidity: humidity)
        
    }
    
    func toNSDictionary() -> NSDictionary {
        return NSDictionary(dictionary: ["date" : self.date,
            "temperature" : self.weather.temperature,
            "windAverage" : self.weather.windAverage,
            "windMax" : self.weather.windMax,
            "rain" : self.weather.rain,
            "humidity" : self.weather.humidity])
    }
    
    func formattedDate() -> String {
        return MeteoDataManager.shared.dateFormatter.stringFromDate(self.date)
    }
}

