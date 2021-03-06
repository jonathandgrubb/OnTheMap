//
//  StudentListViewController.swift
//  OnTheMap
//
//  Created by Jonathan Grubb on 4/28/16.
//  Copyright © 2016 Jonathan Grubb. All rights reserved.
//

import UIKit

class StudentListViewController: CustomUIViewController, UITableViewDelegate, UITableViewDataSource, Refreshable {

    @IBOutlet weak var studentsTableView: UITableView!
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let CellReuseId = "StudentSearchCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(CellReuseId)
        if cell == nil {
            // create a cell if there is not one to dequeue
            cell = UITableViewCell(style:UITableViewCellStyle.Subtitle, reuseIdentifier:CellReuseId)
        }
        
        if let studentLocations = StudentsInformation.sharedInstance().studentLocations,
           let studentLocation = studentLocations[indexPath.row] as StudentInformation? {
            
            // populate cell with student location information
            cell!.textLabel!.text = "\(studentLocation.firstName) \(studentLocation.lastName)"
            cell!.imageView?.image = UIImage(named: "pin")
            
            // popluate interesting url posted by student (if present)
            if let url = studentLocation.url {
                cell!.detailTextLabel!.text = url
            }
        } else {
            cell!.textLabel!.text = "Error loading cell"
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let studentLocations = StudentsInformation.sharedInstance().studentLocations {
            return studentLocations.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let app = UIApplication.sharedApplication()
        
        if let studentLocations = StudentsInformation.sharedInstance().studentLocations,
           let studentLocation = studentLocations[indexPath.row] as StudentInformation?,
           let url = studentLocation.url,
           let validUrl = NSURL(string: url)
           where app.canOpenURL(validUrl) == true {
            app.openURL(validUrl)
        } else {
            ControllerCommon.displayErrorDialog(self, message: "Invalid Link")
        }

    }
    
    func dataWillRefresh() {
        performUIUpdatesOnMain {
            self.activityIndicator.startAnimating()
        }
    }
    
    // This method is to be called every time we need to redraw because student data was refreshed
    func dataIsRefreshed() {
        performUIUpdatesOnMain {
            if let tableView = self.studentsTableView {
                tableView.reloadData()
            }
            self.activityIndicator.stopAnimating()
        }
    }
    
}
