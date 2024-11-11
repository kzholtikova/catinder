import Foundation
import Combine
import UIKit

final class CatBreedsViewModel {
    private var breedModelsSubject = PassthroughSubject<[BreedModel], Never>()
    private var isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    private let catAPIService: CatAPIService
    var cancellables = Set<AnyCancellable>()
    
    var breedModelsPublisher: AnyPublisher<[BreedModel], Never> {
        breedModelsSubject.eraseToAnyPublisher()
    }
    
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        isLoadingSubject.eraseToAnyPublisher()
    }
    
    init(catAPIService: CatAPIService) {
        self.catAPIService = catAPIService
        fetchBreeds()
    }
    
    private func fetchBreeds() {
        isLoadingSubject.send(true)
        
        catAPIService.fetchCatBreeds()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure = completion {
                    self?.breedModelsSubject.send([])
                }
            } receiveValue: { [weak self] breeds in
                self?.fetchBreedImages(for: breeds)
            }
            .store(in: &cancellables)
    }
    
    private func fetchBreedImages(for breeds: [Breed]) {
        let breedImagePublishers = breeds.map { self.catAPIService.fetchBreedImage(for: $0) }
        
        Publishers.MergeMany(breedImagePublishers)
            .collect()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoadingSubject.send(false)
                if case .failure = completion {
                    self?.breedModelsSubject.send([])
                }
            } receiveValue: { [weak self] breedModels in
                self?.breedModelsSubject.send(breedModels)
            }
            .store(in: &cancellables)
    }
}
