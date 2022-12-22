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
    @Published var favorites: [Launch] = []
    @Published var launchiesCount: Int = 0
    @Published var launchies: [Launch] = []
    @Published var favoritesCount = 0
    var favoriteLaunchiesId: [String] = []
    private var apiService = ApiService()
    var userDefaults = UserDefaults.standard
    var itemIndex: Int = 0
    
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

//MARK: - Favorites Control
typealias ViewModelFavoritesControl = LaunchViewModel
extension ViewModelFavoritesControl {
    func saveToFavorites(launch: Launch){
        favorites.append(launch)
        favoriteLaunchiesId.append(launch.id!)
    }
    
    func removeFromFavorites(launch: Launch){
        favorites.removeAll(where: {$0.id == launch.id})
        favoriteLaunchiesId.removeAll(where: {$0 == launch.id})
        self.saveData()
    }
    
    func checkLaunchIsInFavorite(launch: Launch) -> Bool {
        if favorites.contains(where: {$0.id == launch.id}) {
          return true
        } else {
            return false
        }
    }
    
    func saveData() {
        userDefaults.set(favoriteLaunchiesId, forKey: "SavedFavorites")
    }
    
    func fetchIdFromUserDefaults() {
        favoriteLaunchiesId = userDefaults.object(forKey: "SavedFavorites") as? [String] ?? [String]()
        print(favoriteLaunchiesId)
    }
    
    func fillFavoritesArrayWithData(launchies: [Launch]) {
        for launch in launchies {
            if favoriteLaunchiesId.contains(where: {$0 == launch.id}) {
                favorites.append(launch)
                favoritesCount += 1
            }
        }
    }
}
