//
//  DownloadProgress.swift
//  NetworkingSwift
//
//  Created by Mauro Olivo on 22/06/16.
//  Copyright © 2016 Mauro Olivo. All rights reserved.
//

import UIKit

class DownloadProgress: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Download Progress"
        
        self.progressView.progress = 0.0
        print(C._AppSupDir)
        
        NetworkService.sharedInstance.getURL(C._UrlToCdcJson, completion: manageNetworkData)
        
        NetworkService.sharedInstance.getURL(C._UrlToCdcJson) { (obj, error) in
            NSLog("1")
        }
        
        NSLog("3")
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func manageNetworkData (obj:AnyObject?, error:ErrorType?) -> Void {
        NSLog("2")
    }
    
    @IBAction func startDownload(sender: UIButton) {
        var bigDownloadTask: NSURLSessionDownloadTask?
        bigDownloadTask = NetworkService.sharedInstance.getBigFile(C._UrlToBigFile,
                                                                   dowloadProgressBlock: { [weak self] (progress) in
                                                                    if(progress > 0 && progress < 1) {
                                                                        self?.progressView.progress = progress
                                                                        self?.progressLabel.text = String(format: "%.1f", progress*100)+"%"
                                                                        self?.progressView.hidden = false
                                                                    } else {
                                                                        self?.progressView.hidden = true
                                                                    }
            }, completion: { [weak self] (file, error) in
                guard error == nil else {
                    print("error downloading file")
                    return
                }
                self?.progressLabel.text = String(format: "%.1f", 100.0)+"%"
            })
        bigDownloadTask?.resume()
        
    }
}
