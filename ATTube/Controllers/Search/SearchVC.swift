//
//  SearchVC.swift
//  ATTube
//
//  Created by Asiantech1 on 8/1/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit

class SearchVC: ViewController {

    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var searchResultTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK - Init UI & Data
    override func configUI() {
        searchResultTableView.dataSource = self
        searchResultTableView.delegate = self
        searchTextField.becomeFirstResponder()
    }

    override func loadData() { }

    @IBAction private func dismissViewController(sender: UIButton) {
        view.endEditing(true)
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension SearchVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = "Section \(indexPath.section) Row \(indexPath.row)"
        cell.backgroundColor = Color.clear
        return cell ?? UITableViewCell()
    }
}
