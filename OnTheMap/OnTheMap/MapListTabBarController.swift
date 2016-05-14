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
        print("pin")
        
        // has this user pinned a location before?
        ParseClient.sharedInstance().studentLocationPresent(true) { (isPresent, error) in
            if let _ = error {
                ControllerCommon.displayConfirmCancelDialog(self, message: "Cannot Determine If Student Location Already Posted. Would You Like To Possibly Overwrite Their Location?", confirmButtonText: "Overwrite", confirmHandler: self.presentInformationPostingView)
            } else {
                if let _ = isPresent where isPresent == true {
                    var message : String?
                    if let fname = ParseClient.sharedInstance().firstName,
                       let lname = ParseClient.sharedInstance().lastName {
                        message = "User \"\(fname) \(lname)\" Has Already Posted a Student Location. Would You Like to Overwrite Their Location?"
                    } else {
                        message = "User Has Already Posted a Student Location. Would You Like to Overwrite Their Location?"
                    }
                    ControllerCommon.displayConfirmCancelDialog(self, message: message!, confirmButtonText: "Overwrite", confirmHandler: self.presentInformationPostingView)
                }
            }
        }
        
        // go to the information posting view
        presentInformationPostingView(nil)
    }
    
    @IBAction func logoutPressed(sender: AnyObject) {
        
        // go back to the login screen
        print("logout")
        
        UdacityClient.sharedInstance().logoutSession { (success, error) in
            // do not check for success since we are going back to the login screen either way
            performUIUpdatesOnMain {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
    }
    
    func presentInformationPostingView(alert: UIAlertAction?) {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("PinNavigationController") as! UINavigationController
        presentViewController(controller, animated: true, completion: nil)
    }
}
