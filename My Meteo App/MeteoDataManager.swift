//
//  MeteoDataManager.swift
//  My Meteo App
//
//  Created by Aurélien Fontaine on 16/06/2016.
//  Copyright © 2016 Diavo Lab. All rights reserved.
//

import UIKit
import Alamofire

private let _sharedInstance = MeteoDataManager()

///Singleton helper class handling API calls, saving them to user defaults and providing data to view controllers
class MeteoDataManager: NSObject {
    class var shared: MeteoDataManager {
        return _sharedInstance
    }
    
    override init() {
        super.init()
        
        print("Initialized the MeteoDataManager singleton.")
    }
    
    func updateData() {
        Alamofire.request(.GET, "http://www.infoclimat.fr/public-api/gfs/json?_ll=48.85341,2.3488&_auth=CRNUQwV7AyFVeFFmVSNXfgRsUGVaLAMkBXkKaQtuBHkAawBhB2cDZVE%2FUC0PIAUzVHkHZAw3BzcAawN7AXMAYQljVDgFbgNkVTpRNFV6V3wEKlAxWnoDJAVuCmULeARmAGUAZwd6A2BROVA1DyEFMFRhB2IMLAcgAGIDYAFqAGUJalQ3BWMDZ1UzUTRVeld8BDJQN1pjAzkFbgo8C2UEZgAwAGIHbQM3UWhQNQ8hBThUbwdgDDoHPABlA2EBaAB8CXVUSQUVA3xVelFxVTBXJQQqUGVaOwNv&_c=c6776eedf1c97db9ac6082ada467bb6a", parameters: nil, encoding: .JSON, headers: nil)
            .validate()
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(response.result.error)")
                    return
                }
                
                print(response.result.value)
        }
    }
}
