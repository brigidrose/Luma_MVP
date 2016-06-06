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
    private var newMomentButton:UIButton!
    private var streamGallerySelectedIndexPath:NSIndexPath = NSIndexPath(forItem: 0, inSection: 1)
    private var refreshControl:UIRefreshControl!
    
    var momentStreams:[MomentStream] = [MomentStream()]
    
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
        streamTV.backgroundColor = Colors.white
        streamTV.translatesAutoresizingMaskIntoConstraints = false
        streamTV.delegate = self
        streamTV.dataSource = self
        streamTV.clipsToBounds = false
        streamTV.registerClass(MomentTableViewCell.self, forCellReuseIdentifier: "MomentTableViewCell")
        streamTV.registerClass(TitleSeparatorTableViewCell.self, forCellReuseIdentifier: "TitleSeparatorTableViewCell")
        streamTV.registerClass(MomentStreamSummaryTableViewCell.self, forCellReuseIdentifier: "MomentStreamSummaryTableViewCell")
        streamTV.registerClass(MomentTableViewCell.self, forCellReuseIdentifier: "MomentTableViewCell")
        streamTV.registerClass(GeoLockedMomentTableViewCell.self, forCellReuseIdentifier: "GeoLockedMomentTableViewCell")
        streamTV.registerClass(TimeLockedMomentTableViewCell.self, forCellReuseIdentifier: "TimeLockedMomentTableViewCell")
        streamTV.estimatedRowHeight = 150
        streamTV.rowHeight = UITableViewAutomaticDimension
        streamTV.contentInset.top = 64
//        streamTV.scrollIndicatorInsets.top = 64
        streamTV.separatorStyle = .None
        streamTableViewController.tableView = streamTV
        view.addSubview(streamTV)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.itemSize = CGSizeMake(50, 50)
        layout.minimumInteritemSpacing = 10
        layout.sectionInset.right = 10
        let streamGalleryCollectionViewController = UICollectionViewController()
        self.addChildViewController(streamGalleryCollectionViewController)
        streamGalleryCV = TPKeyboardAvoidingCollectionView(frame: CGRectZero, collectionViewLayout: layout)
        streamGalleryCV.translatesAutoresizingMaskIntoConstraints = false
        streamGalleryCV.backgroundColor = Colors.white
        streamGalleryCV.contentInset = UIEdgeInsetsMake(15, 10, 15, 10)
        streamGalleryCV.alwaysBounceHorizontal = true
        streamGalleryCV.delegate = self
        streamGalleryCV.dataSource = self
        streamGalleryCV.scrollsToTop = false
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
        let vStreamGallerySeparatorView = NSLayoutConstraint(item: streamGallerySeparatorView, attribute: .Bottom, relatedBy: .Equal, toItem: streamGalleryCV, attribute: .Bottom, multiplier: 1, constant: 0)
        
        view.addConstraints(hStreamGallerySeparatorView + [heightStreamGallerySeparatorView, vStreamGallerySeparatorView])
        
        newMomentButton = UIButton(frame: CGRectZero)
        newMomentButton.translatesAutoresizingMaskIntoConstraints = false
        newMomentButton.setButtonType("circle")
        newMomentButton.setImage(UIImage(named: "PlusButtonIcon"), forState: .Normal)
        newMomentButton.addTarget(self, action: #selector(MainViewController.newMomentButtonTapped), forControlEvents: .TouchUpInside)
        view.addSubview(newMomentButton)
        
        let newMomentButtonCenterX = NSLayoutConstraint(item: newMomentButton, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0)
        view.addConstraint(newMomentButtonCenterX)
        let newMomentButtonH = NSLayoutConstraint.constraintsWithVisualFormat("H:[newMomentButton(76)]", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: ["newMomentButton" : newMomentButton])
        view.addConstraints(newMomentButtonH)
        let newMomentButtonV = NSLayoutConstraint.constraintsWithVisualFormat("V:[newMomentButton(76)]-36-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: ["newMomentButton" : newMomentButton])
        view.addConstraints(newMomentButtonV)

        
        
        if momentStreams.count == 0{
            noFeedActionButton.hidden = false
            noFeedTitleLabel.hidden = false
            noFeedBodyLabel.hidden = false
            newMomentButton.hidden = true
            streamTV.hidden = true
            streamGalleryCV.hidden = true
            streamGallerySeparatorView.hidden = true
        }
        else{
            noFeedActionButton.hidden = true
            noFeedTitleLabel.hidden = true
            noFeedBodyLabel.hidden = true
            newMomentButton.hidden = false
            streamTV.hidden = false
            streamGalleryCV.hidden = false
            streamGallerySeparatorView.hidden = false
        }

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(MainViewController.streamRefreshed), forControlEvents: .ValueChanged)
        streamTV.addSubview(refreshControl)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func newMomentButtonTapped() {
        print("new moment button tapped")
    }
    
    func streamRefreshed() {
        print("stream refreshed")
        refreshControl.beginRefreshing()
        refreshControl.endRefreshing()
    }
    
    // MARK: Table View Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        else{
            if streamGallerySelectedIndexPath.item != 0{
                return momentStreams[streamGallerySelectedIndexPath.item].moments.count + 1
            }
            else{
                return 5
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            // stream header section
            // dequeue what's new header if what's new is selected
            if streamGallerySelectedIndexPath == NSIndexPath(forItem: 0, inSection: 0){
                let cell = tableView.dequeueReusableCellWithIdentifier("TitleSeparatorTableViewCell") as! TitleSeparatorTableViewCell
                cell.titleLabel.text = "What's New"
                return cell
            }
            // else dequeue stream summary header
            else{
                let cell = tableView.dequeueReusableCellWithIdentifier("MomentStreamSummaryTableViewCell") as! MomentStreamSummaryTableViewCell
                if cell.participantsStackView.arrangedSubviews.count != 4{
                    for _ in 0...3 {
                        let button = UIButton()
                        button.setImage(UIImage(named:"streamParticipantIcon"), forState: .Normal)
                        cell.participantsStackView.addArrangedSubview(button)
                    }
                }
                return cell
            }
        }
        else{
            if indexPath.item % 3 == 1{
                let cell = tableView.dequeueReusableCellWithIdentifier("MomentTableViewCell") as! MomentTableViewCell
                return cell
            }
            else if indexPath.item % 3 == 2{
                let cell = tableView.dequeueReusableCellWithIdentifier("TimeLockedMomentTableViewCell") as! TimeLockedMomentTableViewCell
                cell.unlockCountdownLabel.start()
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCellWithIdentifier("GeoLockedMomentTableViewCell") as! GeoLockedMomentTableViewCell
                return cell
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 0 && section < tableView.numberOfSections - 1{
            return 28
        }
        else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1{
            let view = UIView(frame: CGRectMake(0,0,UIScreen.mainScreen().bounds.width, 44 + 36))
            view.backgroundColor = UIColor.whiteColor()
            
            let leftLineView = UIView(frame: CGRectZero)
            let rightLineView = UIView(frame: CGRectZero)
            let titleLabel = UILabel(frame: CGRectZero)
            leftLineView.translatesAutoresizingMaskIntoConstraints = false
            rightLineView.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(leftLineView)
            view.addSubview(rightLineView)
            view.addSubview(titleLabel)
            
            leftLineView.backgroundColor = UIColor.blackColor()
            rightLineView.backgroundColor = UIColor.blackColor()
            titleLabel.font = UIFont.monospacedDigitSystemFontOfSize(14, weight: UIFontWeightMedium).italic()
            titleLabel.text = "5 Locked Moments"
            titleLabel.textAlignment = .Center
            
            let metricsDictionary = ["sidePadding":10, "titleLabelBuffer":7.5]
            let viewsDictionary = ["leftLineView":leftLineView, "rightLineView":rightLineView, "titleLabel":titleLabel]
            
            let titleLabelCenterX = NSLayoutConstraint(item: titleLabel, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0)
            let titleAndLinesH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[leftLineView]-titleLabelBuffer-[titleLabel]-titleLabelBuffer-[rightLineView]-sidePadding-|", options: .AlignAllCenterY, metrics: metricsDictionary, views: viewsDictionary)
            let allV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-titleLabelBuffer-[titleLabel]-titleLabelBuffer-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
            let leftLineViewHeight = NSLayoutConstraint(item: leftLineView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 0.5)
            let rightLineViewHeight = NSLayoutConstraint(item: rightLineView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 0.5)
            view.addConstraints(titleAndLinesH + allV)
            view.addConstraints([titleLabelCenterX, leftLineViewHeight, rightLineViewHeight])
            
            return view
        }
        else{
            return nil
        }

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section != 0{
            let momentDetailVC = MomentDetailViewController()
            momentDetailVC.view.tintColor = Colors.primary
            let momentDetailNC = UINavigationController(rootViewController: momentDetailVC)
            momentDetailNC.navigationBar.tintColor = Colors.primary
            presentViewController(momentDetailNC, animated: true, completion: nil)
        }
        else{
            print(indexPath)
        }
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
