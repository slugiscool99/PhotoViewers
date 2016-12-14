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
        
        let results = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
        
        results.enumerateObjects({ (object, _, _) in
            if let asset = object as? PHAsset {
                self.assets.append(asset)
            }
        })

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        layout.itemSize = CGSize(width: floor(UIScreen.main.bounds.size.width/2 - 8), height: floor(UIScreen.main.bounds.size.height/2 - 8))
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.white
        self.view.addSubview(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 99
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)

        setImage(cell, indexPath: indexPath)
        
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        
        return cell
    }
    
    func setImage(_ cell: UICollectionViewCell, indexPath: IndexPath){
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
            //load the image async
            let data = self.getAssetThumbnail(self.assets[self.assets.endIndex - (Int(indexPath.row) + 1)])
           
            //when done, assign it to the cell's UIImageView on the main thread
            DispatchQueue.main.async(execute: {
                let img = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width/2 - 8, height: UIScreen.main.bounds.size.height/2 - 8))
                img.contentMode = UIViewContentMode.scaleToFill
                cell.addSubview(img)
                img.image = data
                //self.collectionView.reloadData()

            })
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("ended")
        for view in cell.subviews{
            view.removeFromSuperview()
        }
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
