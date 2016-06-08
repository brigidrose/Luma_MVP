//
//  AccountViewController.swift
//  Luma
//
//  Created by Chun-Wei Chen on 6/8/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Account"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"CloseBarButtonItem" ), style: .Plain, target: self, action: #selector(AccountViewController.closeButtonTapped))
        
        view.backgroundColor = Colors.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func closeButtonTapped() {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
