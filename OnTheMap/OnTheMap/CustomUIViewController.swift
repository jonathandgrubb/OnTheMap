//
//  CustomUIViewController.swift
//  OnTheMap
//
//  Created by Jonathan Grubb on 5/27/16.
//  Copyright © 2016 Jonathan Grubb. All rights reserved.
//

import UIKit

public class CustomUIViewController : UIViewController {
    
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // programmatically adding UIActivityView:
        // http://sourcefreeze.com/uiactivityindicatorview-example-using-swift-in-ios/
        // http://stackoverflow.com/questions/7212859/how-to-set-an-uiactivityindicatorview-when-loading-a-uitableviewcell
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.center = view.center;
        self.view.addSubview(activityIndicator)
    }
    
    // dimiss the keyboard when the user taps the background
    // http://www.globalnerdy.com/2015/05/18/how-to-dismiss-the-ios-keyboard-when-the-user-taps-the-background-in-swift/
    @IBAction func userTappedBackground(sender: AnyObject) {
        view.endEditing(true)
    }
}

