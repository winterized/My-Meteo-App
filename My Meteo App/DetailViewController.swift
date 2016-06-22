//
//  DetailViewController.swift
//  My Meteo App
//
//  Created by Aurélien Fontaine on 16/06/2016.
//  Copyright © 2016 Diavo Lab. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    var detailItem: DatedWeather? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    var waitView: UIView?

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            self.title = detail.formattedDate()
            if let label = self.detailDescriptionLabel {
                //Here we should use number formatters to display the numbers in the right locales, with the right number of decimals...
                label.text = "Température: \(Int(round(detail.weather.temperature)))°C\nPluie: \(detail.weather.rain) mm\nHumidité de l'air: \(detail.weather.humidity) %\nVent: \(detail.weather.windAverage) km/h\n(Rafales à \(detail.weather.windMax) km/h)"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
        guard MeteoDataManager.shared.weatherPredictions?.count > 0 else {
            self.justWait()
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(stopWaiting), name: "WEATHER_DATA_UPDATED", object: nil)
            return
        }
    }
    
    func justWait() {
        waitView = UIView(frame: self.view.bounds)
        waitView!.backgroundColor = UIColor(white: 0, alpha: 0.8)
        let label = UILabel(frame: CGRect(x: 10, y: 100, width: 300, height: 80))
        label.text = "Fetching data on the server for the first time..."
        label.numberOfLines = 0
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        waitView!.addSubview(label)
        let actIndic = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        actIndic.center = CGPoint(x: label.center.x, y: label.frame.origin.y + label.frame.size.height + 60)
        waitView!.addSubview(actIndic)
        actIndic.startAnimating()
        self.view.addSubview(waitView!)
    }
    
    func stopWaiting() {
        waitView?.removeFromSuperview()
        waitView = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

