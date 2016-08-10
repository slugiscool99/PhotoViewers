//
//  MethodThree.swift
//  PhotoViewers
//
//  Created by Adam Barr-Neuwirth on 8/9/16.
//  Copyright © 2016 Adam Barr-Neuwirth. All rights reserved.
//
import UIKit
import AssetsLibrary
import Photos


//inverse of mikes

class MethodThree: UIViewController {

    var assets: [PHAsset] = []

    let imgA = UIImageView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width/2, UIScreen.mainScreen().bounds.size.height/2))
    let imgB = UIImageView(frame: CGRectMake(UIScreen.mainScreen().bounds.size.width/2, 0, UIScreen.mainScreen().bounds.size.width/2, UIScreen.mainScreen().bounds.size.height/2))
    let imgC = UIImageView(frame: CGRectMake(0, UIScreen.mainScreen().bounds.size.height/2, UIScreen.mainScreen().bounds.size.width/2, UIScreen.mainScreen().bounds.size.height/2))
    let imgD = UIImageView(frame: CGRectMake(UIScreen.mainScreen().bounds.size.width/2, UIScreen.mainScreen().bounds.size.height/2, UIScreen.mainScreen().bounds.size.width/2, UIScreen.mainScreen().bounds.size.height/2))
   
    var i = 5

    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgA.contentMode = UIViewContentMode.ScaleToFill
        imgB.contentMode = UIViewContentMode.ScaleToFill
        imgC.contentMode = UIViewContentMode.ScaleToFill
        imgD.contentMode = UIViewContentMode.ScaleToFill

        
        let results = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: nil)
        
        results.enumerateObjectsUsingBlock { (object, _, _) in
            if let asset = object as? PHAsset {
                self.assets.append(asset)
            }
        }
        
        self.view.addSubview(imgA)
        self.view.addSubview(imgB)
        self.view.addSubview(imgC)
        self.view.addSubview(imgD)
        
        let tapA = UITapGestureRecognizer(target: self, action: "tappedA:")
        imgA.userInteractionEnabled = true
        imgA.addGestureRecognizer(tapA)
        
        let tapB = UITapGestureRecognizer(target: self, action: "tappedB:")
        imgB.userInteractionEnabled = true
        imgB.addGestureRecognizer(tapB)
        
        let tapC = UITapGestureRecognizer(target: self, action: "tappedC:")
        imgC.userInteractionEnabled = true
        imgC.addGestureRecognizer(tapC)
        
        let tapD = UITapGestureRecognizer(target: self, action: "tappedD:")
        imgD.userInteractionEnabled = true
        imgD.addGestureRecognizer(tapD)


    }
    
    override func viewDidAppear(animated: Bool) {
        print("appeared")
        let adata = getAssetThumbnail(assets[assets.endIndex - 1])
        imgA.image = adata
        let bdata = getAssetThumbnail(assets[assets.endIndex - 2])
        imgB.image = bdata
        let cdata = getAssetThumbnail(assets[assets.endIndex - 3])
        imgC.image = cdata
        let ddata = getAssetThumbnail(assets[assets.endIndex - 4])
        imgD.image = ddata

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
    
    func tappedA(sender: UITapGestureRecognizer){
        let newdata = getAssetThumbnail(assets[assets.endIndex - i])
        imgA.image = newdata
        i += 1
    }
    func tappedB(sender: UITapGestureRecognizer){
        let newdata = getAssetThumbnail(assets[assets.endIndex - i])
        imgB.image = newdata
        i += 1
    }
    func tappedC(sender: UITapGestureRecognizer){
        let newdata = getAssetThumbnail(assets[assets.endIndex - i])
        imgC.image = newdata
        i += 1
    }
    func tappedD(sender: UITapGestureRecognizer){
        let newdata = getAssetThumbnail(assets[assets.endIndex - i])
        imgD.image = newdata
        i += 1
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}