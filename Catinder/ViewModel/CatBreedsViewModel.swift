import Foundation
import Combine
import UIKit

final class CatBreedsViewModel {
    private var breedsSubject = PassthroughSubject<[Breed], Never>()
    private var breedsImagesSubject = PassthroughSubject<[UIImage?], Never>()
    private var isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    private let catAPIService: CatAPIService
    var cancellables = Set<AnyCancellable>()
    
    var breedsPublisher: AnyPublisher<[Breed], Never> {
        breedsSubject.eraseToAnyPublisher()
    }
    
    var breedsImagesPublisher: AnyPublisher<[UIImage?], Never> {
        breedsImagesSubject.eraseToAnyPublisher()
    }
    
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        isLoadingSubject.eraseToAnyPublisher()
    }
    
    init(catAPIService: CatAPIService) {
        self.catAPIService = catAPIService
    }
    
    func fetchBreeds() {
        isLoadingSubject.send(true)
        
        catAPIService.fetchCatBreeds()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure = completion {
                    self?.breedsSubject.send([])
                }
            } receiveValue: { [weak self] breeds in
                self?.breedsSubject.send(breeds)
            }
            .store(in: &cancellables)
        
        fetchBreedsImages()
    }
    
    private func fetchBreedsImages() {
        breedsSubject
            .sink { [weak self] breeds in
                guard let self = self else { return }
                
                let breedImagePublishers = breeds.map { breed in self.catAPIService.fetchImageForBreed(breedID: breed.id) }
                
                Publishers.MergeMany(breedImagePublishers)
                    .collect()
                    .sink(receiveCompletion: { [weak self] completion in
                        self?.isLoadingSubject.send(false)
                        if case .failure = completion {
                            self?.breedsImagesSubject.send([])
                        }
                    }, receiveValue: { [weak self] images in
                        self?.breedsImagesSubject.send(images)
                    })
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)
    }
}
