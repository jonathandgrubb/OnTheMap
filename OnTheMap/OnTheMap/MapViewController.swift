//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Jonathan Grubb on 4/28/16.
//  Copyright © 2016 Jonathan Grubb. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: CustomUIViewController, MKMapViewDelegate, Refreshable {

    @IBOutlet weak var mapView: MKMapView!
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let url = view.annotation?.subtitle!,
               let validUrl = NSURL(string: url)
               where app.canOpenURL(validUrl) == true {
                app.openURL(validUrl)
            } else {
                ControllerCommon.displayErrorDialog(self, message: "Invalid Link")
            }
        }
    }
    
    // This method is to be called every time data is about to be refreshed
    func dataWillRefresh() {
        activityIndicator.startAnimating()
    }
    
    // This method is to be called every time we need to redraw because student data was refreshed
    func dataIsRefreshed() {
        if let studentLocations = ParseClient.sharedInstance().studentLocations {
            // convert it to the format the map needs
            ParseClient.sharedInstance().mkPointAnnotation(studentLocations) { (success, mapData) in
                performUIUpdatesOnMain {
                    if !success {
                        self.activityIndicator.stopAnimating()
                        ControllerCommon.displayErrorDialog(self, message: "Could Not Retrieve Classmate Locations")
                    } else {
                        let oldAnnotations = self.mapView.annotations
                        // add the new annotations
                        self.mapView.addAnnotations(mapData!)
                        // remove the old annotations
                        self.mapView.removeAnnotations(oldAnnotations)
                        
                        self.activityIndicator.stopAnimating()
                    }
                }
            }
        } else {
            self.activityIndicator.stopAnimating()
        }
    }

}