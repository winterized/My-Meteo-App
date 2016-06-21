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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

