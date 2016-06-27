//
//  Config.swift
//  NetworkingSwift
//
//  Created by Mauro Olivo on 22/06/16.
//  Copyright © 2016 Mauro Olivo. All rights reserved.
//

import Foundation

struct C {
    static let _UrlToCdcJson = NSURL(string: "http://staging.onenetlab.com/democdc/issues/issues.json")!
    static let _UrlToBigFile = NSURL(string: "http://staging.onenetlab.com/democdc/issues/file/magazine-12.pdf")!
    
    static let _AppSupDir = NSFileManager.defaultManager().URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask)[0]
    static let _DocDir = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
}