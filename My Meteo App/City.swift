//
//  City.swift
//  My Meteo App
//
//  Created by Aurélien Fontaine on 17/06/2016.
//  Copyright © 2016 Diavo Lab. All rights reserved.
//

import UIKit

struct City {
    let name: String
    let latitude: String
    let longitude: String
    
    init(name: String, latitude: String, longitude: String) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init?(dico: NSDictionary) {
        if let name = dico["name"] as? String, let lat = dico["latitude"] as? String, let lon = dico["longitude"] as? String {
            self.name = name
            self.latitude = lat
            self.longitude = lon
        } else {
            return nil
        }
    }
    
    func toNSDictionary() -> NSDictionary {
        return NSDictionary(dictionary: ["name" : name, "latitude" : latitude, "longitude" : longitude])
    }
}
