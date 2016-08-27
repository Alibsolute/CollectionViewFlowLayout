//
//  ViewController.swift
//  CollectionViewFlowLayout
//
//  Created by ABS on 16/3/14.
//  Copyright © 2016年 abs. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ABSWaterFlowLayoutDelegate,CollectionViewLayoutDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var once:dispatch_once_t = 0
    var supplementaryElementOnce:dispatch_once_t = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
//        let flowLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        flowLayout.minimumInteritemSpacing = 0;
//        flowLayout.minimumLineSpacing = 5
//        flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//        flowLayout.itemSize = CGSize(width: UIScreen.mainScreen().bounds.size.width/2-8, height: 260)
//        self.collectionView.collectionViewLayout = flowLayout
        
//        let temp:ABSWaterFlowLayout = ABSWaterFlowLayout()
//        temp.delegate = self
//        self.collectionView.collectionViewLayout = temp
        
        let temp:CollectionViewLayout = CollectionViewLayout()
        temp.delegate = self
        temp.numberOfColumns = 3;
        temp.interItemSpacing = 10;
        temp.headerReferenceSize = CGSize(width: 0, height: 60);
        self.collectionView.collectionViewLayout = temp
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    /**
     
     - parameter collectionView: collectionView description
     - parameter section:        section description
     
     - returns: return numberOfItemsInSection
     */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 29
        } else if section == 1 {
            return 25
        } else {
            return 0;
        }
    }
    
    /**
     
     - parameter collectionView: collectionView description
     - parameter indexPath:      indexPath description
     
     - returns: return cell
     */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        dispatch_once(&once) { () -> Void in
            collectionView.registerNib(UINib(nibName: "CollectionViewCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: "CELL")
        }
        
        let cell:CollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("CELL", forIndexPath: indexPath) as! CollectionViewCell
        cell.pinImageView.image = UIImage(named: "pin\((rand()%5+1))"+".jpg")
        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 50, height: 40)
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        dispatch_once(&supplementaryElementOnce) { () -> Void in
            collectionView.registerNib(UINib(nibName: "CollectionReusableView", bundle: NSBundle.mainBundle()), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
        }
        
        var header:UICollectionReusableView = CollectionReusableView()
        if kind == UICollectionElementKindSectionHeader {
            
            header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath)
            
        }
        return header
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: UIScreen.mainScreen().bounds.size.width/2-8, height: CGFloat(160+rand()%50+rand()%50))
    }

    
    func waterflowLayout(waterflowLayout: ABSWaterFlowLayout!, heightForWidth width: CGFloat, atIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return CGFloat(160+rand()%50+rand()%50)
    }
    
    func collection(collectionView: UICollectionView!, layout: CollectionViewLayout!, heightForItemAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return CGFloat(160+rand()%50+rand()%50)
    }
    
}

