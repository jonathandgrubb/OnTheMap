//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Jonathan Grubb on 4/13/16.
//  Copyright © 2016 Jonathan Grubb. All rights reserved.
//

import Foundation

extension UdacityClient {

    func getSessionInfo(username: String, password: String, completionHandlerForSession: (success: Bool, sessionID: String?, userID: String?, error: UdacityClient.Errors?) -> Void) {
        
        // specify params (if any)
        let parameters = [String:AnyObject]()
        
        // build the json body with the username and password
        let body = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        
        taskForPOSTMethod(Methods.Session, parameters: parameters, jsonBody: body) { (result, error) in
            // 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                if error.code == 403 {
                    completionHandlerForSession(success: false, sessionID: nil, userID: nil, error: UdacityClient.Errors.LoginFailed)
                } else {
                    completionHandlerForSession(success: false, sessionID: nil, userID: nil, error: UdacityClient.Errors.NetworkError)
                }
            } else {
                // get the session id
                if let session = result["session"] as? [String:AnyObject],
                       sessionId = session["id"] as? String,
                       account = result["account"] as? [String:AnyObject],
                       userId = account["key"] as? String {
                    completionHandlerForSession(success: true, sessionID: sessionId, userID: userId, error: nil)
                } else {
                    print("Could not find something we needed in the response \(result)")
                    completionHandlerForSession(success: false, sessionID: nil, userID: nil, error: UdacityClient.Errors.RequiredContentMissing)
                }
            }
        }

    }
    
    func getUsersName(userID: String, completionHandlerForNames: (success: Bool, firstName: String?, lastName: String?, error: UdacityClient.Errors?) -> Void) {
        
        // specify params (if any)
        let parameters = [String:AnyObject]()
        
        // build the method
        var mutableMethod: String = Methods.UsersID
        mutableMethod = Common.subtituteKeyInMethod(mutableMethod, key: URLKeys.UserID, value: userID)!
        
        taskForGETMethod(mutableMethod, parameters: parameters) { (result, error) in
            // 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForNames(success: false, firstName: nil, lastName: nil, error: UdacityClient.Errors.NetworkError)
            } else {
                print(result)
                // get the session id
                if let user = result["user"] as? [String:AnyObject],
                    firstName = user["first_name"] as? String,
                    lastName = user["last_name"] as? String {
                    completionHandlerForNames(success: true, firstName: firstName, lastName: lastName, error: nil)
                } else {
                    print("Could not find names in \(result)")
                    completionHandlerForNames(success: false, firstName: nil, lastName: nil, error: UdacityClient.Errors.RequiredContentMissing)
                }
            }
        }
    }

}