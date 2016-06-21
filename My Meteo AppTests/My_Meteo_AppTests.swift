//
//  My_Meteo_AppTests.swift
//  My Meteo AppTests
//
//  Created by Aurélien Fontaine on 16/06/2016.
//  Copyright © 2016 Diavo Lab. All rights reserved.
//

import XCTest
@testable import My_Meteo_App

class My_Meteo_AppTests: XCTestCase {
    var masterVC: MasterViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCity() {
        // Tests that a city is available in the device defaults.
        XCTAssert((NSUserDefaults.standardUserDefaults().objectForKey("city") as? NSDictionary) != nil)
    }
    
    func testNumberOfItems() {
        // Tests that we got the 64 items available via the API
        XCTAssert(MasterViewController().tableView(MasterViewController().tableView, numberOfRowsInSection: 0) == 64)
    }
    
    func testPerformanceLoadingMasterVC() {
        // Tests the performance while initializing the master view which lists all the data points.
        self.measureBlock {
            MasterViewController()
        }
    }
    
    func testPerformanceLoadingWeatherData() {
        // Tests the performance of loading all data from the device and converting it to appropriate struct.
        self.measureBlock {
            MeteoDataManager.shared.loadData()
        }
    }
    
    func testPerformanceLoadingDetailView() {
        //Tests the performance of loading a detail view controller and configuring it
        self.measureBlock { 
            let detViewController = DetailViewController()
            detViewController.detailItem = DatedWeather(date: NSDate(), weatherData: WeatherData(temperature: 18.99653, windAverage: 9.83287, windMax: 67.92837, rain: 0.87236, humidity: 76.92837))
        }
    }
    
}
