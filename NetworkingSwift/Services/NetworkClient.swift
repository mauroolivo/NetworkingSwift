//
//  NetworkClient.swift
//  NetworkingSwift
//
//  Created by Mauro Olivo on 19/06/16.
//  Copyright © 2016 Mauro Olivo. All rights reserved.
//

import UIKit

enum NetworkClientError: ErrorType {
    case ImageData
}

typealias NetworkResult = (AnyObject?, ErrorType?) -> Void
typealias ImageResult = (UIImage?, ErrorType?) -> Void
typealias ProgressBlock = (Float) -> Void

class NetworkClient: NSObject {
    private var urlSession: NSURLSession!
    private var backgroundSession: NSURLSession!
    private var completionHandlers = [NSURL: ImageResult]()
    private var progressHandlers = [NSURL: ProgressBlock]()
    
    static let sharedInstance = NetworkClient()
    
    override init() {
        
        super.init()
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        urlSession = NSURLSession(configuration: configuration)
        
        let backgroundConfiguration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(
            "com.razeware.flickrfeed")
        backgroundSession = NSURLSession(configuration: backgroundConfiguration, delegate: self, delegateQueue: nil)
    }
    
    
    
    
    // MARK: service methods
    
    func getURL(url: NSURL, completion: NetworkResult) {
        let request = NSURLRequest(URL: url)
        let task = urlSession.dataTaskWithRequest(request) { [unowned self] (data, response, error) in
            guard let data = data else {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    completion(nil, error)
                }
                return
            }
            self.parseJSON(data, completion: completion)
        }
        task.resume()
    }
    
    func getImage(url: NSURL, completion: ImageResult) -> NSURLSessionDownloadTask {
        
        let request = NSURLRequest(URL: url)
        let task = urlSession.downloadTaskWithRequest(request) {
            (fileUrl, response,error) in
            guard let fileUrl = fileUrl else {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    completion(nil, error)
                }
                return
            }
            if let data = NSData(contentsOfURL: fileUrl), image = UIImage(data: data) {
                print(fileUrl)
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    completion(image, nil)
                }
            } else {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    completion(nil, NetworkClientError.ImageData)
                }
            }
        }
        task.resume()
        return task
    }
    
    func getImageInBackground(url: NSURL, dowloadProgressBlock: ProgressBlock?, completion: ImageResult?) -> NSURLSessionDownloadTask {
        completionHandlers[url] = completion
        progressHandlers[url] = dowloadProgressBlock
        let request = NSURLRequest(URL: url)
        let task = backgroundSession.downloadTaskWithRequest(request)
        task.resume()
        return task
    }
    
    // MARK: helper methods
    
    private func parseJSON(data: NSData, completion: NetworkResult) {
        do {
            let fixedData = fixedJSONData(data)
            let parseResults = try NSJSONSerialization.JSONObjectWithData(fixedData, options: [])
            if let dictionary = parseResults as? NSDictionary {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    completion(dictionary, nil)
                }
            } else if let array = parseResults as? [NSDictionary] {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    completion(array, nil)
                }
            }
        } catch let parseError {
            NSOperationQueue.mainQueue().addOperationWithBlock {
                completion(nil, parseError)
            }
        }
    }
    
    private func fixedJSONData(data: NSData) -> NSData {
        guard let jsonString = String(data: data, encoding: NSUTF8StringEncoding) else { return data }
        let fixedString = jsonString.stringByReplacingOccurrencesOfString("\\'", withString: "'")
        if let fixedData = fixedString.dataUsingEncoding(NSUTF8StringEncoding) {
            return fixedData
        } else {
            return data
        }
    }
    
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?)
    {
        // 1
        if let error = error, url = task.originalRequest?.URL, completion = completionHandlers[url] {
            // 2
            completionHandlers[url] = nil
            completeProgressForURL(url)
            // 3
            NSOperationQueue.mainQueue().addOperationWithBlock {
                completion(nil, error)
            }
        }
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if let url = downloadTask.originalRequest?.URL, progress = progressHandlers[url] {
            let percentDone = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            NSOperationQueue.mainQueue().addOperationWithBlock {
                progress(percentDone)
            }
        }
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        // You must move the file or open it for reading before
        // this closure returns or it will be deleted
        // 1
        if let data = NSData(contentsOfURL: location),
            image = UIImage(data: data),
            request = downloadTask.originalRequest,
            response = downloadTask.response {
            // 2
            let cachedResponse = NSCachedURLResponse(response: response, data: data)
            self.urlSession.configuration.URLCache?.storeCachedResponse(cachedResponse, forRequest: request)
            // 3
            if let url = downloadTask.originalRequest?.URL, completion = completionHandlers[url] {
                completionHandlers[url] = nil
                completeProgressForURL(url)
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    completion(image, nil)
                }
            }
        } else {
            // 4
            if let url = downloadTask.originalRequest?.URL, completion = completionHandlers[url] {
                completionHandlers[url] = nil
                completeProgressForURL(url)
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    completion(nil, NetworkClientError.ImageData)
                }
            }
        }
    }
    
    //METODO CHIAMATO SOLO SE METTO L'APP IN BACKGROUND
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
        print("URLSessionDidFinishEventsForBackgroundURLSession")
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate, completionHandler = appDelegate.backgroundSessionCompletionHandler {
            appDelegate.backgroundSessionCompletionHandler = nil
            completionHandler()
        }
    }
    
    private func completeProgressForURL(url: NSURL) {
        if let progress = progressHandlers[url] {
            progressHandlers[url] = nil
            NSOperationQueue.mainQueue().addOperationWithBlock({ 
                progress(1)
            })
        }
    }
    
}

extension NetworkClient: NSURLSessionDelegate, NSURLSessionDownloadDelegate { }
