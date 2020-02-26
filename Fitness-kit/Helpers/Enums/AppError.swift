//
//  AppError.swift
//  Fitness-kit
//
//  Created by Yuri Ivashin on 25.02.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import Foundation

enum AppError: Error {
    case weekDayDecoding
    case decodingDataError
    case conversionJSONError
    case otherError(Error)
    
    func getError() -> String {
        switch self {
        case .weekDayDecoding:
            return "There is an error while decoding the week day"
        case .decodingDataError:
            return "There is an error while decoding the received data"
        case .conversionJSONError:
            return "There is an error while conversion of the received JSON"
        case .otherError(let error):
            return error.localizedDescription
        }
    }
}
