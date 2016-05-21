//
//  WhereStudyingViewController.swift
//  OnTheMap
//
//  Created by Jonathan Grubb on 5/15/16.
//  Copyright © 2016 Jonathan Grubb. All rights reserved.
//

import UIKit
import CoreLocation

class WhereStudyingViewController: UIViewControllerWithTextViewDefaultText {

    var studentInfo : StudentInformation?
    
    @IBOutlet weak var yourLocationTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the default text for our UITextView
        defaultLocationText = "Enter Your Location Here"
    }
    
    @IBAction func findOnTheMapButtonPressed(sender: AnyObject) {
        if let text = yourLocationTextView.text where text != defaultLocationText {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(text) { (placemark, error) in
                
                if let placemark = placemark as [CLPlacemark]?,
                   let location = placemark[0].location
                   where placemark.count > 0 && error == nil {
                    
                    // do we still have the student info?
                    if let firstName = ParseClient.sharedInstance().firstName,
                       let lastName = ParseClient.sharedInstance().lastName,
                       let userId = ParseClient.sharedInstance().userId {
                        
                        // yes. prepare the info for sending to the next step
                        self.studentInfo = StudentInformation(firstName: firstName, lastName: lastName, mapString: text, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                        self.studentInfo!.userId = userId
                        
                    } else {
                        ControllerCommon.displayErrorDialog(self, message: "Error. Cannot Post Location")
                        return
                    }
                    
                    // present the ShareLinkViewController
                    performUIUpdatesOnMain {
                        self.performSegueWithIdentifier("ShareLinkSegue", sender: nil)
                    }
                    
                } else {
                    // Couldn't geocode this location
                    performUIUpdatesOnMain {
                        ControllerCommon.displayErrorDialog(self, message: "Could Not Geocode This Location")
                        return
                    }
                }

            }
        } else {
            // display an error
            ControllerCommon.displayErrorDialog(self, message: "Must Enter a Location")
        }
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // prepare the segue by giving the latitude and longitude to the next controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShareLinkSegue" {
            if let shareLinkVC = segue.destinationViewController as? ShareLinkViewController,
               let studentInfo = studentInfo {
                shareLinkVC.studentInfo = studentInfo
            }
        }
    }
    
}
