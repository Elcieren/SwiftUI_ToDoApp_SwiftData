## SwiftUI_ToDoApp_SwiftData
| SwiftData Veri Ekle&&Silme&&Duzenleme |
|---------|
| ![Video 1](https://github.com/user-attachments/assets/85087770-72f4-4ce6-92cd-c359311e645c) | 


 <details>
    <summary><h2>Uygulamanın Amacı ve Senaryo Mantığı</h2></summary>
    Proje Amacı
   Bu uygulama, iki farklı veri kaynağından (local JSON dosyası ve canlı web servisi) veri çekmek için yapılandırılmıştır. Amaç, arka uç (backend) tarafında yapılan değişiklikleri hızlıca test edebilmek ve veri akışını bir satırla değiştirebilmek. Geliştirilen senaryoya göre, arka uç geliştiren kişiyle iletişim kurarak, uygulama içinde yapılan JSON verisi değişikliklerini hızlıca görebilmek hedeflenmiştir. Bu nedenle, LocalService ve WebService sınıfları farklı veri çekme yöntemlerini implement eder, ancak ana yapı değişmeden kalır. Bu senaryoda, uygulama sadece hangi veri kaynağından veri çekeceğini belirler ve bu kaynak, kolayca değiştirilebilir.
  </details>  


  <details>
    <summary><h2>MVVM Yapısı</h2></summary>
     Bu yapı ile uygulamanız, kullanıcıların Todo öğelerini eklemesini, listelemesini, düzenlemesini ve silmesini sağlar. SwiftData ile veritabanı yönetimi yapılırken, MVVM yapısı ile kodunuzu daha temiz ve yönetilebilir tutarsınız.
     MVVM (Model-View-ViewModel) yapısı, uygulamanın veri ile ilgili iş mantığının View ve Model arasında temiz bir ayrım yaparak yönetilmesine olanak tanır. Bu yapı, uygulamanın daha kolay yönetilmesini, test edilmesini ve bakımının yapılmasını sağlar.
     - Model
     - View
     - Viewmodel
  </details> 

  <details>
    <summary><h2>AddToDoScreen (Yeni Todo Ekleme Ekranı)</h2></summary>
    @Environment(.modelContext): SwiftData'dan gelen model context'e erişim sağlar. Bu, verileri kaydetmek ve yönetmek için kullanılır.
    @Environment(.dismiss): Ekranı kapatmak için kullanılan dismiss fonksiyonuna erişim sağlar.
    @State private var name ve @State private var priority: Kullanıcının girdiği verileri (Todo öğesinin adı ve önceliği) tutar.
    isFormValid: Formun geçerli olup olmadığını kontrol eden bir hesaplanan özellik. Adın boş olup olmadığı ve önceliğin seçilip seçilmediğini kontrol eder.
    TextField: Kullanıcının isim ve öncelik bilgilerini girmesini sağlar.
    ToolbarItem: Ekranın üst kısmında iki buton (gizle ve kaydet) gösterir. Kaydetme butonu, form geçerli değilse devre dışı bırakılır
    
    ```
     import SwiftUI
      import SwiftData

    struct AddToDoScreen: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var name : String = ""
    @State private var priority : Int?
    
    private var isFormValid : Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty && priority != nil
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField(text: $name) {
                    Text("Name")
                }
                TextField(value: $priority, format: .number) {
                    Text("Priority")
                }
            }.navigationTitle("Add ToDo")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Text("Dismiss")
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            guard let priority = priority else { return }
                            let toDo = ToDo(name: name, priority: priority)
                            // Kaydetme işlemi
                            context.insert(toDo)
                            do {
                                try context.save()
                            } catch {
                                print(error.localizedDescription)
                            }
                            dismiss()
                        } label: {
                            Text("Save")
                        }.disabled(!isFormValid)
                    }
                }
        }
    }
    }


    ```
  </details> 


  <details>
    <summary><h2>ListScreen (Todo Listeleme Ekranı)</h2></summary>
   @Query: Bu, SwiftData'nın veritabanındaki Todo öğelerini sıralar. Burada, isimlerine göre artan sırayla Todo öğeleri çekiliyor.
   isAddToDoPresented: Yeni Todo ekranının gösterilip gösterilmeyeceğini kontrol eden bir durum (state).
   .sheet(isPresented: $isAddToDoPresented): Bu, kullanıcı "Add ToDo" butonuna tıkladığında AddToDoScreen ekranını açan bir modal (sayfa açma) görünümüdür.
    
    ```
    import SwiftUI

    struct ListScreen: View {
    @Query(sort: \ToDo.name, order: .forward) private var toDos: [ToDo]
    @State private var isAddToDoPresented : Bool = false
    
    
    var body: some View {
        ToDoListView(toDos: toDos)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isAddToDoPresented = true
                    } label: {
                        Text("Add ToDo")
                    }

                }
            }
            .sheet(isPresented: $isAddToDoPresented) {
                NavigationStack{
                    AddToDoScreen()
                }
            }
        
    }
    }

    #Preview {
    NavigationStack {
        ListScreen().modelContainer(for: [ToDo.self])
    }
    }

    ```
  </details> 


  <details>
    <summary><h2>ToDoListView (Todo Liste Görünümü)</h2></summary>
   List: Todo öğelerini liste halinde gösterir. ForEach, her bir Todo öğesini döngüye sokarak görüntüler.
   NavigationLink: Her bir Todo öğesine tıklandığında, detay ekranına gitmek için kullanılan bir bağlantıdır.
   onDelete: Kullanıcı bir öğeyi silmek istediğinde tetiklenen bir işlem. Silinen Todo öğesi context.delete(toDo) ile silinir ve sonra veritabanına kaydedilir.
   navigationDestination: Bir Todo öğesine tıklandığında detay ekranına yönlendirilir.
    
    ```
    import SwiftUI

    struct ToDoListView: View {
    let toDos : [ToDo]
    @Environment(\.modelContext) private var context
    
    var body: some View {
        List {
            ForEach(toDos) { toDo in
                NavigationLink(value: toDo) {
                    HStack {
                        Text(toDo.name)
                        Spacer()
                        Text(toDo.priority.description)
                    }
                }
            }.onDelete { indexSet in
                indexSet.forEach { index in
                    let toDo = toDos[index]
                    context.delete(toDo)
                    do {
                        try context.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }.navigationDestination(for: ToDo.self) { toDo in
            ToDoDetailScreen(toDo: toDo)
        }
    }
     }

    #Preview {
    ToDoListView(toDos: [ToDo(name: "Test", priority: 123)]).modelContainer(for: [ToDo.self])
    }




    ```
  </details> 

  

  
  <details>
    <summary><h2>Model (ToDo)</h2></summary>
     @Model: SwiftData'da veri modeli olduğunu belirtir. Burada ToDo sınıfı, her Todo öğesinin adı (name) ve önceliği (priority) gibi bilgileri tutar.
    init(name:priority:): ToDo nesnesinin oluşturulabilmesi için bir başlatıcı (constructor) fonksiyonu sağlar.
    
    ```
    import Foundation
    import SwiftData

    @Model
    final class ToDo {
    var name: String
    var priority : Int
    
    init(name: String, priority: Int) {
        self.name = name
        self.priority = priority
     }
    }


    ```
  </details> 



  


<details>
    <summary><h2>Uygulama Görselleri </h2></summary>
    
    
 <table style="width: 100%;">
    <tr>
        <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">SwidtData Veri Ekleme</h4>
            <img src="https://github.com/user-attachments/assets/b1035c0b-7120-485d-a36f-15ccc6497fed" style="width: 100%; height: auto;">
        </td>
        <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">SwiftData Veri Silme</h4>
            <img src="https://github.com/user-attachments/assets/ab622ee5-ef5a-4554-8504-ae96f7cf82e6" style="width: 100%; height: auto;">
        </td>
              <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">SwiftData Veri Guncelleme</h4>
            <img src="https://github.com/user-attachments/assets/2f23c617-cfeb-4bcf-9bfb-3ef37ab16e2d" style="width: 100%; height: auto;">
        </td>
    </tr>
</table>
  </details> 
