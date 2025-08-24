//
//  ContentView.swift
//  Weather App
//
//  Created by Shashank Yadav on 11/08/25.
//

import SwiftUI

struct ContentView: View {
    //@State private var isnight = false
    @State  private var cityName = ""
    @StateObject private var viewModel = ViewModel()
    @State private var isnight:Bool = false
    
       
    var body: some View {
        ZStack {
            
            GradientView(isnight:$isnight)
    
            VStack{
                HStack{
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        
                    TextField("Search City", text:$cityName)
                        .foregroundColor(.primary)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .submitLabel(.search)
                        .onSubmit {
                            viewModel.fetchWeather(for: cityName)
                        }
                        
                    if !cityName.isEmpty {
                        Button(action:{
                            cityName=""
                        }){
                            Image(systemName: "xmark.circle.fill")
                        }
                    }
                    
                }
                .padding(12)
                .background(Color(.systemGray6))
                .clipShape(Capsule())
                .padding(.horizontal,20)
                .shadow(radius: 2)
                .onChange(of:viewModel.weather?.dt) {
                    guard let weather = viewModel.weather else { return }
                let timeZoneOffset = weather.timezone
                let currentTime = Date(timeIntervalSince1970: weather.dt+Double(timeZoneOffset))
                let sunrise = Date(timeIntervalSince1970: weather.sys.sunrise+Double(timeZoneOffset))
                let sunset = Date(timeIntervalSince1970: weather.sys.sunset+Double(timeZoneOffset))
                isnight = currentTime<sunrise || currentTime>sunset
                    
                    print("DEBUG City:", weather.name)
                    print("DEBUG Timezone Offset:", timeZoneOffset)
                    print("DEBUG Local Time:", currentTime)
                    print("DEBUG Sunrise:", sunrise)
                    print("DEBUG Sunset:", sunset)
                    print("DEBUG isnight:", isnight)
                
            }
                
                
                    //.foregroundColor(.black)
                CityNameView(cityName: viewModel.weather?.name ?? (cityName.isEmpty ? "Enter The City" : cityName))
                
                if let weather = viewModel.weather {
                    WeatherTemperatureView(weatherImageStatus:weatherIcon(for: weather.weather.first?.description , isnight:isnight), temperature: Int(weather.main.temp))
                        .onAppear {
                                print("DEBUG -> temp:", weather.main.temp)
                                print("DEBUG -> dt:", weather.dt,
                                      "sunrise:", weather.sys.sunrise,
                                      "sunset:", weather.sys.sunset)
                            }
                    
                }
                
                if let forecast = viewModel.forecast {
                    ScrollView(.horizontal,showsIndicators: false){
                        HStack{
                            Spacer()
                            LazyHStack(spacing: 15) {
                                ForEach(forecast.list.prefix(7)){ day in
                                    WeatherView(day: dayofweek(from : TimeInterval(day.dt)), temperature: Int(day.main.temp_max), cloudImage: weatherIcon(for: day.weather.first?.description, isnight: isnight))
                                }
                                
                            }
                            Spacer()
                            
                        }
                        
                        .padding(.horizontal,8)
                        .frame(minWidth: UIScreen.main.bounds.width)
                       /* .frame(maxWidth: .infinity)
                        .contentShape(Rectangle())
                        .padding(.horizontal)
                        .frame(alignment: .center)*/
                    }
                    
                    
                }
                
               /* HStack(alignment:.top,spacing:15){
                    
                    ForEach(weekDaysObject.week){ weather in
                        WeatherView(day: weather.day, temperature: weather.temperature, cloudImage: weather.cloudImage)
                    }
                        
                    
                    
                    }*/
                
                
                   Spacer()
                Button {
                    isnight.toggle()
                }label:{
                    
                    WeatherButton(textColor: .white, backgroundColor: .black, title: "Change The Day")
                        
                        
                    
                }
                Spacer()
            }
        }
            
           
    }
    
    // helper function
    func weatherIcon( for description : String? , isnight:Bool ) -> String {
        /*if isnight {
            return "moon.stars.fill"
        }
        guard let description = description else {
            return "cloud.sun.fill"
        }*/
        
        /*switch description.lowercased() {
        case "clear sky":return "sun.max.fill"
        case "few clouds":return "cloud.sun.fill"
        case "scattered clouds":return "cloud.fill"
        case "broken clouds":return "cloud.fill"
        case "shower rain": return "cloud.rain.fill"
        case "rain": return "cloud.rain.fill"
        case "thunderstorm": return "cloud.bolt.rain.fill"
        case "snow": return "snow"
        case "mist": return "cloud.fog.fill"
        case "haze": return "sun.haze.fill"
        case "smoke": return "smoke.fill"
        case "fog": return "cloud.fog.fill"
        case "drizzle": return "cloud.drizzle.fill"
        default : return "cloud.sun.fill"
            
        }*/
        
        guard let desc = description?.lowercased() else { return "questionmark"}
        
        switch desc {
            case "clear sky":
                return isnight ? "moon.stars.fill" : "sun.max.fill"
            case "few clouds":
                return isnight ? "cloud.moon.fill" : "cloud.sun.fill"
            case "scattered clouds", "broken clouds", "overcast clouds":
                return "cloud.fill"
            case "shower rain", "rain":
                return isnight ? "cloud.moon.rain.fill" : "cloud.rain.fill"
            case "thunderstorm":
                return isnight ? "cloud.moon.bolt.fill" : "cloud.bolt.fill"
            case "snow":
                return "snowflake"
            case "mist", "haze", "fog":
                return "cloud.fog.fill"
            default:
                return "cloud.fill"
            }
        
    }
    
    // helper function for the forecast
    func dayofweek ( from timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
        
    }
    
        
}

#Preview {
    ContentView()
}

struct WeatherView: View {
    var day:String
    var temperature:Int
    var cloudImage:String
    var body: some View {
        
     
        
        VStack (spacing:10){
            Text(day)
                .font(.system(size: 20, weight: .medium, design: .rounded))
                .foregroundColor(.white)
            //Spacer()
               // .frame(height:20)
            Image(systemName:cloudImage)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:40)
                .foregroundColor(.white)
           // Spacer()
                //.frame(height:20)
            
            Text("\(temperature)°")
                .font(.system(size: 20, weight: .medium, design: .rounded))
                .foregroundColor(.white)
            
        }
        .frame(width:45,height:100)
    }
}
 

struct GradientView: View {
   @Binding var isnight: Bool
   // var isnight:Bool
    var body: some View {
        LinearGradient(colors: [isnight ? .black : .blue , isnight ? .gray : Color("lightblue")], startPoint: .topLeading,
                       endPoint: .bottomTrailing)
        .edgesIgnoringSafeArea(.all)
    }
}

struct CityNameView:View {
    var cityName:String
    var body:some View{
        Text(cityName)
            .font(.system(size: 48, weight: .medium, design: .rounded))
            .foregroundColor(.white)
            .padding(.top,18)

        
    }
}

struct weatherStatusView:View {
    var body:some View{
        
        
    }
}

struct WeatherTemperatureView:View {
    var weatherImageStatus:String
    var temperature:Int
    var body: some View {
        VStack(spacing:10){
            Image(systemName:weatherImageStatus)
                .renderingMode(.original)
                
            //.resizable()
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:230)
                .padding(.bottom,20)
                .foregroundColor(.white)
            
            Text("\(temperature)°")
                .font(.system(size: 72, weight: .medium, design: .rounded))
                .foregroundColor(.white)
        }
        .padding(.bottom,60)
    }
}


