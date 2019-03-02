//
//  TableViewModel.swift
//  Taskly
//
//  Created by Matthew Faller on 10/31/18.
//  Copyright © 2018 Royal Bank of Canada. All rights reserved.
//

import Foundation
import UIKit

internal class TaskTableModel: NSObject {
 
    init(with tableView: UITableView) {
        self.tableView = tableView
    }
    
    private weak var tableView: UITableView?
}

//extension TaskDataSource: UITableViewDataSource {
//    
//}
