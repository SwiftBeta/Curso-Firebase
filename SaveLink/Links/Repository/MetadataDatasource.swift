//
//  MetadataDatasource.swift
//  SaveLink
//
//  Created by Home on 21/12/21.
//

import Foundation
import LinkPresentation

enum CustoMetadataError: Error {
    case badURL
}

final class MetadataDatasource {
    private var metadataProvider: LPMetadataProvider?
    
    func getMetadata(fromURL url: String, completionBlock: @escaping (Result<LinkModel, Error>) -> Void) {
        guard let url = URL(string: url) else {
            completionBlock(.failure(CustoMetadataError.badURL))
            return
        }
        metadataProvider = LPMetadataProvider()
        metadataProvider?.startFetchingMetadata(for: url, completionHandler: { metadata, error in
            if let error = error {
                print("Error getting metadata \(error.localizedDescription)")
                completionBlock(.failure(error))
                return
            }
            
            let linkModel = LinkModel(url: url.absoluteString,
                                      title: metadata?.title ?? "No title",
                                      isFavorited: false,
                                      isCompleted: false)
            completionBlock(.success(linkModel))
        })
    }
}
