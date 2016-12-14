//
//  MethodFive.swift
//  PhotoViewers
//
//  Created by Adam Barr-Neuwirth on 8/10/16.
//  Copyright © 2016 Adam Barr-Neuwirth. All rights reserved.
//

import UIKit
import AssetsLibrary
import Photos

class MethodFive: UIViewController{
   
    var assets: [PHAsset] = []
    
    //some constants
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    let iheight = (UIScreen.main.bounds.size.width - 20)/2
    var start: CGPoint = CGPoint(x: 0.0, y: 0.0)
    var startTime: TimeInterval = 0.0
    var i = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        let results = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
        
        results.enumerateObjects({ (object, _, _) in
            if let asset = object as? PHAsset {
                self.assets.append(asset)
            }
        })
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(MethodFive.swipeDown(_:)))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(MethodFive.swipeUp(_:)))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)

        view.isUserInteractionEnabled = true

    }

    
    func swipeDown(_ sender: UISwipeGestureRecognizer){
        print("Down")
        //set current image as placeholder/backgorund, then delete, then:
        
        let img = UIImageView(frame: CGRect(x: (width/2)-iheight,y: -(width/2), width: (width - 20), height: (height/2 - 10)))
        img.contentMode = UIViewContentMode.scaleAspectFit
        let data = getAssetThumbnail(assets[assets.endIndex - (i+1)]) //iterate this
        img.image = data
        img.tag = (i+1)
        self.view.addSubview(img)
        i += 1

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            for subview in self.view.subviews{
                if(subview.tag == self.i - 1){
                    subview.superview?.bringSubview(toFront: subview)
                    subview.transform = CGAffineTransform(translationX: 0, y: (self.height/2) + 5 + (self.width/2))
                    subview.alpha -= 0.3
                }
                else if(subview.tag > self.i - 5 && subview.tag < self.i){
                    subview.alpha -= 0.3
                }
            }
            img.transform = CGAffineTransform(translationX: 0, y: (self.width/2) + 5)
            
            }, completion:{ finished in
                for subview in self.view.subviews{
                    if(subview.tag < self.i - 4){
                         subview.removeFromSuperview()
                    }
                }
        })
        
        
    }
    
    func swipeUp(_ sender: UISwipeGestureRecognizer){
        print("Up")
    }
    
    //setup first image
    override func viewDidAppear(_ animated: Bool) {
        print("appear")
//        let img = UIImageView(frame: CGRectMake((width/2)-iheight, (height/2)-iheight, (width - 20), (height/2 - 10)))
//        img.contentMode = UIViewContentMode.ScaleToFill
//        let data = getAssetThumbnail(assets[assets.endIndex - 1])
//        img.image = data
//        img.tag = i
//        self.view.addSubview(img)

    }
    
    func getAssetThumbnail(_ asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        option.resizeMode = .none
        option.isNetworkAccessAllowed = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 500, height: 500), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }

    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
