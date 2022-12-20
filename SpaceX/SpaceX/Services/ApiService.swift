//
//  ApiService.swift
//  SpaceX
//
//  Created by Secrieru Andrei on 19.12.2022.
//

import Foundation

class ApiService {
    
    private var dataTask: URLSessionDataTask?
    typealias CompletionHandler = (Result<LaunchiesData, Error>) -> Void
    
    func getLaunchies(completion: @escaping CompletionHandler) {
        let urlString = "https://api.spacexdata.com/v5/launches"
        
        guard let url = URL(string: urlString) else {return}
        
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                completion (.failure(error))
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse  else {
                print("No response")
                return
            }
            
            if response.statusCode == 200 {
                guard let data = data else {return}
                guard let result = self.parse(data: data) else {return}
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            }
        }
        dataTask?.resume()
    }
    
    func parse(data: Data) -> LaunchiesData? {
        let decoder = JSONDecoder()
        guard let result = try? decoder.decode(LaunchiesData.self, from: data) else {return nil}
        return result
    }
}
