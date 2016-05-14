//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Jonathan Grubb on 5/14/16.
//  Copyright © 2016 Jonathan Grubb. All rights reserved.
//

import Foundation

struct StudentInformation {
    
    // MARK: Properties
    
    let firstName: String
    let lastName: String
    let url: String?
    let userId: String?
    let latitude: Double
    let longitude: Double
    
    // MARK: Initializers
    
    // construct a StudentInformation from a dictionary
    init(dictionary: [String:AnyObject]) {
        firstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as! String
        lastName  = dictionary[ParseClient.JSONResponseKeys.LastName]  as! String
        url       = dictionary[ParseClient.JSONResponseKeys.MediaUrl]  as? String
        userId    = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as? String
        latitude  = dictionary[ParseClient.JSONResponseKeys.Latitude]  as! Double
        longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as! Double
    }
    
    static func studentsFromResults(results: [[String:AnyObject]]) -> [StudentInformation] {
        
        var studentInformation = [StudentInformation]()
        
        // iterate through array of dictionaries, each Movie is a dictionary
        for result in results {
            studentInformation.append(StudentInformation(dictionary: result))
        }
        
        return studentInformation
    }
}
