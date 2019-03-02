//
//  MockTaskService.swift
//  Taskly
//
//  Created by Matthew Faller on 10/30/18.
//  Copyright © 2018 Royal Bank of Canada. All rights reserved.
//

import Foundation

internal class MockTaskService {
    
    internal init(mockedResponse: [TaskModel] = DefaultStubs.taskList) {
        self.mockDatabase = mockedResponse
    }
    
    func performMockRequest<T>(mockedResult: ServiceResult<T, TaskError>, with completion: @escaping TaskCompletionHandler<T>) {
        let mockResponseTime = TimeInterval.random(in: 0.5...1.5)
        Thread.sleep(forTimeInterval: mockResponseTime)
        
        let result = response(from: mockedResult)
        
        DispatchQueue.main.async {
            completion(result)
        }
    }
    
    private func response<T>(from mock: ServiceResult<T, TaskError>) -> ServiceResult<T, TaskError> {
        
        if numberOfMocks == countTillError {
            return .failure(error: TaskError())
        }
        
        return mock
    }
    
    private var numberOfMocks = 0 {
        didSet {
            if numberOfMocks > countTillError {
                numberOfMocks = 0
            }
        }
    }
    
    private let countTillError = 6
    private let mockDatabase: [TaskModel]
    private let queue = DispatchQueue(label: "MockTaskServiceQueue")
}

// MARK: Protocol Conformance
extension MockTaskService: TaskService {
    
    func getTasks(_ completion: @escaping (ServiceResult<[TaskModel], TaskError>) -> Void) {
        numberOfMocks += 1
        
        let mockedSuccess: ServiceResult<[TaskModel], TaskError> = .success(model: mockDatabase)
        
        queue.async {
            self.performMockRequest(mockedResult: mockedSuccess, with: completion)
        }
    }
}

internal struct DefaultStubs {
    static let taskList: [TaskModel] = generateTasks()
    
    private static func generateTasks() -> [TaskModel] {
        return (1...2).reduce([]) { (tasks, next) -> [TaskModel] in
            return tasks + [TaskModel(userId: next, id: next, title: "Task #\(next)", completed: Bool.random())]
        }
    }
}


