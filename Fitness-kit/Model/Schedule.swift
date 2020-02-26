//
//  Schedule.swift
//  Fitness-kit
//
//  Created by Yuri Ivashin on 25.02.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import Foundation

class Schedule: Codable {
    let name: String
    let startTime: String
    let endTime: String
    let teacher: String
    let place: String
    let description: String
    let weekDay: WeekDay
    let appointmentId: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case startTime
        case endTime
        case teacher
        case place
        case description
        case weekDay
        case appointmentId = "appointment_id"
    }
    
    init?(name: String, startTime: String, endTime: String, teacher: String, place: String, description: String, weekDay: Int, appointmentId: String) {
        guard
            let weekDayInt = WeekDayInt(rawValue: weekDay),
            let index = WeekDayInt.allCases.firstIndex(of: weekDayInt) else {
                return nil
        }
        
        self.name = name
        self.startTime = startTime
        self.endTime = endTime
        self.teacher = teacher
        self.place = place
        self.description = description
        self.appointmentId = appointmentId
        self.weekDay = WeekDay.allCases[index]
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try values.decode(String.self, forKey: .name)
        self.startTime = try values.decode(String.self, forKey: .startTime)
        self.endTime = try values.decode(String.self, forKey: .endTime)
        self.teacher = try values.decode(String.self, forKey: .teacher)
        self.place = try values.decode(String.self, forKey: .place)
        self.description = try values.decode(String.self, forKey: .description)
        self.appointmentId = try values.decode(String.self, forKey: .appointmentId)
        
        let weekDayInteger = try values.decode(Int.self, forKey: .weekDay)
        
        guard
            let weekDayInt = WeekDayInt(rawValue: weekDayInteger),
            let index = WeekDayInt.allCases.firstIndex(of: weekDayInt) else {
            throw AppError.weekDayDecoding
        }
        
        self.weekDay = WeekDay.allCases[index]
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.startTime, forKey: .startTime)
        try container.encode(self.endTime, forKey: .endTime)
        try container.encode(self.teacher, forKey: .teacher)
        try container.encode(self.place, forKey: .place)
        try container.encode(self.description, forKey: .description)
        try container.encode(self.appointmentId, forKey: .appointmentId)
        
        guard let index = WeekDay.allCases.firstIndex(of: self.weekDay) else {
            throw AppError.weekDayDecoding
        }
        
        try container.encode(WeekDayInt.allCases[index].rawValue, forKey: .weekDay)
    }
}
