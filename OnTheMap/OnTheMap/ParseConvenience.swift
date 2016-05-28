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
    
    func getStudentLocations(numRecords: Int = 100, skip: Int = 0, ascending: Bool = false, completionHandlerForLocations: (success: Bool, error: ParseClient.Errors?) -> Void) {
        
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
                completionHandlerForLocations(success: false, error: ParseClient.Errors.NetworkError)
            } else {
                print(result)
                // get the students' locations
                if let results = result["results"] as? [[String:AnyObject]] {
                    // convert it to the format the map needs
                    StudentsInformation.sharedInstance().studentLocations = StudentInformation.studentsFromResults(results)
                    completionHandlerForLocations(success: true, error: nil)
                } else {
                    print("Could not find results in \(result)")
                    completionHandlerForLocations(success: false, error: ParseClient.Errors.RequiredContentMissing)
                }
            }
        }

    }
    
    func studentLocationPresent(useLocalData: Bool = true, completionHandlerForLocation: (isPresent: Bool?, error: ParseClient.Errors?) -> Void) {
        
        guard let currentStudent = StudentsInformation.sharedInstance().currentStudent else {
            // we haven't yet saved the user from login
            completionHandlerForLocation(isPresent: nil, error: ParseClient.Errors.RequiredContentMissing)
            return
        }
        
        if useLocalData {

            // use the local 100 results we already have stored
            
            guard let locations = StudentsInformation.sharedInstance().studentLocations else {
                // not yet populated with student locations info
                completionHandlerForLocation(isPresent: nil, error: ParseClient.Errors.RequiredContentMissing)
                return
            }
            
            for location in locations {
                if location.userId == currentStudent.userId {
                    // found this student in the local data
                    completionHandlerForLocation(isPresent: true, error: nil)
                    return
                }
            }
            
            // did not find this student in the local data
            completionHandlerForLocation(isPresent: false, error: nil)

        } else {
            
            // reach out via the API to query for this individual
            
            // specify params (if any)
            let parameters : [String:AnyObject] = [
                ParameterKeys.Where : "{\"uniqueKey\":\"\(currentStudent.userId)\"}"
            ]
            
            taskForGETMethod(Methods.StudentLocation, parameters: parameters) { (result, error) in
                // 3. Send the desired value(s) to completion handler */
                if let error = error {
                    print(error)
                    completionHandlerForLocation(isPresent: false, error: ParseClient.Errors.NetworkError)
                } else {
                    print(result)
                    if let results = result["results"] as? [[String:AnyObject]],
                       let record  = results[0] as [String:AnyObject]?,
                       let objectId = record["objectId"] as? String
                       where StudentsInformation.sharedInstance().currentStudent != nil {
                        // found an entry for this student in the Parse stored data
                        StudentsInformation.sharedInstance().currentStudent!.objectId = objectId
                        print("objectId: \(objectId)")
                        completionHandlerForLocation(isPresent: true, error: nil)
                    } else {
                        // did not find an entry for this student in the Parse stored data
                        print("Could not find objectId in \(result)")
                        completionHandlerForLocation(isPresent: false, error: ParseClient.Errors.RequiredContentMissing)
                    }
                }
            }
            

        }
        
    }
    
    func addStudentLocation(completionHandlerForAdd: (success: Bool, error: ParseClient.Errors?) -> Void) -> Void {
        
        // specify params (if any)
        let parameters = [String:AnyObject]()
        
        guard let currentStudent = StudentsInformation.sharedInstance().currentStudent,
            let mapString = currentStudent.mapString,
            let latitude = currentStudent.latitude,
            let longitude = currentStudent.longitude else {
                completionHandlerForAdd(success: false, error: ParseClient.Errors.InputError)
                return
        }
        
        // not required for an add, but we need to be able to unwrap it
        let url = currentStudent.url ?? ""
        
        // build the json body with the username and password
        let body = "{\"uniqueKey\": \"\(currentStudent.userId)\", \"firstName\": \"\(currentStudent.firstName)\", \"lastName\": \"\(currentStudent.lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(url)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}"
        
        taskForPOSTMethod(Methods.StudentLocation, parameters: parameters, jsonBody: body) { (result, error) in
            // 3. Send the desired value(s) to completion handler
            if let error = error {
                print(error)
                // assume a network problem
                completionHandlerForAdd(success: false, error: ParseClient.Errors.NetworkError)
            } else {
                print(result)
                if result["createdAt"] == nil || result["objectId"] == nil {
                    // the record was not added
                    completionHandlerForAdd(success: false, error: ParseClient.Errors.RecordNotAdded)
                } else {
                    // the record was added
                    completionHandlerForAdd(success: true, error: nil)
                }
            }
        }
    }
    
    func updateStudentLocation(completionHandlerForUpdate: (success: Bool, error: ParseClient.Errors?) -> Void) -> Void {
        
        // specify params (if any)
        let parameters = [String:AnyObject]()
        
        guard let currentStudent = StudentsInformation.sharedInstance().currentStudent,
              let objectId = currentStudent.objectId,
              let mapString = currentStudent.mapString,
              let latitude = currentStudent.latitude,
              let longitude = currentStudent.longitude else {
            completionHandlerForUpdate(success: false, error: ParseClient.Errors.InputError)
            return
        }
        
        // not required for an update, but we need to be able to unwrap it
        let url = currentStudent.url ?? ""
        
        // build the json body with the username and password
        let body = "{\"uniqueKey\": \"\(currentStudent.userId)\", \"firstName\": \"\(currentStudent.firstName)\", \"lastName\": \"\(currentStudent.lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(url)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}"
        
        // build the method
        var mutableMethod: String = Methods.StudentLocationID
        mutableMethod = ClientCommon.subtituteKeyInMethod(mutableMethod, key: URLKeys.UserID, value: objectId)!
        
        taskForPUTMethod(mutableMethod, parameters: parameters, jsonBody: body) { (result, error) in
            // 3. Send the desired value(s) to completion handler
            if let error = error {
                print(error)
                // assume a network problem
                completionHandlerForUpdate(success: false, error: ParseClient.Errors.NetworkError)
            } else {
                print(result)
                if result["updatedAt"] == nil {
                    // the record was not added
                    completionHandlerForUpdate(success: false, error: ParseClient.Errors.RecordNotUpdated)
                } else {
                    // the record was added
                    completionHandlerForUpdate(success: true, error: nil)
                }
            }
        }
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
        
            if let latitude = dictionary.latitude,
               let longitude = dictionary.longitude {
                
                // Notice that the float values are being used to create CLLocationDegree values.
                // This is a version of the Double type.
                let lat = CLLocationDegrees(latitude)
                let long = CLLocationDegrees(longitude)
                
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
        }
        
        completionHandlerForConversion(success: true, mapData: annotations)
    }

}