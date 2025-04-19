//
//  ChartDataView.swift
//  FitnessApp
//
//  Created by mac on 4/9/25.
//
import SwiftUI
import Charts

struct ChartDataView: View {
    
    @State var average: Int
    @State var total: Int
    
    var body: some View {
                                HStack {
                                    Spacer()
                                    
                                    VStack(spacing: 16) {
                                        Text("Average")
                                            .font(.title2)
                                        
                                        Text("\(average)")
                                            .font(.title3)
                                    }
                                    .frame(width: 90)
                                    .foregroundStyle(.black)
                                    .padding()
                                    .background(.gray.opacity(0.1))
                                    .cornerRadius(10)
                                    
                                    Spacer()
                                    
                                    VStack(spacing: 16) {
                                        Text("Total")
                                            .font(.title2)
                                        
                                        Text("\(total)")
                                            .font(.title3)
                                    }
                                    .frame(width: 90)
                                    .foregroundStyle(.black)
                                    .padding()
                                    .background(.gray.opacity(0.1))
                                    .cornerRadius(10)
                                    
                                    Spacer()
                                    
                                }
                                

    }
}

#Preview {
    ChartDataView(average: 1212, total: 232)
}


