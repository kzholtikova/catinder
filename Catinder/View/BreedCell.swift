import UIKit

final class BreedCell: UITableViewCell {
    static let reuseIdentifier = "BreedCell"
    
    private let breedImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 24, weight: .heavy)
        label.textColor = .black
        
        return label
    }()
    
    public static let identifier = "breed"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = nil
        breedImageView.image = nil
    }
    
    private func setupView() {
        contentView.addSubview(breedImageView)
        contentView.addSubview(nameLabel)
        
        breedImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview().inset(10)
            $0.height.width.equalTo(130)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(breedImageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
    }
    
    func setupCell(with breed: Breed, image: UIImage?) {
        nameLabel.text = breed.name
        guard let breedImage = image else {
            return breedImageView.backgroundColor = .gray
        }
        breedImageView.image = breedImage
    }
}
