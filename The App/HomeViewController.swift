//
//  HomeViewController.swift
//  The App
//
//  Created by Hugo Prinsloo on 2017/01/03.
//  Copyright © 2017 Hugo Prinsloo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bannerView: StoreBannerView!
    
    fileprivate enum Items {
        case cropper
        case unknown
        
        var backgroundImage: UIImage? {
            switch self {
            case .cropper:
                return UIImage(named: "Cropper-Icon")
            case .unknown:
                return UIImage(named: "Placeholder")
            }
        }
        
        var title: String {
            switch self {
            case .cropper:
                return "The Cropper"
            case .unknown:
                return "Coming soon"
            }
        }
    }
    
    fileprivate let items: [Items] = [.cropper, .unknown, .unknown, .unknown, .unknown]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .blackTranslucent
        navigationController?.title = "The App"
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerView.delegate = self
        bannerView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "HomeCell")
                
        let layout = GridLayout()
        layout.footerState = .collapsed
        collectionView.collectionViewLayout = layout
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch items[indexPath.row] {
        case .cropper:
            let vc = CropperViewController.create()
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
        switch items[indexPath.count] {
        case .cropper:
            cell.backgroundImageView.image = items[indexPath.row].backgroundImage
            cell.backgroundImageView.alpha = 1.0
            cell.title.text = items[indexPath.row].title
        case .unknown:
            cell.backgroundImageView.alpha = 0.5
            cell.backgroundImageView.image = items[indexPath.row].backgroundImage
            cell.title.text = items[indexPath.row].title
        }
        return cell
    }
}

extension HomeViewController: StoreBannerViewDelegate, StoreBannerViewDataSource {
    func storeBannerView(_ storeBannerView: StoreBannerView, didSelectItemAtIndex index: Int) {
        
    }
    
    func storeBannerViewNumberOfImages(_ storeBannerView: StoreBannerView) -> Int {
        return 3
    }
    
    func storeBannerView(_ storeBannerView: StoreBannerView, imageAtIndex index: Int) -> UIImage {
        return UIImage(named: "BannerView")!
    }
    
}

class HomeCollectionViewCell: UICollectionViewCell {
    
    let backgroundImageView = UIImageView(frame: .zero)
    let title = UILabel(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        comminInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        comminInit()
    }
    
    func comminInit() {
        
        contentView.addSubview(title)
        contentView.addSubview(backgroundImageView)
        
        backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.backgroundColor = UIColor.lightGray
        backgroundImageView.layer.cornerRadius = 8
        backgroundImageView.clipsToBounds = true

        title.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4).isActive = true
        title.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: 5).isActive = true
        title.translatesAutoresizingMaskIntoConstraints = false
        
        title.font = UIFont(name: "HelveticaNeue", size: 12)

        title.textAlignment = .center
        title.textColor = UIColor.white
    }
}
