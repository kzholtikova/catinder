import UIKit
import Combine

class LikedCatsViewController: UIViewController {
    private let viewModel: LikedCatsViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CatImageCell.self, forCellWithReuseIdentifier: CatImageCell.identifier)
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    init(viewModel: LikedCatsViewModel = .shared) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        bindViewModel()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        view.backgroundColor = .darkGray
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bindViewModel() {
        viewModel.likedCatsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension LikedCatsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getLikedCats().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatImageCell.identifier, for: indexPath) as? CatImageCell else {
            return UICollectionViewCell()
        }
        let catImage = viewModel.getLikedCats()[indexPath.item]
        
        cell.configure(with: catImage)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 8
        let availableWidth = collectionView.frame.width - padding * 3
        let widthPerItem = availableWidth / 2
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}
