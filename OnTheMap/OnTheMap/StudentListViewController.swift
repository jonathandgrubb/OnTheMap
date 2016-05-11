//
//  StudentListViewController.swift
//  OnTheMap
//
//  Created by Jonathan Grubb on 4/28/16.
//  Copyright © 2016 Jonathan Grubb. All rights reserved.
//

import UIKit

class StudentListViewController: UIViewController {

    override func viewDidLoad() {
        // configure tap recognizer
        //let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        //tapRecognizer.numberOfTapsRequired = 1
        //tapRecognizer.delegate = self
        //view.addGestureRecognizer(tapRecognizer)
    }
}

/*
extension StudentListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let CellReuseId = "MovieSearchCell"
        let movie = movies[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(CellReuseId) as UITableViewCell!
        
        if let releaseYear = movie.releaseYear {
            cell.textLabel!.text = "\(movie.title) (\(releaseYear))"
        } else {
            cell.textLabel!.text = "\(movie.title)"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let movie = movies[indexPath.row]
        let controller = storyboard!.instantiateViewControllerWithIdentifier("MovieDetailViewController") as! MovieDetailViewController
        controller.movie = movie
        navigationController!.pushViewController(controller, animated: true)
    }
}
*/
