//
//  RestfulTaskService.swift
//  Taskly
//
//  Created by Matthew Faller on 11/6/18.
//  Copyright © 2018 Royal Bank of Canada. All rights reserved.
//

import Foundation
import Alamofire

class RestfulTaskService: TaskService {
    
    func getTasks(_ completion: @escaping TaskCompletionHandler<[TaskModel]>) {
        Alamofire.request("https://jsonplaceholder.typicode.com/todos", method: .get).validate().responseData { (dataResponse) in
            
            switch dataResponse.result {
            
            case .success(let json):
                let result = self.processJson(json: json)
                
                completion(.success(model: result))
                
                
            case .failure:
                completion(.failure(error: TaskError()))
                
            }
        }
    }
    
    func processJson(json: Data) -> [TaskModel] {
        do {
           return try JSONDecoder().decode([TaskModel].self, from: json)
        } catch is DecodingError {
            
        } catch {
            print("\(error)")
        }
        
        return []
    }
    
}
