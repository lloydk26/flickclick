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


class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var searchResults: UICollectionView!
    
    let baseUrl = "https://api.flickr.com/services/rest/"
    let methodName = "flickr.photos.search"
    let apiKey = "e10a8006ecdcd8c37b16c74b3ad90103"
    let apiSecret = "26cab35aa3c2f760"
    let extra = "url_m"
    let dataFormat = "json"
    var imageArray : NSMutableArray! = NSMutableArray()
//    let safeSearch = "1"
//    let noJSONCallback = "1"
    
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
        searchingImage()
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
     let cell = searchResults.dequeueReusableCellWithReuseIdentifier("flickerPhotoCell", forIndexPath: indexPath) as! FlickrPhoto
        let queue:dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        dispatch_async(queue, { () -> Void in
            let flickrPhoto : FlickrPhotoObject = self.imageArray.objectAtIndex(indexPath.item) as! FlickrPhotoObject
            let error:NSError?
            let imageData : NSData = NSData(contentsOfURL: flickrPhoto.imageUrl)!
            let image:UIImage = UIImage(data: imageData)!
                
                dispatch_async(dispatch_get_main_queue(), {
                    cell.thumbnail.image = image
                    
                })
        })
        return cell
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchingImage()
    }
    
    func searchingImage(){
        let searchText = searchBar.text
        print("Name >>",searchText)
        let search:String = searchBar.text!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let url =  "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(search)&per_page=100&format=json&nojsoncallback=1"
            requestImage(url)
        
    }
    
    func requestImage(baseUrl : String){
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: baseUrl)
        let request = NSURLRequest(URL: url!)
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            if let requestError = error{
                print("ERROR: \(error)")
            }
                
            else{
                let result: AnyObject!
                do {
                    result = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                } catch let error as NSError {
                    print(error)
                    result = nil
                } catch {
                    fatalError()
                }
                
                
                if let photosDictionary = result.valueForKey("photos") as? NSDictionary {
                    print(photosDictionary)
                    if let photoArray = photosDictionary.valueForKey("photo") as? [[String: AnyObject]] {
                        for (var index = 0; index < photoArray.count; ++index ){
                            
                            let photoDictionary = photoArray[index] as [String: AnyObject]
                            print("Item # \(index), \(photoDictionary) ")
                            dispatch_async(dispatch_get_main_queue(), {
                                let image : FlickrPhotoObject = FlickrPhotoObject()
                                    image.farm = photoDictionary["farm"] as! Int
                                    image.server = photoDictionary["secret"] as! String
                                    image.secret = photoDictionary["secret"] as! String
                                    image.photoID = photoDictionary["id"] as! String
                                    image.photoName = photoDictionary["title"] as? String
                                let imageUrl : NSURL = NSURL(string: "http://farm\(image.farm).staticflickr.com/\(image.server)/\(image.photoID)_\(image.secret)_m.jpg")!
                                    print("ImageUrl >>>",imageUrl)
                                    image.imageUrl = imageUrl
                                    self.imageArray.addObject(image)
                                })
                                print("Array Size >>>>",self.imageArray.count)
                        }
                        self.searchResults.reloadData()
                    } else {
                        print("Cant find key 'photo' in \(photosDictionary)")
                    }
                } else {
                    print("Error")
                }
            
        
                
            }
        })
        
        task.resume()
    }

    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        searchBar.resignFirstResponder()
    }

}

