//
//  MapListTabBarController.swift
//  OnTheMap
//
//  Created by Jonathan Grubb on 5/2/16.
//  Copyright © 2016 Jonathan Grubb. All rights reserved.
//

import UIKit

class MapListTabBarController: UITabBarController {
    
    override func viewWillAppear(animated: Bool) {
        refreshData()
    }
    
    @IBAction func refreshPressed(sender: AnyObject) {
        refreshData()
    }
    
    @IBAction func pinPressed(sender: AnyObject) {
        print("pin")
        
        // has this user pinned a location before?
        if let currentStudent = StudentsInformation.sharedInstance().currentStudent
           where currentStudent.objectId != nil {
            
            // yes. ask the user if they want to overwrite their previous entry
            let message = "User \"\(currentStudent.firstName) \(currentStudent.lastName)\" Has Already Posted a Student Location. Would You Like to Overwrite Their Location?"
            
            // answering "Overwrite" will take user to the information posting views
            //           "Cancel" will leave them on the current screen
            ControllerCommon.displayConfirmCancelDialog(self, message: message, confirmButtonText: "Overwrite", confirmHandler: self.presentInformationPostingView)
        
        } else {
            
            // no. simply present the information posting views
            presentInformationPostingView(nil)
        }
    
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
    
    func refreshData() {
        print("refresh")
        
        // give the Map and List controllers the opportunity to display the 'circle of patience'
        childrenDataWillRefresh()
        
        // grab most recent student data
        ParseClient.sharedInstance().getStudentLocations() { (success, error) in
            
            if (!success) {
                performUIUpdatesOnMain {
                    self.childrenDataIsRefreshed()
                    ControllerCommon.displayErrorDialog(self, message: "Could Not Retrieve Classmate Locations")
                }
                return
            } else {
                // refresh whether this particular student already has an entry
                ParseClient.sharedInstance().studentLocationPresent(false) { (isPresent, error) in
                    // successful refresh requires no action since it is saved in the model
                    self.childrenDataIsRefreshed()
                    if error != nil {
                        performUIUpdatesOnMain {
                            ControllerCommon.displayErrorDialog(self, message: "Could Not Retrieve Location For Your User From Network")
                        }
                    } else {
                        if let isPresent = isPresent {
                            print("existing entry found: \(isPresent)")
                        } else {
                            print("existing entry found: unknown")
                        }
                    }
                }
            }
        }
    
    
    }
    
    // tells child controllers that we about to refresh data over the network
    func childrenDataWillRefresh() {
        for controller in self.childViewControllers {
            if let c = controller as? Refreshable {
                c.dataWillRefresh()
            }
        }
    }
    
    // tells child controllers that we are done refreshing data over the network
    func childrenDataIsRefreshed() {
        for controller in self.childViewControllers {
            if let c = controller as? Refreshable {
                c.dataIsRefreshed()
            }
        }
    }
    
}
