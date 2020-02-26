//
//  MainCell.swift
//  Fitness-kit
//
//  Created by Yuri Ivashin on 25.02.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import UIKit

class MainCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    
    func configure(with scheduleItem: Schedule) {
        nameLabel.text = "Занятие: \(scheduleItem.name)"
        descriptionLabel.text = scheduleItem.description
        timeLabel.text = "\(scheduleItem.weekDay.rawValue) с \(scheduleItem.startTime) по \(scheduleItem.endTime)"
        placeLabel.text = scheduleItem.place
        teacherLabel.text = "Тренер: \(scheduleItem.teacher)"
    }
}
