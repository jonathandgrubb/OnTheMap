//
//  WhereStudyingViewController.swift
//  OnTheMap
//
//  Created by Jonathan Grubb on 5/15/16.
//  Copyright © 2016 Jonathan Grubb. All rights reserved.
//

import UIKit
import CoreLocation

class WhereStudyingViewController: UIViewController {

    var latitude : Double?
    var longitude : Double?
    
    let defaultLocationText = "Enter Your Location Here"
    
    @IBOutlet weak var yourLocationTextView: UITextView!
    
    @IBAction func findOnTheMapButtonPressed(sender: AnyObject) {
        if let text = yourLocationTextView.text where text != defaultLocationText {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(text) { (placemark, error) in
                
                if let placemark = placemark as [CLPlacemark]?,
                   let location = placemark[0].location
                   where placemark.count > 0 && error == nil {
                    
                    // successfully geocoded
                    self.latitude = location.coordinate.latitude
                    self.longitude = location.coordinate.longitude
                    
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
    
    // dimiss the keyboard when the user taps the background
    // http://www.globalnerdy.com/2015/05/18/how-to-dismiss-the-ios-keyboard-when-the-user-taps-the-background-in-swift/
    @IBAction func userTappedBackground(sender: AnyObject) {
        view.endEditing(true)
    }
    
    // prepare the segue by giving the latitude and longitude to the next controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShareLinkSegue" {
            if let shareLinkVC = segue.destinationViewController as? ShareLinkViewController
               where latitude != nil && longitude != nil {
                shareLinkVC.latitude = latitude
                shareLinkVC.longitude = longitude
            }
        }
    }
    
}

// delegate functions for yourLocationTextView UITextView (around keeping default text and dismissing keyboard)
// http://stackoverflow.com/questions/18607599/textviewdidendediting-is-not-called
extension WhereStudyingViewController : UITextViewDelegate {
    
    // if the text is still "Enter Your Location Here", clear it
    func textViewDidBeginEditing(textView: UITextView) {
        print("editing location")
        if textView.text == defaultLocationText {
            textView.text = ""
        }
    }
    
    // we're done editing if the user pressed enter
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        print("text changed")
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    // if there's a question of whether we should end editing, the answer is yes
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        print("should end editing")
        return true
    }
    
    // if the text is clear, restore "Enter Your Location Here"
    func textViewDidEndEditing(textView: UITextView) {
        print("done editing location")
        if textView.text == "" {
            textView.text = defaultLocationText
        }
    }
}
