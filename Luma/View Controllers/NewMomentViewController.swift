//
//  NewMomentViewController.swift
//  Luma
//
//  Created by Chun-Wei Chen on 6/6/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit

class NewMomentViewController: UIViewController {

    var toolBarBottom:UIToolbar!
    var streamSelectionButton:UIButton!
    var momentContentTableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        navigationItem.title = "Moment"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .Done, target: self, action: #selector(NewMomentViewController.createButtonTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(NewMomentViewController.cancelButtonTapped))
        
        toolBarBottom = UIToolbar(frame: CGRectZero)
        toolBarBottom.translatesAutoresizingMaskIntoConstraints = false
        let addMediaButton = UIBarButtonItem(image: UIImage(named: "addMediaButtonIcon"), style: .Plain, target: self, action: #selector(NewMomentViewController.addMediaButtonTapped))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let addUnlockButton = UIBarButtonItem(image: UIImage(named: "addUnlockSettingsIcon"), style: .Plain, target: self, action: #selector(NewMomentViewController.addUnlockSettingsButtonTapped))
        toolBarBottom.tintColor = Colors.primary
        toolBarBottom.items = [addMediaButton, flexSpace, addUnlockButton]
        self.view.addSubview(toolBarBottom)
        
        let toolBarBottomPinConstraint = NSLayoutConstraint(item: toolBarBottom, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.bottomLayoutGuide, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        let toolBarBottomHeightConstraint = NSLayoutConstraint(item: toolBarBottom, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 44)
        let toolBarBottomWidthConstraint = NSLayoutConstraint(item: toolBarBottom, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        
        self.view.addConstraint(toolBarBottomPinConstraint)
        self.view.addConstraint(toolBarBottomHeightConstraint)
        self.view.addConstraint(toolBarBottomWidthConstraint)
        
        toolBarBottom.removeFromSuperview()

        view.backgroundColor = Colors.white
        
        
        
        let momentContentTVC = UITableViewController()
        addChildViewController(momentContentTVC)
        
        momentContentTVC.tableView = UITableView(frame: CGRectZero)
        momentContentTVC.tableView.translatesAutoresizingMaskIntoConstraints = false
        momentContentTableView = momentContentTVC.tableView
//        momentContentTableView.contentInset.top = 64
        momentContentTableView.contentInset.bottom = 44
        view.addSubview(momentContentTableView)
        
        let streamThumbnailImageView = UIImageView(frame: CGRectZero)
        streamThumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        streamThumbnailImageView.layer.cornerRadius = 22
        streamThumbnailImageView.contentMode = .ScaleAspectFill
        streamThumbnailImageView.backgroundColor = Colors.offWhite
        
        let streamSelectionLabel = UILabel(frame: CGRectZero)
        streamSelectionLabel.translatesAutoresizingMaskIntoConstraints = false
        streamSelectionLabel.textAlignment = .Left
        streamSelectionLabel.text = "Select Moment Stream"
        streamSelectionLabel.font = UIFont.systemFontOfSize(17)
        
        let streamSelectionSeparatorView = UIView(frame: CGRectZero)
        streamSelectionSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        streamSelectionSeparatorView.backgroundColor = Colors.offWhite
        
        streamSelectionButton = UIButton(type: .Custom)
        streamSelectionButton.frame = CGRectZero
        streamSelectionButton.translatesAutoresizingMaskIntoConstraints = false
        streamSelectionButton.backgroundColor = Colors.white
        streamSelectionButton.setBackgroundColor(Colors.offWhite, forUIControlState: .Highlighted)
        streamSelectionButton.addTarget(self, action: #selector(NewMomentViewController.streamSelectionButtonTapped), forControlEvents: .TouchUpInside)
        streamSelectionButton.addSubview(streamThumbnailImageView)
        streamSelectionButton.addSubview(streamSelectionLabel)
        streamSelectionButton.addSubview(streamSelectionSeparatorView)
        view.addSubview(streamSelectionButton)
        
        
        let viewsDictionary = ["momentContentTableView":momentContentTableView, "topLayoutGuide":topLayoutGuide, "bottomLayoutGuide":bottomLayoutGuide, "streamSelectionButton":streamSelectionButton, "streamThumbnailImageView":streamThumbnailImageView, "streamSelectionLabel":streamSelectionLabel, "streamSelectionSeparatorView":streamSelectionSeparatorView]
        let metricsDictionary = ["sidePadding":15, "buttonPadding":10]
        
        let buttonViewsH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-buttonPadding-[streamThumbnailImageView(44)]-buttonPadding-[streamSelectionLabel]-buttonPadding-|", options: .AlignAllCenterY, metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        
        let buttonSeparatorH = NSLayoutConstraint.constraintsWithVisualFormat("H:|[streamSelectionSeparatorView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        
        let buttonViewsV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-buttonPadding-[streamThumbnailImageView(44)]-9-[streamSelectionSeparatorView(1)]|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        
        streamSelectionButton.addConstraints(buttonViewsH)
        streamSelectionButton.addConstraints(buttonViewsV)
        streamSelectionButton.addConstraints(buttonSeparatorH)
        
        let tableViewHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[momentContentTableView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String : AnyObject])
        let tableViewVConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[topLayoutGuide][momentContentTableView][bottomLayoutGuide]", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String : AnyObject])
        
        view.addConstraints(tableViewHConstraints)
        view.addConstraints(tableViewVConstraints)
        
        let streamSelectionButtonH = NSLayoutConstraint.constraintsWithVisualFormat("H:|[streamSelectionButton]|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        let streamSelectionButtonV = NSLayoutConstraint.constraintsWithVisualFormat("V:[topLayoutGuide][streamSelectionButton(64)]", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        
        view.addConstraints(streamSelectionButtonH)
        view.addConstraints(streamSelectionButtonV)
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }

    
    override var inputAccessoryView: UIView?{
        return toolBarBottom
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func streamSelectionButtonTapped() {
        print("stream selection button tapped")
        let streamSelectionVC = StreamSelectionViewController()
        let streamSelectionNC = UINavigationController(rootViewController:streamSelectionVC)
        streamSelectionNC.view.tintColor = Colors.primary
        presentViewController(streamSelectionNC, animated: true, completion: nil)
    }
    
    func createButtonTapped() {
        print("create button tapped")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func cancelButtonTapped() {
        print("cancel button tapped")
        resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addMediaButtonTapped() {
        print("add media button tapped")
    }
    
    func addUnlockSettingsButtonTapped(){
        print("add unlock settings button tapped")
        let unlockSettingsVC = UnlockSettingsViewController()
        let unlockSettingsNC = UINavigationController(rootViewController: unlockSettingsVC)
        unlockSettingsNC.view.tintColor = Colors.primary
        presentViewController(unlockSettingsNC, animated: true, completion: nil)
    }


}
