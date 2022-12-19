//
//  File.swift
//  SpaceX
//
//  Created by Secrieru Andrei on 19.12.2022.
//

import Foundation
import UIKit

extension UIImageView {
    
    func getImageFromUrl(url: String) {
        guard let url = URL(string: url) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Eror: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("Empty Data")
                return
            }
            
            DispatchQueue.main.async {
                if let image =  UIImage(data: data) {
                    self.image = image
                }
            }
        }.resume()
    }
}
