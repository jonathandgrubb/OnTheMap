//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Jonathan Grubb on 5/2/16.
//  Copyright © 2016 Jonathan Grubb. All rights reserved.
//

import Foundation
import MapKit

extension ParseClient {
    
    func getStudentLocations(numRecords: Int = 100, skip: Int = 0, ascending: Bool = true, completionHandlerForLocations: (success: Bool, studentLocations: [StudentInformation]?, error: ParseClient.Errors?) -> Void) {
        
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
                    // convert it to the format the map needs
                    self.studentLocations = StudentInformation.studentsFromResults(results)
                    completionHandlerForLocations(success: true, studentLocations: self.studentLocations, error: nil)
                } else {
                    print("Could not find results in \(result)")
                    completionHandlerForLocations(success: false, studentLocations: nil, error: ParseClient.Errors.RequiredContentMissing)
                }
            }
        }

    }
    
    func studentLocationPresent(useLocalData: Bool = true, completionHandlerForLocation: (isPresent: Bool?, error: ParseClient.Errors?) -> Void) {
        
        guard useLocalData == false else {
            // not implemented
            completionHandlerForLocation(isPresent: nil, error: ParseClient.Errors.NotImplemented)
            return
        }
        
        guard let userID = self.userId else {
            // we haven't yet saved the userId from login
            completionHandlerForLocation(isPresent: nil, error: ParseClient.Errors.RequiredContentMissing)
            return
        }
        
        guard let locations = self.studentLocations else {
            // not yet populated with student locations info
            completionHandlerForLocation(isPresent: nil, error: ParseClient.Errors.RequiredContentMissing)
            return
        }
        
        for location in locations {
            if location.userId == userID {
                completionHandlerForLocation(isPresent: true, error: nil)
                return
            }
        }
        
        completionHandlerForLocation(isPresent: false, error: nil)
    }
    
    func addStudentLocation() {
        
    }
    
    func updateStudentLocation() {
        
    }
    
    func mkPointAnnotation(fromStudentLocations: [StudentInformation]?, completionHandlerForConversion: (success: Bool, mapData: [MKPointAnnotation]?) -> Void) -> Void {
    
        guard let studentLocations = fromStudentLocations else {
            completionHandlerForConversion(success: false, mapData: nil)
            return
        }
    
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
        
        // The "locations" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.
        
        for dictionary in studentLocations {
        
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(dictionary.latitude)
            let long = CLLocationDegrees(dictionary.longitude)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(dictionary.firstName) \(dictionary.lastName)"
            
            if let url = dictionary.url {
                annotation.subtitle = url
            }
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        completionHandlerForConversion(success: true, mapData: annotations)
    }

}