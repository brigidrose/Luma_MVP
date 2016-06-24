//
//  ProductScannerViewController.swift
//  Luma
//
//  Created by Chun-Wei Chen on 6/15/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit
import swiftScan
import Parse

class ProductScannerViewController: LBXScanViewController {

    var mainVC:MainViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Pair Charm"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"CloseBarButtonItem" ), style: .Plain, target: self, action: #selector(ProductScannerViewController.closeButtonTapped))
        self.scanStyle?.centerUpOffset = 40
        self.scanStyle?.colorAngle = Colors.primary
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func closeButtonTapped() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func handleCodeResult(arrayResult:[LBXScanResult])
    {
        for result:LBXScanResult in arrayResult
        {
            print("%@",result.strScanned)
        }
        
        let result:LBXScanResult = arrayResult[0]
        
        print("type is\(result.strBarCodeType) and code is \(result.strScanned!)")
        switch result.strScanned! {
        case "lumaDemoCharm1":
            // check if current user is already owner or participant of stream
            // sororities
            self.currentUserIsMemberOfStream("R94I88keSy")
        case "lumaDemoCharm2":
            // nyc trip
            self.currentUserIsMemberOfStream("GZd5i0dcut")
        case "lumaDemoCharm3":
            // liam <3
            self.currentUserIsMemberOfStream("R119gIcCrg")
        case "lumaDemoCharm4":
            // Family time
            self.currentUserIsMemberOfStream("r5WYtMknrz")
        case "lumaDemoCharm5":
            // squad
            self.currentUserIsMemberOfStream("i6un02JFax")
        default:
            let alertController = UIAlertController(title: "Not Recognized", message: "This QR is not recognized", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (action) in
                self.startScan()
            })
            alertController.addAction(okAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func addCurrentUserToStreamAsParticipant(streamObjectId:String){
        
    }
    
    func currentUserIsMemberOfStream(streamObjectId:String){
        let streamQuery = PFQuery(className: "Stream")
        streamQuery.getObjectInBackgroundWithId(streamObjectId) { (stream, error) in
            if error != nil{
                print(error)
            }
            else{
                let stream = stream as! Stream
                if self.mainVC.streams.contains(stream){
                    let alertController = UIAlertController(title: "You Are Already a Member of \(stream.title)", message: "Scan something else!", preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (action) in
                        self.startScan()
                    })
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                else{
                    let alertController = UIAlertController(title: "Welcome to \(stream.title)", message: "Everyone's waiting!", preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (action) in
                        stream.participants.addObject(PFUser.currentUser()!)
                        stream.saveInBackgroundWithBlock({ (success, error) in
                            if error != nil{
                                print(error)
                            }
                            else{
                                print("load charms")
                                self.mainVC.streamGallerySelectedIndexPath = NSIndexPath(forItem: 0, inSection: 1)
                                self.mainVC.focusOnLatest = true
                                self.mainVC.loadCharms()
                                self.dismissViewControllerAnimated(true, completion: {
                                    
                                })
                            }
                        })
                    })
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }
    }


}
