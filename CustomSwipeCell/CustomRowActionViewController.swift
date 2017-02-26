//
//  CustomRowActionViewController.swift
//  CustomSwipeCell
//
//  Created by Atuooo on 26/02/2017.
//  Copyright © 2017 xyz. All rights reserved.
//

import UIKit

private let cellID = "CustomRowActionCell"

class CustomRowActionViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.rowHeight = 60
            tableView.tableFooterView = UIView()
            tableView.register(CustomRowActionCell.self, forCellReuseIdentifier: cellID)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension CustomRowActionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 22
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! CustomRowActionCell
        
        cell.rowAction = {
            self.tableView.setEditing(false, animated: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alertController = UIAlertController(title: "Select \(indexPath)", message: nil, preferredStyle: .alert)
        let action: UIAlertAction = UIAlertAction(title: "OK", style: .default) { _ in }
        alertController.addAction(action)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true) {
                self.tableView.deselectRow(at: indexPath, animated: false)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        
        if CustomRowActionCell.isSwiping {
            // 当有 cell 正在展开状态，收起该 cell，并屏蔽 cell 的 select 手势
            NotificationCenter.default.post(name: Notification.Name("encloseSwipeCell"), object: nil)
            return false
            
        } else {
            
            return true
        }
    }
}

extension CustomRowActionViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        NotificationCenter.default.post(name: Notification.Name("encloseSwipeCell"), object: nil)
    }
}
