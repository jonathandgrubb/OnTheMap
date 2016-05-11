//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Jonathan Grubb on 5/8/16.
//  Copyright © 2016 Jonathan Grubb. All rights reserved.
//

extension ParseClient {
    
    struct Constants {
        static let AppId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RestApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    enum Errors {
        case NetworkError
        case RequiredContentMissing
        case DataConversionError
    }
    
    struct Methods {
        static let StudentLocation = "/StudentLocation"
        //static let UsersID = "/users/{id}"
    }
    
    struct URLKeys {
        //static let UserID = "id"
    }
    
    struct ParameterKeys {
        static let NumRecords = "limit"
        static let SkipRecords = "skip"
        static let OrderRecords = "order"
    }
    
    struct ParameterValues {
        static let OrderRecordsDescending = "-updatedAt"
    }

    struct HeaderKeys {
        static let AppId = "X-Parse-Application-Id"
        static let RestApiKey = "X-Parse-REST-API-Key"
    }
}
