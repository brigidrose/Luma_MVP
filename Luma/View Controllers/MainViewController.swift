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
import MarqueeLabel
class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {

    private var streamGalleryCV:UICollectionView!
    private var streamGallerySeparatorView:UIView!
    private var streamTV:UITableView!
    private var noFeedTitleLabel:MarqueeLabel!
    private var noFeedBodyLabel:MarqueeLabel!
    private var noFeedActionButton:UIButton!
    
    var indexOfSelectedMomentStream:Int?
    var momentStreams:[MomentStream] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.titleView = LumaNavigationControllerTitleView(frame:CGRectMake(0,0,30,25))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "AccountBarButtonItem"), style: .Plain, target: self, action: #selector(MainViewController.accountBarButtonItemTapped(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "DevicesBarButtonItem"), style: .Plain, target: self, action: #selector(MainViewController.devicesBarButtonItemTapped(_:)))

        noFeedTitleLabel = MarqueeLabel(frame: CGRectZero)
        noFeedTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        noFeedTitleLabel.textAlignment = .Center
        noFeedTitleLabel.font = UIFont.systemFontOfSize(17, weight: UIFontWeightMedium)
        noFeedTitleLabel.text = "You Haven’t Joined a Moment Stream"
        noFeedTitleLabel.numberOfLines = 1
        noFeedTitleLabel.trailingBuffer = 50
        view.addSubview(noFeedTitleLabel)
        
        noFeedBodyLabel = MarqueeLabel(frame: CGRectZero)
        noFeedBodyLabel.translatesAutoresizingMaskIntoConstraints = false
        noFeedBodyLabel.textAlignment = .Center
        noFeedBodyLabel.font = UIFont.systemFontOfSize(15)
        noFeedBodyLabel.text = "Purchase a Bracelet to create your own"
        noFeedBodyLabel.textColor = Colors.grayTextColor
        noFeedBodyLabel.numberOfLines = 1
        noFeedBodyLabel.trailingBuffer = 50
        view.addSubview(noFeedBodyLabel)
        
        let metricsDictionary = ["sidePadding":20]
        
        let noFeedTitleLabelV = NSLayoutConstraint(item: noFeedTitleLabel, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: -36)
        let noFeedTitleLabelH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[noFeedTitleLabel]-sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: ["noFeedTitleLabel":noFeedTitleLabel, "noFeedBodyLabel":noFeedBodyLabel])
        let noFeedLabelsV = NSLayoutConstraint.constraintsWithVisualFormat("V:[noFeedTitleLabel][noFeedBodyLabel]", options: [.AlignAllLeft, .AlignAllRight], metrics: metricsDictionary, views: ["noFeedTitleLabel":noFeedTitleLabel, "noFeedBodyLabel":noFeedBodyLabel])

        view.addConstraints(noFeedTitleLabelH)
        view.addConstraints(noFeedLabelsV)
        view.addConstraint(noFeedTitleLabelV)
        
        noFeedActionButton = UIButton(frame: CGRectZero)
        noFeedActionButton.translatesAutoresizingMaskIntoConstraints = false
        noFeedActionButton.setButtonType("primary")
        noFeedActionButton.setTitle("Purchase Bracelet", forState: .Normal)
        noFeedActionButton.addTarget(self, action: #selector(MainViewController.noFeedActionButtonTapped(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(noFeedActionButton)
        
        let noFeedActionButtonH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[noFeedActionButton]-sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: ["noFeedActionButton" : noFeedActionButton])
        view.addConstraints(noFeedActionButtonH)
        let noFeedActionButtonV = NSLayoutConstraint.constraintsWithVisualFormat("V:[noFeedActionButton(56)]-36-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: ["noFeedActionButton" : noFeedActionButton])
        view.addConstraints(noFeedActionButtonV)

        
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
        
        
        if momentStreams.count == 0{
            noFeedActionButton.hidden = false
            noFeedTitleLabel.hidden = false
            noFeedBodyLabel.hidden = false
            streamTV.hidden = true
            streamGalleryCV.hidden = true
            streamGallerySeparatorView.hidden = true
        }
        else{
            noFeedActionButton.hidden = true
            noFeedTitleLabel.hidden = true
            noFeedBodyLabel.hidden = true
            streamTV.hidden = false
            streamGalleryCV.hidden = false
            streamGallerySeparatorView.hidden = false
        }

        

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
            if indexOfSelectedMomentStream != nil{
                return momentStreams[indexOfSelectedMomentStream!].moments.count + 1
            }
            else{
                return 0
            }
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
    
    // MARK: Navigation Bar Button Taps
    
    func accountBarButtonItemTapped(sender:UIBarButtonItem){
        
    }
    
    func devicesBarButtonItemTapped(sender:UIBarButtonItem){
        
    }
    
    func noFeedActionButtonTapped(sender:UIButton){
        let storeVC = LumaStoreViewController()
        let storeNC = UINavigationController(rootViewController: storeVC)
        storeNC.navigationBar.tintColor = Colors.primary
        presentViewController(storeNC, animated: true, completion: nil)
        
    }
    
    
}
