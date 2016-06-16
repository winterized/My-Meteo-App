//
//  MeteoDataManager.swift
//  My Meteo App
//
//  Created by Aurélien Fontaine on 16/06/2016.
//  Copyright © 2016 Diavo Lab. All rights reserved.
//

import UIKit
import Alamofire
import Gloss


private let _sharedInstance = MeteoDataManager()

///Singleton helper class handling weather API calls, saving them to user defaults and providing data to view controllers
class MeteoDataManager: NSObject {
    class var shared: MeteoDataManager {
        return _sharedInstance
    }
    
    private(set) var weatherPredictions: [DatedWeather]?
    
    override init() {
        super.init()
        
        self.loadData()
        self.updateData()
    }
    
    ///Tries to get new weather (meteo) data on the server
    func updateData() {
        Alamofire.request(.GET, "http://www.infoclimat.fr/public-api/gfs/json?_ll=48.85341,2.3488&_auth=CRNUQwV7AyFVeFFmVSNXfgRsUGVaLAMkBXkKaQtuBHkAawBhB2cDZVE%2FUC0PIAUzVHkHZAw3BzcAawN7AXMAYQljVDgFbgNkVTpRNFV6V3wEKlAxWnoDJAVuCmULeARmAGUAZwd6A2BROVA1DyEFMFRhB2IMLAcgAGIDYAFqAGUJalQ3BWMDZ1UzUTRVeld8BDJQN1pjAzkFbgo8C2UEZgAwAGIHbQM3UWhQNQ8hBThUbwdgDDoHPABlA2EBaAB8CXVUSQUVA3xVelFxVTBXJQQqUGVaOwNv&_c=c6776eedf1c97db9ac6082ada467bb6a", parameters: nil, encoding: .JSON, headers: nil)
            .validate()
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    print("Error while fetching remote data: \(response.result.error)")
                    return
                }
                
                guard let datedJSONs = self.preprocessJSON(response.result.value) where datedJSONs.count > 0 else {
                    print("Error while preprocessing remote data")
                    return
                }
                
                var predictions = [DatedWeather]()
                
                for (date, json) in datedJSONs {
                    guard let jsonObject = json as? JSON else {
                        print("Error while processing json object")
                        return
                    }
                    
                    guard let datedWeather = DatedWeather(date: date, weatherData: WeatherData(json: jsonObject)) else {
                        print("Error while creating dated weather object")
                        return
                    }
                    
                    predictions.append(datedWeather)
                }
                
                self.weatherPredictions = predictions.sort({ (elt1: DatedWeather, elt2: DatedWeather) -> Bool in
                    return elt1.date.compare(elt2.date) == NSComparisonResult.OrderedAscending
                })
                
                self.saveData()
        }
    }
    
    ///Loads previously saved data from NSUserDefaults
    func loadData() {
        if let dicoArray = NSUserDefaults.standardUserDefaults().objectForKey("backupData") as? [NSDictionary] {
            var tempPredictions = [DatedWeather]()
            for dico in dicoArray {
                if let datedWeather = DatedWeather(dico: dico) {
                    tempPredictions.append(datedWeather)
                }
            }
            if tempPredictions.count > 0 {
                self.weatherPredictions = tempPredictions
                print("Loaded \(tempPredictions.count) dated weather elements to the device.")
            }
        }
    }
    
    ///Saves current data to NSUserDefaults (without checking whether the saved data is newer, as the API never goes back)
    func saveData() {
        if let predictions = self.weatherPredictions {
            let convertedPredictions = predictions.map({ (elt: DatedWeather) -> NSDictionary in
                return elt.toNSDictionary()
            })
            NSUserDefaults.standardUserDefaults().setObject(convertedPredictions, forKey: "backupData")
            NSUserDefaults.standardUserDefaults().synchronize()
            print("Saved \(convertedPredictions.count) dated weather elements to the device.")
        }
    }
    
    // MARK: - Preprocessing JSON
    ///Get the keys from the JSON object (as they are not constant names)
    func preprocessJSON(jsonObject: AnyObject?) -> [NSDate : AnyObject]? {
        guard let json = jsonObject as? [String: AnyObject] else {
            print("Error while preprocessing remote JSON data")
            return nil
        }
        
        var datedJSONs: [NSDate : AnyObject] = [:]
        for (key, value) in json {
            let idx = key.startIndex.advancedBy(2)
            if key.substringToIndex(idx) == "20" {
                if let dateKey = self.convertDateString(key) {
                    datedJSONs[dateKey] = value
                }
            }
        }
        guard datedJSONs.count > 0 else {
            return nil
        }
        
        return datedJSONs
    }
    
    ///Simply converts strings used as keys in the JSON object to NSDate
    func convertDateString(dateString: String) -> NSDate? {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.dateFromString(dateString)
    }
}
