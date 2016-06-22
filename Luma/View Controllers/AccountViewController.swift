//
//  AccountViewController.swift
//  Luma
//
//  Created by Chun-Wei Chen on 6/8/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4
import SDWebImage
import Crashlytics
class AccountViewController: UIViewController {

    var userProfileImageView:UIImageView!
    var userNameLabel:UILabel!
    var userEmailLabel:UILabel!
    
    var editAccountButton:UIButton!
    var orderHistoryButton:UIButton!
    var contactSupportButton:UIButton!
    
    var privacyPolicyButton:UIButton!
    var termsConditionsButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Account"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"CloseBarButtonItem" ), style: .Plain, target: self, action: #selector(AccountViewController.closeButtonTapped))
        
        view.backgroundColor = Colors.white
        
        userProfileImageView = UIImageView(frame: CGRectZero)
        userProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        userProfileImageView.layer.cornerRadius = 55
        userProfileImageView.contentMode = .ScaleAspectFill
        userProfileImageView.backgroundColor = Colors.offWhite
        userProfileImageView.clipsToBounds = true
        view.addSubview(userProfileImageView)
        
        userNameLabel = UILabel(frame: CGRectZero)
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.textAlignment = .Center
        userNameLabel.text = "First Last"
        userNameLabel.font = UIFont.systemFontOfSize(20, weight: UIFontWeightMedium)
        view.addSubview(userNameLabel)
        
        userEmailLabel = UILabel(frame: CGRectZero)
        userEmailLabel.translatesAutoresizingMaskIntoConstraints = false
        userEmailLabel.textAlignment = .Center
        userEmailLabel.text = "Email"
        userEmailLabel.font = UIFont.systemFontOfSize(16)
        view.addSubview(userEmailLabel)
        
        editAccountButton = UIButton(frame: CGRectZero)
        editAccountButton.translatesAutoresizingMaskIntoConstraints = false
        editAccountButton.setButtonType("primary")
        editAccountButton.setTitle("Logout", forState: .Normal)
        editAccountButton.addTarget(self, action: #selector(AccountViewController.editAccountButtonTapped(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(editAccountButton)
        
        orderHistoryButton = UIButton(frame: CGRectZero)
        orderHistoryButton.translatesAutoresizingMaskIntoConstraints = false
        orderHistoryButton.setButtonType("primary")
        orderHistoryButton.setTitle("Order History", forState: .Normal)
        orderHistoryButton.addTarget(self, action: #selector(AccountViewController.orderHistoryButtonTapped(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(orderHistoryButton)

        contactSupportButton = UIButton(frame: CGRectZero)
        contactSupportButton.translatesAutoresizingMaskIntoConstraints = false
        contactSupportButton.setButtonType("primary")
        contactSupportButton.setTitle("Contact Support", forState: .Normal)
        contactSupportButton.addTarget(self, action: #selector(AccountViewController.contactSupportButtonTapped(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(contactSupportButton)
        
        privacyPolicyButton = UIButton(frame: CGRectZero)
        privacyPolicyButton.translatesAutoresizingMaskIntoConstraints = false
        privacyPolicyButton.setTitle("Privacy Policy", forState: .Normal)
        privacyPolicyButton.titleLabel?.textAlignment = .Left
        privacyPolicyButton.titleLabel?.font = UIFont.systemFontOfSize(18, weight: UIFontWeightMedium)
        privacyPolicyButton.setTitleColor(Colors.grayTextColor, forState: .Normal)
        privacyPolicyButton.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
        view.addSubview(privacyPolicyButton)
        
        termsConditionsButton = UIButton(frame: CGRectZero)
        termsConditionsButton.translatesAutoresizingMaskIntoConstraints = false
        termsConditionsButton.setTitle("Terms & Conditions", forState: .Normal)
        termsConditionsButton.titleLabel?.textAlignment = .Right
        termsConditionsButton.titleLabel?.font = UIFont.systemFontOfSize(18, weight: UIFontWeightMedium)
        termsConditionsButton.setTitleColor(Colors.grayTextColor, forState: .Normal)
        termsConditionsButton.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
        view.addSubview(termsConditionsButton)
        
        let viewsDictionary = ["userProfileImageView":userProfileImageView, "userNameLabel":userNameLabel, "userEmailLabel":userEmailLabel, "topLayoutGuide":topLayoutGuide, "editAccountButton":editAccountButton, "orderHistoryButton":orderHistoryButton, "contactSupportButton":contactSupportButton, "privacyPolicyButton":privacyPolicyButton, "termsConditionsButton":termsConditionsButton]
        let metricsDictionary = ["topPadding":40, "midPadding":20, "bottomPadding":5, "sidePadding":15, "largeSidePadding":20]
        
        let userProfileImageViewWidth = NSLayoutConstraint.constraintsWithVisualFormat("H:[userProfileImageView(110)]", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        let userProfileImageViewV = NSLayoutConstraint.constraintsWithVisualFormat("V:[topLayoutGuide]-topPadding-[userProfileImageView(110)]-midPadding-[userNameLabel]-bottomPadding-[userEmailLabel]", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        let userProfileImageViewCenterX = NSLayoutConstraint(item: userProfileImageView, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0)
        let userNameLabelH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[userNameLabel]-sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        let userEmailLabelH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[userEmailLabel]-sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        
        view.addConstraints(userProfileImageViewWidth)
        view.addConstraints(userProfileImageViewV)
        view.addConstraint(userProfileImageViewCenterX)
        view.addConstraints(userNameLabelH)
        view.addConstraints(userEmailLabelH)
        
        let userAccountButtonH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-largeSidePadding-[editAccountButton]-largeSidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        let buttonsYLeading = NSLayoutConstraint.constraintsWithVisualFormat("V:[userEmailLabel]-60-[editAccountButton]", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        let buttonsV = NSLayoutConstraint.constraintsWithVisualFormat("V:[editAccountButton(56)]-sidePadding-[orderHistoryButton(56)]-sidePadding-[contactSupportButton(56)]", options: [.AlignAllLeft, .AlignAllRight], metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        
        view.addConstraints(userAccountButtonH)
        view.addConstraints(buttonsYLeading)
        view.addConstraints(buttonsV)
        
        let docsButtonsH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-largeSidePadding-[privacyPolicyButton]->=0-[termsConditionsButton]-largeSidePadding-|", options: .AlignAllCenterY, metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        let docsButtonsV = NSLayoutConstraint.constraintsWithVisualFormat("V:[privacyPolicyButton]-25-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        
        view.addConstraints(docsButtonsH)
        view.addConstraints(docsButtonsV)
        
        
        var fullName:String = "No Name"
        if (PFUser.currentUser()!["firstName"] != nil && PFUser.currentUser()!["lastName"] != nil){
            fullName = (PFUser.currentUser()!["firstName"] as! String) + " " + (PFUser.currentUser()!["lastName"] as! String)
        }
        userNameLabel.text = fullName
        userEmailLabel.text = PFUser.currentUser()!["email"] as? String
        fetchProfileImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchProfileImage() {
        if (PFUser.currentUser()!["facebookId"] != nil){
            let id = PFUser.currentUser()!["facebookId"] as! String
            let url = NSURL(string: "https://graph.facebook.com/\(id)/picture?width=500&height=500")
            userProfileImageView.sd_setImageWithURL(url)
        }
    }
    

    func closeButtonTapped() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func editAccountButtonTapped(sender:UIButton) {
        sender.enabled = false
        print("edit account button tapped")
        PFUser.logOutInBackgroundWithBlock { (error) in
            if error == nil{
                self.dismissViewControllerAnimated(true, completion:nil)
            }
            else{
                print(error)
                sender.enabled = true
            }
        }
    }
    
    func orderHistoryButtonTapped(sender:UIButton) {
        print("order history button tapped")
    }
    
    func contactSupportButtonTapped(sender:UIButton) {
        print("contact support button tapped")
    }

}
