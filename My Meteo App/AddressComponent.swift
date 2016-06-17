//
//  AddressComponent.swift
//  My Meteo App
//
//  Created by Aurélien Fontaine on 17/06/2016.
//  Copyright © 2016 Diavo Lab. All rights reserved.
//

import UIKit
import Gloss

///Structure with all relevant weather data: temperature, wind (average and max), rain
struct AddressComponent: Decodable {
    let types: [String]
    let name: String

    
    // MARK: - Deserialization
    
    init?(json: JSON) {
        guard let types: [String] = "types" <~~ json
            else { return nil }
        self.types = types
        
        guard let name: String = "long_name" <~~ json
            else { return nil }
        self.name = name
    }
    
}
