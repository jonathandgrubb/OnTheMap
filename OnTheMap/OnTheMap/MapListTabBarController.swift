//
//  MapListTabBarController.swift
//  OnTheMap
//
//  Created by Jonathan Grubb on 5/2/16.
//  Copyright © 2016 Jonathan Grubb. All rights reserved.
//

import UIKit

class MapListTabBarController: UITabBarController {
    
    @IBAction func refreshPressed(sender: AnyObject) {
        print("refresh")
        
        // grab most recent student data
        ParseClient.sharedInstance().getStudentLocations() { (success, studentLocations, error) in
            
            performUIUpdatesOnMain {
                if (!success) {
                    ControllerCommon.displayErrorDialog(self, message: "Could Not Retrieve Classmate Locations")
                    return
                }
            }
            
            // tell the controllers containing the Map and List to redraw
            for controller in self.childViewControllers {
                if let c = controller as? Refreshable {
                    c.dataRefreshed()
                    return
                }
            }
            
        }
    }
    
    @IBAction func pinPressed(sender: AnyObject) {
        // go to the information posting view
        print("pin")
    }
    
    @IBAction func logoutPressed(sender: AnyObject) {
        // go back to the login screen
        print("logout")
        dismissViewControllerAnimated(true, completion: nil)
    }
}
