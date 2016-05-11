//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Jonathan Grubb on 5/2/16.
//  Copyright © 2016 Jonathan Grubb. All rights reserved.
//

import Foundation

extension ParseClient {
    
    func getStudentLocations(numRecords: Int = 100, skip: Int = 0, ascending: Bool = true, completionHandlerForLocations: (success: Bool, studentLocations: [[String:AnyObject]]?, error: ParseClient.Errors?) -> Void) {
        
        // specify params (if any)
        var parameters : [String:AnyObject] = [
            ParameterKeys.NumRecords : numRecords,
            ParameterKeys.SkipRecords : skip]
        if !ascending {
            parameters[ParameterKeys.OrderRecords] = ParameterValues.OrderRecordsDescending
        }
        
        taskForGETMethod(Methods.StudentLocation, parameters: parameters) { (result, error) in
            // 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForLocations(success: false, studentLocations: nil, error: ParseClient.Errors.NetworkError)
            } else {
                print(result)
                // get the students' locations
                if let results = result["results"] as? [[String:AnyObject]] {
                    completionHandlerForLocations(success: true, studentLocations: results, error: nil)
                } else {
                    print("Could not find results in \(result)")
                    completionHandlerForLocations(success: false, studentLocations: nil, error: ParseClient.Errors.RequiredContentMissing)
                }
            }
        }

    }
    
    func addStudentLocation() {
        
    }
    
    func updateStudentLocation() {
        
    }
}