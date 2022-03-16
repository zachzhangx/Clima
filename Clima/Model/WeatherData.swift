//
//  WeatherData.swift
//  Clima
//
//  Created by Zhang Xu on 2022/3/14.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData : Codable{
    let name : String
    let main : Main
    let weather : [Weather] //Array
}

struct Main : Codable{
    let temp : Double
}

struct Weather : Codable{
    let description : String
    let id : Int
}
