//
//  StudentsInformation.swift
//  OnTheMap
//
//  Created by Jonathan Grubb on 5/27/16.
//  Copyright © 2016 Jonathan Grubb. All rights reserved.
//

import Foundation

class StudentsInformation {
    
    var studentLocations: [StudentInformation]?
    var currentStudent: StudentInformation?
    
    // MARK: Shared Instance
    class func sharedInstance() -> StudentsInformation {
        struct Singleton {
            static var sharedInstance = StudentsInformation()
        }
        return Singleton.sharedInstance
    }
}