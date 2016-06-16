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
import Parse
import SDWebImage
import MapKit

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
    
    var streams:[Stream] = []
    var charms:[Charm] = []
    var participantsInFocus:[PFUser] = []
    var lockedMomentsInFocus:[Moment] = []
    var momentsInFocus:[Moment] = []
    
    var streamSummaryLoaded = false
    
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
        streamTV.registerClass(StreamSummaryTableViewCell.self, forCellReuseIdentifier: "StreamSummaryTableViewCell")
        streamTV.registerClass(MomentTableViewCell.self, forCellReuseIdentifier: "MomentTableViewCell")
        streamTV.registerClass(GeoLockedMomentTableViewCell.self, forCellReuseIdentifier: "GeoLockedMomentTableViewCell")
        streamTV.registerClass(TimeLockedMomentTableViewCell.self, forCellReuseIdentifier: "TimeLockedMomentTableViewCell")
        streamTV.registerClass(StreamAnnotationTableViewCell.self, forCellReuseIdentifier: "StreamAnnotationTableViewCell")
        streamTV.estimatedRowHeight = 150
        streamTV.rowHeight = UITableViewAutomaticDimension
        streamTV.contentOffset.y = -64
        streamTV.contentInset.top = 64
        streamTV.contentInset.bottom = 44 + 92
        streamTV.scrollIndicatorInsets.top = 64
        streamTV.separatorStyle = .None
        
        streamTableViewController.tableView = streamTV
        view.addSubview(streamTV)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.itemSize = CGSizeMake(50, 50)
        layout.minimumInteritemSpacing = 10
        layout.sectionInset.right = 10
        streamGalleryCV = TPKeyboardAvoidingCollectionView(frame: CGRectZero, collectionViewLayout: layout)
        streamGalleryCV.translatesAutoresizingMaskIntoConstraints = false
        streamGalleryCV.backgroundColor = Colors.white
        streamGalleryCV.alwaysBounceHorizontal = true
        streamGalleryCV.delegate = self
        streamGalleryCV.dataSource = self
        streamGalleryCV.scrollsToTop = false
        streamGalleryCV.registerClass(StreamGalleryCollectionViewCell.self, forCellWithReuseIdentifier: "StreamGalleryCollectionViewCell")
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

        
        toggleVisibility()

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(MainViewController.streamRefreshed), forControlEvents: .ValueChanged)
        streamTV.addSubview(refreshControl)

    }
    
    func toggleVisibility() {
        if streams.count == 0{
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if PFUser.currentUser() == nil{
            let onboardingVC = OnboardingViewController()
            presentViewController(onboardingVC, animated: true, completion: nil)
        }
        else{
            loadCharms()
        }

    }
    
    func newMomentButtonTapped() {
        print("new moment button tapped")
        let newMomentVC = NewMomentViewController()
        let newMomentNC = UINavigationController(rootViewController: newMomentVC)
        newMomentNC.view.tintColor = Colors.primary
        presentViewController(newMomentNC, animated: true, completion: nil)
    }
    
    func streamRefreshed() {
        print("stream refreshed")
        refreshControl.beginRefreshing()
        loadCharms()
    }
    
    func addParticipantButtonTapped() {
        print("add participant button tapped")
        let streamSettingsVC = StreamSettingsViewController()
        streamSettingsVC.stream = streams[streamGallerySelectedIndexPath.item]
        let streamSettingsNC = UINavigationController(rootViewController: streamSettingsVC)
        streamSettingsNC.view.tintColor = Colors.primary
        presentViewController(streamSettingsNC, animated: true, completion: {
            streamSettingsVC.transitionToParticipants()
        })
        
    }
    
    func streamSettingsButtonTapped() {
        print("stream settings button tapped")
        
        let streamSettingsVC = StreamSettingsViewController()
        streamSettingsVC.stream = streams[streamGallerySelectedIndexPath.item]
        let streamSettingsNC = UINavigationController(rootViewController: streamSettingsVC)
        streamSettingsNC.view.tintColor = Colors.primary
        presentViewController(streamSettingsNC, animated: true, completion: nil)
    }
    
    // MARK: Table View Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if streams.count > 0{
            return 3
        }
        else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if streams.count > 0{
            if section == 0{
                return 1
            }
            else{
                // locked section
                if section == 1{
                    return lockedMomentsInFocus.count
                }
                else{
                    return momentsInFocus.count
                }
            }
        }
        else{
            return 0
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
                let cell = tableView.dequeueReusableCellWithIdentifier("StreamSummaryTableViewCell") as! StreamSummaryTableViewCell
                print("streamGallerySelectedIndexPath.item is \(streamGallerySelectedIndexPath.item)")
                cell.titleLabel.text = streams[streamGallerySelectedIndexPath.item].title

                if !streamSummaryLoaded{
                    for subView in cell.participantsStackView.arrangedSubviews{
                        cell.participantsStackView.removeArrangedSubview(subView)
                        subView.removeFromSuperview()
                    }
                    let button = UIButton()
                    button.imageView?.contentMode = .ScaleAspectFit
                    button.layer.cornerRadius = 15
                    button.clipsToBounds = true
                    let url = NSURL(string: "https://graph.facebook.com/\(self.streams[streamGallerySelectedIndexPath.item].author["facebookId"] as! String)/picture?type=large")
                    button.sd_setImageWithURL(url, forState: .Normal, placeholderImage: UIImage(named: "streamParticipantIcon"))
                    button.addConstraint(NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 30))
                    cell.participantsStackView.addArrangedSubview(button)
                    var count = 0
                    for _ in 0...self.participantsInFocus.count - 1{
                        let button = UIButton()
                        button.imageView?.contentMode = .ScaleAspectFit
                        button.layer.cornerRadius = 15
                        button.clipsToBounds = true
                        let url = NSURL(string: "https://graph.facebook.com/\(self.participantsInFocus[count]["facebookId"] as! String)/picture?type=large")
                        button.sd_setImageWithURL(url, forState: .Normal, placeholderImage: UIImage(named: "streamParticipantIcon"))
                        button.addConstraint(NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 30))
                        cell.participantsStackView.addArrangedSubview(button)
                        count += 1
                    }

                    cell.addParticipantButton.addTarget(self, action: #selector(MainViewController.addParticipantButtonTapped), forControlEvents: .TouchUpInside)
                    cell.settingsButton.addTarget(self, action: #selector(MainViewController.streamSettingsButtonTapped), forControlEvents: .TouchUpInside)
                    streamSummaryLoaded = true
                }
                return cell
            }
        }
        else{
            if momentsInFocus.count == 0 && indexPath.section == 2{
                if indexPath.row == 0{
                    let cell = tableView.dequeueReusableCellWithIdentifier("StreamAnnotationTableViewCell") as! StreamAnnotationTableViewCell
                    cell.label.attributedText = NSAttributedString(string: "No Moments")
                    return cell
                }
            }
            let moment:Moment
            if indexPath.section == 1{
                moment = lockedMomentsInFocus[indexPath.row]
            }
            else{
                moment = momentsInFocus[indexPath.row]
            }
            if !moment.locked{
                let cell = tableView.dequeueReusableCellWithIdentifier("MomentTableViewCell") as! MomentTableViewCell
                cell.actionLabel.text = "\(moment.author["firstName"]) added a moment"
                cell.contentLabel.text = moment.narrative
                if (moment.author["facebookId"] != nil){
                    let id = moment.author["facebookId"] as! String
                    let url = NSURL(string: "https://graph.facebook.com/\(id)/picture?type=large")
                    cell.userButton.sd_setImageWithURL(url, forState: .Normal)
                }
                return cell
            }
            else if moment.unlockType == "date"{
                let cell = tableView.dequeueReusableCellWithIdentifier("TimeLockedMomentTableViewCell") as! TimeLockedMomentTableViewCell
                cell.unlockCountdownLabel.setCountDownDate(moment.unlockDate)
                cell.unlockCountdownLabel.start()
                cell.actionLabel.text = "\(moment.author["firstName"]) added a moment to unlock in"
                if (moment.author["facebookId"] != nil){
                    let id = moment.author["facebookId"] as! String
                    let url = NSURL(string: "https://graph.facebook.com/\(id)/picture?type=large")
                    cell.userButton.sd_setImageWithURL(url, forState: .Normal)
                }
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCellWithIdentifier("GeoLockedMomentTableViewCell") as! GeoLockedMomentTableViewCell
                let unlockCoordinate = CLLocationCoordinate2D(latitude: moment.unlockLocation.latitude, longitude:moment.unlockLocation.longitude)
                cell.mapView.setRegion(MKCoordinateRegion(center: unlockCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)), animated: false)
                let mapPin = MapPin(coordinate: unlockCoordinate)
                cell.mapView.addAnnotation(mapPin)
                cell.actionLabel.text = "\(moment.author["firstName"]) added a moment to unlock nearby"
                if (moment.author["facebookId"] != nil){
                    let id = moment.author["facebookId"] as! String
                    let url = NSURL(string: "https://graph.facebook.com/\(id)/picture?type=large")
                    cell.userButton.sd_setImageWithURL(url, forState: .Normal)
                }
                return cell
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 0 && section < tableView.numberOfSections - 1{
            if lockedMomentsInFocus.count > 0{
                return 28
            }
            else{
                return 0
            }
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
            titleLabel.text = "\(tableView.numberOfRowsInSection(1)) Locked Moments"
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
        if indexPath.section == 2{
            let momentDetailVC = MomentDetailViewController()
            momentDetailVC.moment = momentsInFocus[indexPath.row]
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
            return 0
        }
        else{
            return streams.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("StreamGalleryCollectionViewCell", forIndexPath: indexPath) as! StreamGalleryCollectionViewCell
//        cell.backgroundColor = Colors.primary.colorWithAlphaComponent(0.5)
        if indexPath.section == 1{
            if indexPath.item < charms.count{
                let model = charms[indexPath.item].model
                cell.streamProfileImageView.sd_setImageWithURL(NSURL(string:model.heroImage.url!))
            }
            else{
                // current user not author of stream
                cell.streamProfileImageView.backgroundColor = Colors.offWhite
            }
        }
        if indexPath != streamGallerySelectedIndexPath{
            cell.alpha = 0.5
        }
        else{
            cell.alpha = 1
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        streamGallerySelectedIndexPath = indexPath
        loadCharms()
    }
    
    // MARK: Navigation Bar Button Taps
    
    func accountBarButtonItemTapped(sender:UIBarButtonItem){
        let accountVC = AccountViewController()
        let accountNC = UINavigationController(rootViewController: accountVC)
        accountNC.view.tintColor = Colors.primary
        presentViewController(accountNC, animated: true, completion: nil)
    }
    
    func devicesBarButtonItemTapped(sender:UIBarButtonItem){
        let devicesVC = DevicesViewController()
        let devicesNC = UINavigationController(rootViewController: devicesVC)
        devicesNC.view.tintColor = Colors.primary
        presentViewController(devicesNC, animated: true, completion: nil)
    }
    
    func noFeedActionButtonTapped(sender:UIButton){
        let storeVC = LumaStoreViewController()
        let storeNC = UINavigationController(rootViewController: storeVC)
        storeNC.navigationBar.tintColor = Colors.primary
        presentViewController(storeNC, animated: true, completion: nil)
        
    }
    
    func loadCharms() {
        streamSummaryLoaded = false
        let loadCharmsQuery = PFQuery(className: "Charm")
        loadCharmsQuery.whereKey("owner", equalTo: PFUser.currentUser()!)
        loadCharmsQuery.includeKeys(["gifter", "model", "owner", "stream"])
        loadCharmsQuery.findObjectsInBackgroundWithBlock { (charms, error) in
            if error != nil{
                print(error)
            }
            else{
                self.streams.removeAll()
                self.charms = charms as! [Charm]
                for charm in charms as! [Charm]{
                    self.streams.append(charm.stream)
                }
                // load streams in which current user is not author and is contained in participants
                let loadParticipatingStreamsQuery = PFQuery(className: "Stream")
                loadParticipatingStreamsQuery.whereKey("author", notEqualTo: PFUser.currentUser()!)
                loadParticipatingStreamsQuery.whereKey("participants", equalTo: PFUser.currentUser()!)
                loadParticipatingStreamsQuery.findObjectsInBackgroundWithBlock({ (streams, error) in
                    if error != nil{
                        print(error)
                    }
                    else{
                        self.streams.appendContentsOf(streams as! [Stream])
                        let streamInFocus = self.streams[self.streamGallerySelectedIndexPath.item]
                        streamInFocus.participants.query().findObjectsInBackgroundWithBlock({ (participants, error) in
                            if error != nil{
                                print(error)
                            }
                            else{
                                self.participantsInFocus.removeAll()
                                self.participantsInFocus = participants as! [PFUser]
//                                self.streamTV.reloadRowsAtIndexPaths([NSIndexPath(forRow:0,inSection:0)], withRowAnimation: .Automatic)
                                let momentsQuery = streamInFocus.moments.query()
                                momentsQuery.includeKeys(["author"])
                                momentsQuery.orderByDescending("createdAt")
                                momentsQuery.findObjectsInBackgroundWithBlock({ (moments, error) in
                                    if error != nil{
                                        print(error)
                                    }
                                    else{
                                        self.lockedMomentsInFocus.removeAll()
                                        self.momentsInFocus.removeAll()
                                        for moment in moments as! [Moment]{
                                            if moment.locked{
                                                self.lockedMomentsInFocus.append(moment)
                                                if moment.unlockType == "date"{
                                                    let notification = UILocalNotification()
                                                    notification.fireDate = moment.unlockDate
                                                    notification.alertBody = "It's time to unlock \(moment.author["firstName"])'s moment in \(moment.inStream.title)"
                                                    notification.alertAction = "Unlock"
                                                    notification.soundName = UILocalNotificationDefaultSoundName
                                                    notification.userInfo = ["momentId":"\(moment.objectId!)"]
                                                    UIApplication.sharedApplication().scheduleLocalNotification(notification)
                                                }
                                            }
                                            else{
                                                self.momentsInFocus.append(moment)
                                            }
                                        }
                                        self.refreshControl.endRefreshing()
                                        self.toggleVisibility()
                                        self.streamGalleryCV.reloadData()
                                        self.streamTV.reloadData()
                                    }
                                })
                            }
                        })
                    }
                })
            }
        }
    }
}
