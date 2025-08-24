//
//  ViewModel.swift
//  Weather App
//
//  Created by Shashank Yadav on 22/08/25.
//

import Foundation

class ViewModel:ObservableObject {
    @Published var weather:WeatherResponse?
    @Published var forecast:ForecastResponse?
    @Published var isLoading = false
    @Published var error: String?
    @Published var dailyForecast: [ForecastItem] = []
    // fetching the dat from the weather service
    
    func fetchWeather (for city:String){
        isLoading = true
        error = nil
        
        WeatherService.shared.fetchWeather(cityName: city){ [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    self?.weather=response
                    
                        let lat = response.coord.lat
                        let lon = response.coord.lon
                        self?.fetchForecast( lat: lat, lon: lon )
                case .failure(let errorMessage):
                    print("DEBUG -> Error fetching weather:", errorMessage.localizedDescription)
                    self?.error=errorMessage.localizedDescription
                    
                }
            }
            
        }
            
            
        }
    func fetchForecast ( lat : Double , lon : Double ){
        WeatherService.shared.fetchForecast( lat: lat, lon: lon ){ [weak self] result in
            switch result {
            case .success(let forecast):
                print("DEBUG -> Forecast daily count:", forecast.list.count)
                let dailyList = self?.getDailyForecast(from: forecast.list) ?? []
                self?.forecast = ForecastResponse(list: dailyList)
            case .failure(let error):
                self?.error = error.localizedDescription
            }
        }
    }
    
    func getDailyForecast(from list:[ForecastItem]) ->[ForecastItem]{
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: list){ item in
        let date = Date(timeIntervalSince1970: TimeInterval(item.dt))
            return calendar.startOfDay(for: date)
            
        }
        
        let daily = grouped.compactMap { (_, items) in
               items.min { abs($0.dt - 12*3600) < abs($1.dt - 12*3600) }
        }
        
        return daily.sorted { $0.dt < $1.dt }
    }
    
    func mapIconToSymbol(_ icon: String) -> String {
        switch icon {
        case "01d": return "sun.max.fill"
        case "01n": return "moon.stars.fill"
        case "02d": return "cloud.sun.fill"
        case "02n": return "cloud.moon.fill"
        case "03d", "03n": return "cloud.fill"
        case "04d", "04n": return "smoke.fill"
        case "09d", "09n": return "cloud.drizzle.fill"
        case "10d": return "cloud.sun.rain.fill"
        case "10n": return "cloud.moon.rain.fill"
        case "11d", "11n": return "cloud.bolt.rain.fill"
        case "13d", "13n": return "snowflake"
        case "50d", "50n": return "cloud.fog.fill"
        default: return "questionmark.circle"
        }
    }
}
