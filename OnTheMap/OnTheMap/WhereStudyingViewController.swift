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

    //var studentInfo : StudentInformation?
    
    @IBOutlet weak var yourLocationTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the default text for our UITextView
        defaultLocationText = "Enter Your Location Here"
    }
    
    @IBAction func findOnTheMapButtonPressed(sender: AnyObject) {
        if let text = yourLocationTextView.text where text != defaultLocationText {
            activityIndicator.startAnimating()
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(text) { (placemark, error) in
                
                if let placemark = placemark as [CLPlacemark]?,
                   let location = placemark[0].location
                   where placemark.count > 0 && error == nil {
                    
                    // do we still have the student info?
                    if StudentsInformation.sharedInstance().currentStudent != nil {
                        
                        // yes. prepare the info for sending to the next step
                        StudentsInformation.sharedInstance().currentStudent!.mapString = text
                        StudentsInformation.sharedInstance().currentStudent!.latitude = location.coordinate.latitude
                        StudentsInformation.sharedInstance().currentStudent!.longitude = location.coordinate.longitude
                        
                    } else {
                        performUIUpdatesOnMain{
                            self.activityIndicator.stopAnimating()
                            ControllerCommon.displayErrorDialog(self, message: "Error. Cannot Post Location")
                            return
                        }
                    }
                    
                    // present the ShareLinkViewController
                    performUIUpdatesOnMain {
                        self.activityIndicator.stopAnimating()
                        self.performSegueWithIdentifier("ShareLinkSegue", sender: nil)
                    }
                    
                } else {
                    // Couldn't geocode this location
                    performUIUpdatesOnMain {
                        self.activityIndicator.stopAnimating()
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

}
