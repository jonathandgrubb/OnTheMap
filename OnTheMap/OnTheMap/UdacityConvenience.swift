//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Jonathan Grubb on 4/13/16.
//  Copyright © 2016 Jonathan Grubb. All rights reserved.
//

import Foundation

extension UdacityClient {

    func getSessionID(username: String, password: String, completionHandlerForSession: (success: Bool, sessionID: String?, errorString: String?) -> Void) {
        
        // specify params (if any)
        let parameters = [String:AnyObject]()
        
        // build the json body with the username and password
        let body = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        
        taskForPOSTMethod("session", parameters: parameters, jsonBody: body) { (result, error) in
            // 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForSession(success: false, sessionID: nil, errorString: "Login Failed (Session ID).")
            } else {
                // get the session id
                if let session = result["session"] as? [String:AnyObject],
                       sessionId = session["id"] as? String {
                    completionHandlerForSession(success: true, sessionID: sessionId, errorString: nil)
                } else {
                    print("Could not find sessionId in \(result)")
                    completionHandlerForSession(success: false, sessionID: nil, errorString: "Login Failed (Session ID).")
                }
            }
        }

    }

}