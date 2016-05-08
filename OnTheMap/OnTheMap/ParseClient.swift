//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Jonathan Grubb on 5/2/16.
//  Copyright © 2016 Jonathan Grubb. All rights reserved.
//

import Foundation

class ParseClient : NSObject {

    // shared session
    var session = NSURLSession.sharedSession()

    // GET
    func taskForGETMethod(method: String, parameters: [String:AnyObject], completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        // 1. Set the parameters
        // no additional to set right now...
        
        // 2/3. Build the URL, Configure the request
        let request = NSMutableURLRequest(URL: parseURLFromParameters(parameters, withPathExtension: method))
        request.HTTPMethod = "GET"
        request.addValue(Constants.AppId, forHTTPHeaderField: HeaderKeys.AppId)
        request.addValue(Constants.RestApiKey, forHTTPHeaderField: HeaderKeys.RestApiKey)
        
        // 4. Make the request
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(result: nil, error: NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            // GUARD: Was there an error?
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            // GUARD: Did we get a successful 2XX response?
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            // GUARD: Was there any data returned?
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // 5/6. Parse the data and use the data (happens in completion handler)
            Common.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        // 7. Start the request
        task.resume()
        
        return task
    }

    // create a URL from parameters
    private func parseURLFromParameters(parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = "https"
        components.host = "api.parse.com"
        components.path = "/1/classes" + (withPathExtension ?? "")
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
}