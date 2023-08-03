({
	searchForKeyAndPush : function(item, items, foundAndPushed, level, parentCategoryActive) {
        console.log('here');
        console.log('item='+JSON.stringify(item));
        //Iterate over add categories
        for(var i=0; i<items.length; i++){
            console.log('Searched In:'+JSON.stringify(items));
            //Check if current category's parent is in the list
            if(items[i].name == item.metatext){
                //If yes, add the current category as a child of the existing parent in the list
                items[i].items.push(item);
                foundAndPushed = true;
                break;
            }
            else{
                //If there are inner categories search there for the parent
                if(items[i].items.length > 0){
                    //Call the same function recursively to dig another level in to the JSON Object
                    var returnItems = this.searchForKeyAndPush(item, items[i].items);
                    if(returnItems != items[i].items){
                        items = returnItems;
                    }
                }
                else{
                    continue;
                }
            }
        }
        //Stricly for top level categories, since they won't be satisfying the above conditions but need
        //to be added to the list
        if(foundAndPushed == false && level == 1 && parentCategoryActive == true){
            console.log('foundAndPushed='+foundAndPushed);
            items.push(item);
            foundAndPushed = true;
        }
        return items;
	}
})