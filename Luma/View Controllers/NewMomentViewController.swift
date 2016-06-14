//
//  NewMomentViewController.swift
//  Luma
//
//  Created by Chun-Wei Chen on 6/6/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit
import QBImagePickerController
import IQKeyboardManagerSwift
import Parse

class NewMomentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, QBImagePickerControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var toolBarBottom:UIToolbar!
    var streamSelectionButton:UIButton!
    var momentContentTableView:UITableView!
    var imagePickerVC = QBImagePickerController()
    var cameraVC = UIImagePickerController()
    var photos:[UIImage] = []
    var captions:[String] = []
    var momentNarrative:String = ""
    var inStream:Stream!
    var locked = false
    var unlockDate:NSDate?
    var unlockLocation:PFGeoPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePickerVC.delegate = self
        imagePickerVC.allowsMultipleSelection = true
        imagePickerVC.maximumNumberOfSelection = 10
        imagePickerVC.showsNumberOfSelectedAssets = true
        imagePickerVC.mediaType = .Image
        imagePickerVC.view.tintColor = Colors.primary
        
        cameraVC.delegate = self
        cameraVC.view.tintColor = Colors.primary
        
        navigationItem.title = "Moment"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .Done, target: self, action: #selector(NewMomentViewController.createButtonTapped(_:)))
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
        momentContentTableView.registerClass(TextViewTableViewCell.self, forCellReuseIdentifier: "TextViewTableViewCell")
        momentContentTableView.registerClass(ImageWithCaptionTableViewCell.self, forCellReuseIdentifier: "ImageWithCaptionTableViewCell")
        momentContentTableView.delegate = self
        momentContentTableView.dataSource = self
        momentContentTableView.rowHeight = UITableViewAutomaticDimension
        momentContentTableView.estimatedRowHeight = 44
        momentContentTableView.separatorStyle = .None
        view.addSubview(momentContentTableView)
        
        let streamThumbnailImageView = UIImageView(frame: CGRectZero)
        streamThumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        streamThumbnailImageView.layer.cornerRadius = 22
        streamThumbnailImageView.contentMode = .ScaleAspectFill
        streamThumbnailImageView.backgroundColor = Colors.offWhite
        
        let streamSelectionLabel = UILabel(frame: CGRectZero)
        streamSelectionLabel.translatesAutoresizingMaskIntoConstraints = false
        streamSelectionLabel.textAlignment = .Left
        streamSelectionLabel.text = "Select Stream"
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.becomeFirstResponder()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        else{
            return photos.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("TextViewTableViewCell") as! TextViewTableViewCell
            cell.textView.delegate = self
            cell.textView.returnKeyType = .Done
            cell.textView.text = momentNarrative
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("ImageWithCaptionTableViewCell") as! ImageWithCaptionTableViewCell
            cell.momentImageCaptionTextView.delegate = self
            cell.momentImageView.image = photos[indexPath.row]
            cell.momentImageCaptionTextView.text = captions[(indexPath.row)]
            return cell
        }
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
        streamSelectionVC.newMomentVC = self
        let streamSelectionNC = UINavigationController(rootViewController:streamSelectionVC)
        streamSelectionNC.view.tintColor = Colors.primary
        presentViewController(streamSelectionNC, animated: true, completion: nil)
    }
    
    func createButtonTapped(sender:UIBarButtonItem) {
        print("create button tapped")
        sender.enabled = false
        let newMoment = Moment()
        newMoment.inStream = inStream
        newMoment.author = PFUser.currentUser()!
        newMoment.narrative = momentNarrative
        if unlockDate != nil || unlockLocation != nil{
            locked = true
            newMoment.locked = locked
        }
        if unlockLocation != nil{
            newMoment.unlockLocation = unlockLocation!
            newMoment.unlockType = "location"
        }
        if unlockDate != nil{
            newMoment.unlockDate = unlockDate!
            newMoment.unlockType = "date"
        }
        var count = 0
        var mediaSaveCount = 0
        if photos.count > 0{
            for photo in photos{
                let media = Media(className: "Media")
                media.file = PFFile(data: UIImagePNGRepresentation(photo)!)!
                media.caption = captions[count]
                count += 1
                media.saveInBackgroundWithBlock({ (success, error) in
                    if error != nil{
                        print(error)
                    }
                    else{
                        newMoment.medias.addObject(media)
                        newMoment.saveInBackgroundWithBlock({ (success, error) in
                            if error != nil{
                                print(error)
                            }
                            else{
                                mediaSaveCount += 1
                                if mediaSaveCount == self.photos.count{
                                    self.inStream.moments.addObject(newMoment)
                                    self.inStream.saveInBackgroundWithBlock({ (success, error) in
                                        if success{
                                            self.resignFirstResponder()
                                            self.dismissViewControllerAnimated(true, completion: nil)
                                        }
                                        else{
                                            print(error)
                                        }
                                    })
                                    
                                }
                            }
                        })
                    }
                })
            }
        }
        else{
            newMoment.saveInBackgroundWithBlock({ (success, error) in
                if error != nil{
                    print(error)
                }
                else{
                    self.inStream.moments.addObject(newMoment)
                    self.inStream.saveInBackgroundWithBlock({ (success, error) in
                        if success{
                            self.resignFirstResponder()
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                        else{
                            print(error)
                        }
                    })
                }
            })
        }
        
    }
    
    func cancelButtonTapped() {
        print("cancel button tapped")
        view.endEditing(true)
        resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addMediaButtonTapped() {
        print("add media button tapped")
        let actionSheetAlertController = UIAlertController(title: "Choose an Image Source", message: nil, preferredStyle: .ActionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .Default) { (action) in
            self.cameraVC.sourceType = .Camera
            self.presentViewController(self.cameraVC, animated: true, completion: nil)
        }
        
        let libraryAction = UIAlertAction(title: "Photo Library", style: .Default) { (action) in
            self.presentViewController(self.imagePickerVC, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            print("cancel button tapped")
        }
        actionSheetAlertController.addAction(cameraAction)
        actionSheetAlertController.addAction(libraryAction)
        actionSheetAlertController.addAction(cancelAction)
        presentViewController(actionSheetAlertController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photos.removeAll()
            photos.append(pickedImage)
            
        }
        captions.removeAll()
        captions = Array(count: photos.count, repeatedValue: "")
        momentContentTableView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func qb_imagePickerController(imagePickerController: QBImagePickerController!, didFinishPickingAssets assets: [AnyObject]!) {
        photos.removeAll()
        for asset in assets{
            let image = getAssetCropped(asset as! PHAsset)
            photos.append(image)
        }
        captions.removeAll()
        captions = Array(count: photos.count, repeatedValue: "")
        momentContentTableView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func qb_imagePickerControllerDidCancel(imagePickerController: QBImagePickerController!) {
        self.becomeFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addUnlockSettingsButtonTapped(){
        print("add unlock settings button tapped")
        let unlockSettingsVC = UnlockSettingsViewController()
        unlockSettingsVC.newMomentVC = self
        let unlockSettingsNC = UINavigationController(rootViewController: unlockSettingsVC)
        unlockSettingsNC.view.tintColor = Colors.primary
        presentViewController(unlockSettingsNC, animated: true, completion: nil)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
            return false
        }
        else{
            return true
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        let indexPath = momentContentTableView.indexPathForRowAtPoint(textView.convertPoint(CGPointZero, toView: momentContentTableView))
        if indexPath?.section == 1{
            captions[(indexPath?.row)!] = textView.text
        }
        else{
            momentNarrative = textView.text
        }
    }
    
    func getAssetCropped(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.defaultManager()
        let option = PHImageRequestOptions()
        option.resizeMode = .Fast
        var cropped = UIImage()
        option.synchronous = true
        manager.requestImageForAsset(asset, targetSize: CGSize(width: 1500.0, height: 1500.0), contentMode: .AspectFit, options: option, resultHandler: {(result, info)->Void in
            cropped = result!
        })
        return cropped
    }
    
    func updateSelectedStreamButton() {
        for subview in streamSelectionButton.subviews{
            if subview.isMemberOfClass(UILabel){
                (subview as! UILabel).text = inStream.title
            }
        }
    }



}
