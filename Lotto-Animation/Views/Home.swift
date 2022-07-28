//
//  Home.swift
//  Lotto-Animation
//
//  Created by Daniel Spalek on 26/07/2022.
//

import SwiftUI

struct Home: View {
    var body: some View {
        VStack{
            // MARK: Header
            HStack{
                HStack{
                    Image(systemName: "applelogo")
                    Text("Pay")
                }
                .font(.largeTitle)
                .bold(true)
                .foregroundColor(.white)
                
                Spacer()
                
                Button {
                    
                } label: {
                    Text("BACK")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }

                
            }
            .foregroundColor(.white)
            
            // MARK: Card
            CardView()
            
            // MARK: Footer content
            Group{
                Text("Woohoo!")
                    .font(.system(size: 35, weight: .bold))
                    
                Text("When you send or receive money with someone, you each earn a scratch card that can contain amazing prices!!")
                    .kerning(1.02) //amount of spacing between characters
                    .multilineTextAlignment(.center)
                    .padding(.vertical)
                Button {
                    
                } label: {
                    Text("VIEW BALANCE")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical, 17)
                        .frame(maxWidth: .infinity)
                        .background{
                            Rectangle()
                                .fill(LinearGradient(colors: [
                                    .purple,
                                    .blue
                                ], startPoint: .leading, endPoint: .trailing))
                        }
                }
                .padding(.top, 15)
            }
            .foregroundColor(.white)

        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) //TODO: add alignment top
        .background{
            Color("BG")
                .ignoresSafeArea() //we want the color to ignore safe areas
        }
    }
    
    // MARK: Card View
    @ViewBuilder
    func CardView() -> some View{
        GeometryReader{ proxy in
            let size = proxy.size
            
            ScratchCardView(pointSize: 60) {
                // MARK: Gift card itself
                GiftCardView(size: size)
            } overlay: {
                // MARK: SCRATCH OVERLAY
                Image("Card")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width * 0.9, height: size.width * 0.9, alignment: .topLeading)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                
            } onFinish: {
                    print("Finished")
            }
            .frame(width: size.width, height: size.height, alignment: .center)

        }
        .padding(15)
    }
    
    @ViewBuilder
    func GiftCardView(size: CGSize) -> some View{
        VStack(spacing: 18){
            Image("Trophy")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
            Text("You won")
                .font(.callout)
                .foregroundColor(.gray)
            HStack{
                Image(systemName: "applelogo")
                Text("$59")
            }
            .font(.title)
            .bold()
            .foregroundColor(.black)
            Text("It will be credited within 24 hours.")
                .font(.caption)
                .foregroundColor(.gray)
            
        }
        .padding(20)
        .frame(width: size.width * 0.9, height: size.width * 0.9)
        .background{
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(.white)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
