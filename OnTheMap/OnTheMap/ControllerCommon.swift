//
//  ControllerCommon.swift
//  OnTheMap
//
//  Created by Jonathan Grubb on 5/10/16.
//  Copyright © 2016 Jonathan Grubb. All rights reserved.
//

import UIKit

public class ControllerCommon {

    public static func displayErrorDialog(controller: UIViewController, message: String) {
        let emptyAlert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        emptyAlert.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
        controller.presentViewController(emptyAlert, animated: true, completion: nil)
    }

    public static func displayConfirmCancelDialog(controller: UIViewController, message: String, confirmButtonText: String = "Confirm", confirmHandler: (alert: UIAlertAction) -> Void ) {
        let emptyAlert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        emptyAlert.addAction(UIAlertAction(title: confirmButtonText, style: .Default, handler: confirmHandler))
        emptyAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        controller.presentViewController(emptyAlert, animated: true, completion: nil)
    }
}

protocol Refreshable {
    func dataRefreshed() -> Void
}