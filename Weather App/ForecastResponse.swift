//
//  ForecastResponse.swift
//  Weather App
//
//  Created by Shashank Yadav on 24/08/25.
//

import Foundation

struct ForecastResponse : Codable {
    let list:[ForecastItem]
}

struct ForecastItem:Codable , Identifiable{
    var id: Int { dt }
    let dt:Int
    let main:MainClass
    let weather:[Weather]
}

struct MainClass:Codable {
    let temp:Double
    let temp_min:Double
    let temp_max:Double
}
