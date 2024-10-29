//
//  ViewController.swift
//  Marvel_Heroes
//
//  Created by Effective on 24.10.2024.
//

import UIKit
import PagingCollectionViewLayout

class ViewController: UIViewController{
    
    
    class HeroCell: UICollectionViewCell {
        
        private let backgroundContainerView: UIView = {
            let view = UIView()
            view.layer.masksToBounds = true
            return view
        }()
        
        private let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 10
            return imageView
        }()
        
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
            label.textColor = .white
            label.textAlignment = .center
            label.numberOfLines = 2
            return label
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            contentView.addSubview(backgroundContainerView)
            backgroundContainerView.addSubview(imageView)
            backgroundContainerView.addSubview(titleLabel)

            backgroundContainerView.translatesAutoresizingMaskIntoConstraints = false
            imageView.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                backgroundContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
                backgroundContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                backgroundContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                backgroundContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                
                imageView.topAnchor.constraint(equalTo: backgroundContainerView.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: backgroundContainerView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: backgroundContainerView.trailingAnchor),
                imageView.bottomAnchor.constraint(equalTo: backgroundContainerView.bottomAnchor),
                
                
                titleLabel.centerXAnchor.constraint(equalTo: backgroundContainerView.centerXAnchor),
                titleLabel.centerYAnchor.constraint(equalTo: backgroundContainerView.centerYAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: backgroundContainerView.leadingAnchor, constant: 10),
                titleLabel.trailingAnchor.constraint(equalTo: backgroundContainerView.trailingAnchor, constant: -10)
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configure(with text: String, backgroundColor: UIColor, image: UIImage?) {
            titleLabel.text = text
            backgroundContainerView.backgroundColor = backgroundColor
            imageView.image = image
        }
    }
    
    class CardPagingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
        private var collectionView: UICollectionView!
        private let cellIdentifier = "HeroCell"
        private let itemSize = CGSize(width: 250, height: 350)
        private let minScale: CGFloat = 0.8
        private let backgroundImageView = UIView()
        private let headerLabel = UILabel()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            setupBackgroundView()
            
            setupHeaderLabel()

            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = itemSize
            layout.minimumLineSpacing = 16
            layout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
            
            collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
            collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            collectionView.decelerationRate = .fast
            collectionView.backgroundColor = .clear
            collectionView.dataSource = self
            collectionView.delegate = self
            
            collectionView.register(HeroCell.self, forCellWithReuseIdentifier: cellIdentifier)
            
            view.addSubview(collectionView)
            view.bringSubviewToFront(headerLabel)
        }
        
        private func setupBackgroundView() {
            backgroundImageView.backgroundColor = UIColor.systemTeal
            backgroundImageView.frame = view.bounds
            backgroundImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            view.addSubview(backgroundImageView)
            view.sendSubviewToBack(backgroundImageView)
        }
        
        private func setupHeaderLabel() {

            headerLabel.text = "Choose your hero!"
            headerLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            headerLabel.textColor = .white
            headerLabel.textAlignment = .center
            
            headerLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(headerLabel)
            
            NSLayoutConstraint.activate([
                headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
            ])
        }
        
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 3
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? HeroCell else {
                return UICollectionViewCell()
            }
            
            let backgroundColor = UIColor(hue: CGFloat(indexPath.item) / 20, saturation: 0.8, brightness: 0.8, alpha: 1)
            let text = "Deadpool"
            let image = UIImage(named: "image\(indexPath.item % 2)")
            cell.configure(with: text, backgroundColor: backgroundColor, image: image)
            
            return cell
        }
        
        
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                            layoutAttributesForElementsIn rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            guard let attributes = collectionViewLayout.layoutAttributesForElements(in: rect) else {
                return nil
            }
            
            let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
            let centerX = visibleRect.midX
            
            for attribute in attributes {
                let distanceFromCenter = abs(attribute.center.x - centerX)
                let maxDistance = visibleRect.width / 2
                let scale = max(minScale, 1 - (distanceFromCenter / maxDistance) * (1 - minScale))
                attribute.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
            return attributes
        }
    }
}
