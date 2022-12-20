//
//  LaunchModel.swift
//  SpaceX
//
//  Created by Secrieru Andrei on 19.12.2022.
//
import Foundation

struct Launch: Codable {
    let links: Links?
    let rocket: String?
    let name: String?
    let launchLibraryID, id: String?
    let dateUnix: Int?
    let details: String?

    enum CodingKeys: String, CodingKey {
        case links
        case name
        case launchLibraryID = "launch_library_id"
        case id, rocket, details
        case dateUnix = "date_unix"
    }
}

// MARK: - Links
struct Links: Codable {
    let patch: Patch?
    let webcast: String?
    let youtubeID: String?
    let wikipedia: String?

    enum CodingKeys: String, CodingKey {
        case patch, webcast, wikipedia
        case youtubeID = "youtube_id"
    }
}

// MARK: - Patch
struct Patch: Codable {
    let small, large: String?
}

typealias LaunchiesData = [Launch]
