({
	searchForKeyAndPush : function(item, items, foundAndPushed, level) {
        console.log('here');
        for(var i=0; i<items.length; i++){
            console.log('Searched In:'+JSON.stringify(items));
            if(items[i].name == item.metatext){
                items[i].items.push(item);
                foundAndPushed = true;
                break;
            }
            else{
                if(items[i].items.length > 0){
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
        if(foundAndPushed == false && level == 1){
            items.push(item);
            foundAndPushed = true;
        }
        return items;
	}
})