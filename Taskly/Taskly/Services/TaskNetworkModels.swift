//
//  TaskNetworkModels.swift
//  Taskly
//
//  Created by Matthew Faller on 10/30/18.
//  Copyright © 2018 Royal Bank of Canada. All rights reserved.
//

import Foundation

public struct TaskModel: Codable {

    let userId: Int
    let id: Int
    let title: String
    var completed: Bool
}

public enum ServiceResult<T, E: Error> {
    
    case success(model: T)
    case failure(error: E)
}

public struct TaskError: Error {}
