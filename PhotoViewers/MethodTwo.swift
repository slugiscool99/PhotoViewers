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
    var imageViewObject: UIImageView = UIImageView(frame:CGRect(x: 0, y: 0, width: 100, height: 100));
    
    var oldx: CGFloat = 0.0
    var oldy: CGFloat = 0.0
    var hasrun = false
    var cumxdiff: CGFloat = 0.0
    var cumydiff: CGFloat = 0.0
    var cumdiff: CGFloat = 0.0
    var width = UIScreen.main.bounds.width
    var height = UIScreen.main.bounds.height
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
        let results = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
        results.enumerateObjects { (object, _, _) in
            if let asset = object as? PHAsset {
                self.assets.append(asset)
            }
        }
        

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        
        layout.itemSize = CGSize(width: floor(UIScreen.main.bounds.size.width/2 - 8), height: floor(UIScreen.main.bounds.size.height/2 - 8))
        
        layout.scrollDirection = .horizontal
        
        collectionViewTop = UICollectionView(frame: CGRect(x: 0.0, y: 0.0, width: width, height: (height/2)), collectionViewLayout: layout)
        collectionViewTop.dataSource = self
        collectionViewTop.delegate = self
        collectionViewTop.register(UICollectionViewCell.self, forCellWithReuseIdentifier: collectionViewTopIdentifier)
        collectionViewTop.backgroundColor = UIColor.white
        collectionViewTop.isUserInteractionEnabled = false
        self.view.addSubview(collectionViewTop)
        
        collectionViewBottom = UICollectionView(frame: CGRect(x: 0.0, y: (height/2), width: width, height: (height/2)), collectionViewLayout: layout)
        collectionViewBottom.dataSource = self
        collectionViewBottom.delegate = self
        collectionViewBottom.register(UICollectionViewCell.self, forCellWithReuseIdentifier: collectionViewBottomIdentifier)
        collectionViewBottom.backgroundColor = UIColor.white
        collectionViewBottom.isUserInteractionEnabled = false
        self.view.addSubview(collectionViewBottom)


    }



    //this function calclates the cumalitive distance moved
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        let touch = touches.first
        let position: CGPoint = touch!.location(in: view)
        
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("off")
        hasrun = false
    }
    
    //this gets images from library
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

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(collectionView == self.collectionViewTop){ //top
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewTopIdentifier, for: indexPath)
            
            setImageTop(cell, indexPath: indexPath)
            
            cell.layer.shouldRasterize = true
            cell.layer.rasterizationScale = UIScreen.main.scale
            
            return cell
        }
        else{ //bottom
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewBottomIdentifier, for: indexPath)
            
            setImageBottom(cell, indexPath: indexPath)
            
            cell.layer.shouldRasterize = true
            cell.layer.rasterizationScale = UIScreen.main.scale
            
            return cell
        }
        
    }

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionViewTop {
            return 99 //change this to asset count (also MethodFour)
        }
        else{
            return 99
        }
    }
    
    
    func setImageTop(_ cell: UICollectionViewCell, indexPath: IndexPath){
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
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
            DispatchQueue.main.async(execute: {
                let img = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width/2 - 8, height: UIScreen.main.bounds.size.height/2 - 8))
                img.contentMode = UIViewContentMode.scaleToFill
                cell.addSubview(img)
                img.image = data
            })
        })
    }
   
    func setImageBottom(_ cell: UICollectionViewCell, indexPath: IndexPath){
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
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
            DispatchQueue.main.async(execute: {
                let img = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width/2 - 8, height: UIScreen.main.bounds.size.height/2 - 8))
                img.contentMode = UIViewContentMode.scaleToFill
                cell.addSubview(img)
                img.image = data
            })
        })
    }

    
    //delete unused cells
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("ended")
        for view in cell.subviews{
            view.removeFromSuperview()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("going")
        let lastSectionIndex = (collectionViewBottom?.numberOfSections)! - 1
        let lastItemIndex = (collectionViewBottom?.numberOfItems(inSection: lastSectionIndex))! - 1
        let indexPath = IndexPath(item: lastItemIndex, section: lastSectionIndex)
        collectionViewBottom!.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.right, animated: false)
        orico = collectionViewBottom.contentOffset.x


    }
    
    func moveImage(){
        print("cd \(cumdiff)")
        collectionViewTop.setContentOffset(CGPoint(x: cumdiff, y: 0), animated: false)
        collectionViewBottom.setContentOffset(CGPoint(x: (orico - cumdiff), y: 0), animated: false)

    }
    
    
    
    
    //this hides the status bar
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    
    //this does nothing
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
