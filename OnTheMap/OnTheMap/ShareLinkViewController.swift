//
//  ShareLinkViewController.swift
//  OnTheMap
//
//  Created by Jonathan Grubb on 5/15/16.
//  Copyright © 2016 Jonathan Grubb. All rights reserved.
//

import UIKit
import MapKit

class ShareLinkViewController: UIViewControllerWithTextViewDefaultText, MKMapViewDelegate {
    
    var studentInfo : StudentInformation?
    
    @IBOutlet weak var shareLink: UITextView!
    @IBOutlet weak var studentMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaultLocationText = "Enter Your Location Here"

        // make sure we have the studentInfo
        if let info = studentInfo {
            
            // convert it to the format the map needs
            ParseClient.sharedInstance().mkPointAnnotation([info]) { (success, mapData) in
                performUIUpdatesOnMain {
                    if !success {
                        ControllerCommon.displayErrorDialog(self, message: "Error Formatting The Location For The Map")
                    } else {
                        let oldAnnotations = self.studentMapView.annotations
                        // add the new annotations
                        self.studentMapView.addAnnotations(mapData!)
                        // remove the old annotations
                        self.studentMapView.removeAnnotations(oldAnnotations)
                        
                        print("latitude: \(self.studentInfo!.latitude)")
                        print("longitude: \(self.studentInfo!.longitude)")
                        
                        // zoom in on the pin
                        let center = CLLocationCoordinate2D(latitude: self.studentInfo!.latitude, longitude: self.studentInfo!.longitude)
                        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                        let region = MKCoordinateRegion(center: center, span: span)
                        self.studentMapView.setRegion(region, animated: true)
                    }
                }
            }
            
        } else {
            // somehow we lost the student info
            ControllerCommon.displayErrorDialog(self, message: "Cannot Display Location")
        }
    }

    
    @IBAction func submitPressed(sender: AnyObject) {
    }
}
