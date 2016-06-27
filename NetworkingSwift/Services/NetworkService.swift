//
//  NetworkService.swift
//  NetworkingSwift
//
//  Created by Mauro Olivo on 22/06/16.
//  Copyright © 2016 Mauro Olivo. All rights reserved.
//

import UIKit

enum NetworkServiceError: ErrorType {
    case UnableToDownload
    case UnableToSave
}

//typealias NetworkServiceResult = (AnyObject?, ErrorType?) -> Void
typealias NetworkServiceProgressBlock = (Float) -> Void

class NetworkService: NSObject {
    
    private var urlSession: NSURLSession!
    private var backgroundSession: NSURLSession!
    
    private var progressHandler: ( (Float) -> Void )?
    private var completionHandler: ( (AnyObject?, ErrorType?) -> Void )?
    
    static let sharedInstance = NetworkService()
    
    override init() {
        
        super.init()

        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        urlSession = NSURLSession(configuration: configuration)
        
        let backgroundConfiguration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(
            "urlSessionBackgroundConfig")
        backgroundSession = NSURLSession(configuration: backgroundConfiguration, delegate: self, delegateQueue: nil)
    }
    
    func getURL(url: NSURL, completion: (AnyObject?, ErrorType?) -> Void) {
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
    
    private func parseJSON(data: NSData, completion: (AnyObject?, ErrorType?) -> Void) {
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
        let error = error,  completion = completionHandler
        
        completeProgress()
        NSOperationQueue.mainQueue().addOperationWithBlock {
            completion!(nil, error)
        }
        
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let progress = progressHandler
        let percentDone = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        
        NSOperationQueue.mainQueue().addOperationWithBlock {
            progress!(percentDone)
        }
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        // You must move the file or open it for reading before
        // this closure returns or it will be deleted

        
        
        if let data = NSData(contentsOfURL: location),
            //request = downloadTask.originalRequest,
            response = downloadTask.response {
            var s = C._DocDir.path!
            s = s+"/"+response.suggestedFilename!
            
            print(s)
            let destinationUrl = NSURL(fileURLWithPath: s)

            print(C._AppSupDir.path!)
            print(response.suggestedFilename!)
            
            print(destinationUrl)
            
            if NSFileManager().fileExistsAtPath(destinationUrl.path!) {
                print("The file already exists at path")
            } else {
                
                if data.writeToURL(destinationUrl, atomically: true)  {
                    print("file saved")
                } else {
                    print("error saving file")
                    let completion = completionHandler
                    completeProgress()
                    NSOperationQueue.mainQueue().addOperationWithBlock {
                        completion!(nil, NetworkServiceError.UnableToSave)
                    }
                }
            }

            let completion = completionHandler
            completeProgress()
            NSOperationQueue.mainQueue().addOperationWithBlock {
                completion!(data, nil)
            }
        } else {
            let completion = completionHandler
                completeProgress()
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    completion!(nil, NetworkServiceError.UnableToDownload)
                }
        }
    }
    
    
    func getBigFile(url: NSURL, dowloadProgressBlock: (Float) -> Void, completion: (AnyObject?, ErrorType?) -> Void) -> NSURLSessionDownloadTask {
        
        progressHandler = dowloadProgressBlock
        completionHandler = completion
        
        let request = NSURLRequest(URL: url)
        let task = backgroundSession.downloadTaskWithRequest(request)
        task.resume()
        return task
    }
 
    private func completeProgress() {
        let progress = progressHandler
 
        print("complete Progress Called")
        NSOperationQueue.mainQueue().addOperationWithBlock({
            progress!(1)
        })
 
    }
}

extension NetworkService: NSURLSessionDelegate, NSURLSessionDownloadDelegate { }

