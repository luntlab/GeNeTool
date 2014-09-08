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

///////////////////////////////////////////////  LIST  DOMAINS 
void MenuDomains(int ligneX,int ligneY,int NumMenu){
  
  MenuOnglet(ligneX,ligneY,NumMenu,"Domains");
  
  ligneX+=10; ligneY+=30;

  
 //Draw the list of domaines
  textFont(myFont, 12); 
  for(int i=0;i<nbDomain;i++){
     Domain dom=(Domain)Domains.get(i);
     int coordY=ligneY+i*25+ShiftDomainsY;
      if(coordY>=ligneY && coordY<ligneY+SizeMenuXY[1][1]-50){
          dom.draw(ligneX+5,coordY,colorDomain);
          if(mousePressOn(ligneX+5,coordY,SizeDrawDomain,20)) {
             if(doubleClick()){
               String Name=ask("Give a new name to "+dom.Name); 
               if(Name!=null) dom.Name=Name;
            }
            else{//Draw the domain
                ObjetDrag=new Objet(dom); 
                MenuDragActive=1; DragMod=0;
                if(MyModel!=null) MyModel.ActiveDomain=MyModel.getDomain(dom);
          }
          }
      }
  }
  
   if(MenuActive[NumMenu]==1) {
      //Draw "R" Domain
      GenericDomain.draw(ligneX+70,ligneY-30,colorDomain,-1);
      if(mousePressOn(ligneX+70,ligneY-30,15,20)) {  ObjetDrag=new Objet(GenericDomain);  MenuDragActive=1; DragMod=0; }
      MenuDefinitionDomain(ligneX,ligneY-25); //Domain Definition
    }
    
    
   //Scroll Bar
   int sizeBar=SizeMenuXY[NumMenu][1]-40;
  float ratio=Domains.size()*25/(float)sizeBar;
  if(ratio>1){
     float sizeBarr=sizeBar/ratio;
     int barV=100;
     float yl=ligneY+ShiftDomainsY*(sizeBar-sizeBarr)/(sizeBar-Domains.size()*25);
     if(mouseOn(ligneX-8,yl, 10,sizeBarr)){
         barV=250;
         if(mousePressed && AcceptEvent){   AcceptEvent=false; scrollMenu=NumMenu;oldScroll=ShiftDomainsY; }
     }
     if(scrollMenu==NumMenu)  barV=250;
     fill(colorOnglet,barV);  rect(ligneX-8,yl, 10,sizeBarr); //Draw 
  }
  
}



///////////////////////////////////////////////   DOMAIN DEFINITION
public int MenuDefinitionDomain(int ligneX,int ligneY){
 if(mouseUnHide(ligneX+100,ligneY-2,15,5,"Add a new domain"))  {
    String Name=ask("Give a name "); 
    if(Name!=null)  addDomain(new Domain(Name));
  }

  ligneX+=170;
  
  //Draw the Definition Box
  LigneDomDefBoxX=ligneX;  LigneDomDefBoxY=ligneY;

 if(DomainDef!=null){
   fill(Textcolor);  textFont(myFont, 24);  text(DomainDef.Name,ligneX-10,ligneY+20);
   textFont(myFont, 12); 
   ligneY+=70;
  //Tree Definition
 //  ligneX+=SizeDrawDomain+50; 
  int ix=0;
   if(Regions.size()>0){
       fill(Textcolor);  text("Domain Ancestors",ligneX,ligneY-15);
       int SizeTree=max(DomainDef.getTreeSize(),50); 
       
       if(mouseOn(ligneX-5,ligneY-5,SizeTree+10,30)) stroke(colorButton); else stroke(colorBoxBackground); 
       noFill(); rect(ligneX-5,ligneY-5,SizeTree+10,30);   
       for(int i=0;i<DomainDef.Tree.size();i++){
          Region reg=DomainDef.getTree(i);
          float tx=textWidth(reg.Name);
          fill(colorBoxBackground,50);     noStroke();  rect(ligneX+ix+1,ligneY,tx+2,20);
          fill(Textcolor);  text(reg.Name,ligneX+ix+2,ligneY+14);
          if(mousePressOn(ligneX+ix+1,ligneY,tx+2,20)){   ObjetDrag=new Objet(reg);  MenuDragActive=1;  DragMod=2; } //Drag Obj
          ix+=tx+4;
       }
   }
   
   
     //Draw the domain Spatial Definition
    ligneY+=70;
    
    fill(Textcolor);  text("Definition",ligneX,ligneY-15);
    
   int SizeDef=0;
   if(DomainDef.DefObjets!=null)  {  
     SizeDef=DomainDef.DefObjets.length;
     for(int i=0;i<SizeDef;i++){
        fill(colorBoxBackground,50);    stroke(colorBoxBackground);  rect(ligneX,ligneY-5+i*30,SizeDrawDomain+SizeDrawOperator+30+4*4,30);
        Objet[] objets=DomainDef.DefObjets[i];
         ix=0;
        if(objets!=null)
          for(int j=0;j< objets.length;j++){
            int siz=SizeDrawDomain;
            if(objets[j]!=null)  {
                  if(j==0) { 
                      siz=SizeDrawOperator+30;
                      objets[j].draw(ligneX+ix+5+j*4,ligneY+i*30,siz);
                      Operator op=objets[j].getOperator();
                      int Middle=ligneX+ix+5+j*4+siz/2-round(textWidth(op.toRule())+4)/2+round(textWidth(op.getName())+4); //Begining of the word
                      if(mouseOn(Middle-2,ligneY+i*30,textWidth(""+op.hmin)+4,20)) { 
                            if(mousePressed && AcceptEvent){AcceptEvent=false; op.hmin++; if(op.hmin>30)op.hmin=0; }
                            if(keyPressed){
                              if(keyCode==UP)    op.hmin++;
                              if(keyCode==DOWN)  op.hmin--;
                            }
                            if(op.hmin<0)op.hmin=0;
                            
                       }
                      else if(mouseOn(Middle+textWidth(""+op.hmin+"-")-2,ligneY+i*30,textWidth(""+op.hmax)+4,20)){ 
                           if(mousePressed && AcceptEvent){AcceptEvent=false; op.hmax++; if(op.hmax>30)op.hmax=1;  }
                           if(keyPressed){
                              if(keyCode==UP)    op.hmax++;
                              if(keyCode==DOWN)  op.hmax--;
                            }
                           if(op.hmax<0)op.hmax=0;
                      }
                  }
                  else objets[j].draw(ligneX+ix+5+j*4,ligneY+i*30);
            }
           ix+=siz;
          }
      
     }
   }
   
  //Delete a Definition Domain
   ix=0;
   while(DomainDef.DefObjets!=null && ix<DomainDef.DefObjets.length){
        if(mouseHide(ligneX-20,ligneY+ix*30+8,13,4,"Delete this definition"))  { DomainDef.delDef(ix);  ix++; }
        ix++;
    } 
    if(mouseUnHide(ligneX-22,ligneY+SizeDef*30,15,5,"Add a new definition"))   DomainDef.addEmptyDef();
   
   
    ResizeMenuXY(1,0,400);
    if(DomainDef.DefObjets!=null) ResizeMenuXY(1,1,200+DomainDef.DefObjets.length*30);
   }
 
 
 
 
 return ligneY+20;

}


