//
//  NavigationController.swift
//  PhotoViewers
//
//  Created by Adam Barr-Neuwirth on 8/9/16.
//  Copyright © 2016 Adam Barr-Neuwirth. All rights reserved.
//

import UIKit
import AssetsLibrary
import Photos



class NavigationController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                print("dope")
            case .restricted:
                print("damn")
            case .denied:
                print("fuck")
            default:
                // place for .notDetermined - in this callback status is already determined so should never get here
                break
            }
        }
        
    }

}
