//
//  WeatherModel.swift
//  Weather App
//
//  Created by Shashank Yadav on 21/08/25.
//

import Foundation

struct WeatherResponse: Codable , Equatable{
    let name:String
    let main:Main
    let weather:[Weather]
    let dt:TimeInterval
    let sys:Sys
    let timezone:Int
    let coord:Coord
    let wind: Wind
    
    
}

struct Main: Codable ,Equatable{
    let temp:Double
    let feels_like: Double
    let humidity:Int

}
struct Weather: Codable, Equatable {
    let description:String
    let icon:String
}

struct Sys:Codable ,Equatable{
   // let timeZoneOffsetTime:TimeZone
    let sunrise:TimeInterval
    let sunset:TimeInterval
}
 
struct Coord: Codable,Equatable {
    let lon:Double
    let lat:Double
}

struct Wind: Codable,Equatable {
    let speed:Double
}
