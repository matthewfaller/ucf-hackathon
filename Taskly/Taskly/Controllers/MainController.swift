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
    private lazy var tableModel = TaskTableModel(service: service)
    private lazy var tableRefreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = .black
        control.addTarget(self, action: #selector(beginRefresh), for: .valueChanged)
        return control
    }()
    
    private var incompleteTasks: [TaskViewModel] = []
    private var finishedTasks: [TaskViewModel] = []
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = tableRefreshControl
        tableModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableRefreshControl.beginRefreshing()
        beginRefresh()
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
    
    private func updateCell(_ taskCell: TaskTableCell?, for model: TaskViewModel) {
        taskCell?.viewModel = model
    }
    
    private func model(for indexPath: IndexPath) -> TaskViewModel? {
        guard let sectionID = TaskSection(rawValue: indexPath.section) else {
            return nil
        }
        
        let model: TaskViewModel
        
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
        let isFinished = model(for: indexPath)?.isComplete ?? true
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
            let model = self.incompleteTasks.remove(at: indexPath.row)
            model.isComplete.toggle()
            self.finishedTasks.append(model)
            self.finishedTasks.sort { $0.id < $1.id }
            let index = self.finishedTasks.firstIndex { $0.id == model.id } ?? 1
            let newRow = IndexPath(row: index, section: 1)
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.insertRows(at: [newRow], with: .left)
            
        }, completion: nil)
    }
}

extension MainController: TaskTableModelDelegate {
    
    func didRecieveError(_ taskError: TaskError) {
        endRefresh()
        let alert = UIAlertController(title: "A problem has occurred", message: "We're sorry, but we're having trouble connecting right now", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func didFinishFetchingTasks(incomplete: [TaskViewModel], completed: [TaskViewModel]) {
        endRefresh()
        incompleteTasks = incomplete
        finishedTasks = completed
        
        tableView.reloadSections([0, 1], with: .fade)
    }
    
    @IBAction private func beginRefresh() {
        tableModel.requestUpdate()
    }
    
    @IBAction private func endRefresh() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
            self.tableRefreshControl.endRefreshing()
        }
    }
}
