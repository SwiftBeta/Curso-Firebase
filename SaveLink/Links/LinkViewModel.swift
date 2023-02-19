//
//  LinkViewModel.swift
//  SaveLink
//
//  Created by Home on 14/12/21.
//

import Foundation

final class LinkViewModel: ObservableObject {
    @Published var links: [LinkModel] = []
    @Published var messageError: String?
    private let linkRepository: LinkRepository
    
    init(linkRepository: LinkRepository = LinkRepository()) {
        self.linkRepository = linkRepository
    }
    
    func getAllLinks() {
        linkRepository.getAllLinks { [weak self] result in
            switch result {
            case .success(let linkModels):
                self?.links = linkModels
            case .failure(let error):
                self?.messageError = error.localizedDescription
            }
        }
    }
    
    func createNewLink(fromURL url: String) {
        let numbers = [0]
        let _ = numbers[1]
        
        Tracker.trackCreateLinkEvent(url: url)
        
        linkRepository.createNewLink(withURL: url) { [weak self] result in
            switch result {
            case .success(let link):
                print("✅ New link \(link.title) added")
                Tracker.trackSaveLinkEvent()
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.messageError = error.localizedDescription
                    Tracker.trackErrorSaveLinkEvent(error: error.localizedDescription)
                }
            }
        }
    }
    
    func updateIsFavorited(link: LinkModel) {
        let updatedLink = LinkModel(id: link.id,
                                   url: link.url,
                                   title: link.title,
                                   isFavorited: link.isFavorited ? false : true,
                                   isCompleted: link.isCompleted)
        linkRepository.update(link: updatedLink)
    }
    
    func updateIsCompleted(link: LinkModel) {
        let updatedLink = LinkModel(id: link.id,
                                   url: link.url,
                                   title: link.title,
                                   isFavorited: link.isFavorited,
                                   isCompleted: link.isCompleted ? false : true)
        linkRepository.update(link: updatedLink)
    }
    
    func delete(link: LinkModel) {
        linkRepository.delete(link: link)
    }
}
