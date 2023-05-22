//
//  TodoView.swift
//  weather_music_food_todo_app
//
//  Created by 坂井泰吾 on 2023/05/20.
//

import SwiftUI
import CoreData

struct TodoView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        VStack {
            NavigationView {
                List {
                    ForEach(items) { item in
                        NavigationLink(destination: ScrollView(.vertical) {
                            Text("\(item.itemDescription ?? "") - \(item.timestamp!, formatter: itemFormatter)に追加")
                        }) {
                            Text("\(item.itemDescription ?? "") - \(item.timestamp!, formatter: itemFormatter)")
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button(action: addItem) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                    
                }
                
            }
        }
    }


    private func addItem() {
        // ユーザーからの入力を受け取るためのアラートを表示
        let alertController = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Enter item description"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let itemDescription = alertController.textFields?.first?.text {
                withAnimation {
                    let newItem = Item(context: viewContext)
                    newItem.timestamp = Date()
                    newItem.itemDescription = itemDescription

                    do {
                        try viewContext.save()
                    } catch {
                        // エラーハンドリングの実装
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true, completion: nil)
    }

    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        TodoView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
