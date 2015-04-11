//
//  PrimaryViewController.swift
//  EMPartialModalViewController
//
//  Created by Emad A. on 16/02/2015.
//  Copyright (c) 2015 Emad A. All rights reserved.
//

import UIKit

class PrimaryViewController: UIViewController {

    @IBAction func dismiss() {
        parentViewController?.dismissViewControllerAnimated(true) {
            println("dismissing view controller - done")
        }
    }
}
