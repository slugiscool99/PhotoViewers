//
//  ViewController.swift
//  PhotoViewers
//
//  Created by Adam Barr-Neuwirth on 8/8/16.
//  Copyright © 2016 Adam Barr-Neuwirth. All rights reserved.
//

import UIKit
import AssetsLibrary
import Photos



// if youre about to read this literal waste kilobytes, just know that i gave up trying to make this even remotly nice


class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    
    var assets: [PHAsset] = []
    var cindex: Int = 0

    var iscale = 0
    
    let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let results = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: nil)
        
        results.enumerateObjectsUsingBlock { (object, _, _) in
            if let asset = object as? PHAsset {
                self.assets.append(asset)
            }
        }
     
        var pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: "pinch:")
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(pinchGestureRecognizer)
        
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFill
        
        self.view.addSubview(imageViewBackground)
        self.view.sendSubviewToBack(imageViewBackground)
        
    }

    
    
    override func viewDidAppear(animated: Bool) {
        cindex = assets.endIndex
        let idata = getAssetThumbnail(assets[assets.endIndex - 1])
        imageView.image = idata

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
    
    
    var tindex = 0.0
    
    
    
    func pinch(sender: UIPinchGestureRecognizer){
        
        
        if(sender.scale >= 1){
            tindex += Double((sender.scale / 6))
            if(floor(tindex) > 1){
                addBackground()
                let idata = getAssetThumbnail(assets[cindex - 1])
                imageView.image = idata
                imageView.transform = CGAffineTransformMakeScale(0.9, 0.9)
                animateImage()
                cindex = cindex - 1
                tindex = 0
            }
        }
        else{
            iscale = Int((sender.scale + 1) * 1)
            if(cindex + iscale < assets.endIndex){
                let idata = getAssetThumbnail(assets[cindex + iscale])
                imageView.image = idata
                imageView.transform = CGAffineTransformMakeScale(1.1, 1.1)
                animateImage()
                cindex = cindex + iscale

            }
        }
        
    }
    
    func addBackground() {
        imageViewBackground.image = imageView.image
    }
    
    func animateImage(){
        
        UIView.animateWithDuration(0.25, delay: 0, options: .CurveEaseOut, animations: {
            self.imageView.userInteractionEnabled = false
            self.imageView.transform = CGAffineTransformMakeScale(1, 1)
            }, completion:{ finished in
                self.imageView.userInteractionEnabled = true
        })
    }

    
    
    
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

