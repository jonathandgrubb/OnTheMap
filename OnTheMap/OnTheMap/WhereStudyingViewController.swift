//
//  WhereStudyingViewController.swift
//  OnTheMap
//
//  Created by Jonathan Grubb on 5/15/16.
//  Copyright © 2016 Jonathan Grubb. All rights reserved.
//

import UIKit

class WhereStudyingViewController: UIViewController {

    @IBOutlet weak var yourLocationTextView: UITextView!
    
    @IBAction func findOnTheMapButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
