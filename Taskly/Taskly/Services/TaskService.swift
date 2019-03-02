//
//  TaskService.swift
//  Taskly
//
//  Created by Matthew Faller on 10/30/18.
//  Copyright © 2018 Royal Bank of Canada. All rights reserved.
//

import Foundation

public typealias TaskResult<T> = ServiceResult<T, TaskError>

public typealias TaskCompletionHandler<T> = (TaskResult<T>) -> Void

public protocol TaskService {
    func getTasks(_ completion: @escaping TaskCompletionHandler<[TaskModel]>)
}
