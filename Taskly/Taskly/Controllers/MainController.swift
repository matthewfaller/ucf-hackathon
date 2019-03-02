//
//  ViewController.swift
//  Taskly
//
//  Created by Matthew Faller on 10/29/18.
//  Copyright © 2018 Royal Bank of Canada. All rights reserved.
//

import UIKit
import Alamofire

class MainController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private var tableView: UITableView!
    
    private var service: TaskService = RestfulTaskService()
    
    private var incompleteTasks: [TaskModel] = []
    private var finishedTasks: [TaskModel] = []
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Alamofire.request("https://jsonplaceholder.typicode.com/todos").validate().responseJSON { (response) in
            
            switch response.result {
            case .success(let data):
                if let jsonArray = data as? [[String: Any]] {
                    
                    var result: [TaskModel] = []
                    
                    jsonArray.forEach { (jsonObject) in
                        
                        guard
                            let userId = jsonObject["userId"] as? Int,
                            let id = jsonObject["id"] as? Int,
                            let title = jsonObject["title"] as? String,
                            let completed = jsonObject["completed"] as? Bool
                        else {
                            return
                        }
                        
                        let newModel = TaskModel(userId: userId, id: id, title: title, completed: completed)
                        
                        result.append(newModel)
                    }
                    
                    self.sortResponse(tasks: result)
                }
                
            case .failure:
                self.displayError(TaskError())
            }
        }
    }
    
    private func sortResponse(tasks: [TaskModel]) {
        incompleteTasks.removeAll()
        finishedTasks.removeAll()
        
        tasks.forEach { (task) in
            
            if task.completed {
                finishedTasks.append(task)
            } else {
                incompleteTasks.append(task)
            }
        }
        
        tableView.reloadSections([0, 1], with: .fade)
    }
    
    private func displayError(_ error: TaskError) {
        let alert = UIAlertController(title: "A problem has occurred", message: "We're sorry, but we're having trouble connecting right now", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionID = TaskSection(rawValue: section) else {
            return nil
        }
        
        let result = tableView.dequeueReusableCell(withIdentifier: ReuseIDs.taskSection) as? TaskTableSection
        
        if case sectionID = TaskSection.incomplete {
            result?.title = "To Do"
        } else {
            result?.title = "Complete"
        }
        
        return result?.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let sectionID = TaskSection(rawValue: section) else {
            return 0
        }
        
        if case sectionID = TaskSection.incomplete {
            return incompleteTasks.isEmpty ? 0 : 50
        } else {
            return finishedTasks.isEmpty ? 0 : 50
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionID = TaskSection(rawValue: section) else {
            return 0
        }
        
        switch sectionID {
        case .incomplete: return incompleteTasks.count
        case .finished: return finishedTasks.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIDs.taskCell, for: indexPath)
        
        guard let model = model(for: indexPath) else {
            return cell
        }
        
        updateCell(cell as? TaskTableCell, for: model)
        
        return cell
    }
    
    private func updateCell(_ taskCell: TaskTableCell?, for model: TaskModel) {
        
        let color: UIColor
        
        if model.completed {
            color = .green
        } else {
            color = UIColor.red.withAlphaComponent(0.75)
        }
        
        taskCell?.taskTitle.text = model.title
        taskCell?.taskIcon.tintColor = color
    }
    
    private func model(for indexPath: IndexPath) -> TaskModel? {
        guard let sectionID = TaskSection(rawValue: indexPath.section) else {
            return nil
        }
        
        let model: TaskModel
        
        switch sectionID {
        case .incomplete:
            model = incompleteTasks[indexPath.row]
        case .finished:
            model = finishedTasks[indexPath.row]
        }
        
        return model
    }
    
    // MARK Editing:
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let isFinished = model(for: indexPath)?.completed ?? true
        return !isFinished
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let markDone = UITableViewRowAction(style: .destructive, title: "Mark Complete") { (action, indexPath) in
            
            self.completeTask(at: indexPath)
        }
        
        markDone.backgroundColor = UIColor(red:0.04, green:0.41, blue:0.75, alpha:1.0)
        
        return [markDone]
    }
    
    private func completeTask(at indexPath: IndexPath) {
        tableView.performBatchUpdates({
            var model = self.incompleteTasks.remove(at: indexPath.row)
            model.completed.toggle()
            self.finishedTasks.append(model)
            self.finishedTasks.sort { $0.id < $1.id }
            let index = self.finishedTasks.firstIndex { $0.id == model.id } ?? 1
            let newRow = IndexPath(row: index, section: 1)
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.insertRows(at: [newRow], with: .left)
            
        }, completion: nil)
    }
}

