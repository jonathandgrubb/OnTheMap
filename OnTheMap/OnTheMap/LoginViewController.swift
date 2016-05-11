//
//  ViewController.swift
//  OnTheMap
//
//  Created by Jonathan Grubb on 4/11/16.
//  Copyright © 2016 Jonathan Grubb. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var userName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginPressed(sender: AnyObject) {
        if let uname = userName.text, pw = password.text {
            // try to get the session id from udacity
            UdacityClient.sharedInstance().getSessionInfo(uname, password: pw) { (success, sessionID, userID, error) in
                    if (!success) {
                        performUIUpdatesOnMain {
                            if (error == UdacityClient.Errors.LoginFailed) {
                                ControllerCommon.displayErrorDialog(self, message: "Invalid Email or Password")
                            } else {
                                ControllerCommon.displayErrorDialog(self, message: "Failed Network Connection")
                            }
                        }
                    } else {
                        // get the nickname for this user that logged in
                        UdacityClient.sharedInstance().getUsersName(userID!) { (success, firstName, lastName, error) in
                            performUIUpdatesOnMain {
                                if (success) {
                                    // transition to the MapNavigationController
                                    self.completeLogin(userID!, firstName: firstName!, lastName: lastName!)
                                } else {
                                    // Public User Info Either Not Found - Udacity's API must be having an issue
                                    ControllerCommon.displayErrorDialog(self, message: "Failed Network Connection")
                                }
                            }
                        }
                    }
            }
        } else {
            // open a dialog saying "Empty Email or Password"
            ControllerCommon.displayErrorDialog(self, message: "Empty Email or Password")
        }
    }

    @IBAction func facebookButtonPressed(sender: AnyObject) {
        ControllerCommon.displayErrorDialog(self, message: "Feature Not Available At This Time")
    }
    
    private func completeLogin(userId: String, firstName: String, lastName: String) {
        // save the stuff we need for the Parse API calls
        ParseClient.sharedInstance().userId = userId
        ParseClient.sharedInstance().firstName = firstName
        ParseClient.sharedInstance().lastName = lastName
        
        // present the tab bar controller
        let controller = storyboard!.instantiateViewControllerWithIdentifier("MapNavigationController") as! UINavigationController
        presentViewController(controller, animated: true, completion: nil)
    }

}

