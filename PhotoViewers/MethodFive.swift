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
    let width = UIScreen.mainScreen().bounds.size.width
    let height = UIScreen.mainScreen().bounds.size.height
    let iheight = (UIScreen.mainScreen().bounds.size.width - 20)/2
    var start: CGPoint = CGPointMake(0.0, 0.0)
    var startTime: NSTimeInterval = 0.0
    var i = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        let results = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: nil)
        
        results.enumerateObjectsUsingBlock { (object, _, _) in
            if let asset = object as? PHAsset {
                self.assets.append(asset)
            }
        }
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: "swipeDown:")
        swipeDown.direction = .Down
        view.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: "swipeUp:")
        swipeUp.direction = .Up
        view.addGestureRecognizer(swipeUp)

        view.userInteractionEnabled = true

    }

    
    func swipeDown(sender: UISwipeGestureRecognizer){
        print("Down")
        //set current image as placeholder/backgorund, then delete, then:
        
        let img = UIImageView(frame: CGRectMake((width/2)-iheight,-(width/2), (width - 20), (height/2 - 10)))
        img.contentMode = UIViewContentMode.ScaleAspectFit
        let data = getAssetThumbnail(assets[assets.endIndex - (i+1)]) //iterate this
        img.image = data
        img.tag = (i+1)
        self.view.addSubview(img)
        i += 1

        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseOut, animations: {
            for subview in self.view.subviews{
                if(subview.tag == self.i - 1){
                    subview.superview?.bringSubviewToFront(subview)
                    subview.transform = CGAffineTransformMakeTranslation(0, (self.height/2) + 5 + (self.width/2))
                    subview.alpha -= 0.3
                }
                else if(subview.tag > self.i - 5 && subview.tag < self.i){
                    subview.alpha -= 0.3
                }
            }
            img.transform = CGAffineTransformMakeTranslation(0, (self.width/2) + 5)
            
            }, completion:{ finished in
                for subview in self.view.subviews{
                    if(subview.tag < self.i - 4){
                         subview.removeFromSuperview()
                    }
                }
        })
        
        
    }
    
    func swipeUp(sender: UISwipeGestureRecognizer){
        print("Up")
    }
    
    //setup first image
    override func viewDidAppear(animated: Bool) {
        print("appear")
//        let img = UIImageView(frame: CGRectMake((width/2)-iheight, (height/2)-iheight, (width - 20), (height/2 - 10)))
//        img.contentMode = UIViewContentMode.ScaleToFill
//        let data = getAssetThumbnail(assets[assets.endIndex - 1])
//        img.image = data
//        img.tag = i
//        self.view.addSubview(img)

    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.defaultManager()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.synchronous = true
        option.resizeMode = .None
        option.networkAccessAllowed = true
        manager.requestImageForAsset(asset, targetSize: CGSize(width: 500, height: 500), contentMode: .AspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }

    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}