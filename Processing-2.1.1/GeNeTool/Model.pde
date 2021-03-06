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


String lastModelLoaded=""; //Save the name of the  last Model / Rules Loaded
String [] ModelLoad; //To have the Model in String format for Search Function

//Add a new model in the list
public void addModel(Model model){
  Model[] TempMyModels=new Model[MyModels.length+1];
  for(int i=0;i<MyModels.length;i++) TempMyModels[i]=MyModels[i];
  TempMyModels[MyModels.length]=model;
  MyModels=TempMyModels;
  MyModel=model; //Current Model
}
//Delete a model from the list
public void delModel(Model model){
   Model []TempMyModels=new Model[MyModels.length-1];
   int nb=0;
   for(int i=0;i<MyModels.length;i++)  if(MyModels[i]!=model)  TempMyModels[nb++]=MyModels[i];
   MyModels=TempMyModels;
   MyModel=MyModels[0];
   MyModel.ActiveDomain=MyModel.getDomain(0);
}
public class Model{
  int number=0;
  String date;
  String Name;
  int [] Correspons; //Corresponding Hours
  int ActualStep=0; //For Recursive Model Computation
  int step;
  ModelDomain ActiveDomain=null;
  boolean lock=false;
  ArrayList modelDomains=new ArrayList(); //List of the Domain include in this model
 
  //Constructeur for an empty Model
  public Model(int number,String date){
      addMessage("Create model "+this.number+ " at " + date);
      this.Name="default";
      this.reset();
      this.number=number;
      this.date=date; 
      this.step=-1; 
      this.ActualStep=-1;
      modelDomains=new ArrayList();
  }
  
  //Duplicate a model for a new Version
  public Model(Model model,int number,String Name,String date){
    addMessage("Duplicate from model "+model.number+ " at " + date);
    this.number=number;
    this.date=date;
    this.Name=Name;
    this.step=model.step;
    this.ActualStep=model.ActualStep;
    Correspons=new int[model.Correspons.length];
    for(int i=0;i<Correspons.length;i++) Correspons[i]=model.Correspons[i];
    modelDomains=new ArrayList();
    for(int i=0;i<model.modelDomains.size();i++) this.addDomain(new ModelDomain(model.getDomain(i)));
    this.ActiveDomain=this.getDomain(model.ActiveDomain.getName());
  }
  
  
  //Resest the model to restart at the first step
  public void reset(){ 
      Correspons=new int[maxStep]; for(int i=0;i<maxStep;i++)Correspons[i]=i;
      step=0;ActualStep=0;
  }
 
 
 //When we Create a new Genes we extend it in all the domains
 public void addGene(Gene g){ for(int d=0;d<this.modelDomains.size();d++)this.getDomain(d).addGene(g); }
 public void delGene(Gene g){ for(int d=0;d<this.modelDomains.size();d++)this.getDomain(d).delGene(g); }

  
  public void addDomain(Domain domToAdd){ addDomain(new ModelDomain(domToAdd));}
  public void addDomain(ModelDomain mdToAdd){  modelDomains.add(mdToAdd);  }
 
  void delDomain(Domain domToDel){
     if(this.ActiveDomain!=null && this.ActiveDomain.dom==domToDel) this.ActiveDomain=null;
     ArrayList NewDomains=new ArrayList();
     for(int d=0;d<this.modelDomains.size();d++){
       ModelDomain md=this.getDomain(d);  
       if(domToDel!=md.dom) NewDomains.add(md);  
     }
     this.modelDomains=NewDomains;
  }
 
  public ModelDomain getDomain(String name){
      for(int d=0;d<this.modelDomains.size();d++){
        ModelDomain md=this.getDomain(d);
        if(equal(md.dom.Name,name)) return md;
      }
      return null;
  }
  public ModelDomain getDomain(Domain domg){
      for(int d=0;d<this.modelDomains.size();d++){
        ModelDomain md=this.getDomain(d);
        if(md.dom==domg) return md;
      }
      return null;
  }
  public ModelDomain getDomain(int num){ return (ModelDomain)this.modelDomains.get(num);  }


  
  //compute the Next step of the model
   public void Step(int s){
     addMessage("Model " + this.Name +" -> Calcul Step " +(s+1) );
     for(int d=0;d<this.modelDomains.size();d++){ //For Each Domains
          ModelDomain md=this.getDomain(d);
          for(int i=0;i<nbGene;i++){ //For Each Gene Verify the rules
              Gene gene=getGene(i);
              CommentsRule="";
              if(toDo==4 & md.Manual[i][s+1]) { } //If we are in restart mode, we don't change the value
              else{
                if(toDo!=4 && md.Manual[i][s] && s+1==ActualStep){  //If the box was Manual clicked and this is the last step
                    md.GenesStates[i][s+1]=md.GenesStates[i][s];
                    md.isBlueState[i][s+1]=md.isBlueState[i][s];
                    md.Manual[i][s+1]=true;
                 }
              else   {
                     md.GenesStates[i][s+1]=gene.is(md,s+1); //Othewise compute the logic
                    // if(dom.GenesStates[i][s+1]) dom.isBlueState[i][s+1]=gene.isBlue(dom,s+1);
                  //if(dom.Name.equals("Skel.Micromere") && gene.Name.equals("U1"))    addMessage("Step " +(s+1) + " gene "+gene.Name + " is " + dom.GenesStates[i][s+1]);
                }
              }
          }
      }
      
      //Because we have some value which can be AT-0 or AFTER-0, we need to do again the same check until we dont have any more changements
      int loopCheck=0; int nbChagement=1;
      while(loopCheck<5 && nbChagement>0){
          nbChagement=0;
       //   print(" Next Try "+loopCheck);
        for(int d=0;d<this.modelDomains.size();d++){ //For Each Domains
          ModelDomain md=this.getDomain(d);
          for(int i=0;i<nbGene;i++){ //For Each Gene Verify the rules
              Gene gene=getGene(i);
              if(!md.Manual[i][s+1]){  //If the box was not Manual clicked
                 boolean curstate=gene.is(md,s+1);
                 if(curstate!=md.GenesStates[i][s+1]){
                     //addMessage("in Domain " +dom.Name + " Gene " +gene + " change value ");
                     md.GenesStates[i][s+1]=curstate; nbChagement++;
                   }
              } 
          }
        }loopCheck++;
        if(nbChagement>0)   addMessage("Model " + this.Name +" -> Try "+ loopCheck + " check -> "+nbChagement+" changement");
      }
      if(loopCheck==5) addMessage("Model " + this.Name +" -> ERROR infinite loop at  " +this.Correspons + " "+timeUnit);
      //BLUE MODULE
     for(int d=0;d<this.modelDomains.size();d++){ //For Each Domains
          ModelDomain md=this.getDomain(d);
          for(int i=0;i<nbGene;i++){ //For Each Gene Verify if w have a blue modul
            Gene gene=getGene(i);
            if(md.GenesStates[i][s+1]) md.isBlueState[i][s+1]=gene.isBlue(md,s+1);
          }
      }
      
   }
   //For Manual or Line-Automatic Calcul
   public void Step(){
     if(toDo!=4) this.Correspons[step+1]=this.Correspons[step]+1; //Else Restart Mode
     else if(this.Correspons[step+1]<this.Correspons[step]) this.Correspons[step+1]=this.Correspons[step]; //In case the hour is not well define
     this.Step(this.step);
     this.isStep(step+1);
     step++;
  }
 
  
 


  //Return true if in one of the Domain, we have a gene changment
  public void isStep(int s){
    //if(s==0) return false;
     for(int d=0;d<this.modelDomains.size();d++){ //For Each Domains
          ModelDomain md=this.getDomain(d);
          md.Steps[s]=md.isStep(s);
    }
  }
  
}


