//
//  SwipeCellDemoViewController.swift
//  CustomSwipeCell
//
//  Created by Atuooo on 26/02/2017.
//  Copyright © 2017 xyz. All rights reserved.
//

import UIKit

class SwipeCellDemoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
        }
    }

}

extension SwipeCellDemoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 22
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwipeCell") as! SwipeTableViewCell
        
        cell.delegate = self
        
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
}

extension SwipeCellDemoViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        switch orientation {
            
        case .left:
            
            let lAction = SwipeAction(style: .destructive, title: "actionL") { _, _ in }
            lAction.backgroundColor = .blue
            
            return [lAction]

        case .right:
            
            let r1Action = SwipeAction(style: .destructive, title: "actionR1") { _, _ in }
            r1Action.backgroundColor = .lightGray
            
            let r2Action = SwipeAction(style: .destructive, title: "actionR2") { _, _ in }
            r2Action.backgroundColor = .orange
            
            let r3Action = SwipeAction(style: .destructive, title: "actionR2") { _, _ in }
            r3Action.backgroundColor = .red
            
            return [r1Action, r2Action, r3Action]
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        
        var option = SwipeTableOptions()
        
        option.expansionStyle = orientation == .left ? .selection : .none
        option.transitionStyle = .border
        
        return option
    }
}
