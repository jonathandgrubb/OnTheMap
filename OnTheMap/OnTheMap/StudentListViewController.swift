//
//  StudentListViewController.swift
//  OnTheMap
//
//  Created by Jonathan Grubb on 4/28/16.
//  Copyright © 2016 Jonathan Grubb. All rights reserved.
//

import UIKit

class StudentListViewController: UIViewController {

    @IBOutlet weak var studentsTableView: UITableView!
    
    override func viewDidLoad() {
        
        // refresh student locations if for some reason they are not available
        if ParseClient.sharedInstance().studentLocations == nil {
            ParseClient.sharedInstance().getStudentLocations() { (success, studentLocations, error) in
                performUIUpdatesOnMain {
                    if (!success) {
                        ControllerCommon.displayErrorDialog(self, message: "Could Not Retrieve Classmate Locations")
                        return
                    }
                }
            }
        }
        
        // configure tap recognizer
        //let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        //tapRecognizer.numberOfTapsRequired = 1
        //tapRecognizer.delegate = self
        //view.addGestureRecognizer(tapRecognizer)
    }
}

extension StudentListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let CellReuseId = "StudentSearchCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(CellReuseId)
        if cell == nil {
            // create a cell if there is not one to dequeue
            cell = UITableViewCell(style:UITableViewCellStyle.Subtitle, reuseIdentifier:CellReuseId)
        }
        
        if let studentLocations = ParseClient.sharedInstance().studentLocations,
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
        if let studentLocations = ParseClient.sharedInstance().studentLocations {
            return studentLocations.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let app = UIApplication.sharedApplication()
        
        if let studentLocations = ParseClient.sharedInstance().studentLocations,
           let studentLocation = studentLocations[indexPath.row] as StudentInformation?,
           let url = studentLocation.url {
            app.openURL(NSURL(string: url)!)
        }

    }
}
