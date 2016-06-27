//
//  PhotoCell.swift
//  NetworkingSwift
//
//  Created by Mauro Olivo on 19/06/16.
//  Copyright © 2016 Mauro Olivo. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var imageTask: NSURLSessionDownloadTask?
    
    var photo: Photo? {
        didSet {
            imageTask?.cancel()
            guard let photoUrl = photo?.photoUrl else {
                self.photoImageView.image = UIImage(named: "Downloading")
                return
            }
            /*
             imageTask = NetworkClient.sharedInstance.getImage(photoUrl) { [weak self] (image, error) in
             guard error == nil else {
             self?.photoImageView.image = UIImage(named: "Broken")
             return
             }
             
             self?.photoImageView.image = image
             }
             */
            imageTask = NetworkClient.sharedInstance.getImageInBackground(photoUrl,
                dowloadProgressBlock: { [weak self] (progress) in
                if(progress > 0 && progress < 1) {
                    self?.progressView.progress = progress
                    self?.progressView.hidden = false
                } else {
                    self?.progressView.hidden = true
                }
            }, completion: { [weak self] (image, error) in
                guard error == nil else {
                    self?.photoImageView.image = UIImage(named: "Broken")
                    return
                }
                self?.photoImageView.image = image
            })
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photo = nil
    }
    
}
