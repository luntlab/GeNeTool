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

package grnboolmodel;

import java.util.ArrayList;

  /////////////////////////////////////////////////////////////////////////////////////////////
  //
  // Domain.pde
  //
  /////////////////////////////////////////////////////////////////////////////////////////////

public class DomainManager {
  
  private GRNBoolModel p;
  
  ArrayList Domains=new ArrayList();
  Domain DomainDef=null; //Domain current show in the definition
  int nbDomain;
  
  String CommentsRule="";
  Domain GenericDomain;
  int SizeDrawDomain=100;
  
  
  DomainManager(GRNBoolModel p) {
    this.p = p;
    GenericDomain=new Domain(p, "R");
  }  

  public void addDomain(Domain dom){
    p.mm.addMessage("Create domain " +dom.Name);
    Domains.add(dom); nbDomain=Domains.size();
    if(nbDomain==1) p.mbm.checkEnablelMenu();
   
    DomainDef=dom;
    if(p.lm.MyModels!=null) for(int i=0;i<p.lm.MyModels.length;i++) p.lm.MyModels[i].addDomain(dom);
  }
  public void delDomain(Domain dom){
    p.mm.addMessage("Delete domain " +dom.Name);
    if(dom==DomainDef) DomainDef=null;
    if(p.lm.MyModels!=null) for(int i=0;i<p.lm.MyModels.length;i++) p.lm.MyModels[i].delDomain(dom);
    ArrayList newDomains=new ArrayList();
    for(int d=0;d<nbDomain;d++){ Domain domm=getDomain(d);  if(domm!=dom) newDomains.add(domm);}
    Domains=newDomains;nbDomain=Domains.size();
    if(nbDomain==0)  p.mbm.checkEnablelMenu();
   
  }
  //Return a domain from the global list
  public Domain getDomain(String name){  for(int d=0;d<nbDomain;d++){ Domain dom=getDomain(d);  if(p.uf.equal(dom.Name,name)) return dom;}return null;}
  public Domain getDomain(int i){ return (Domain)Domains.get(i);}
  public void computeData(){ for(int d=0;d<nbDomain;d++) getDomain(d).computeData();}
  public void reComputeData(Gene g){ for(int d=0;d<nbDomain;d++) getDomain(d).reComputeData(g);}

}