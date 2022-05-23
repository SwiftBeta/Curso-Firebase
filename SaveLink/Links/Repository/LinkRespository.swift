//
//  LinkRespository.swift
//  SaveLink
//
//  Created by Home on 14/12/21.
//

import Foundation

final class LinkRepository {
    private let linkDatasource: LinkDatasource
    private let metadataDatasource: MetadataDatasource
    
    init(linkDatasource: LinkDatasource = LinkDatasource(),
         metadataDatasource: MetadataDatasource = MetadataDatasource()) {
        self.linkDatasource = linkDatasource
        self.metadataDatasource = metadataDatasource
    }
    
    func getAllLinks(completionBlock: @escaping (Result<[LinkModel], Error>) -> Void) {
        linkDatasource.getAllLinks(completionBlock: completionBlock)
    }
    
    func createNewLink(withURL url: String, completionBlock: @escaping (Result<LinkModel, Error>) -> Void) {
        metadataDatasource.getMetadata(fromURL: url) { [weak self] result in
            switch result {
            case .success(let linkModel):
                self?.linkDatasource.createNew(link: linkModel,
                                               completionBlock: completionBlock)
            case .failure(let error):
                completionBlock(.failure(error))
            }
        }
    }
    
    func update(link: LinkModel) {
        linkDatasource.update(link: link)
    }
    
    func delete(link: LinkModel) {
        linkDatasource.delete(link: link)
    }
}
