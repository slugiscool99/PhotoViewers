//
//  MethodFour.swift
//  PhotoViewers
//
//  Created by Adam Barr-Neuwirth on 8/9/16.
//  Copyright © 2016 Adam Barr-Neuwirth. All rights reserved.
//

//
import UIKit
import AssetsLibrary
import Photos


//inverse of mikes
//this has got some absolute quality asynchronous loading
//fixed async memory issues by removeing views from cell when cell disappears. probably its better to not create/destroy every time but if needed it can be recoded

class MethodFour: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate{
    
    var collectionView: UICollectionView!
    var assets: [PHAsset] = []

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let results = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: nil)
        
        results.enumerateObjectsUsingBlock { (object, _, _) in
            if let asset = object as? PHAsset {
                self.assets.append(asset)
            }
        }

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        layout.itemSize = CGSize(width: floor(UIScreen.mainScreen().bounds.size.width/2 - 8), height: floor(UIScreen.mainScreen().bounds.size.height/2 - 8))
        layout.scrollDirection = .Horizontal
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 99
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)

        setImage(cell, indexPath: indexPath)
        
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.mainScreen().scale
        
        return cell
    }
    
    func setImage(cell: UICollectionViewCell, indexPath: NSIndexPath){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            //load the image async
            let data = self.getAssetThumbnail(self.assets[self.assets.endIndex - (Int(indexPath.row) + 1)])
           
            //when done, assign it to the cell's UIImageView on the main thread
            dispatch_async(dispatch_get_main_queue(), {
                let img = UIImageView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width/2 - 8, UIScreen.mainScreen().bounds.size.height/2 - 8))
                img.contentMode = UIViewContentMode.ScaleToFill
                cell.addSubview(img)
                img.image = data
                //self.collectionView.reloadData()

            })
        })
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        print("ended")
        for view in cell.subviews{
            view.removeFromSuperview()
        }
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