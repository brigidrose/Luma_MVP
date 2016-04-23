//
//  MainViewController.swift
//  Luma
//
//  Created by Chun-Wei Chen on 4/22/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import UIColor_Hex_Swift

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {

    private var streamGalleryCV:UICollectionView!
    private var streamGallerySeparatorView:UIView!
    private var streamTV:UITableView!
    
    var indexOfSelectedMomentStream:Int = 0
    var momentStreams:[MomentStream] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.titleView = LumaNavigationControllerTitleView(frame:CGRectMake(0,0,30,25))
        
        let streamTableViewController = UITableViewController()
        self.addChildViewController(streamTableViewController)
        streamTV = TPKeyboardAvoidingTableView(frame: CGRectZero)
        streamTV.backgroundColor = Colors.offWhite
        streamTV.translatesAutoresizingMaskIntoConstraints = false
        streamTV.delegate = self
        streamTV.dataSource = self
        streamTV.clipsToBounds = false
        streamTV.registerClass(MomentTableViewCell.self, forCellReuseIdentifier: "MomentTableViewCell")
        streamTV.estimatedRowHeight = 150
        streamTV.rowHeight = UITableViewAutomaticDimension
        streamTableViewController.tableView = streamTV
        view.addSubview(streamTV)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.itemSize = CGSizeMake(50, 50)
        layout.minimumInteritemSpacing = 10
        let streamGalleryCollectionViewController = UICollectionViewController()
        self.addChildViewController(streamGalleryCollectionViewController)
        streamGalleryCV = TPKeyboardAvoidingCollectionView(frame: CGRectZero, collectionViewLayout: layout)
        streamGalleryCV.translatesAutoresizingMaskIntoConstraints = false
        streamGalleryCV.backgroundColor = Colors.white
        streamGalleryCV.contentInset = UIEdgeInsetsMake(15, 10, 15, 10)
        streamGalleryCV.alwaysBounceHorizontal = true
        streamGalleryCV.delegate = self
        streamGalleryCV.dataSource = self
        streamGalleryCV.registerClass(StreamGalleryCollectionViewCell.self, forCellWithReuseIdentifier: "StreamGalleryCollectionViewCell")
        streamGalleryCollectionViewController.collectionView = streamGalleryCV
        view.addSubview(streamGalleryCV)
        
        
        streamGallerySeparatorView = UIView(frame:CGRectZero)
        streamGallerySeparatorView.translatesAutoresizingMaskIntoConstraints = false
        streamGallerySeparatorView.backgroundColor = Colors.separatorGray
        view.addSubview(streamGallerySeparatorView)
        
        let viewsDictionary = ["streamTV":streamTV, "streamGalleryCV":streamGalleryCV, "streamGallerySeparatorView":streamGallerySeparatorView]
        
        let hStreamTV = NSLayoutConstraint.constraintsWithVisualFormat("H:|[streamTV]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: viewsDictionary)
        let bottomStreamTV = NSLayoutConstraint.constraintsWithVisualFormat("V:[streamTV]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: viewsDictionary)
        let topStreamTV = NSLayoutConstraint(item: streamTV, attribute: .Top, relatedBy: .Equal, toItem: topLayoutGuide, attribute: .Bottom, multiplier: 1, constant: 16)
        view.addConstraints(hStreamTV + bottomStreamTV + [topStreamTV])
        
        let hStreamGalleryCV = NSLayoutConstraint.constraintsWithVisualFormat("H:|[streamGalleryCV]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: viewsDictionary)
        let heightStreamGalleryCV = NSLayoutConstraint.constraintsWithVisualFormat("V:[streamGalleryCV(80)]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: viewsDictionary)
        let vStreamGalleryCV = NSLayoutConstraint(item: streamGalleryCV, attribute: .Top, relatedBy: .Equal, toItem: topLayoutGuide, attribute: .Bottom, multiplier: 1, constant: 0)
        view.addConstraints(hStreamGalleryCV + heightStreamGalleryCV + [vStreamGalleryCV])
        
        let hStreamGallerySeparatorView = NSLayoutConstraint.constraintsWithVisualFormat("H:|[streamGallerySeparatorView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: viewsDictionary)
        let heightStreamGallerySeparatorView = NSLayoutConstraint(item: streamGallerySeparatorView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 0.5)
        let vStreamGallerySeparatorView = NSLayoutConstraint(item: streamGallerySeparatorView, attribute: .Bottom, relatedBy: .Equal, toItem: streamGalleryCV, attribute: .Bottom, multiplier: 1, constant: -0.5)
        
        view.addConstraints(hStreamGallerySeparatorView + [heightStreamGallerySeparatorView, vStreamGallerySeparatorView])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Table View Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        else{
//            return momentStreams[indexOfSelectedMomentStream].moments.count + 1
            return 2
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MomentTableViewCell") as! MomentTableViewCell
        return cell
    }
    
    // MARK: Collection View Data Source
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return 2
        }
        else{
            return momentStreams.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("StreamGalleryCollectionViewCell", forIndexPath: indexPath)
        cell.backgroundColor = Colors.primary.colorWithAlphaComponent(0.5)
        return cell
    }
    
    
}
