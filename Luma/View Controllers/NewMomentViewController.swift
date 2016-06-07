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

        
        navigationItem.title = "New Moment"
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
        
        
        streamSelectionButton = UIButton(type: .Custom)
        streamSelectionButton.frame = CGRectZero
        streamSelectionButton.translatesAutoresizingMaskIntoConstraints = false
        streamSelectionButton.backgroundColor = Colors.primary
        view.addSubview(streamSelectionButton)
        
        let momentContentTVC = UITableViewController()
        addChildViewController(momentContentTVC)
        
        momentContentTVC.tableView = UITableView(frame: CGRectZero)
        momentContentTVC.tableView.translatesAutoresizingMaskIntoConstraints = false
        momentContentTableView = momentContentTVC.tableView
        momentContentTableView.contentInset.top = 64
        momentContentTableView.contentInset.bottom = 44
        view.addSubview(momentContentTableView)
        
        let viewsDictionary = ["momentContentTableView":momentContentTableView, "topLayoutGuide":topLayoutGuide, "bottomLayoutGuide":bottomLayoutGuide, "streamSelectionButton":streamSelectionButton]
        let metricsDictionary = ["sidePadding":15]
        
        let tableViewHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[momentContentTableView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String : AnyObject])
        let tableViewVConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[topLayoutGuide][momentContentTableView][bottomLayoutGuide]", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String : AnyObject])
        
        view.addConstraints(tableViewHConstraints)
        view.addConstraints(tableViewVConstraints)
        
        
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
    
    func createButtonTapped() {
        print("create button tapped")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func cancelButtonTapped() {
        print("cancel button tapped")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addMediaButtonTapped() {
        print("add media button tapped")
    }
    
    func addUnlockSettingsButtonTapped(){
        print("add unlock settings button tapped")
    }


}
