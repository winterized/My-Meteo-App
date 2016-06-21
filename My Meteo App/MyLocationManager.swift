//
//  MyLocationManager.swift
//  My Meteo App
//
//  Created by Aurélien Fontaine on 16/06/2016.
//  Copyright © 2016 Diavo Lab. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import Gloss

private let _sharedInstance = MyLocationManager()

///Singleton helper class handling location usage and converting it into a city name
class MyLocationManager: NSObject, CLLocationManagerDelegate, UIAlertViewDelegate {
    class var shared: MyLocationManager {
        return _sharedInstance
    }
    
    private var locationManager: CLLocationManager
    private(set) var city: City?
    
    override init() {
        locationManager = CLLocationManager()
        
        super.init()
        
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.getLocationOrAuthorization()
    }
    
    func getLocationOrAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedWhenInUse, .AuthorizedAlways:
            self.locationManager.requestLocation()
        case .NotDetermined:
            //Here in real life we should present a view explaining to the user why we want to use his location
            self.locationManager.requestWhenInUseAuthorization()
        default:
            MeteoDataManager.shared.updateData()
        }
    }
    
    ///Deals with the user authorizing or not geolocation
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        self.getLocationOrAuthorization()
    }
    
    ///Updates the stored location
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let tempLocation = locations.last {
            self.retrieveCityFromLocation(tempLocation)
        }
    }
    
    ///Deals with geolocation error
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        MeteoDataManager.shared.updateData()
    }
    
    ///Finds the corresponding city to the user's location
    func retrieveCityFromLocation(location: CLLocation) {
        let latitude = String(format:"%.2f", location.coordinate.latitude)
        let longitude = String(format:"%.2f", location.coordinate.longitude)
        let urlAddress = "http://maps.googleapis.com/maps/api/geocode/json?latlng=" + latitude + "," + longitude
        Alamofire.request(.GET, urlAddress, parameters: nil, encoding: .JSON, headers: nil)
            .validate()
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    print("Error while fetching city: \(response.result.error)")
                    MeteoDataManager.shared.updateData()
                    return
                }
                
                guard let responseDico = response.result.value as? [String: AnyObject] else {
                    print("Error while preprocessing city data")
                    MeteoDataManager.shared.updateData()
                    return
                }
                
                guard let resultsArray = responseDico["results"] as? [AnyObject] where resultsArray.count > 0 else {
                    print("Unable to find the city associated with the user's location")
                    MeteoDataManager.shared.updateData()
                    return
                }
                
                guard let firstResult = resultsArray[0] as? [String:AnyObject] where firstResult.count > 0 else {
                    print("Unable to process the city associated with the user's location")
                    MeteoDataManager.shared.updateData()
                    return
                }
                
                guard let addressComponents = firstResult["address_components"] as? [AnyObject] where addressComponents.count > 0 else {
                    print("Unable to process the city components associated with the user's location")
                    MeteoDataManager.shared.updateData()
                    return
                }
                
                for component in addressComponents {
                    if let json = component as? JSON {
                        if let address = AddressComponent(json: json) where address.types.contains("locality"){
                            self.city = City(name: address.name, latitude: latitude, longitude: longitude)
                            print("User is located in \(self.city!.name)")
                            MeteoDataManager.shared.updateDataWithNewLocation()
                        }
                    }
                }
        }

    }
}
