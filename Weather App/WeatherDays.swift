//
//  WeatherDays.swift
//  Weather App
//
//  Created by Shashank Yadav on 15/08/25.
//
import SwiftUI
struct Days :Identifiable{
    var id=UUID()
    var day:String
    var temperature:Int
    var cloudImage:String
}

struct Weekdays {
    var week = [
        Days(day:"Mon",temperature:24,cloudImage:"cloud.sun.rain.fill"),
        Days(day:"Tue",temperature:28,cloudImage:"smoke.fill"),
        Days(day:"Wed",temperature:34,cloudImage:"cloud.hail.fill"),
        Days(day:"Thur",temperature:21,cloudImage:"wind"),
        Days(day:"Frid",temperature:27,cloudImage:"cloud.sun.fill"),
        Days(day:"Sat",temperature:28,cloudImage:"cloud.bolt.rain.fill"),
        Days(day:"Sun",temperature:28,cloudImage:"cloud.sun.fill")
        ]
    
}

let weekDaysObject = Weekdays()
