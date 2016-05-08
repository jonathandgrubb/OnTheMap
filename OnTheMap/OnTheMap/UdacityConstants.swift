//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Jonathan Grubb on 5/8/16.
//  Copyright © 2016 Jonathan Grubb. All rights reserved.
//

extension UdacityClient {
    
    enum Errors {
        case NetworkError
        case LoginFailed
        case RequiredContentMissing
    }
    
    struct Methods {
        static let Session = "/session"
        static let UsersID = "/users/{id}"
    }
    
    struct URLKeys {
        static let UserID = "id"
    }
}