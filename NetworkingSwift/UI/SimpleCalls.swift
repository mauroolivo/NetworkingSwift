//
//  SimpleCalls.swift
//  NetworkingSwift
//
//  Created by Mauro Olivo on 21/06/16.
//  Copyright © 2016 Mauro Olivo. All rights reserved.
//

import UIKit

class SimpleCalls: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
/*
        //1. Simplest Call
        let session1 = NSURLSession.sharedSession()
        let url1     = NSURL(string: "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1")!
        
        let task1 = session1.dataTaskWithURL(url1, completionHandler: someHandler)
        task1.resume()
*/
/*
        //2. Simple Call anonymous handler
        let session2 = NSURLSession.sharedSession()
        let url2     = NSURL(string: "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1")!
        
        let task2 = session2.dataTaskWithURL(url2) { (data, response, error) in
            guard let data = data else { return }
            let result = NSString(data: data, encoding: NSUTF8StringEncoding)
            print(result)
        }
        task2.resume()
*/
        //3. Using NSURLSessionConfiguration
/*
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.allowsCellularAccess = false
        
        configuration.URLCache?.diskCapacity
        configuration.URLCache?.memoryCapacity
        
        let smallCache = NSURLCache(memoryCapacity: 512000,
                                    diskCapacity: 2000000, diskPath: nil)
        
        configuration.URLCache = smallCache
        configuration.URLCache?.diskCapacity
        configuration.URLCache?.memoryCapacity
        
        let session = NSURLSession(configuration: configuration)
        
        let url = NSURL(string:"https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1")!
        
        let task = session.dataTaskWithURL(url){ (data,response,error) in
            guard let data = data else { print(error); return }
    
            let result = NSString(data: data, encoding:  NSUTF8StringEncoding)
            
            print(result)
        }
        task.resume()
*/
        //4. Some configurations
/*
        let urlString = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"
        let url = NSURL(string: urlString)
        
        url?.absoluteString
        url?.scheme
        url?.host
        url?.path
        url?.query
        url?.baseURL
        
        let baseURL = NSURL(string: "https://api.flickr.com")
        //url?.baseURL = baseURL
        let relativeURL = NSURL(string: "services/feeds/photos_public.gne", relativeToURL: baseURL)
        relativeURL?.absoluteString
        relativeURL?.scheme
        relativeURL?.host
        relativeURL?.path
        relativeURL?.query
        relativeURL?.baseURL
        //relativeURL?.query = "format=json&nojsoncallback=1"
        
        //NSURL is read only
        
        let components = NSURLComponents(URL: relativeURL!, resolvingAgainstBaseURL: true)
        components?.string
        components?.URL
        components?.scheme
        components?.host
        components?.path
        components?.query = "format=json"
        components?.URL
        components?.queryItems?.append(NSURLQueryItem(name: "nojsoncallback", value: "1"))
        components?.URL
        
        
        // NSURLRequest & NSMutableURLRequest
        
        let request = NSMutableURLRequest.init(URL: components!.URL!)
        request.allowsCellularAccess = false
        request.HTTPMethod = "POST"
        print(request.allHTTPHeaderFields)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        print(request.allHTTPHeaderFields)
        request.addValue("application/json", forHTTPHeaderField: "Content/Type")
        print(request.allHTTPHeaderFields)
*/
        //5.
//        let session = NSURLSession.sharedSession()
/*
        //----- DATA TASK -----
        let urlString = "https://www.example.com"
        let url = NSURL(string: urlString)!
        
        let dataTask = session.dataTaskWithURL(url) { (data, response, error) in
            //defer {
            //    XCPlaygroundPage.currentPage.finishExecution()
            //}
            response
            error
            guard let data = data else { return }
            
            let result = NSString(data: data, encoding: NSUTF8StringEncoding)
            print(result)
        }
        dataTask.resume()

        //----- UPLOAD TASK -----
        let loginKisString = "http://urltologin.com"
        let loginKisUrl = NSURL(string: loginKisString)
        
        let request = NSMutableURLRequest.init(URL: loginKisUrl!)
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let componenets = NSURLComponents()
        componenets.query = "email=x@gmail.pro&password=kis"
        let body = componenets.percentEncodedQuery!
        let uploadTask = session.uploadTaskWithRequest(request, fromData: body.dataUsingEncoding(NSUTF8StringEncoding)!) {
            data, response, error in
            //defer {
            //    XCPlaygroundPage.currentPage.finishExecution()
            //}
            response
            error
            guard let data = data else { return }
            
            let result = NSString(data: data, encoding: NSUTF8StringEncoding)
            print(result)
        }
        uploadTask.resume()
*/
        // ----- DOWNLOAD TASK -----
/*
        let moString = "http://urltoimage.com/image.png"
        let moUrl = NSURL(string: moString)
        let downloadTask = session.downloadTaskWithURL(moUrl!) { (fileUrl, response, error) in
            response
            error
            guard let fileUrl = fileUrl else { return }
            
            fileUrl
            let result = try? NSString(contentsOfURL: fileUrl, encoding: NSUTF8StringEncoding)
            print(fileUrl)
            print(result)
            
            let fileManager = NSFileManager.defaultManager()
            let documents = try! fileManager.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
            let fileURL = documents.URLByAppendingPathComponent("test.png")
            do {
                try fileManager.moveItemAtURL(fileUrl, toURL: fileURL)
            } catch {
                print(error)
            }
        }
        downloadTask.resume()
*/
        //6. Status and Error
/*
        let urlString = "https://www.example.com"
        let url = NSURL(string: urlString)!
        let task = session.dataTaskWithURL(url){ (data,response,error) in
            if error != nil {
                // Used for client-side errors
                // ad esempio no network found
            }
            
            // Used for server-side errors
            (response as? NSHTTPURLResponse)?.statusCode
            // ad esempio 404, o authentication error
            // in eusto caso l'error sopra è nil
        }
        task.resume()
 */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func someHandler(data:NSData?, response:NSURLResponse?, error:NSError?) -> Void {
        guard let data = data else { return }
        let result = NSString(data: data, encoding: NSUTF8StringEncoding)
        print(result)
    }

}
