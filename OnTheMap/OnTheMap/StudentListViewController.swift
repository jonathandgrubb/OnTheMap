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
            cell = UITableViewCell(style:UITableViewCellStyle.Subtitle, reuseIdentifier:CellReuseId)
        }
        
        if let studentLocations = ParseClient.sharedInstance().studentLocations,
           let student = studentLocations[indexPath.row] as? [String:AnyObject],
           let firstName = student["firstName"] as? String,
           let lastName = student["lastName"] as? String,
           let url = student["mediaURL"] as? String {
            cell!.textLabel!.text = "\(firstName) \(lastName)"
            cell!.detailTextLabel!.text = url
            cell!.imageView?.image = UIImage(named: "pin")
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
        /*
        let movie = movies[indexPath.row]
        let controller = storyboard!.instantiateViewControllerWithIdentifier("MovieDetailViewController") as! MovieDetailViewController
        controller.movie = movie
        navigationController!.pushViewController(controller, animated: true)
        */
    }
}
