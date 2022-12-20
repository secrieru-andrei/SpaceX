//
//  LaunchViewModel.swift
//  SpaceX
//
//  Created by Secrieru Andrei on 19.12.2022.
//

import Foundation

class LaunchViewModel: ObservableObject {
    //MARK: - Properties
    var itemId: String = ""
    @Published var launchiesCount: Int = 0
    @Published var launchies: [Launch] = []
    private var apiService = ApiService()
    
    init() {
        fetchLaunchies()
    }
}

//MARK: - Fetch Data[[[[
typealias LaunchViewModelFetchData = LaunchViewModel
extension LaunchViewModelFetchData {
    
    func fetchLaunchies() {
        apiService.getLaunchies { [weak self] (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let result):
                self?.launchies = result
            }
        }
    }
}
