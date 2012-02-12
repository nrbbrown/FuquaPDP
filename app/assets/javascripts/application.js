// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .


var Mim = {
    
    up: -1,
    
    init: function(){
        dojo.connect(dojo.byId('infomim'),'onclick',{},Mim.toggleInfo);  
        dojo.connect(dojo.byId('mimbird'),'onclick',{},Mim.toggleInfo); 
    },
    
    toggleInfo: function(){
        var node = dojo.byId('mimitem');
        var b = dojo.style(node, 'bottom');
        var newb = (b == '-220px') ? '-20px' : '-220px';
        
        dojo.toggleClass('mimbird','hidediv');
        dojo.toggleClass('infomim','iteminactive');
        
        dojo.style(node, {'bottom':newb});
        Mim.up *= -1;
        Score.toggleHideDiv();
    }
}

var Score = {
    
    up: -1,
    fadeoff: 0,
    
    init: function(){
        dojo.connect(dojo.byId('infoscore'),'onclick',{},Score.toggleInfo);  
    },
    
    toggleInfo: function(){
        var node = dojo.byId('scoreitem');
        var b = dojo.style(node, 'bottom');
        var newb = (b == '-112px') ? '20px' : '-112px';

        dojo.style(node, {'bottom':newb});
        dojo.toggleClass('scoreplusminus','hidediv');
        dojo.toggleClass('infoscore','iteminactive');
        Score.up *= -1;
        Score.toggleHideDiv();
                    
        dojo.byId('categoryScore').innerHTML = Goals.calculateScore(Goals.goallist,null,Goals.filter,null);
        dojo.byId('overallScore').innerHTML = Goals.calculateScore(Goals.goallist,null,null,null);
    },
    
    toggleHideDiv: function(){
        if((Score.up > 0 || Mim.up > 0) && Score.fadeoff==0){
            dojo.removeClass('dim','hidediv');
            dojo.style(dojo.byId('dim'), "opacity", "0");
            dojo.animateProperty({
                node: "dim",
                properties: {
                    opacity:0.4
                }
            }).play();
            Score.fadeoff = 1;        
        }else if(Score.up < 0 && Mim.up < 0){
          //  dojo.addClass('dim','hidediv');
            dojo.style(dojo.byId('dim'), "opacity", "0.4");
            dojo.animateProperty({
                node: "dim",
                properties: {
                    opacity:0
                }
            }).play();
            Score.fadeoff = 0;
            setTimeout('Score.hideBlack()',400);
        }
    },
    
    hideBlack: function(){
        dojo.addClass('dim','hidediv');
    }
    
}

var Progress = {
    
    init: function(){
    }
}

var Goals = {
    
    categories: ['academic','career','social','personal','physical'],
    filter: 'academic',
    complete: '0',
    token: '',
    goallist: null,
    uid: 0,
    on: -1,
    
    init: function(){
        Goals.attachListeners();
        Goals.setFilter();
    },
    
    attachListeners: function(){
		
        for(var c in Goals.categories){
            var openc = Goals.categories[c];
            dojo.connect(dojo.byId('cat-'+openc),'onclick',{'filterby':openc},Goals.filterByChange);
        }
        for(i = 0; i<10; i++){
            var node = dojo.byId('taskrow'+i);
            if(node && node.value != ''){
                var parent = node.parentNode.parentNode;
                dojo.removeClass(parent,'taskrowoff');
            }
            node && dojo.connect(node,'onfocus',{'taskrow':i+1},Goals.shownextTask);
        }
        dojo.query('.truetaskcheck0').forEach(Goals.connectCompleteTask);
        dojo.query('.truetaskcheck1').forEach(Goals.connectCompleteTask);
        
        Goals.showActiveComplete();
        
        
        dojo.connect(dojo.byId('searchdiv'),'onclick',{},Goals.showSearch);
        dojo.connect(dojo.byId('userdirectory'),'onclick',{},Goals.showSearch);

    },

    
    showSearch: function(){
        dojo.toggleClass('userlistdiv','hidediv');
        
        if(Goals.on < 0){
            dojo.removeClass('dimuser','hidediv');
            dojo.style(dojo.byId('dimuser'), "opacity", "0");
            dojo.animateProperty({
                node: "dimuser",
                properties: {
                    opacity:0.4
                }
            }).play();
        }else{
            dojo.style(dojo.byId('dimuser'), "opacity", "0.4");
            dojo.animateProperty({
                node: "dimuser",
                properties: {
                    opacity:0
                }
            }).play();
            setTimeout('Goals.hideSearch()',400);
        }
        Goals.on *= -1;
    },
    
    hideSearch: function(){
        dojo.addClass('dimuser','hidediv');
    },
    
    showActiveComplete: function(){
        dojo.addClass('activecomplete'+Goals.complete,'selected');
    },
    
    connectCompleteTask: function(t){
        dojo.connect(dojo.byId(t.id), 'onclick', {id:t.id,gid:t.title}, Goals.completeTask);
    },
    
    completeTask: function(){
        var goalid = this.gid.substring(4);
        var id = this.id.substring(6);
        var was_is_complete = Goals.getGoalTaskComplete(goalid, id);
        var is_complete = (was_is_complete == '1') ? '0' : '1';
        
        Goals.updateGoalTask(goalid,id,is_complete);
        
        var xhrArgs = {
        url:'/goals/'+goalid+'/tasks/'+id,
        content:{
            taskid:id,
            is_complete:is_complete
        },
        headers:{
            'X-CSRF-Token':Goals.token            
        },
        load:function(data){
            dojo.removeClass(dojo.byId('taskid'+id),'truetaskcheck'+was_is_complete);
            dojo.addClass(dojo.byId('taskid'+id),'truetaskcheck'+is_complete);
        },
        error:function(data) {
            alert('failed to complete task');
        }
        };new dojo.xhrPut(xhrArgs);

    },
    
    shownextTask: function(){
        var n = this.taskrow
        var node = dojo.byId('taskrow'+n).parentNode.parentNode;

        node && dojo.hasClass(node,'taskrowoff') && dojo.removeClass(node,'taskrowoff');
    },
    
    setFilter: function(){
        dojo.addClass('cat-'+Goals.filter,'selected');
        dojo.query('.goalcat'+Goals.filter).forEach(function(t){t.style.display='block'});
        dojo.create('img',{'src':'/images/menu_arrow.png','class':'catarrow'},dojo.byId('cat-'+Goals.filter));
    },
    
    
    filterByChange: function(){
        window.location = '/goals?filter='+this.filterby+'&u='+Goals.uid;
    },
    
    findGoalById: function(id){
        for(var g in Goals.goallist){
            if(Goals.goallist[g].id == id){
                return Goals.goallist[g];
            }
        }
        return null;
    },
    
    getGoalTaskComplete: function(goalid, taskid){
        for(var g in Goals.goallist){
            if(Goals.goallist[g].id == goalid){
                for(var t in Goals.goallist[g].tasks){
                    if(Goals.goallist[g].tasks[t].id == taskid){
                        return Goals.goallist[g].tasks[t].is_complete;
                    }
                }
            }
        }  
        return -1;
    },
    
    updateGoalTask: function(goalid, taskid, is_complete){
        // update 1 value
        for(var g in Goals.goallist){
            if(Goals.goallist[g].id == goalid){
                for(var t in Goals.goallist[g].tasks){
                    if(Goals.goallist[g].tasks[t].id == taskid){
                        Goals.goallist[g].tasks[t].is_complete = is_complete;
                    }
                }
            }
        }
        
        // get count
        var goalscore = Goals.calculateScore(Goals.goallist,null,Goals.filter,goalid);
        
        if(goalscore == '100%'){
            Goals.updateGoalComplete(goalid,1)
        }else{
            Goals.updateGoalComplete(goalid,0);
        }
        
        // update score
        dojo.byId('goalscore'+goalid).innerHTML = goalscore;
        dojo.byId('categoryScore').innerHTML = Goals.calculateScore(Goals.goallist,null,Goals.filter,null);
        dojo.byId('overallScore').innerHTML = Goals.calculateScore(Goals.goallist,null,null,null);
    },
    
    updateGoalComplete: function(goalid,is_complete){
        var xhrArgs = {
        url:'/goals/'+goalid,
        content:{
            id:goalid,
            is_complete:is_complete
        },
        headers:{
            'X-CSRF-Token':Goals.token            
        },
        load:function(data){
            
        },
        error:function(data) {
            alert('failed to complete goal');
        }
        };new dojo.xhrPut(xhrArgs);
    },
    
    calculateScore: function(list,is_complete,category,goalid){
        var th = 0;
        var ch = 0;
        for(var l in list){
            // specific goal only?
            if(goalid == null || list[l].id == goalid){
                // complete goals only?
                if(is_complete == null || list[l].is_complete == is_complete){
                    // specific category only?
                    if(category == null || list[l].category == category){
                        for(var tt in list[l].tasks){
                            if(list[l].tasks[tt].is_complete == 1){
                                ch++;
                            }
                            th++;
                        }
                    }
                }
            }
        }
        
        var score = Math.round((ch*100)/Math.max(th,1))+'%';
        
        return score;
        
    }
    
}

