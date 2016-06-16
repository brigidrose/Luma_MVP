//
//  ProductScannerViewController.swift
//  Luma
//
//  Created by Chun-Wei Chen on 6/15/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit
import swiftScan

class ProductScannerViewController: LBXScanViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        print("type is\(result.strBarCodeType) and code is \(result.strScanned)")
        startScan()
    }


}
