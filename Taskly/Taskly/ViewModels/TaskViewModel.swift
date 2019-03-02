//
//  TaskViewModel.swift
//  Taskly
//
//  Created by Matthew Faller on 10/31/18.
//  Copyright © 2018 Royal Bank of Canada. All rights reserved.
//

import Foundation
import UIKit

internal class TaskViewModel {
    
    init(from networkModel: TaskModel) {
        taskModel = networkModel
    }
    
    internal var isComplete: Bool {
        get {
            return taskModel.completed
        }
        set {
            taskModel.completed = true
        }
    }
    
    internal var title: String {
        return taskModel.title
    }
    
    internal var id: Int {
        return taskModel.id
    }
    
    internal var taskColor: UIColor {
        let color: UIColor
        
        if isComplete {
            color = .green
        } else {
            color = UIColor.red.withAlphaComponent(0.75)
        }
        
        return color
    }
    
    private var taskModel: TaskModel
}

internal enum TaskSection: Int {
    case incomplete
    case finished
}
