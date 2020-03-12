//
//  ViewController.swift
//  HT13_PerformanceWithCoreData
//
//  Created by Maksym Korostelov on 3/10/20.
//  Copyright © 2020 Maksym Korostelov. All rights reserved.
//

import UIKit
import CoreData

class ImageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        
    }
    @IBAction func loadFromInternet(_ sender: UIButton) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        CoreDataService.loadFromInternet { data in
            DispatchQueue.main.async { [weak self] in
                debugPrint("\(Date()) update UI started")
                self?.imageView.image = UIImage(data: data)
                debugPrint("\(Date()) update UI finished")
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
            }
        }
    }
    
    @IBAction func loadFromCoreData(_ sender: UIButton) {
        imageView.image = nil
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        CoreDataService.loadFromCoreData { imageData in
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = UIImage(data: imageData)
                
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
            }
        }
    }
}
