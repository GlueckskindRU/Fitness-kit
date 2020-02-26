//
//  Result.swift
//  Fitness-kit
//
//  Created by Yuri Ivashin on 25.02.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(AppError)
}
