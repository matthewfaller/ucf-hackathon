//
//  TableViewModel.swift
//  Taskly
//
//  Created by Matthew Faller on 10/31/18.
//  Copyright © 2018 Royal Bank of Canada. All rights reserved.
//

import Foundation
import UIKit

internal class TaskTableModel {
 
    internal init(service: TaskService) {
        self.service = service
    }
    
    private let service: TaskService
    internal weak var delegate: TaskTableModelDelegate?
    
    internal func requestUpdate() {
        
        service.getTasks { (serviceResult) in
            
            switch serviceResult {
                
            case let .success(models):
                self.handleSuccess(models)
                
            case let .failure(error):
                self.handleFailure(error)
                
            }
        }
    }
    
    private func handleSuccess(_ models: [TaskModel]) {
        let incomeplete = models.filter(isIncomplete)
        let completed = models.filter(isCompleted)
        
        delegate?.didFinishFetchingTasks(incomplete: incomeplete, completed: completed)
    }
    
    private func handleFailure(_ error: TaskError) {
        // Additional error processing, as needed.
        
        delegate?.didRecieveError(error)
    }
    
    private func isIncomplete(_ model: TaskModel) -> Bool {
        return !model.completed
    }
    
    private func isCompleted(_ model: TaskModel) -> Bool {
        return model.completed
    }
}

internal protocol TaskTableModelDelegate: class {
    
    func didFinishFetchingTasks(incomplete: [TaskModel], completed: [TaskModel])
    
    func didRecieveError(_ taskError: TaskError)
}
