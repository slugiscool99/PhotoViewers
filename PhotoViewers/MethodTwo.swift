//
//  MethodTwo.swift
//  PhotoViewers
//
//  Created by Adam Barr-Neuwirth on 8/8/16.
//  Copyright © 2016 Adam Barr-Neuwirth. All rights reserved.
//

import UIKit
import AssetsLibrary
import Photos


//more quality async loading and infintite image capabilities 

class MethodTwo: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var assets: [PHAsset] = []
    var imageViewObject: UIImageView = UIImageView(frame:CGRectMake(0, 0, 100, 100));
    
    var oldx: CGFloat = 0.0
    var oldy: CGFloat = 0.0
    var hasrun = false
    var cumxdiff: CGFloat = 0.0
    var cumydiff: CGFloat = 0.0
    var cumdiff: CGFloat = 0.0
    var width = UIScreen.mainScreen().bounds.width
    var height = UIScreen.mainScreen().bounds.height
    var orico: CGFloat = 0.0
    var offscreen = true
    
    var collectionViewTop: UICollectionView!
    var collectionViewBottom: UICollectionView!
    let collectionViewTopIdentifier = "CollectionViewTopCell"
    let collectionViewBottomIdentifier = "CollectionViewBottomCell"


    var i = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //get images
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
        
        collectionViewTop = UICollectionView(frame: CGRectMake(0.0, 0.0, width, (height/2)), collectionViewLayout: layout)
        collectionViewTop.dataSource = self
        collectionViewTop.delegate = self
        collectionViewTop.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: collectionViewTopIdentifier)
        collectionViewTop.backgroundColor = UIColor.whiteColor()
        collectionViewTop.userInteractionEnabled = false
        self.view.addSubview(collectionViewTop)
        
        collectionViewBottom = UICollectionView(frame: CGRectMake(0.0, (height/2), width, (height/2)), collectionViewLayout: layout)
        collectionViewBottom.dataSource = self
        collectionViewBottom.delegate = self
        collectionViewBottom.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: collectionViewBottomIdentifier)
        collectionViewBottom.backgroundColor = UIColor.whiteColor()
        collectionViewBottom.userInteractionEnabled = false
        self.view.addSubview(collectionViewBottom)


    }



    //this function calclates the cumalitive distance moved
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
       
        let touch = touches.first
        let position: CGPoint = touch!.locationInView(view)
        
        if(hasrun == false){
            oldx = position.x
            oldy = position.y
            hasrun = true
        }
        
        cumxdiff += abs(oldx - position.x)
        cumydiff += abs(oldy - position.y)
        
        cumdiff = sqrt(pow(CGFloat(cumxdiff), 2) + pow(CGFloat(cumydiff), 2))
      
        offscreen = false
        
        moveImage()
        
        oldx = position.x
        oldy = position.y
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("off")
        hasrun = false
    }
    
    //this gets images from library
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

    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if(collectionView == self.collectionViewTop){ //top
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionViewTopIdentifier, forIndexPath: indexPath)
            
            setImageTop(cell, indexPath: indexPath)
            
            cell.layer.shouldRasterize = true
            cell.layer.rasterizationScale = UIScreen.mainScreen().scale
            
            return cell
        }
        else{ //bottom
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionViewBottomIdentifier, forIndexPath: indexPath)
            
            setImageBottom(cell, indexPath: indexPath)
            
            cell.layer.shouldRasterize = true
            cell.layer.rasterizationScale = UIScreen.mainScreen().scale
            
            return cell
        }
        
    }

    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionViewTop {
            return 99 //change this to asset count (also MethodFour)
        }
        else{
            return 99
        }
    }
    
    
    func setImageTop(cell: UICollectionViewCell, indexPath: NSIndexPath){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            //load the image async
            var cimage = 0
            if(indexPath.row%2 != 0){
                cimage = (indexPath.row*2) + 1
            }
            else{
                cimage = (indexPath.row*2)
            }

            let data = self.getAssetThumbnail(self.assets[self.assets.endIndex - (cimage + 1)])
            
            //when done, assign it to the cell's UIImageView on the main thread
            dispatch_async(dispatch_get_main_queue(), {
                let img = UIImageView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width/2 - 8, UIScreen.mainScreen().bounds.size.height/2 - 8))
                img.contentMode = UIViewContentMode.ScaleToFill
                cell.addSubview(img)
                img.image = data
            })
        })
    }
   
    func setImageBottom(cell: UICollectionViewCell, indexPath: NSIndexPath){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            //load the image async, only odds
            var cimage = 0
            if(indexPath.row%2 != 1){
                cimage = (indexPath.row*2) + 1
            }
            else{
                cimage = (indexPath.row*2)
            }
            let data = self.getAssetThumbnail(self.assets[self.assets.endIndex - (cimage + 1)])
            
            //when done, assign it to the cell's UIImageView on the main thread
            dispatch_async(dispatch_get_main_queue(), {
                let img = UIImageView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width/2 - 8, UIScreen.mainScreen().bounds.size.height/2 - 8))
                img.contentMode = UIViewContentMode.ScaleToFill
                cell.addSubview(img)
                img.image = data
            })
        })
    }

    
    //delete unused cells
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        print("ended")
        for view in cell.subviews{
            view.removeFromSuperview()
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        print("going")
        let lastSectionIndex = (collectionViewBottom?.numberOfSections())! - 1
        let lastItemIndex = (collectionViewBottom?.numberOfItemsInSection(lastSectionIndex))! - 1
        let indexPath = NSIndexPath(forItem: lastItemIndex, inSection: lastSectionIndex)
        collectionViewBottom!.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Right, animated: false)
        orico = collectionViewBottom.contentOffset.x


    }
    
    func moveImage(){
        print("cd \(cumdiff)")
        collectionViewTop.setContentOffset(CGPoint(x: cumdiff, y: 0), animated: false)
        collectionViewBottom.setContentOffset(CGPoint(x: (orico - cumdiff), y: 0), animated: false)

    }
    
    
    
    
    //this hides the status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    //this does nothing
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
