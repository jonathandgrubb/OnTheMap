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
    
    //var studentInfo : StudentInformation?
    
    @IBOutlet weak var shareLink: UITextView!
    @IBOutlet weak var studentMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide the back button
        self.navigationItem.hidesBackButton = true
        
        // set the default text for our UITextView
        defaultLocationText = "Enter a Link to Share Here"
        
        // allow clicking the map to dismiss the keyboard too
        // http://stackoverflow.com/questions/1275731/iphone-detecting-tap-in-mkmapview
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        studentMapView.addGestureRecognizer(singleTap)

        // make sure we have the studentInfo
        if let info = StudentsInformation.sharedInstance().currentStudent {
            
            // convert it to the format the map needs
            ParseClient.sharedInstance().mkPointAnnotation([info]) { (success, mapData) in
                performUIUpdatesOnMain {
                    if !success {
                    
                        ControllerCommon.displayErrorDialog(self, message: "Error Formatting The Location For The Map")
                    
                    } else {
                        
                        let oldAnnotations = self.studentMapView.annotations
                        // add the new annotation
                        self.studentMapView.addAnnotations(mapData!)
                        // remove the old annotation
                        self.studentMapView.removeAnnotations(oldAnnotations)
                        
                        print("latitude: \(info.latitude)")
                        print("longitude: \(info.longitude)")
                        
                        // zoom in on the pin
                        if let latitude = info.latitude, let longitude = info.longitude {
                            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                            let region = MKCoordinateRegion(center: center, span: span)
                            self.studentMapView.setRegion(region, animated: true)
                        }
                    }
                }
            }
            
        } else {
            // somehow we lost the student info
            ControllerCommon.displayErrorDialog(self, message: "Cannot Display Location")
        }
    }

    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func submitPressed(sender: AnyObject) {
        
        // make sure we have the studentInfo
        if StudentsInformation.sharedInstance().currentStudent != nil {
        
            // make sure the Link isn't the default text
            if let link = shareLink.text where link != defaultLocationText {
            
                // add the link to the student info
                StudentsInformation.sharedInstance().currentStudent!.url = link
                
                activityIndicator.startAnimating()
                
                // are we adding new or updating existing?
                // write the new location data
                if StudentsInformation.sharedInstance().currentStudent!.objectId == nil {
                    
                    // new record
                    print("adding a new student record")
                    
                    ParseClient.sharedInstance().addStudentLocation() { (success, error) in
                        
                        performUIUpdatesOnMain {
                            self.activityIndicator.stopAnimating()
                            
                            if !success {
                                if let error = error where error == ParseClient.Errors.NetworkError {
                                    ControllerCommon.displayErrorDialog(self, message: "Network Error. Submit Again Later.")
                                } else {
                                    ControllerCommon.displayErrorDialog(self, message: "Could Not Add Location Info")
                                }
                                return
                            }
                            // dismiss this view controller
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                    }
                } else {
                    
                    // update exiting record
                    print("modifying an existing student record")
                    
                    ParseClient.sharedInstance().updateStudentLocation() { (success, error) in
                        
                        performUIUpdatesOnMain {
                            self.activityIndicator.stopAnimating()
                            
                            if !success {
                                if let error = error where error == ParseClient.Errors.NetworkError {
                                    ControllerCommon.displayErrorDialog(self, message: "Network Error. Submit Again Later.")
                                } else {
                                    ControllerCommon.displayErrorDialog(self, message: "Could Not Update Location Info")
                                }
                                return
                            }
                            // dismiss this view controller
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                    }
                }
            
            } else {
                ControllerCommon.displayErrorDialog(self, message: "Must Enter a Link.")
            }
        } else {
            // somehow we lost the student info
            ControllerCommon.displayErrorDialog(self, message: "Cannot Post Location Data")
        }
    }
    
    func dismissKeyboard(gestureRecognizer: UIGestureRecognizer) {
        view.endEditing(true)
    }
}
