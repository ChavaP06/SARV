package com.mv;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;


import com.google.gson.Gson;
import com.google.gson.GsonBuilder;


	public class Entry {
	
		private String name;
		private List<Entry> children;
		
		public Entry(String node) {
			// TODO Auto-generated constructor stub
			this.name = node;

		}
		

    public void addChild(Entry node) {
    	 if (children == null)
             children = new ArrayList<Entry>();
    	 children.add(node);

	}
    
    
    public static void main(String[] args) {
    	String pump =  "B C B D D B B G G";
    	String pump2 = "D D E F R G H D V";
    	ArrayList<String> superPump = new ArrayList<String>();
    	
    	String[] pumptest = pump.split(" ");
    	String[] pumptest2 = pump2.split(" ");
    	//Arrays.sort(pumptest);
    	HashSet<String> set = new HashSet<String>();
    	Entry root = new Entry("begin");
    	
    	
    
    	for(int i =0;i<pumptest.length;i++) {
    		
    			superPump.add(pumptest[i]+" "+pumptest2[i]);
 
    	}
    	
    	Collections.sort(superPump);
    	
    	String humlek2 = "";
    	String humlek3 = "";
    	for(int i = 0;i<superPump.size();i++) {
    		humlek2 = humlek2 + superPump.get(i).split(" ")[0] + " ";
    		humlek3 = humlek3 + superPump.get(i).split(" ")[1] + " ";
    	}
    	
    	humlek2 = humlek2.trim();
    	humlek3 = humlek3.trim();
    	//System.out.println(humlek2);
    	//System.out.println(humlek3);
    	String [] pumptest3 = humlek2.split(" ");
    	String [] pumptest4 = humlek3.split(" ");
    	
    	for(String i : pumptest3) {
    		System.out.println(i);
    	}
    	System.out.println("\n");
    	for(String i : pumptest4) {
    		System.out.println(i);
    	}
    	System.out.print("\n");
    	/*String pumplol="";
    	for(String i : superPump) {
    		pumplol = pumplol+i+"\n";
    	}
    	pumplol = pumplol.trim();
    	System.out.println(pumplol);
    	String humlek2 = pumplol.split(" ")[0];
    	String humlek3 = pumplol.split(" ")[1];
    	
    	System.out.println(humlek2);
    	/*for(int i =0;i<humlek2.length;i+=2) {
    		superPumpBros.put(humlek2[i], humlek2[i+1]);
    	}*/
    	
    	List<String> dupListChild = new ArrayList<String>();
    	
    	Entry node=null;
    	for(int i = 0;i<pumptest3.length;i++){
    		
    		if(set.add(pumptest3[i])==false){//duplicate
    			dupListChild.add(pumptest4[i]);
    			
    		}else { //not duplicate
    			
    			if(node!=null) {
    				if(!(node.toString().equals(pumptest3[i]))) {
    					
    					node = aMethod2form(node, dupListChild);
    					root.addChild(node);
    				
    					dupListChild.clear();
    				}
    				
    			}

    			node = new Entry(pumptest3[i]);
    			//root.addChild(node);
    			dupListChild.add(pumptest4[i]);
    			
    		}
    		if(i==pumptest3.length-1) {
    			node = new Entry(pumptest3[i]);
    			//dupListChild.add(pumptest4[i]);   			
    			node = aMethod2form(node, dupListChild);
    			root.addChild(node);
    			
    		}
    		/*
    		Entry node = new Entry(pumptest[i]);
    		root.addChild(node);
    		node.addChild(new Entry(pumptest2[i]));
    		*/
    	}
    	
    	
    	
    	
    	
    	/*for(int i = 0;i<pumptest.length;i++){
    		
    		if(set.add(pumptest[i])==false){//dup
    			root.findTreeNode(pumptest[i]).addChild(pumptest2[i]);
    			

    		}else{//not dup
    			root.addChild(pumptest[i]);
    			
    			root.findTreeNode(pumptest[i]).addChild(pumptest2[i]);
    		}
    	}*/
    	Gson g = new GsonBuilder().setPrettyPrinting().create();
    	System.out.println(g.toJson(root));
    	//System.out.println(g.toJson(root));
    	//System.out.println(dupListChild);
    /*	for(String i : pumptest) {
    		System.out.println(i);
    	}*/
    	
    	
    	//System.out.print(root.findTreeNode("E"));
       /* List<String> listofParent = new ArrayList<String>();
        listofParent.add("Mind");
        listofParent.add("Habbit");
        listofParent.add("Culture");

        List<String> listofChild = new ArrayList<String>();
        listofChild.add("Sea");
        listofChild.add("water");
        listofChild.add("Wind");
        Entry topLevelEntry = new Entry("Root");
        //Entry mainRoot=null;//deleted
        for (int i = 0; i < listofParent.size(); i++) {
            Entry root = new Entry(listofParent.get(i));
            Entry mainRoot= aMethod2form(root, listofChild); //modified
            //Entry e=new Entry("Root");
            //e.add(mainRoot);
           // Gson g=new Gson();
           // System.out.println(g.toJson(e));
            topLevelEntry.add(mainRoot);	
        }*/
        
       // System.out.println(g.toJson(topLevelEntry));
    }
    
    @Override
	public String toString() {
		return name != null ? name.toString() : "[data null]";
	}
    
 
    
    private static Entry aMethod2form(Entry root, List<String> listofChild) {
        for(int i=0;i<listofChild.size();i++){
            root.addChild(new Entry(listofChild.get(i)));
        }
          return root;
    }
    
    
}

