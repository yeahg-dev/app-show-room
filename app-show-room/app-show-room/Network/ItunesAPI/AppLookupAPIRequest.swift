//
//  AppLookupAPIRequest.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/13.
//

import Foundation

struct AppLookupAPIRequest: iTunesAPIRequest {

    typealias APIResponse = AppLookupResponse
    
    var httpMethod: HTTPMethod  = .get
    var path: String = "/lookup"
    var query: [String: Any]
    var body: Data? = nil
    
    init(appID: Int) {
        self.query = ["id": appID]
    }
    
}

struct AppLookupResponse: Decodable {
    
    let resultCount: Int
    let results: [AppResponse]
    
}

struct AppResponse {
    
    let screenshotUrls: [String]?
    let ipadScreenshotUrls: [String]?
    let appletvScreenshotUrls: [String]?
    let artworkUrl60, artworkUrl512, artworkUrl100: String?
    let artistViewURL: String?
    let features: [String]?
    let isGameCenterEnabled: Bool?
    let supportedDevices: [String]?
    let advisories: [String]?
    let kind: String?
    let averageUserRating: Double?
    let releaseNotes, minimumOSVersion, trackCensoredName: String?
    let languageCodesISO2A: [String]?
    let fileSizeBytes, formattedPrice, contentAdvisoryRating: String?
    let averageUserRatingForCurrentVersion: Double?
    let userRatingCountForCurrentVersion: Int?
    let trackViewURL: String?
    let trackContentRating, resultDescription: String?
    let releaseDate: String?
    let bundleID, sellerName, currency, primaryGenreName: String?
    let primaryGenreID: Int?
    let currentVersionReleaseDate: String?
    let isVppDeviceBasedLicensingEnabled: Bool?
    let genreIDS: [String]?
    let version, wrapperType: String?
    let artistID: Int?
    let artistName: String?
    let genres: [String]?
    let price: Double
    let trackID: Int?
    let trackName: String?
    let userRatingCount: Int?

}

extension AppResponse: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case screenshotUrls, ipadScreenshotUrls, appletvScreenshotUrls, artworkUrl60, artworkUrl512, artworkUrl100, features, isGameCenterEnabled, supportedDevices, advisories, kind, averageUserRating, releaseNotes, trackCensoredName, languageCodesISO2A, fileSizeBytes, formattedPrice, contentAdvisoryRating, averageUserRatingForCurrentVersion, userRatingCountForCurrentVersion, trackContentRating, releaseDate, sellerName, currency, primaryGenreName,
             currentVersionReleaseDate, isVppDeviceBasedLicensingEnabled, version, wrapperType,
             artistName, genres, price, trackName, userRatingCount
        case artistViewURL = "artistViewUrl"
        case minimumOSVersion = "minimumOsVersion"
        case trackViewURL = "trackViewUrl"
        case resultDescription = "description"
        case bundleID = "bundleId"
        case primaryGenreID = "primaryGenreId"
        case genreIDS = "genreIds"
        case artistID = "artistId"
        case trackID = "trackId"

    }
}

extension AppLookupResponse {
    
    func toAppDetail() -> AppDetail? {
        guard let appDetail = self.results.first else {
            return nil
        }
        
        return AppDetail(
            appName: appDetail.trackName,
            iconImageURL: appDetail.artworkUrl512,
            sellerName: appDetail.sellerName,
            price: appDetail.price,
            averageUserRating: appDetail.averageUserRating,
            userRatingCount: appDetail.userRatingCount,
            appContentRating: appDetail.contentAdvisoryRating,
            primaryGenreName: appDetail.primaryGenreName,
            languageCodesISO2A: appDetail.languageCodesISO2A,
            screenShotURLs: appDetail.screenshotUrls,
            description: appDetail.resultDescription)
    }
}
