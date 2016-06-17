//
//  WeatherData.swift
//  My Meteo App
//
//  Created by Aurélien Fontaine on 16/06/2016.
//  Copyright © 2016 Diavo Lab. All rights reserved.
//

import UIKit
import Gloss

///Structure with all relevant weather data: temperature, wind (average and max), rain
struct WeatherData: Decodable {
    let temperature: Double
    let windAverage: Double
    let windMax: Double
    let rain: Double
    let humidity: Double
    
    init(temperature: Double, windAverage: Double, windMax: Double, rain: Double, humidity: Double) {
        self.temperature = temperature
        self.windMax = windMax
        self.windAverage = windAverage
        self.rain = rain
        self.humidity = humidity
    }
    
    // MARK: - Deserialization
    
    init?(json: JSON) {
        guard let temperatureKelvin: Double = "temperature.2m" <~~ json
            else { return nil }
        self.temperature = temperatureKelvin - 273.15
        
        guard let ventMoyen: Double = "vent_moyen.10m" <~~ json
            else { return nil }
        self.windAverage = ventMoyen
        
        guard let ventRafales: Double = "vent_rafales.10m" <~~ json
            else { return nil }
        self.windMax = ventRafales
        
        guard let pluie: Double = "pluie" <~~ json
            else { return nil }
        self.rain = pluie
        
        guard let humidite: Double = "humidite.2m" <~~ json
            else { return nil }
        self.humidity = humidite
    }
    
}

