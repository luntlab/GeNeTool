/*
**    Copyright (C) 2010-2014 Emmanuel FAURE, 
**                California Institute of Technology
**                            Pasadena, California, USA.
**
**    This library is free software; you can redistribute it and/or
**    modify it under the terms of the GNU Lesser General Public
**    License as published by the Free Software Foundation; either
**    version 2.1 of the License, or (at your option) any later version.
**
**    This library is distributed in the hope that it will be useful,
**    but WITHOUT ANY WARRANTY; without even the implied warranty of
**    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
**    Lesser General Public License for more details.
**
**    You should have received a copy of the GNU Lesser General Public
**    License along with this library; if not, write to the Free Software
**    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307  USA
*/


//Draw a light color Menu on the rest
boolean offMenu=false; //Desactivate the mouse for all the others things
boolean colorMenu=false;
boolean ActiveMenuFont=false;




public void changeMenuColor(){
  colorMenu=!colorMenu;
  mWCo.setState(colorMenu);
  if(colorMenu && searchMenu) changeMenuSearch(); //Remove search Menu if it was here
  offMenu=colorMenu;
}

public void MenuColor(){
  fill(colorBackground,175); noStroke(); rect(0,0,width,height); //Draw a white cover on everything
  
  
  int sizeHeightColor=500; int sizeWidthColor=500;
  int ligneX=round(width-sizeWidthColor)/2; int ligneY=round(height-sizeHeightColor)/2;
  
  rect(ligneX-5,ligneY,sizeWidthColor,sizeHeightColor,colorBackground,colorOngletBackground); 
  if(mousePressed && AcceptEvent && !mouseOnMenuOff(ligneX-5,ligneY,sizeWidthColor,sizeHeightColor)) {   AcceptEvent=false;  changeMenuColor();  } //If mouse pressOut out the color Menu come back
  
  
   //COLOR
   noStroke();
   color colorchoose=color(0,0,0);
   for(int Comp=1;Comp<=MenuColorList.length;Comp++){
          colorchoose=colorMenu(Comp);
          if(mouseOnMenuOff(ligneX,ligneY+Comp*25,100,20)) stroke(Textcolor,255); else noStroke();
          if(mousePressOnMenuOff(ligneX,ligneY+Comp*25,100,20)) {ChangeColor=Comp;textSearch=new ArrayList();ActiveMenuFont=false;}
          fill(colorchoose);  rect(ligneX,ligneY+Comp*25,100,20);
          textFont(myFont,12); fill(Textcolor);   text(MenuColorList[Comp-1],ligneX+45-textWidth(MenuColorList[Comp-1])/2,ligneY+Comp*25+14);
          
   }
    if(ChangeColor>=1){
       colorchoose=colorMenu(ChangeColor);
       color Newcolorchoose=colorchoose;
       int NewValue=0;
       NewValue=h_slice(ligneX+150,ligneY+70,0,255,round(red(colorchoose)),color(red(colorchoose),0,0,alpha(colorchoose)),color(colorBackground),"red","choose red");
       if(NewValue!=round(red(colorchoose))) Newcolorchoose=color(NewValue,green(Newcolorchoose),blue(Newcolorchoose),alpha(colorchoose));
       NewValue=h_slice(ligneX+150,ligneY+100,0,255,round(green(colorchoose)),color(0,green(colorchoose),0,alpha(colorchoose)),color(colorBackground),"green","choose green");
       if(NewValue!=round(green(colorchoose))) Newcolorchoose=color(red(Newcolorchoose),NewValue,blue(Newcolorchoose),alpha(colorchoose));
       NewValue=h_slice(ligneX+150,ligneY+130,0,255,round(blue(colorchoose)),color(0,0,blue(colorchoose),alpha(colorchoose)),color(colorBackground),"blue","choose blue");
       if(NewValue!=round(blue(colorchoose))) Newcolorchoose=color(red(Newcolorchoose),green(Newcolorchoose),NewValue,alpha(colorchoose));
       NewValue=h_slice(ligneX+150,ligneY+160,0,255,round(alpha(colorchoose)),colorchoose,color(colorBackground),"alpha","choose alpha");
       if(NewValue!=round(alpha(colorchoose))) Newcolorchoose=color(red(Newcolorchoose),green(Newcolorchoose),blue(Newcolorchoose),NewValue);
       
       image(colorWheel,ligneX+150,ligneY+180,SizeWheelColor,SizeWheelColor);
       if(mousePressOnMenuOff(ligneX+150,ligneY+180,SizeWheelColor,SizeWheelColor)){
         Newcolorchoose=colorWheel.pixels[round(mouseX()-(ligneX+150)+(mouseY()-(ligneY+180))*SizeWheelColor)];
       }
       if(Newcolorchoose!=colorchoose)  assignColorMenu(ChangeColor,Newcolorchoose);
    }
    int tligneY=ligneY+(MenuColorList.length+1)*25;
    //FONT
     
     if(mouseOnMenuOff(ligneX,tligneY,100,20)) textFont(myFont,14); else textFont(myFont,12); 
     text((String)allFonts.get(font),ligneX+10,tligneY+15);
     if(mousePressOnMenuOff(ligneX,tligneY,100,20)){
         ChangeColor=0;textSearch=new ArrayList(); //To delete the other
         ActiveMenuFont=true;
     }
     if(ActiveMenuFont){
         noFill();stroke(Textcolor);
         for(int i=0;i<allFonts.size();i++){
             textFont((PFont)allmyFonts.get(i),12);
             text((String)allFonts.get(i),ligneX+150,ligneY+15+i*20); 
             if(mouseOnMenuOff(ligneX+140,ligneY+1+i*20,100,20)){
                 rect(ligneX+140,ligneY+1+i*20,100,20);
                 if(mousePressOnMenuOff(ligneX+140,ligneY+1+i*20,100,20)){
                     font=i;
                    myFont = (PFont)allmyFonts.get(font);
                 }
              }
          }
     }
     textFont(myFont,12);
     tligneY+=25;
     
     


}


public boolean mouseOnMenuOff(float x,float y,float w,float h){
  if (mouseX()<=x+w && mouseX()>=x &&mouseY()<=y+h && mouseY()>=y) return true;
  return false;

}

public boolean mousePressOnMenuOff(float x,float y,float w,float h){
  if(mousePressed && AcceptEvent && mouseOnMenuOff(x,y,w,h)) {
    AcceptEvent=false; 
    return true;
  }
  return false;

}



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  COLORS

int ChangeColor=0; 
color colorBackground=color(255,255,255); //Global Color Background 

color colorOngletBackground=color(120,120,120); //Color Background Onglet
color colorBoxBackground=color(120,120,120); //Color Background Definition Box
color colorButton=color(64,196,246);//Colorize the button
color colorOnglet=color(64,196,246); //Color Menu Onglet

color Textcolor=color(0,0,0); //Color of the texte
color TextNocolor=color(255,255,255); //Color of the texte when it's on No Gene background

color colorUnknownGene=color(255,255,255); //a unknown Gene

color colorOperators=color(120,120,120); //Display Color of Operator

color colorDomain=color(150,150,150,100); 

color colorExplanation=color(253,253,150,240);
//Gene  
color colorBoxGene=color(150,150,150,100); //Color of the box behind the gene name
color colorBoxNoGene=color(100,100,100); //Color of the box behind the gene name

color colorGeneOn=color(64,196,246); // Color of the gene when is activate
color colorGeneOff=color(200,200,200);//Color of the gene when is repress
color colorMaternal=color(0,150,0); //Color of Maternal things
color colorNoData=color(255,255,255);  //Color of No Data
color colorUbiquitous=color(200,0,0);  //Color of genes which are ubiquitous

color ExpressionColor(int c) {
  color cc=color(255,255,255);
  switch(c) {
  case -1 :   cc=color(colorNoData);   break; //Nothing 
  case 0  :   cc=color(colorNoData);   break; //No data;
  case 1  :   cc=color(colorGeneOff);  break; //No expression;
  case 2  :   cc=color(red(colorGeneOn),green(colorGeneOn),blue(colorGeneOn), alpha(colorGeneOn)/2);  break; //Weak expression;
  case 3  :   cc=color(colorGeneOn);  break; //Expression;
  case 4  :   cc=color(colorMaternal);  break; //Maternal;
  }
  return cc;
}


String [] MenuColorList = {"background","tab","tab background","box background","button","text","manual","operators","domain","box gene","box no gene","gene on","gene off","maternal","no data","text no gene","ubiquitous"};
   
void assignColorMenu(int Comp,color Newcolorchoose){
   switch(Comp){
           case 1: colorBackground=Newcolorchoose;break;
           case 2: colorOnglet=Newcolorchoose;break;
           case 3: colorOngletBackground=Newcolorchoose;break;
           case 4: colorBoxBackground=Newcolorchoose;break;
           case 5: colorButton=Newcolorchoose;break;
           case 6: Textcolor=Newcolorchoose;break;
           case 7: colorUnknownGene=Newcolorchoose;break;
           case 8: colorOperators=Newcolorchoose;break;
           case 9: colorDomain=Newcolorchoose;break;
           case 10: colorBoxGene=Newcolorchoose;break;
           case 11: colorBoxNoGene=Newcolorchoose;break;
           case 12: colorGeneOn=Newcolorchoose;break;
           case 13: colorGeneOff=Newcolorchoose;break;
           case 14: colorMaternal=Newcolorchoose;break;
           case 15: colorNoData=Newcolorchoose;break;
           case 16: TextNocolor=Newcolorchoose;break;
           case 17: colorUbiquitous=Newcolorchoose;break;
           
           
       }
}
color colorMenu(int Comp){
  color colorchoose=color(0,0,0);
      switch(Comp){
            case 1: colorchoose=colorBackground;break;
            case 2: colorchoose=colorOnglet;break;
            case 3: colorchoose=colorOngletBackground;break;
            case 4: colorchoose=colorBoxBackground;break;
            case 5: colorchoose=colorButton;break;
            case 6: colorchoose=Textcolor;break;
            case 7: colorchoose=colorUnknownGene;break;
            case 8: colorchoose=colorOperators;break;
            case 9: colorchoose=colorDomain;break;
            case 10: colorchoose=colorBoxGene;break;
            case 11: colorchoose=colorBoxNoGene;break;
            case 12: colorchoose=colorGeneOn;break;
            case 13: colorchoose=colorGeneOff;break; 
            case 14: colorchoose=colorMaternal; break;
            case 15: colorchoose=colorNoData; break;
            case 16: colorchoose=TextNocolor; break;
            case 17: colorchoose=colorUbiquitous; break;
          }
     return colorchoose;
}

color colorLine(int i){
  while(i>=64)i-=64;
  color col=color(0,0,0);
  switch(i){
	case 0: col=color(0,0,0);break;
case 1: col=color(0,128,0);break;
case 2: col=color(255,0,0);break;
case 3: col=color(0,191,191);break;
case 4: col=color(191,0,191);break;
case 5: col=color(191,191,0);break;
case 6: col=color(64,64,64);break;
case 7: col=color(0,0,0);break;
case 8: col=color(0,128,0);break;
case 9: col=color(255,0,0);break;
case 10: col=color(0,191,191);break;
case 11: col=color(191,0,191);break;
case 12: col=color(191,191,0);break;
case 13: col=color(64,64,64);break;
case 14: col=color(0,0,0);break;
case 15: col=color(0,128,0);break;
case 16: col=color(255,0,0);break;
case 17: col=color(0,191,191);break;
case 18: col=color(191,0,191);break;
case 19: col=color(191,191,0);break;
case 20: col=color(64,64,64);break;
case 21: col=color(0,0,0);break;
case 22: col=color(0,128,0);break;
case 23: col=color(255,0,0);break;
case 24: col=color(0,191,191);break;
case 25: col=color(191,0,191);break;
case 26: col=color(191,191,0);break;
case 27: col=color(64,64,64);break;
case 28: col=color(0,0,0);break;
case 29: col=color(0,128,0);break;
case 30: col=color(255,0,0);break;
case 31: col=color(0,191,191);break;
case 32: col=color(191,0,191);break;
case 33: col=color(191,191,0);break;
case 34: col=color(64,64,64);break;
case 35: col=color(0,0,0);break;
case 36: col=color(0,128,0);break;
case 37: col=color(255,0,0);break;
case 38: col=color(0,191,191);break;
case 39: col=color(191,0,191);break;
case 40: col=color(191,191,0);break;
case 41: col=color(64,64,64);break;
case 42: col=color(0,0,0);break;
case 43: col=color(0,128,0);break;
case 44: col=color(255,0,0);break;
case 45: col=color(0,191,191);break;
case 46: col=color(191,0,191);break;
case 47: col=color(191,191,0);break;
case 48: col=color(64,64,64);break;
case 49: col=color(0,0,0);break;
case 50: col=color(0,128,0);break;
case 51: col=color(255,0,0);break;
case 52: col=color(0,191,191);break;
case 53: col=color(191,0,191);break;
case 54: col=color(191,191,0);break;
case 55: col=color(64,64,64);break;
case 56: col=color(0,0,0);break;
case 57: col=color(0,128,0);break;
case 58: col=color(255,0,0);break;
case 59: col=color(0,191,191);break;
case 60: col=color(191,0,191);break;
case 61: col=color(191,191,0);break;
case 62: col=color(64,64,64);break;
case 63: col=color(0,0,0);break;
default : col=color(0,0,0);break;
}

return col;
}





//Initialise Fonts
int font;
PFont myFont;
ArrayList allFonts;
ArrayList allmyFonts;


public void initFonts(){
   allFonts=new ArrayList();
  
  allFonts.add("AndaleMono");
allFonts.add("AppleCasual");
allFonts.add("ArialMT");
allFonts.add("Baghdad");
allFonts.add("Calibri");
allFonts.add("Century");
allFonts.add("Chalkboard");
allFonts.add("Cochin");
allFonts.add("ComicSansMS");
allFonts.add("Constantia");
allFonts.add("Courier");
allFonts.add("Didot-Bold");
allFonts.add("Gabriola");
allFonts.add("GillSans");
allFonts.add("Helvetica");
allFonts.add("Impact");
allFonts.add("Kokonor");
allFonts.add("LucidaSans");
allFonts.add("Marlett");
allFonts.add("Rockwell");
allFonts.add("SansSerif");
allFonts.add("Skia-Regular");
allFonts.add("Tahoma");
allFonts.add("Times-Roman");
allFonts.add("Verdana");

 allmyFonts=new ArrayList();
 for(int i=0;i<allFonts.size();i++)  {
      String ftname=(String)allFonts.get(i);
      allmyFonts.add(createFont(ftname,34));
 }
 
  font=20;
  myFont = (PFont)allmyFonts.get(font);
  textFont(myFont, 12);
}
