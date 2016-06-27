//
//  FlickrFeed.swift
//  NetworkingSwift
//
//  Created by Mauro Olivo on 19/06/16.
//  Copyright © 2016 Mauro Olivo. All rights reserved.
//

import UIKit

class FlickrFeed: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var cw: UICollectionView!

    var photos: [Photo]?
    var currentMessage = "Loading photos..."
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Flicker Feed"
        
        //self.cw!.registerClass(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        self.cw!.registerNib(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCell")

        
        Photo.getAllFeedPhotos { [weak self] (photos, error) in
            guard error == nil else {
                if let error = error as? PhotoServiceError {
                    self?.currentMessage = error.rawValue
                } else if let error = error as? NSError {
                    self?.currentMessage = error.localizedDescription
                } else {
                    self?.currentMessage = "Sorry, there was an error."
                }
                self?.photos = nil
                self?.cw?.reloadData()
                return
            }
            self?.photos = photos
            self?.cw?.reloadData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        guard let photos = photos else { return 0 }
        return photos.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let photoCell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell
        photoCell.photo = photos![indexPath.item]
        
        return photoCell
        
    }

}
