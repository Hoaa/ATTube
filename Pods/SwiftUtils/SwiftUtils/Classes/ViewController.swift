//
//  ViewController.swift
//  SwiftUtils
//
//  Created by DaoNV on 12/31/15.
//  Copyright © 2015 Astraler Technology. All rights reserved.
//

import UIKit

public class ViewController: UIViewController {
    public private(set) var isViewDidAppear = false
    public private(set) var isViewFirstAppear = false

    public override init(nibName: String?, bundle: NSBundle?) {
        super.init(nibName: nibName, bundle: bundle)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public func setup() {
        automaticallyAdjustsScrollViewInsets = false
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        isViewFirstAppear = true
    }

    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        isViewDidAppear = true
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            self?.isViewFirstAppear = false
        }
    }

    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        isViewDidAppear = false
    }
}
