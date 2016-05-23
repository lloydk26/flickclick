//
//  ViewController.swift
//  FlickSearch
//
//  Created by Lloyd Kevin Urbino on 5/23/16.
//  Copyright © 2016 Lloyd Kevin Urbino. All rights reserved.
//

import UIKit
import AssetsLibrary
import Photos


class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var searchResults: UICollectionView!
    
    //testing purposes
     var albumArr = [PHAssetCollection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResults.delegate = self
        searchResults.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func searchImage(sender: AnyObject) {
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        <#code#>
    }
}

