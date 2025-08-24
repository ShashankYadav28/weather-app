//
//  WeatherButton.swift
//  Weather App
//
//  Created by Shashank Yadav on 15/08/25.
//

import SwiftUI
struct WeatherButton:View {
    var textColor:Color
    var backgroundColor:Color
    var title:String
    var body: some View {
        Text(title)
            .frame(width:280,height:50)
            .background(backgroundColor)
            .font(.system(size: 20, weight: .bold, design: .rounded))
            .foregroundColor(textColor)
    }
}
