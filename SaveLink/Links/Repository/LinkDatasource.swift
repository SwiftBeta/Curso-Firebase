//
//  LinkDatasource.swift
//  SaveLink
//
//  Created by Home on 14/12/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct LinkModel: Decodable, Identifiable, Encodable {
    @DocumentID var id: String?
    let url: String
    let title: String
    let isFavorited: Bool
    let isCompleted: Bool
}

final class LinkDatasource {
    private let database = Firestore.firestore()
    private let collection = "links"
    
    func getAllLinks(completionBlock: @escaping (Result<[LinkModel], Error>) -> Void) {
        database.collection(collection)
            .addSnapshotListener { query, error in
                if let error = error {
                    print("Error getting all links \(error.localizedDescription)")
                    completionBlock(.failure(error))
                    return
                }
                guard let documents = query?.documents.compactMap({ $0 }) else {
                    completionBlock(.success([]))
                    return
                }
                let links = documents.map { try? $0.data(as: LinkModel.self) }
                                     .compactMap { $0 }
                completionBlock(.success(links))
            }
    }
    
    func createNew(link: LinkModel, completionBlock: @escaping (Result<LinkModel, Error>) -> Void) {
        do {
            _ = try database.collection(collection).addDocument(from: link)
            completionBlock(.success(link))
        } catch {
            completionBlock(.failure(error))
        }
    }
    
    func update(link: LinkModel) {
        guard let documentId = link.id else {
            return
        }
        do {
            _ = try database.collection(collection).document(documentId).setData(from: link)
        } catch {
            print("Error updating link in our database")
        }
    }
    
    func delete(link: LinkModel) {
        guard let documentId = link.id else {
            return
        }
        database.collection(collection).document(documentId).delete()
    }
}
