//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Jonathan Grubb on 4/11/16.
//  Copyright © 2016 Jonathan Grubb. All rights reserved.
//

import UIKit

class LoginViewController: CustomUIViewController {

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var userName: UITextField!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginPressed(sender: AnyObject) {
        if let uname = userName.text, pw = password.text {
            activityIndicator.startAnimating()
            // try to get the session id from udacity
            UdacityClient.sharedInstance().getSessionInfo(uname, password: pw) { (success, sessionID, userID, error) in
                    if (!success) {
                        performUIUpdatesOnMain {
                            self.activityIndicator.stopAnimating()
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
                                self.activityIndicator.stopAnimating()
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
    
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
    }
    
    private func completeLogin(userId: String, firstName: String, lastName: String) {
        // save the stuff we need for the Parse API calls
        if var studentsInfo = StudentsInformation.sharedInstance().currentStudent {
            studentsInfo.userId = userId
            studentsInfo.firstName = firstName
            studentsInfo.lastName = lastName
        } else {
            StudentsInformation.sharedInstance().currentStudent = StudentInformation(firstName: firstName, lastName: lastName, userId: userId)
        }
        
        // present the tab bar controller
        let controller = storyboard!.instantiateViewControllerWithIdentifier("MapNavigationController") as! UINavigationController
        presentViewController(controller, animated: true, completion: nil)
    }

}

