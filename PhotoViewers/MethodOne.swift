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


class MethodOne: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    
    var assets: [PHAsset] = []
    var cindex: Int = 0

    var iscale = 0
    
    let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let results = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
        
        results.enumerateObjects { (object, _, _) in
            if let asset = object as? PHAsset {
                self.assets.append(asset)
            }
        }
     
        var pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(MethodOne.pinch(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(pinchGestureRecognizer)
        
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        
        self.view.addSubview(imageViewBackground)
        self.view.sendSubview(toBack: imageViewBackground)
        
    }

    
    
    override func viewDidAppear(_ animated: Bool) {
        cindex = assets.endIndex
        let idata = getAssetThumbnail(assets[assets.endIndex - 1])
        imageView.image = idata

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
    
    
    var tindex = 0.0
    
    
    
    func pinch(_ sender: UIPinchGestureRecognizer){
        
        
        if(sender.scale >= 1){
            tindex += Double((sender.scale / 6))
            if(floor(tindex) > 1){
                addBackground()
                let idata = getAssetThumbnail(assets[cindex - 1])
                imageView.image = idata
                imageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
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
                imageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                animateImage()
                cindex = cindex + iscale

            }
        }
        
    }
    
    func addBackground() {
        imageViewBackground.image = imageView.image
    }
    
    func animateImage(){
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.imageView.isUserInteractionEnabled = false
            self.imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion:{ finished in
                self.imageView.isUserInteractionEnabled = true
        })
    }

    
    
    
    
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

