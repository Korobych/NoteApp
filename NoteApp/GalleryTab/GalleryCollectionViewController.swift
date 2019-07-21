//
//  GalleryCollectionViewController.swift
//  NoteApp
//
//  Created by Sergey Korobin on 21/07/2019.
//  Copyright © 2019 SergeyKorobin. All rights reserved.
//

import UIKit

class GalleryCollectionViewController: UIViewController {
    
    var imageNamesArray: [String] = []
    var imagesArray: [UIImage] = []
    
    @IBOutlet weak var galleryCollectionView: UICollectionView!{
        didSet{
            galleryCollectionView.delegate = self
            galleryCollectionView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // test array with multiple use of the same image name
        imageNamesArray = ["spectrumPic", "spectrumPic", "spectrumPic", "spectrumPic", "spectrumPic", "spectrumPic", "spectrumPic", "spectrumPic"]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        galleryCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGalleryPreview" {
            guard let indexPath = sender as? IndexPath else {return}
            guard let nextVC = segue.destination as? ImagePreviewViewController else {return}
            nextVC.imagesArray = imagesArray
            nextVC.selectedImageIndex = indexPath.row
        }
    }
    
}

extension GalleryCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: UICollectionViewDelegate methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showGalleryPreview", sender: indexPath)
    }
    
    // MARK: UICollectionViewDataSource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // test
        return imageNamesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! GalleryCollectionViewCell
        guard let currentImage = UIImage(named: imageNamesArray[indexPath.row])
            else {
                cell.backgroundColor = .gray
                return cell
        }
        imagesArray.append(currentImage)
        cell.imageView.image = currentImage
        
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (galleryCollectionView.bounds.size.width - 40) / 3
        let cellHeight = cellWidth
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
}
