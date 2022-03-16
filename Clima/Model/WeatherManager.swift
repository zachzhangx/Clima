//
//  WeatherManager.swift
//  Clima
//
//  Created by Zhang Xu on 2022/3/14.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather : WeatherModel)
    func didFailWithError(error : Error)
}

struct WeatherManager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=8d686426905a610b70b8b006107aead3&units=metric"
    
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(cityName : String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString : String){
        if let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)
            
            let dataTask = session.dataTask(with: url) { data, urlResponse, error in
                if error != nil{
                    print(error!)
                    return
                }else{
                    if let safeData = data{
                        if let weather = self.parseJson(safeData){
                            //传统传值
                            //let weatherVC = WeatherViewController()
                            //weatherVC.didUpdateWeather(weather: weather)
                            
                            //Delegate传值
                            self.delegate?.didUpdateWeather(self, weather: weather)
                        }
                    }
                }
            }
            
            dataTask.resume()
        }
    }
    
    
    func parseJson(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodeData = try decoder.decode(WeatherData.self, from: weatherData)
            print(decodeData.main.temp)
            let id = decodeData.weather[0].id
            let temp = decodeData.main.temp
            let name = decodeData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            print(weather.conditionName)
            return weather
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}
