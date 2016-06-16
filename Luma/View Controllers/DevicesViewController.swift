//
//  DevicesViewController.swift
//  Luma
//
//  Created by Chun-Wei Chen on 6/8/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit
import swiftScan
class DevicesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Settings"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"CloseBarButtonItem" ), style: .Plain, target: self, action: #selector(DevicesViewController.closeButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Scan", style: .Plain, target: self, action: #selector(DevicesViewController.scanButtonTapped))

        view.backgroundColor = Colors.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func closeButtonTapped() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func scanButtonTapped() {
        print("scan button tapped")
        
        let scanVC = ProductScannerViewController()
        let scanNC = UINavigationController(rootViewController: scanVC)
        scanNC.view.tintColor = Colors.primary
        presentViewController(scanNC, animated: true, completion: nil)
    }
}
