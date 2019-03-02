//
//  TaskTableCell.swift
//  Taskly
//
//  Created by Matthew Faller on 10/31/18.
//  Copyright © 2018 Royal Bank of Canada. All rights reserved.
//

import Foundation
import UIKit

internal class TaskTableCell: UITableViewCell {
    
    @IBOutlet internal var taskTitle: UILabel!
    @IBOutlet internal var taskIcon: UIImageView!
    
    internal var viewModel: TaskViewModel? {
        didSet {
            guard let model = viewModel else {
                displayDefaultState()
                return
            }

            updateView(with: model)
        }
    }
    
    private func updateView(with model: TaskViewModel) {
        
        taskTitle.text = model.title
        taskIcon.tintColor = model.taskColor
    }
    
    private func displayDefaultState() {
        taskTitle.text = "--"
        taskIcon.tintColor = .gray
    }
}

internal class TaskTableSection: UITableViewCell {
    
    @IBOutlet private weak var sectionLabel: UILabel!
    
    internal var title: String? {
        didSet {
            sectionLabel.text = title
        }
    }
}

struct ReuseIDs {
    static let taskCell = "task-cell"
    static let taskSection = "section-header"
}
