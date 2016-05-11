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
    
    func getStudentLocations(numRecords: Int = 100, skip: Int = 0, ascending: Bool = true, completionHandlerForLocations: (success: Bool, studentLocations: [MKPointAnnotation]?, error: ParseClient.Errors?) -> Void) {
        
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
                    self.mkPointAnnotation(results) { (success, mapData) in
                        if success == true {
                            completionHandlerForLocations(success: true, studentLocations: mapData, error: nil)
                        } else {
                            completionHandlerForLocations(success: false, studentLocations: mapData, error: ParseClient.Errors.DataConversionError)
                        }
                    }
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
    
    private func mkPointAnnotation(fromStudentLocations: [[String:AnyObject]]?, completionHandlerForConversion: (success: Bool, mapData: [MKPointAnnotation]?) -> Void) -> Void {
    
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
            let lat = CLLocationDegrees(dictionary["latitude"] as! Double)
            let long = CLLocationDegrees(dictionary["longitude"] as! Double)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = dictionary["firstName"] as! String
            let last = dictionary["lastName"] as! String
            let mediaURL = dictionary["mediaURL"] as! String
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        completionHandlerForConversion(success: true, mapData: annotations)
    }

}