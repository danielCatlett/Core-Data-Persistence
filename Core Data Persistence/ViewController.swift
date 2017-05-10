//  ViewController.swift
//  Core Data Persistence
//
//  Created by Daniel Catlett on 5/9/17.
//  Copyright © 2017 Daniel Catlett. All rights reserved.

import UIKit
import CoreData

class ViewController: UIViewController
{
    private static let lineEntityName = "Line"
    private static let lineNumberKey = "lineNumber"
    private static let lineTextKey = "lineText"
    @IBOutlet var lineFields:[UITextField]!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let request: NSFetchRequest <NSFetchRequestResult> = NSFetchRequest(entityName: ViewController.lineEntityName)
        
        do
        {
            let objects = try context.fetch(request)
            for object in objects
            {
                let lineNum: Int = (object as AnyObject).value(forKey: ViewController.lineNumberKey)! as! Int
                let lineText = (object as AnyObject).value(forKey: ViewController.lineTextKey) as? String ?? ""
                let textField = lineFields[lineNum]
                textField.text = lineText
            }
            
            let app = UIApplication.shared
            NotificationCenter.default.addObserver(self, selector: #selector(UIApplicationDelegate.applicationWillResignActive(_:)), name: NSNotification.Name.UIApplicationWillResignActive, object: app)
        }
        catch
        {
            print("There was an error in executeFetchRequest(): \(error)")
        }
    }
    
    func applicationWillResignActive(_ notification: Notification)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        for i in 0..<lineFields.count
        {
            let textField = lineFields[i]
            
            let request: NSFetchRequest <NSFetchRequestResult> = NSFetchRequest(entityName: ViewController.lineEntityName)
            let pred = Predicate(format: "%K = %d", ViewController.lineNumberKey, i)
            request.predicate = pred
            
            do
            {
                let objects = try context.fetch(request)
                var theLine:NSMangaedObject! = objects.first as? NSManagedObject
                if(theLine == nil)
                {
                    NSEntityDescription.insertNewObject(forEntityName: ViewController.lineEntityName, into: context) as NSManagedObject
                }
                
                theLine.setValue(i, forKey: ViewController.lineNumberKey)
                theLine.setValue(textField.text, forKey: ViewController.lineTextKey)
            }
            catch
            {
                print("there was an error in executeFetchRequest(): \(error)")
            }
        }
        appDelegate.saveContext()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

