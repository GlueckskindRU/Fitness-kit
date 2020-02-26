//
//  MainTableViewController.swift
//  Fitness-kit
//
//  Created by Yuri Ivashin on 25.02.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    private var scheduleArray: [Schedule] = []
    private let cellIdentifier = "Main Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: String(describing: MainCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.separatorStyle = .singleLine
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        
        fetchSchedule()
    }
}

// MARK: - TableView DataSource
extension MainTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MainCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: scheduleArray[indexPath.row])
        
        return cell
    }
}

// MARK: - Fetching Data
extension MainTableViewController {
    private func fetchSchedule() {
        let activityIndicator = ActivityIndicator()
        activityIndicator.start()
        
        ConnectionManager.shared.fetchSchedule {
            (result: Result<[Schedule]>) in
            
            DispatchQueue.main.async {
                activityIndicator.stop()
                
                switch result {
                case .success(let array):
                    self.scheduleArray = array
                    self.tableView.reloadData()
                    if array.isEmpty {
                        self.showDialog(title: nil, message: "Нет данных для отображения!")
                    }
                case .failure(let error):
                    self.showDialog(title: nil, message: error.getError())
                }
            }
        }
    }
}
