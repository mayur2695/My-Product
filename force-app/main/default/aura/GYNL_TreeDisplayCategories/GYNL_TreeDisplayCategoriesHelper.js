({	
    productTreeBuild : function (cmp, event, helper) {
        var cInfo = cmp.get("v.cInfo");
        //console.log('CName in Tree Helper>>>',cInfo.Name);
        //console.log('Catalog Id in Tree Helper>>>',cInfo.Id);
        cmp.set("v.catalogname",cInfo.Name);
        var action = cmp.get("c.sendTreeData");
        action.setParams({"catMasterId": cInfo.Id});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('workModel', response.getReturnValue());
                var treeResp = response.getReturnValue();
                var primaryLevel = treeResp.mainTree;
                var secondaryLevel = treeResp.subTree;
                var prodInfo = treeResp.prodList;
                
                var items = [];
                if(primaryLevel.length !=0) {
                for(var i=0; i< primaryLevel.length; i++) {
                    items.push({label: primaryLevel[i].Name, name: primaryLevel[i].Id, disabled: false, expanded: false, items: []});
                }
                }
                console.log('level 1', items);
                
                if(secondaryLevel.length != 0) {
                    
                for(var i=0; i<items.length; i++) {
                    for(var j=0; j<secondaryLevel.length; j++) {                        
                        if(items[i].label == secondaryLevel[j].GYNCF_Parent_Category__r.Name) {
                           var itemone = [];                           
                            items[i].items.push({ label: secondaryLevel[j].Name, name:secondaryLevel[j].Id, expanded: false, items: []});							                            
                        }						                        
                    }
                    console.log('level 2', items[i].items);
                }
                
                    
                 for(var i=0; i<items.length; i++) {
                    for(var j=0; j<secondaryLevel.length; j++) {                        
                        if(items[i].items.length != 0) {
                            for(var k=0; k<items[i].items.length; k++) {
                                if(secondaryLevel[j].GYNCF_Parent_Category__r.Name == items[i].items[k].label) {                            
									items[i].items[k].items.push({ label: secondaryLevel[j].Name, name:secondaryLevel[j].Id, expanded: false, items: []});							                            
                        		}
                            }                                                    
                       }
                    }                    
                }
                
                
                
                for(var i=0; i<items.length; i++) {
                    for(var j=0; j<secondaryLevel.length; j++) {                        
                        if(items[i].items.length != 0) {
                            for(var k=0; k<items[i].items.length; k++) {
                                if(items[i].items[k].items.length != 0) {
                                    for(var l=0; l<items[i].items[k].items.length; l++ ) {
                                        if(secondaryLevel[j].GYNCF_Parent_Category__r.Name == items[i].items[k].items[l].label) {                                                       
												items[i].items[k].items[l].items.push({ label: secondaryLevel[j].Name, name:secondaryLevel[j].Id, expanded: false, items: []});                            
                        	  			}
                                    }
                                }                                
                            }                                                    
                       }
                    }                    
                }
                
               
                 for(var i=0; i<items.length; i++) {
                    for(var j=0; j<secondaryLevel.length; j++) {                        
                        if(items[i].items.length != 0) {
                            for(var k=0; k<items[i].items.length; k++) {
                                if(items[i].items[k].items.length != 0) {
                                    for(var l=0; l<items[i].items[k].items.length; l++ ) {
                                        if(items[i].items[k].items[l].items.length !=0) {
                                            for(var m=0; m<items[i].items[k].items[l].items.length; m++) {
                                                if(secondaryLevel[j].GYNCF_Parent_Category__r.Name == items[i].items[k].items[l].items[m].label) {
                                                    items[i].items[k].items[l].items[m].items.push({ label: secondaryLevel[j].Name, name:secondaryLevel[j].Id, expanded: false, items: []});
                                                }
                                            }
                                        }
                                    }
                                }                                
                            }                                                    
                       }
                    }                    
                }
                    
                
                
               for(var i=0; i<items.length; i++) {
                    for(var j=0; j<secondaryLevel.length; j++) {                        
                        if(items[i].items.length != 0) {
                            for(var k=0; k<items[i].items.length; k++) {
                                if(items[i].items[k].items.length != 0) {
                                    for(var l=0; l<items[i].items[k].items.length; l++ ) {
                                        if(items[i].items[k].items[l].items.length !=0) {
                                            for(var m=0; m<items[i].items[k].items[l].items.length; m++) {
                                                if(items[i].items[k].items[l].items[m].items.length !=0) {
                                                    for(var n=0; n<items[i].items[k].items[l].items[m].items.length; n++){
                                                        if(secondaryLevel[j].GYNCF_Parent_Category__r.Name == items[i].items[k].items[l].items[m].items[n].label) {
                                                    		items[i].items[k].items[l].items[m].items[n].items.push({ label: secondaryLevel[j].Name, name:secondaryLevel[j].Id, expanded: false, items: []});
                                                		}
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }                                
                            }                                                    
                       }
                    }                    
                }
                
                for(var i=0; i<items.length; i++) {
                    for(var j=0; j<secondaryLevel.length; j++) {                        
                        if(items[i].items.length != 0) {
                            for(var k=0; k<items[i].items.length; k++) {
                                if(items[i].items[k].items.length != 0) {
                                    for(var l=0; l<items[i].items[k].items.length; l++ ) {
                                        if(items[i].items[k].items[l].items.length !=0) {
                                            for(var m=0; m<items[i].items[k].items[l].items.length; m++) {
                                                if(items[i].items[k].items[l].items[m].items.length !=0) {
                                                    for(var n=0; n<items[i].items[k].items[l].items[m].items.length; n++){
                                                        if(items[i].items[k].items[l].items[m].items[n].items.length !=0) {
                                                            for(var o=0; o<items[i].items[k].items[l].items[m].items[n].items.length;o++) {
                                                                if(secondaryLevel[j].GYNCF_Parent_Category__r.Name == items[i].items[k].items[l].items[m].items[n].items[o].label) {
                                                    				items[i].items[k].items[l].items[m].items[n].items[o].items.push({ label: secondaryLevel[j].Name, name:secondaryLevel[j].Id, expanded: false, items: []});
                                                				}
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }                                
                            }                                                    
                       }
                    }                    
                }
                    
                for(var i=0; i<items.length; i++) {
                    for(var j=0; j<secondaryLevel.length; j++) {                        
                        if(items[i].items.length != 0) {
                            for(var k=0; k<items[i].items.length; k++) {
                                if(items[i].items[k].items.length != 0) {
                                    for(var l=0; l<items[i].items[k].items.length; l++ ) {
                                        if(items[i].items[k].items[l].items.length !=0) {
                                            for(var m=0; m<items[i].items[k].items[l].items.length; m++) {
                                                if(items[i].items[k].items[l].items[m].items.length !=0) {
                                                    for(var n=0; n<items[i].items[k].items[l].items[m].items.length; n++){
                                                        if(items[i].items[k].items[l].items[m].items[n].items.length !=0) {
                                                            for(var o=0; o<items[i].items[k].items[l].items[m].items[n].items.length;o++) {
                                                                if(items[i].items[k].items[l].items[m].items[n].items[0].items.length !=0){
                                                                    for(var p=0; p<items[i].items[k].items[l].items[m].items[n].items[0].items.length; p++) {
                                                                        if(secondaryLevel[j].GYNCF_Parent_Category__r.Name == items[i].items[k].items[l].items[m].items[n].items[o].items[p].label) {
                                                    						items[i].items[k].items[l].items[m].items[n].items[o].items[p].items.push({ label: secondaryLevel[j].Name, name:secondaryLevel[j].Id, expanded: false, items: []});
                                                						}
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }                                
                            }                                                    
                       }
                    }                    
                }
                
                
                for(var i=0; i<items.length; i++) {
                    for(var j=0; j<secondaryLevel.length; j++) {                        
                        if(items[i].items.length != 0) {
                            for(var k=0; k<items[i].items.length; k++) {
                                if(items[i].items[k].items.length != 0) {
                                    for(var l=0; l<items[i].items[k].items.length; l++ ) {
                                        if(items[i].items[k].items[l].items.length !=0) {
                                            for(var m=0; m<items[i].items[k].items[l].items.length; m++) {
                                                if(items[i].items[k].items[l].items[m].items.length !=0) {
                                                    for(var n=0; n<items[i].items[k].items[l].items[m].items.length; n++){
                                                        if(items[i].items[k].items[l].items[m].items[n].items.length !=0) {
                                                            for(var o=0; o<items[i].items[k].items[l].items[m].items[n].items.length;o++) {
                                                                if(items[i].items[k].items[l].items[m].items[n].items[0].items.length !=0){
                                                                    for(var p=0; p<items[i].items[k].items[l].items[m].items[n].items[0].items.length; p++) {
                                                                        if(items[i].items[k].items[l].items[m].items[n].items[0].items[p].items.length !=0) {
                                                                            for(var q=0; q<items[i].items[k].items[l].items[m].items[n].items[0].items[p].items.length;q++) {
                                                                                if(secondaryLevel[j].GYNCF_Parent_Category__r.Name == items[i].items[k].items[l].items[m].items[n].items[o].items[p].items[q].label) {
                                                    								items[i].items[k].items[l].items[m].items[n].items[o].items[p].items[q].items.push({ label: secondaryLevel[j].Name, name:secondaryLevel[j].Id, expanded: false, items: []});
                                                								}
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }                                
                            }                                                    
                       }
                    }                    
                }
                    
                }
                                
                //product Tree Generation
                if(prodInfo.length != 0) {
                    
                for(var i=0; i<items.length; i++) {
                    for(var j=0; j<prodInfo.length; j++) {
                        
                        if(items[i].label == prodInfo[j].GYNCF_Product_Category__r.Name) {                                                     
                           items[i].items.push({ label: prodInfo[j].Name, name:prodInfo[j].Id, expanded: false, items: []});                            
                        }
                        if(items[i] && items[i].items) {
                            for(var k=0; k<items[i].items.length; k++) {
                                if(items[i].items[k].label == prodInfo[j].GYNCF_Product_Category__r.Name) {                                                     
                           			items[i].items[k].items.push({ label: prodInfo[j].Name, name:prodInfo[j].Id, expanded: false, items: []});                            
                        		}
                                
                                if(items[i] && items[i].items[k] && items[i].items[k].items) {
                            		for(var l=0; l<items[i].items[k].items.length; l++) {                                	
                                        if(items[i].items[k].items[l].label == prodInfo[j].GYNCF_Product_Category__r.Name) {
                                    		items[i].items[k].items[l].items.push({ label: prodInfo[j].Name, name:prodInfo[j].Id, expanded: false, items: []});
                                		}
                                        
                                        if(items[i] && items[i].items[k] && items[i].items[k].items[l] && items[i].items[k].items[l].items) {
                                            console.log('item info', items[i].items[k].items[l].items);
                                            for(var m=0; m<items[i].items[k].items[l].items.length;m++) {
                                                if(items[i].items[k].items[l].items[m].label == prodInfo[j].GYNCF_Product_Category__r.Name){
                                                    items[i].items[k].items[l].items[m].items.push({ label: prodInfo[j].Name, name:prodInfo[j].Id, expanded: false, items: []});
                                                }
                                                
                                                console.log('item info1', items[i].items[k].items[l].items[m].items);
                                                if(items[i] && items[i].items[k] && items[i].items[k].items[l] && items[i].items[k].items[l].items[m] && items[i].items[k].items[l].items[m].items) {
                                                    for(var n=0; n<items[i].items[k].items[l].items[m].items.length;n++){
                                                        if(items[i].items[k].items[l].items[m].items[n].label == prodInfo[j].GYNCF_Product_Category__r.Name){
                                                            items[i].items[k].items[l].items[m].items[n].items.push({ label: prodInfo[j].Name, name:prodInfo[j].Id, expanded: false, items: []});
                                                        }
                                                        
                                                        if(items[i] && items[i].items[k] && items[i].items[k].items[l] && items[i].items[k].items[l].items[m] && items[i].items[k].items[l].items[m].items[n] && items[i].items[k].items[l].items[m].items[n].items){
                                                            for(var o=0; o<items[i].items[k].items[l].items[m].items[n].items.length;o++) {
                                                                if(items[i].items[k].items[l].items[m].items[n].items[o].label == prodInfo[j].GYNCF_Product_Category__r.Name){
                                                                    items[i].items[k].items[l].items[m].items[n].items[o].items.push({ label: prodInfo[j].Name, name:prodInfo[j].Id, expanded: false, items: []});
                                                                }
                                                                
                                                                if(items[i] && items[i].items[k] && items[i].items[k].items[l] && items[i].items[k].items[l].items[m] && items[i].items[k].items[l].items[m].items[n] && items[i].items[k].items[l].items[m].items[n].items[o] && items[i].items[k].items[l].items[m].items[n].items[o].items){
                                                                    for(var p=0; p<items[i].items[k].items[l].items[m].items[n].items[o].items.length;p++) {
                                                                        if(items[i].items[k].items[l].items[m].items[n].items[o].items[p].label == prodInfo[j].GYNCF_Product_Category__r.Name){
                                                                            items[i].items[k].items[l].items[m].items[n].items[o].items[p].items.push({ label: prodInfo[j].Name, name:prodInfo[j].Id, expanded: false, items: []});
                                                                        }
                                                                        
                                                                        if(items[i] && items[i].items[k] && items[i].items[k].items[l] && items[i].items[k].items[l].items[m] && items[i].items[k].items[l].items[m].items[n] && items[i].items[k].items[l].items[m].items[n].items[o] && items[i].items[k].items[l].items[m].items[n].items[o].items[p] && items[i].items[k].items[l].items[m].items[n].items[o].items[p].items){
                                                                            for(var q=0; q<items[i].items[k].items[l].items[m].items[n].items[o].items[p].items.length;q++){
                                                                                if(items[i].items[k].items[l].items[m].items[n].items[o].items[p].items[q].label == prodInfo[j].GYNCF_Product_Category__r.Name){
                                                                                    items[i].items[k].items[l].items[m].items[n].items[o].items[p].items[q].items.push({ label: prodInfo[j].Name, name:prodInfo[j].Id, expanded: false, items: []});
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }                                        
                            		}
                        		}                                                                                                                                                                                                     
                        	}
                        }
                        
                    }
                }
                }
                //Product Tree End
            }
            //console.log('jitems', items[3].items[0].items[1].items[0].items[0].items);
            cmp.set("v.itemTest",items);
        });
        $A.enqueueAction(action);
    },
    
    retrieveData : function(cmp, event, helper, id) {
        var action = cmp.get("c.objectType");
        action.setParams({ objId : id });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var objType = response.getReturnValue();
                //console.log('objType', objType);
                cmp.set("v.objString", objType);
                cmp.set("v.objId", id);
                
                if(objType=='GYNCO_Product_Category__c') {
                    cmp.set("v.addNodeData", true);
                    cmp.set("v.editNodeData", true);
                    cmp.set("v.showDialog", true);
                }
                /*if(objType=="Product2"){
                    cmp.set("v.editProdData", true);
                }*/ 
            }
        });
        $A.enqueueAction(action);
    },
    removeCategory: function(cmp,event,helper,id){
        //alert('category id to be deleted>>>>'+id);
        var act = cmp.get("c.removeCategoryInfo");
        act.setParams({catId : id});
        act.setCallback(this,function(res){
          var stateVal = res.getState();
            if(stateVal === 'SUCCESS'){
                alert('Cateogry deleted successfully.');
            }
        });
        $A.enqueueAction(act);
    }
})