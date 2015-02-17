//
//  ViewController.swift
//  EMPartialModalViewController
//
//  Created by Emad A. on 16/02/2015.
//  Copyright (c) 2015 Emad A. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showModalViewController_1() {
        let content: UIViewController = storyboard!.instantiateViewControllerWithIdentifier("modalNav") as UIViewController
        let partialModal: EMPartialModalViewController = EMPartialModalViewController(rootViewController: content, contentHeight: 400)

        presentViewController(partialModal, animated: false, completion: nil)
    }

    @IBAction func showModalViewController_2() {
        let content: UIViewController = storyboard!.instantiateViewControllerWithIdentifier("modalNav") as UIViewController
        var frame: CGRect = content.view.frame
        frame.size.height = 200
        content.view.frame = frame

        let partialModal: EMPartialModalViewController = EMPartialModalViewController(rootViewController: content)

        presentViewController(partialModal, animated: true, completion: nil)
    }
}

