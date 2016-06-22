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
    
    // MARK: - Series of very small (and trivial!) unit tests
    func testCity() {
        // Tests that a city is available in the device defaults.
        XCTAssert((NSUserDefaults.standardUserDefaults().objectForKey("city") as? NSDictionary) != nil)
    }
    
    func testDeviceDefaults() {
        // If not first launch and backup data is present in the device, tests its conformity.
        if let dicoArray = NSUserDefaults.standardUserDefaults().objectForKey("backupData") as? [NSDictionary] {
            XCTAssert(dicoArray.count == 64)
        }
    }
    
    func testNumberOfItems() {
        // Tests that we display in the master VC the 64 items available via the API
        XCTAssert(MasterViewController().tableView(MasterViewController().tableView, numberOfRowsInSection: 0) == 64)
    }
    
    func testDatedWeatherInitializer() {
        // Tests DatedWeather initializer
        XCTAssertNotNil(DatedWeather(date: NSDate(), weatherData: WeatherData(temperature: 18.99653, windAverage: 9.83287, windMax: 67.92837, rain: 0.87236, humidity: 76.92837)))
    }
    
    func testDatedWeatherInitializerFail() {
        // Tests that the DateWeather initializer fails gracefully when provided an incomplete dictionary
        XCTAssertNil(DatedWeather(dico: NSDictionary(dictionary: ["date" : NSDate(), "temperature" : 18.99653])))
    }
    
    // MARK: - Series of very small (and trivial!) performance tests
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
    
    // MARK: - A more complex test to test our connexion with the weather API 
    func testAsynchronousConnexionToAPI() {
        let URL = NSURL(string: "http://www.infoclimat.fr/public-api/gfs/json?_ll=48.86,2.35&_auth=CRNUQwV7AyFVeFFmVSNXfgRsUGVaLAMkBXkKaQtuBHkAawBhB2cDZVE%2FUC0PIAUzVHkHZAw3BzcAawN7AXMAYQljVDgFbgNkVTpRNFV6V3wEKlAxWnoDJAVuCmULeARmAGUAZwd6A2BROVA1DyEFMFRhB2IMLAcgAGIDYAFqAGUJalQ3BWMDZ1UzUTRVeld8BDJQN1pjAzkFbgo8C2UEZgAwAGIHbQM3UWhQNQ8hBThUbwdgDDoHPABlA2EBaAB8CXVUSQUVA3xVelFxVTBXJQQqUGVaOwNv&_c=c6776eedf1c97db9ac6082ada467bb6a")!
        let expectation = expectationWithDescription("GET http://www.infoclimat.fr API")
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(URL) { data, response, error in
            XCTAssertNotNil(data, "data should not be nil")
            XCTAssertNil(error, "error should be nil")
            
            if let HTTPResponse = response as? NSHTTPURLResponse,
                responseURL = HTTPResponse.URL,
                MIMEType = HTTPResponse.MIMEType
            {
                XCTAssertEqual(responseURL.absoluteString, URL.absoluteString, "HTTP response URL should be equal to original URL")
                XCTAssertEqual(HTTPResponse.statusCode, 200, "HTTP response status code should be 200")
                XCTAssertEqual(MIMEType, "application/json", "HTTP response content type should be a JSON object")
            } else {
                XCTFail("Response was not NSHTTPURLResponse")
            }
            
            expectation.fulfill()
        }
        
        task.resume()
        
        waitForExpectationsWithTimeout(task.originalRequest!.timeoutInterval) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            task.cancel()
        }

    }
}
