//
//  ConnectionManager.swift
//  Fitness-kit
//
//  Created by Yuri Ivashin on 25.02.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import Foundation
import Alamofire

class ConnectionManager {
    class var shared: ConnectionManager {
        return ConnectionManager()
    }
    
    private let coreDataManager: CoreDataManager
    private let scheduleURL: URL
    
    init() {
        self.coreDataManager = CoreDataManager(modelName: "CDModel")
        
        guard let url = URL(string: "https://sample.fitnesskit-admin.ru/schedule/get_group_lessons_v2/1/") else {
            fatalError("Could not get the url for the schedule")
        }
        self.scheduleURL = url
    }
    
    func fetchSchedule(completion: @escaping (Result<[Schedule]>) -> Void) {
        AF.request(scheduleURL).validate().responseJSON {
            responseJSON in

            if responseJSON.error != nil {
                return self.fetchScheduleFromCoreData(completion: completion)
            }
            
            guard let data = responseJSON.data else {
                return completion(.failure(.decodingDataError))
            }
            
            switch responseJSON.result {
            case .success(_):
                let decoder = JSONDecoder()
                if let arrayOfSchedule = try? decoder.decode([Schedule].self, from: data) {
                    self.saveSchedule(arrayOfSchedule)
                    completion(.success(arrayOfSchedule))
                } else {
                    completion(.failure(.conversionJSONError))
                }
            case .failure(let error):
                completion(.failure(.otherError(error)))
            }
        }
    }
    
    private func saveSchedule(_ scheduleArray: [Schedule]) {
        for scheduleElement in scheduleArray {
            guard
                let elementToSave: CDSchedule = coreDataManager.getEntity(with: scheduleElement.appointmentId),
                let index = WeekDay.allCases.firstIndex(of: scheduleElement.weekDay) else {
                break
            }
            
            let context = coreDataManager.getContext()
            
            elementToSave.name = scheduleElement.name
            elementToSave.startTime = scheduleElement.startTime
            elementToSave.endTime = scheduleElement.endTime
            elementToSave.teacher = scheduleElement.teacher
            elementToSave.place = scheduleElement.place
            elementToSave.descr = scheduleElement.description
            elementToSave.weekDay = Int16(WeekDayInt.allCases[index].rawValue)
            elementToSave.appointmentId = scheduleElement.appointmentId
            
            coreDataManager.save(context: context)
        }
    }
    
    private func fetchScheduleFromCoreData(completion: @escaping (Result<[Schedule]>) -> Void) {
        let feed = coreDataManager.fetchData(for: CDSchedule.self)
        
        completion(.success(feed.compactMap { transformIntoUISchedule($0) }))
    }
    
    private func transformIntoUISchedule(_ cdScheduleElement: CDSchedule) -> Schedule? {
        guard
            let name = cdScheduleElement.name,
            let startTime = cdScheduleElement.startTime,
            let endTime = cdScheduleElement.endTime,
            let teacher = cdScheduleElement.teacher,
            let place = cdScheduleElement.place,
            let description = cdScheduleElement.descr,
            let appointmentId = cdScheduleElement.appointmentId else {
                return nil
        }
        
        return Schedule(name: name,
                        startTime: startTime,
                        endTime: endTime,
                        teacher: teacher,
                        place: place,
                        description: description,
                        weekDay: Int(cdScheduleElement.weekDay),
                        appointmentId: appointmentId
                        )
    }
}
