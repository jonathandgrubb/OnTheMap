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
            UdacityClient.sharedInstance().getSessionID(uname, password: pw) { (success, sessionID, errorString) in
                performUIUpdatesOnMain {
                    if (!success) {
                        print(errorString)
                        self.displayErrorDialog("Invalid Email or Password")
                    } else {
                        // transition to the MapNavigationController
                        self.completeLogin()
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
    
    private func completeLogin() {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("MapNavigationController") as! UINavigationController
        presentViewController(controller, animated: true, completion: nil)
    }

    private func displayErrorDialog(message: String) {
        let emptyAlert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        emptyAlert.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
        presentViewController(emptyAlert, animated: true, completion: nil)
    }
}

