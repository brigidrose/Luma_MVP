//
//  OnboardingViewController.swift
//  Luma
//
//  Created by Chun-Wei Chen on 6/13/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4
import Crashlytics

class OnboardingViewController: UIViewController {

    var loginButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton = UIButton(frame: CGRectZero)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setButtonType("primary")
        loginButton.setTitle("Login with Facebook", forState: .Normal)
        loginButton.addTarget(self, action: #selector(OnboardingViewController.loginButtonTapped(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(loginButton)
        let metricsDictionary = ["sidePadding":20]
        
        let loginButtonH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[loginButton]-sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: ["loginButton" : loginButton])
        view.addConstraints(loginButtonH)
        let loginButtonV = NSLayoutConstraint.constraintsWithVisualFormat("V:[loginButton(56)]-36-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: ["loginButton" : loginButton])
        view.addConstraints(loginButtonV)
        
        view.backgroundColor = Colors.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loginButtonTapped(sender:UIButton) {
        print("login buton tapped")
        sender.enabled = false
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile", "email", "user_friends"], block: {(user:PFUser?, error:NSError?) -> Void in
            if error != nil{
                print(error)
                return
            }
            else if let user = user {
                if user.isNew {
                    if (FBSDKAccessToken.currentAccessToken() != nil){
                        print("token not nil")
                        let parameters:NSMutableDictionary = NSMutableDictionary(dictionary: NSDictionary())
                        parameters.setValue("id,email,location,birthday,first_name,last_name,gender", forKey: "fields")
                        FBSDKGraphRequest(graphPath: "me", parameters: parameters as [NSObject : AnyObject], tokenString: FBSDKAccessToken.currentAccessToken().tokenString, version: "v2.0", HTTPMethod: "GET").startWithCompletionHandler({(connection, result, error) -> Void in
                            print("graph requested")
                            if (error == nil){
                                let user = result as! NSDictionary
                                PFUser.currentUser()!.email = user.objectForKey("email") as? String
                                
                                //only load birthday if it exists in the profile.
                                let dateFormatter = NSDateFormatter()
                                dateFormatter.dateFormat = "MM/dd/yyyy"
                                var birthday:NSDate = dateFormatter.dateFromString("01/01/1900")!
                                if let _ = user["birthday"] {
                                    let birthdayString:String = user.objectForKey("birthday") as! String
                                    let dateFormatter = NSDateFormatter()
                                    if (birthdayString.characters.count == 10){
                                        dateFormatter.dateFormat = "MM/dd/yyyy"
                                    }
                                    else if birthdayString.characters.count == 4{
                                        dateFormatter.dateFormat = "yyyy"
                                    }
                                    else if birthdayString.characters.count == 5{
                                        dateFormatter.dateFormat = "MM/dd"
                                    }
                                    birthday = dateFormatter.dateFromString(birthdayString)!
                                }
                                
                                PFUser.currentUser()?["facebookId"] = user.objectForKey("id")
                                PFUser.currentUser()?["birthday"] = birthday
                                PFUser.currentUser()?["firstName"] = user.objectForKey("first_name")
                                PFUser.currentUser()?["lastName"] = user.objectForKey("last_name")
                                PFUser.currentUser()?["gender"] = user.objectForKey("gender")
                                if let _ = user["location"] {
                                    let locationDictionary = user.objectForKey("location") as! NSDictionary
                                    PFUser.currentUser()?["location"] = locationDictionary["name"]
                                }
                                PFUser.currentUser()?.saveInBackgroundWithBlock({(success, error) -> Void in
                                    if (success){
                                        PFInstallation.currentInstallation()["currentUser"] = PFUser.currentUser()
                                        PFInstallation.currentInstallation().saveInBackgroundWithBlock({(success, error) -> Void in
                                            // TODO: Move this to where you establish a user session
                                            // TODO: Move this to where you establish a user session
                                            self.logUser()
                                            self.dismissViewControllerAnimated(true, completion: nil)
                                            
                                        })
                                    }
                                    else{
                                        print(error)
                                        sender.enabled = true
                                    }
                                })
                            }
                        })
                    }
                    else{
                        print("token is nil")
                        
                    }
                    print("User signed up and logged in through Facebook!")
                } else {
                    print("User logged in through Facebook!")
                    PFInstallation.currentInstallation()["currentUser"] = PFUser.currentUser()
                    PFInstallation.currentInstallation().saveInBackgroundWithBlock({(success, error) -> Void in
                        print("current user saved to current installation")
                        // Check if logged-in user owns a bracelet
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                }
                
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
                sender.enabled = true
            }
        })
    }
    
    func logUser() {
        // TODO: Use the current user's information
        // You can call any combination of these three methods
        Crashlytics.sharedInstance().setUserEmail(PFUser.currentUser()!["email"] as? String)
        Crashlytics.sharedInstance().setUserIdentifier("12345")
        Crashlytics.sharedInstance().setUserName("\(PFUser.currentUser()!["firstName"] as? String) \(PFUser.currentUser()!["lastName"] as? String)")
    }

}
