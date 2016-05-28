//
//  UIViewControllerWithTextViewDefaultText.swift
//  OnTheMap
//
//  Created by Jonathan Grubb on 5/27/16.
//  Copyright © 2016 Jonathan Grubb. All rights reserved.
//

import UIKit

// delegate functions for yourLocationTextView UITextView (around keeping default text and dismissing keyboard)
// http://stackoverflow.com/questions/18607599/textviewdidendediting-is-not-called
public class UIViewControllerWithTextViewDefaultText : CustomUIViewController, UITextViewDelegate {
    
    var defaultLocationText : String?
    
    // if the text is still defaultLocationText, clear it
    public func textViewDidBeginEditing(textView: UITextView) {
        print("editing location")
        if textView.text == defaultLocationText {
            textView.text = ""
        }
    }
    
    // we're done editing if the user pressed enter
    public func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        print("text changed")
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    // if there's a question of whether we should end editing, the answer is yes
    public func textViewShouldEndEditing(textView: UITextView) -> Bool {
        print("should end editing")
        return true
    }
    
    // if the text is clear, restore defaultLocationText
    public func textViewDidEndEditing(textView: UITextView) {
        print("done editing location")
        if textView.text == "" {
            textView.text = defaultLocationText
        }
    }
    
}

