import UIKit

final class ArticleCell: UITableViewCell {

    // MARK: - Constants
    private enum Constants {
        static let imageHeight: CGFloat = 200

        static let titleFontSize: CGFloat = 16
        static let descriptionFontSize: CGFloat = 14

        static let imageTopInset: CGFloat = 8
        static let imageSideInset: CGFloat = 8

        static let titleTopInset: CGFloat = 8
        static let titleSideInset: CGFloat = 8

        static let descriptionTopInset: CGFloat = 4
        static let descriptionSideInset: CGFloat = 8
        static let descriptionBottomInset: CGFloat = 8

        static let shimmerAlpha: CGFloat = 0.3

        static let fallbackImageName = "photo"
    }

    // MARK: - UI Elements
    private let newsImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Constants.titleFontSize)
        label.numberOfLines = 2
        label.textColor = .label
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.descriptionFontSize)
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

        newsImageView.pinTop(to: contentView.topAnchor, Constants.imageTopInset)
        newsImageView.pinLeft(to: contentView.leadingAnchor, Constants.imageSideInset)
        newsImageView.pinRight(to: contentView.trailingAnchor, Constants.imageSideInset)
        newsImageView.setHeight(Constants.imageHeight)

        titleLabel.pinTop(to: newsImageView.bottomAnchor, Constants.titleTopInset)
        titleLabel.pinLeft(to: contentView.leadingAnchor, Constants.titleSideInset)
        titleLabel.pinRight(to: contentView.trailingAnchor, Constants.titleSideInset)

        descriptionLabel.pinTop(to: titleLabel.bottomAnchor, Constants.descriptionTopInset)
        descriptionLabel.pinLeft(to: contentView.leadingAnchor, Constants.descriptionSideInset)
        descriptionLabel.pinRight(to: contentView.trailingAnchor, Constants.descriptionSideInset)
        descriptionLabel.pinBottom(to: contentView.bottomAnchor, Constants.descriptionBottomInset)
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
                        self.newsImageView.image = UIImage(systemName: Constants.fallbackImageName)
                    }
                    self.hideShimmer()
                }
            }
        } else {
            newsImageView.image = UIImage(systemName: Constants.fallbackImageName)
            hideShimmer()
        }
    }

    // MARK: - Shimmer Effect
    private func showShimmer() {
        let shimmer = UIView(frame: newsImageView.bounds)
        shimmer.backgroundColor = UIColor.lightGray.withAlphaComponent(Constants.shimmerAlpha)
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
