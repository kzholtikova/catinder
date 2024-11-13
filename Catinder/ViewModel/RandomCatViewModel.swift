import Foundation
import Combine
import UIKit

final class RandomCatViewModel {
    private var catSubject = CurrentValueSubject<Cat?, Never>(nil)
    private let catImageSubject = PassthroughSubject<UIImage?, Never>()
    private var isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    private let catAPIService: CatAPIService
    var cancellables = Set<AnyCancellable>()
    
    var catPublisher: AnyPublisher<Cat?, Never> {
        catSubject.eraseToAnyPublisher()
    }
    
    var catImagePublisher: AnyPublisher<UIImage?, Never> {
        catImageSubject.eraseToAnyPublisher()
    }

    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        isLoadingSubject.eraseToAnyPublisher()
    }
    
    init(catAPIService: CatAPIService) {
        self.catAPIService = catAPIService
    }
    
    func fetchRandomCat() {
        isLoadingSubject.send(true)
        
        catAPIService.fetchCats(limit: 1)
            .compactMap { $0.first }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure = completion {
                    self?.catSubject.send(nil)
                }
            } receiveValue: { [weak self] cat in
                self?.catSubject.send(cat)
            }
            .store(in: &cancellables)
    }
    
     func fetchCurrentCatImage() {
        guard let cat = catSubject.value, let url = URL(string: cat.url) else { return }
        
        catAPIService.fetchImage(at: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoadingSubject.send(false)
                if case .failure = completion {
                    self?.catImageSubject.send(nil)
                }
            }, receiveValue: { [weak self] image in
                self?.catImageSubject.send(image)
            })
            .store(in: &cancellables)
    }
    
    func likeCat() {
        guard let currentCat = catSubject.value else { return }
        print("Liked cat \(currentCat.id)")
        fetchRandomCat()
    }
    
    func dislikeCat() {
        guard let currentCat = catSubject.value else { return }
        print("Disliked cat \(currentCat.id)")
        fetchRandomCat()
    }
}
