//
//  Home.swift
//  NetworkingSwift
//
//  Created by Mauro Olivo on 19/06/16.
//  Copyright © 2016 Mauro Olivo. All rights reserved.
//

import UIKit

class Home: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Networking Swift"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func simpleCalls(sender: AnyObject) {
        self.navigationController?.pushViewController(SimpleCalls(nibName: "SimpleCalls", bundle: nil), animated: true)
    }

    @IBAction func flickerFeed(sender: AnyObject) {
        self.navigationController?.pushViewController(FlickrFeed(nibName: "FlickrFeed", bundle: nil), animated: true)
    }
    
    @IBAction func downloadProgress(sender: AnyObject) {
                self.navigationController?.pushViewController(DownloadProgress(nibName: "DownloadProgress", bundle: nil), animated: true)
    }
}
