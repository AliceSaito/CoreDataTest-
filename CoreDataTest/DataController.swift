//
//  DataController.swift
//  CoreDataTest
//
//  Created by ALICE SAITO on 2020/01/30.
//  Copyright © 2020 ALICE SAITO. All rights reserved.
//

import Foundation
import UIKit
import CoreData
//既存のデータを追加、削除、修正
class DataController: NSObject {
//    Model.xcdatamodeldをロードする
    var persistentContainer: NSPersistentContainer!
//クロージャーで自分自身を参照する時に＠をつける。モデルというコアデータのマップをロードして、persistentContainerに入れる。
    init(completionClosure: @escaping () -> ()) {
        persistentContainer = NSPersistentContainer(name: "Model")
//        タプル型のパラメーター
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
//                \(error)にはエラーの理由がコンソルに出力される
                fatalError("Failed to load Core Data stack: \(error)")
            }
            completionClosure()
        }
    }

    //persistentContainerの中に定義されているNoteというEntityのオブジェクトを作って、それを返す。
//    新しいスケジュールをNoteに作る。
    func createNote() -> Note {
        let context = persistentContainer.viewContext
        let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context) as! Note
        return note
    }
//書いたNoteを保存する。
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
//    fetch：保存されているデータを取得する。条件がないから全てのスケジュールを取得している。
    func fetchNotes() -> [Note] {
        let context = persistentContainer.viewContext
        let notesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")

        do {
            let fetchedNotes = try context.fetch(notesFetch) as! [Note]
            return fetchedNotes
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }

        return []
    }
    
//    上の条件式が入っているバージョン。predicate：条件を入れるためのもの。
    func fetchNote(value:String) -> [Note] {
        let context = persistentContainer.viewContext
        let notesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        notesFetch.predicate = NSPredicate(format: "title == %@",value)

        do {
            let fetchedNotes = try context.fetch(notesFetch) as! [Note]
            return fetchedNotes
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }

        return []
    }
}
