
//
//  worldTime.swift
//  AlarmProject
//
//  Created by 유영웅 on 2022/07/15.
//

import Foundation
import SwiftUI


struct Alarm:View{
    
    
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var alarmAdd: Bool = false
    @State var contentAdd: Bool = false
    @State var button:String = "plus.app.fill"
    @State private var current = Date()
    @State var currentDate = Date()
    @State var timeName = String()
    @Binding var alarm : Bool
    
    
    @Environment(\.managedObjectContext) var mac
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Entity.time, ascending: true),NSSortDescriptor(keyPath: \Entity.alarmText, ascending: true)]) var timeList: FetchedResults<Entity>
 
    
    init(alarm:Binding<Bool> = .constant(false)){
        _alarm = alarm
        
    }
    var body: some View{
        ZStack{
            Image("NIGHT").resizable().edgesIgnoringSafeArea(.all)
            VStack{
                HStack{
                    Text(FormatterClass.init().yearFormatter.string(from: currentDate)).font(.system(size: 20)).bold().foregroundColor(.white)
                               .onReceive(timer) { input in
                                    self.currentDate = input
                                   //print(FormatterClass.init().timeFormatter.string(from: currentDate))
                                   
                               }
                    
                }
                    DatePickerWindow()
                

                
                List{
                    ForEach(timeList){ list in
                        AlarmList(time: list.time ?? "" ,content: list.alarmText ?? "unknown" )
                            .onAppear(){
                            timeName = list.alarmText ?? "unknown"
                            }
                            .listRowBackground(Color.white.opacity(0))
                        
                    }.onDelete(perform: deleteBooks)
                         
                }.listStyle(PlainListStyle())
            }
        }
            
    }
    func deleteBooks(at offsets: IndexSet) {
        
        guard let index = offsets.first else { return }
        let times = timeList[index]
        AlertAlarm().caancelAlarm(name: times.alarmText ?? "unknown",num: times.time ?? "")
//        print(times.alarmText ?? "unknown")
//        print(index)
        mac.delete(times)
        try? mac.save()
        
        
        
    }
    
}
struct Alarm_Previews: PreviewProvider {
    static var previews: some View {
        Alarm()
    }
}
