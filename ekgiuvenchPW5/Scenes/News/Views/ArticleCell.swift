import UIKit

final class ArticleCell: UITableViewCell {
    
    // MARK: - UI Elements
    private let newsImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        label.textColor = .label
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 3
        label.textColor = .secondaryLabel
        return label
    }()
    
    private var shimmerView: UIView?
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        contentView.addSubview(newsImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        newsImageView.pinTop(to: contentView.topAnchor, 8)
        newsImageView.pinLeft(to: contentView.leadingAnchor, 8)
        newsImageView.pinRight(to: contentView.trailingAnchor, 8)
        newsImageView.setHeight(200)
        
        titleLabel.pinTop(to: newsImageView.bottomAnchor, 8)
        titleLabel.pinLeft(to: contentView.leadingAnchor, 8)
        titleLabel.pinRight(to: contentView.trailingAnchor, 8)
        
        descriptionLabel.pinTop(to: titleLabel.bottomAnchor, 4)
        descriptionLabel.pinLeft(to: contentView.leadingAnchor, 8)
        descriptionLabel.pinRight(to: contentView.trailingAnchor, 8)
        descriptionLabel.pinBottom(to: contentView.bottomAnchor, 8)
    }
    
    // MARK: - Configure Cell
    func configure(with article: Article) {
        titleLabel.text = article.title
        descriptionLabel.text = article.announce
        
        showShimmer()
        
        if let url = article.img?.url {
            DispatchQueue.global(qos: .background).async { [weak self] in
                guard let self = self else { return }
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let data = data, let image = UIImage(data: data) {
                        self.newsImageView.image = image
                    } else {
                        self.newsImageView.image = UIImage(systemName: "photo")
                    }
                    self.hideShimmer()
                }
            }
        } else {
            newsImageView.image = UIImage(systemName: "photo")
            hideShimmer()
        }
    }
    
    // MARK: - Shimmer Effect
    private func showShimmer() {
        let shimmer = UIView(frame: newsImageView.bounds)
        shimmer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        shimmer.isUserInteractionEnabled = false
        newsImageView.addSubview(shimmer)
        shimmer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        shimmerView = shimmer
    }
    
    private func hideShimmer() {
        shimmerView?.removeFromSuperview()
        shimmerView = nil
    }
}
