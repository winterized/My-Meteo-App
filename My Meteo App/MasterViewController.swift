//
//  MasterViewController.swift
//  My Meteo App
//
//  Created by Aurélien Fontaine on 16/06/2016.
//  Copyright © 2016 Diavo Lab. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [DatedWeather]()
    var waitView: UIView?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = MeteoDataManager.shared.city.name
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: #selector(forceUpdate))
        self.navigationItem.rightBarButtonItem = refreshButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        if MeteoDataManager.shared.weatherPredictions?.count > 0 {
            self.selectFirstItem()
        } else {
            self.justWait()
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(stopWaiting), name: "WEATHER_DATA_UPDATED", object: nil)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(refresh), name: "WEATHER_DATA_UPDATED", object: nil)
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {        
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectFirstItem() {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.tableView.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.None)
            self.performSegueWithIdentifier("showDetail", sender: nil)
        }
    }

    func refresh() {
        self.navigationItem.rightBarButtonItem?.enabled = true
        self.tableView.reloadData()
        self.selectFirstItem()
    }
    
    func forceUpdate() {
        self.navigationItem.rightBarButtonItem?.enabled = false
        MeteoDataManager.shared.updateLocationAndData()
    }
    
    func justWait() {
        waitView = UIView(frame: self.view.bounds)
        waitView!.backgroundColor = UIColor(white: 0, alpha: 0.8)
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: 300, height: 80))
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

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let predictions = MeteoDataManager.shared.weatherPredictions {
            waitView?.removeFromSuperview()
            waitView = nil
            objects = predictions
            return objects.count
        } else {
            return 0
        }
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        if objects.count > 0 {
            let object = objects[indexPath.row]
            cell.textLabel!.text = object.formattedDate()
        }
        
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }


}

