//
//  TaskViewModel.swift
//  Taskly
//
//  Created by Matthew Faller on 10/31/18.
//  Copyright © 2018 Royal Bank of Canada. All rights reserved.
//

import Foundation

internal class TaskViewModel {
    
    init(from networkModel: TaskModel) {
        taskModel = networkModel
    }
    
    internal var isComplete: Bool {
        return taskModel.completed
    }
    
    private let taskModel: TaskModel
}

internal enum TaskSection: Int {
    case incomplete
    case finished
}
