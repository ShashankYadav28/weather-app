//
//  WeatherService.swift
//  Weather App
//
//  Created by Shashank Yadav on 21/08/25.
//

import Foundation

class  WeatherService {
    static let shared = WeatherService()
    private init(){}
    
    func fetchWeather (cityName:String , completion: @escaping (Result<WeatherResponse,Error>) -> Void) {
        
        let apiKey = "03d64781580b329f78d39d39f78df9b7"
        let q = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? cityName
        let urlString="https://api.openweathermap.org/data/2.5/weather?q=\(q)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        print("DEBUG -> Fetching weather from URL: \(url.absoluteString)")
        
        URLSession.shared.dataTask( with: url ){ data,response,error in
            if let error = error {
                print("DEBUG -> Network error: \(error.localizedDescription)")
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            if  let http = response as? HTTPURLResponse,!(200...299).contains(http.statusCode) {
                print("DEBUG -> HTTP status code: \(http.statusCode)")
                DispatchQueue.main.async { completion(.failure(URLError(.badServerResponse)))}
                return
            }
            
            guard let data = data else  {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("DEBUG -> Raw JSON: \(jsonString)")
            }
            
            do {
                let decoder = JSONDecoder()
                let weather = try decoder.decode(WeatherResponse.self, from:data)
                print("DEBUG -> Decoded WeatherResponse: \(weather)")
                               
                DispatchQueue.main.async {completion(.success(weather))}
            }
            
            
            catch {
                print("DEBUG -> Decoding error: \(error.localizedDescription)")
                DispatchQueue.main.async {completion(.failure(error))}
            }
            
        
        }.resume()
        
    }
    
    func fetchForecast ( lat: Double , lon: Double , completion: @escaping (Result<ForecastResponse,Error>) -> Void) {
        let apiKey = "03d64781580b329f78d39d39f78df9b7"
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"


        
        print("DEBUG -> Forecast URL:", urlString)

        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: url){ data , response , error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error))}
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(URLError(.badServerResponse)))}
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let forecast = try decoder.decode(ForecastResponse.self, from: data)
                print("DEBUG Forecast Count:", forecast.list.count)
                DispatchQueue.main.async { completion(.success(forecast))}
                
            }
            catch {
                DispatchQueue.main.async { completion(.failure(error))}
            }
        }.resume()
        
    }
    
}
