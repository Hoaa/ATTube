//
//  PlayerVC.swift
//  ATTube
//
//  Created by Asiantech1 on 8/8/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit

class PlayerVC: ViewController {

    @IBOutlet private weak var videosTableView: UITableView!

    @IBOutlet private weak var videoNameLabel: UILabel!
    @IBOutlet private weak var totalViewsLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        autoFontSize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK - Init UI & Data
    override func configUI() {
        videosTableView.registerNib(PlayerCell)
        videosTableView.dataSource = self
        videosTableView.delegate = self
    }

    private func autoFontSize() {
        let helveticaFont = HelveticaFont()
        videoNameLabel.font = helveticaFont.Regular(20)
        totalViewsLabel.font = helveticaFont.Light(14)
        descriptionLabel.font = helveticaFont.Regular(14)
    }

    @IBAction func dismissViewController(sender: UIButton) {
        dismissViewControllerAnimated(true) { }
    }
}

// MARK: - UITableviewDataSource, UITableViewDelegate
extension PlayerVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let playerCell = tableView.dequeue(PlayerCell)
        playerCell.configCellAtIndex(indexPath.row)
        return playerCell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return PlayerCell.getCellHeight()
    }
}
