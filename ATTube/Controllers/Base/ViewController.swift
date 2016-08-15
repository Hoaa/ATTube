//
//  ViewController.swift
//  ATTube
//
//  Created by AsianTech on 8/1/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        configUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK - Init UI & Data
    func configUI() {
    }

    func loadData() {
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    func showMessage(title: String, message: String) {
        let alertcontroller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertcontroller.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
            alertcontroller.dismissViewControllerAnimated(true, completion: nil)
            }))
        presentViewController(alertcontroller, animated: true, completion: nil)
    }
}
