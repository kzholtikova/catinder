import Foundation
import Combine

final class RandomCatViewModel {
    private var randomCatSubject = CurrentValueSubject<CatModel?, Never>(nil)
    private var isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    private let catAPIService: CatAPIService
    var cancellables = Set<AnyCancellable>()
    
    var randomCatPublisher: AnyPublisher<CatModel?, Never> {
        randomCatSubject.eraseToAnyPublisher()
    }

    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        isLoadingSubject.eraseToAnyPublisher()
    }
    
    init(catAPIService: CatAPIService) {
        self.catAPIService = catAPIService
        fetchRandomCat()
    }
    
    private func fetchRandomCat() {
        isLoadingSubject.send(true)
        
        catAPIService.fetchCats(limit: 1)
            .compactMap { $0.first }
            .flatMap { [weak self] cat in
                self?.catAPIService.fetchCatImage(for: cat) ?? Empty().eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoadingSubject.send(false)
                if case .failure = completion {
                    self?.randomCatSubject.send(nil)
                }
            } receiveValue: { [weak self] cat in
                self?.randomCatSubject.send(cat)
            }
            .store(in: &cancellables)
    }
    
    func likeCat() {
        guard let currentCat = randomCatSubject.value else { return }
        print("Liked cat \(currentCat.id)")
    }
    
    func dislikeCat() {
        guard let currentCat = randomCatSubject.value else { return }
        print("Disliked cat \(currentCat.id)")
    }
}
