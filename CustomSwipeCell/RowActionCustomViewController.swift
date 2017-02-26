//
//  RowActionCustomViewController.swift
//  CustomSwipeCell
//
//  Created by Atuooo on 25/02/2017.
//  Copyright © 2017 xyz. All rights reserved.
//

import UIKit

class RowActionCustomViewController: UITableViewController {

    enum SectionType: Int {
        case useDefault = 0
        case customByAppearance
        case customByBgColor
    }
    
    fileprivate let textAttributes = [
        NSFontAttributeName: UIFont(name: "Futura", size: 17),
        NSForegroundColorAttributeName: UIColor.black
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
    }
    
    @IBAction func editClicked(_ sender: UIBarButtonItem) {

        UIView.performWithoutAnimation {
            sender.title = tableView.isEditing ? "Edit" : "Cancel"
        }
        
        tableView.setEditing(!tableView.isEditing, animated: true)
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        guard let sectionType = SectionType(rawValue: indexPath.section) else { return nil }
        
        switch sectionType {
            
        case .useDefault:
            
            return defaultRowActions(style: indexPath.item == 0 ? .default : .normal)
            
        case .customByAppearance:
            
            let appearance = UIButton.appearance(whenContainedInInstancesOf: [RowActionCustomTextCell.self])
            let attString = NSAttributedString(string: "Delete", attributes: textAttributes)
            appearance.setAttributedTitle(attString, for: .normal)
            
            // appearance.titleLabel?.font = UIFont.systemFont(ofSize: 15) // not work! can't titleLabel, it return nil
            
            let rowActions = defaultRowActions()
            return indexPath.item == 0 ? [rowActions[1]] : rowActions
            
        case .customByBgColor:
            
            let cellHeight = tableView.rectForRow(at: indexPath).height

            if indexPath.row == 0 { // draw text
                
                let deleteAction = CustomRowAction(cellHeight: cellHeight,
                                                   bgColor: .red,
                                                   with: ("Let's delete it", .white, UIFont(name: "Bradley Hand", size: 16)!))
                
                let editAction = CustomRowAction(cellHeight: cellHeight,
                                                 bgColor: .orange,
                                                 with: ("edit oo", .black, UIFont(name: "Menlo", size: 14)!))
                
                return [editAction, deleteAction]
                
            } else if indexPath.row == 1 {  // draw icon
                
                let deleteAction = CustomRowAction(size: CGSize(width: 44, height: cellHeight),
                                                   image: #imageLiteral(resourceName: "icon_delete"),
                                                   bgColor: .red)
                
                let editAction = CustomRowAction(size: CGSize(width: 60, height: cellHeight),
                                                 image: #imageLiteral(resourceName: "icon_edit"),
                                                 bgColor: .orange)
                
                return [editAction, deleteAction]
                
            } else {    // draw icon + text
                
                let deleteAction = CustomRowAction(cellHeight: cellHeight,
                                                   bgColor: .red,
                                                   titleInfo: ("Let's delete it", .white, UIFont(name: "Bradley Hand", size: 16)!),
                                                   icon: #imageLiteral(resourceName: "icon_delete"))
                
                return [deleteAction]
            }
        }
    }
}

// MARK: - Helper Mathods

extension RowActionCustomViewController {
    
    typealias RowActions = (edit: UITableViewRowAction, delete: UITableViewRowAction)
    
    fileprivate func defaultRowActions(style: UITableViewRowActionStyle = .default) -> [UITableViewRowAction] {
        
        let rowActions = basicRowAction(of: style)
        rowActions.edit.backgroundColor = .orange
        rowActions.delete.backgroundColor = .red
        
        return [rowActions.edit, rowActions.delete]
    }
    
    fileprivate func basicRowAction(of style: UITableViewRowActionStyle = .default) -> RowActions  {
        
        let deleteAction = UITableViewRowAction(style: style, title: "Delete") { _, _ in
            self.tableView.setEditing(false, animated: true)
        }
        
        let editAction = UITableViewRowAction(style: style, title: "Edit") { _, _ in
            self.tableView.setEditing(false, animated: true)
        }
        
        return (editAction, deleteAction)
    }
}

// MARK: - CustomTextCell

class RowActionCustomTextCell: UITableViewCell {
    
}
