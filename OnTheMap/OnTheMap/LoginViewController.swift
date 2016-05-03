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
            UdacityClient.sharedInstance().getSessionInfo(uname, password: pw) { (success, sessionID, userID, errorString) in
                    if (!success) {
                        performUIUpdatesOnMain {
                            print(errorString)
                            self.displayErrorDialog("Invalid Email or Password")
                        }
                    } else {
                        // get the nickname for this user that logged in
                        UdacityClient.sharedInstance().getUserNickname(userID!) { (success, nickname, errorString) in
                            performUIUpdatesOnMain {
                                if (!success) {
                                    // transition to the MapNavigationController
                                    self.completeLogin(userID!, nickname: nickname!)
                                } else {
                                    // open a dialog saying "Public User Info Not Found"
                                    self.displayErrorDialog("Public User Info Not Found")
                                }
                            }
                        }
                    }
            }
        } else {
            // open a dialog saying "Empty Email or Password"
            displayErrorDialog("Empty Email or Password")
        }
    }

    @IBAction func facebookButtonPressed(sender: AnyObject) {
    }
    
    private func completeLogin(userId: String, nickname: String) {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("MapNavigationController") as! UINavigationController
        presentViewController(controller, animated: true, completion: nil)
    }

    private func displayErrorDialog(message: String) {
        let emptyAlert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        emptyAlert.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
        presentViewController(emptyAlert, animated: true, completion: nil)
    }
}

