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

    let imgA = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width/2, height: UIScreen.main.bounds.size.height/2))
    let imgB = UIImageView(frame: CGRect(x: UIScreen.main.bounds.size.width/2, y: 0, width: UIScreen.main.bounds.size.width/2, height: UIScreen.main.bounds.size.height/2))
    let imgC = UIImageView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height/2, width: UIScreen.main.bounds.size.width/2, height: UIScreen.main.bounds.size.height/2))
    let imgD = UIImageView(frame: CGRect(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2, width: UIScreen.main.bounds.size.width/2, height: UIScreen.main.bounds.size.height/2))
   
    var i = 5

    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgA.contentMode = UIViewContentMode.scaleToFill
        imgB.contentMode = UIViewContentMode.scaleToFill
        imgC.contentMode = UIViewContentMode.scaleToFill
        imgD.contentMode = UIViewContentMode.scaleToFill

        
        let results = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
        
        results.enumerateObjects { (object, _, _) in
            if let asset = object as? PHAsset {
                self.assets.append(asset)
            }
        }
        
        self.view.addSubview(imgA)
        self.view.addSubview(imgB)
        self.view.addSubview(imgC)
        self.view.addSubview(imgD)
        
        let tapA = UITapGestureRecognizer(target: self, action: #selector(MethodThree.tappedA(_:)))
        imgA.isUserInteractionEnabled = true
        imgA.addGestureRecognizer(tapA)
        
        let tapB = UITapGestureRecognizer(target: self, action: #selector(MethodThree.tappedB(_:)))
        imgB.isUserInteractionEnabled = true
        imgB.addGestureRecognizer(tapB)
        
        let tapC = UITapGestureRecognizer(target: self, action: #selector(MethodThree.tappedC(_:)))
        imgC.isUserInteractionEnabled = true
        imgC.addGestureRecognizer(tapC)
        
        let tapD = UITapGestureRecognizer(target: self, action: #selector(MethodThree.tappedD(_:)))
        imgD.isUserInteractionEnabled = true
        imgD.addGestureRecognizer(tapD)


    }
    
    override func viewDidAppear(_ animated: Bool) {
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
    
    func tappedA(_ sender: UITapGestureRecognizer){
        let newdata = getAssetThumbnail(assets[assets.endIndex - i])
        imgA.image = newdata
        i += 1
    }
    func tappedB(_ sender: UITapGestureRecognizer){
        let newdata = getAssetThumbnail(assets[assets.endIndex - i])
        imgB.image = newdata
        i += 1
    }
    func tappedC(_ sender: UITapGestureRecognizer){
        let newdata = getAssetThumbnail(assets[assets.endIndex - i])
        imgC.image = newdata
        i += 1
    }
    func tappedD(_ sender: UITapGestureRecognizer){
        let newdata = getAssetThumbnail(assets[assets.endIndex - i])
        imgD.image = newdata
        i += 1
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
}
