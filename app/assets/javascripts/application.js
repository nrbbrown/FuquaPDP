// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
var isBodyClick = 1;
var selectedUserIndex = -1;
function moveupdown(e){
	var allus = dojo.query('#userlistdiv .userentry');
	var cck = false;
	if(dojo.byId('userlistdiv').className != 'hidediv'){
		if(e.keyCode == 38){
			if(dojo.byId('userentry_'+selectedUserIndex)){
				dojo.removeClass('userentry_'+selectedUserIndex,'userselectedhover');
			}
			if(selectedUserIndex >= 0)
				selectedUserIndex--;
		}else if(e.keyCode == 40){
			if(dojo.byId('userentry_'+selectedUserIndex)){
				dojo.removeClass('userentry_'+selectedUserIndex,'userselectedhover');
			}
			allus.forEach(function(node) {	
				if(node.getAttribute('data-group') > selectedUserIndex && !cck
					&& node.className.indexOf('hidediv') == -1 ){
					selectedUserIndex = selectedUserIndex + 1;
					cck = true;
				}else if(node.getAttribute('data-group') > selectedUserIndex && !cck){
					selectedUserIndex = selectedUserIndex + 1;
				}
			});
		}
		if(dojo.byId('userentry_'+selectedUserIndex)){
			dojo.addClass('userentry_'+selectedUserIndex,'userselectedhover');
		}
	}else{
		selectedUserIndex = -1;
	}
	if(e.keyCode == 13 && dojo.byId('userentry_'+selectedUserIndex)){
		var ah = dojo.query('#userentry_'+selectedUserIndex+' a');
		window.location = ''+(ah[0].href);
	}
}
function bodyClick(){
	
	if(isBodyClick == 1){
		if(dojo.byId('notificationdiv')){
			dojo.addClass('notificationdiv','hidediv');
		}
		if(dojo.byId('myconnectiondiv')){
			dojo.addClass('myconnectiondiv','hidediv');
		}
	}else if(isBodyClick == 2){
		if(dojo.byId('notificationdiv')){
			dojo.addClass('notificationdiv','hidediv');
		}
		if(dojo.byId('search-input')){
			dojo.byId('search-input').value = '';			
			showUserList();
		}
	}else if(isBodyClick == 0){
		if(dojo.byId('myconnectiondiv')){
			dojo.addClass('myconnectiondiv','hidediv');
		}
		if(dojo.byId('search-input')){
			dojo.byId('search-input').value = '';
			showUserList();
		}
	}
}

function deleteComment(commentid, taskid, goalid, goaluserid){
    var comment = '';
    if(dojo.byId('commentOuterDiv')){
        dojo.byId('commentInnerDiv').innerHTML = '';
    }
    var xhrArgs = {
        url:'/comments/edit',
        content:{
            taskid:taskid,
            goalid:goalid,
            goaluserid:goaluserid,
            commentid:commentid,
            comment:comment
        },
        headers:{
            'X-CSRF-Token':''
        },
        load:function(data){
            dojo.byId('commentInnerDiv').innerHTML = data;
        },
        error:function(data) {
            alert('failed to complete task');
        }
    };
    new dojo.xhrGet(xhrArgs);
}

function submitComment(taskid, goalid, goaluserid){
	var comment = dojo.byId('input_comment_'+taskid+'_'+goalid).value;
	if(dojo.byId('commentOuterDiv')){
		dojo.byId('commentInnerDiv').innerHTML = '';
	}
	var xhrArgs = {
		url:'/comments/edit',
		content:{
			taskid:taskid,
			goalid:goalid,
			goaluserid:goaluserid,
			comment:comment
		},
		headers:{
			'X-CSRF-Token':''          
		},
		load:function(data){
			dojo.byId('commentInnerDiv').innerHTML = data;
		},
		error:function(data) {
			alert('failed to complete task');
		}
	};
	new dojo.xhrGet(xhrArgs);
}

function openCommentsPopup (taskid, goalid, goaluserid){
	if(dojo.byId('commentOuterDiv')){
		dojo.removeClass('commentOuterDiv','hidediv');
		dojo.removeClass('instructionDiv','hidediv');
	}
	if(dojo.byId('notificationdiv')){
		dojo.addClass('notificationdiv','hidediv');
	}
	if(dojo.byId('notify_icon_'+taskid+'_'+goalid)){
		var nn = dojo.byId('notify_icon_'+taskid+'_'+goalid).innerHTML;
		dojo.byId('notify_icon_'+taskid+'_'+goalid).innerHTML = 0;
		dojo.byId('notify_icon_'+taskid+'_'+goalid).style.display = 'none';
		if(dojo.byId('notify_total_icon') && dojo.byId('onenotify_'+taskid+'_'+goalid+'_'+goaluserid)){
			var nt = dojo.byId('notify_total_icon').innerHTML;
			dojo.byId('notify_total_icon').innerHTML = nt-nn;
			if((nt-nn) == 0){
				dojo.byId('notify_total_icon').style.display = 'none';
			}
		}		
	}else if(dojo.byId('notify_total_icon') && dojo.byId('onenotify_'+taskid+'_'+goalid+'_'+goaluserid)){
		var nt = dojo.byId('notify_total_icon').innerHTML;
		dojo.byId('notify_total_icon').innerHTML = nt-1;
		if((nt-1) == 0){
			dojo.byId('notify_total_icon').style.display = 'none';
		}
	}
	
	dojo.byId('commentInnerDiv').innerHTML = '';
	var xhrArgs = {
		url:'/comments/index',
		content:{
			taskid:taskid,
			goalid:goalid,
			goaluserid:goaluserid
		},
		headers:{
			'X-CSRF-Token':''          
		},
		load:function(data){
			dojo.byId('commentInnerDiv').innerHTML = data;
		},
		error:function(data) {
			alert('failed to complete task');
			closeCommentsBox();
		}
	};
	new dojo.xhrGet(xhrArgs);
}
function closeCommentBox(){
	if(dojo.byId('commentOuterDiv')){
		dojo.addClass('commentOuterDiv','hidediv');
		dojo.addClass('instructionDiv','hidediv');
	}
}
function searchByUserName(){
	var searchTerm = (dojo.byId('search_user_name').value);
	dojo.addClass('noResultDiv','hidediv');
	var allUsers = dojo.query('.column2');
		var count = 0;
		allUsers.forEach(function(node) {	
			var n = node.innerHTML.toUpperCase();
			if(n != 'NAME'){
				if(n.indexOf(searchTerm.toUpperCase()) == -1){
					dojo.addClass(node.parentNode,'hidediv');
				}else{
					count = count + 1;
					dojo.removeClass(node.parentNode,'hidediv');
				}
			}
		});
	if(count == 0){
		dojo.removeClass('noResultDiv','hidediv');
	}
}

function openinstructions(id1,id2){
	
	if(dojo.byId(id2)){
		dojo.removeClass('instructionOuterDiv','hidediv');
		dojo.removeClass('instructionDiv','hidediv');
		dojo.byId('instructionInnerDiv').innerHTML = dojo.byId(id2).innerHTML;
	}
}
function closeInstructionBox(){
	if(dojo.byId('instructionDiv')){
		dojo.addClass('instructionOuterDiv','hidediv');
		dojo.addClass('instructionDiv','hidediv');
	}
}
function showUserList(){
	var v = dojo.byId('search-input').value;
	
	if(v == ''){
		dojo.addClass('userlistdiv','hidediv');
		dojo.addClass('dimuser','hidediv');
	}else{
		dojo.removeClass('userlistdiv','hidediv');
		dojo.removeClass('dimuser','hidediv');
		var allUsers = dojo.query('.userentry a');
		var count = 0;
		allUsers.forEach(function(node) {	
			var n = node.innerHTML.toUpperCase();
			if(n.indexOf(v.toUpperCase()) == 0){
				dojo.removeClass(node.parentNode,'hidediv');
				count++;
			}else{
				dojo.addClass(node.parentNode,'hidediv');
			}
		});
		if(count == 0){
			dojo.addClass('userlistdiv','hidediv');
			dojo.addClass('dimuser','hidediv');
		}
	}
}
function showMentorList(){
	var v = dojo.byId('goal_accountability').value;
	if(v.lastIndexOf(',') != -1){
		v = v.substr(v.lastIndexOf(',')+1);
	}
	v = dojo.trim(v);
	if(v == ''){
		dojo.addClass('mentorlistdiv','hidediv');
	}else{
		dojo.removeClass('mentorlistdiv','hidediv');
		var allUsers = dojo.query('.mentorentry div');
		var count = 0;
		allUsers.forEach(function(node) {	
			var n = node.innerHTML.toUpperCase();
						
			if(n.indexOf(v.toUpperCase()) == 0){
				dojo.removeClass(node.parentNode,'hidediv');
				count++;
			}else{
				dojo.addClass(node.parentNode,'hidediv');
			}
		});
		if(count == 0){
			dojo.addClass('mentorlistdiv','hidediv');
		}
	}
}
var mentorclick = 0;
function removeMentor(){
	setTimeout("dojo.addClass('mentorlistdiv','hidediv')",200);
	
}
function appendMentor(name){
	mentorclick = 1;
	var v = dojo.byId('goal_accountability').value;
	if(v.indexOf(',') == -1){
		dojo.byId('goal_accountability').value = name;
	}else{
		v = v.substr(0,v.lastIndexOf(','));
		dojo.byId('goal_accountability').value = v + ', '+ name;
	}
}
function openConnections(){
	isBodyClick = 2;
	dojo.toggleClass('myconnectiondiv','hidediv');
	setTimeout('isBodyClick = 1;',400);
}
function openNotifications(){
	isBodyClick = 0;
	dojo.toggleClass('notificationdiv','hidediv');
	setTimeout('isBodyClick = 1;',400);
}
function markBodyClickOn(){
	isBodyClick = 1;
}
function showgreen(id){
	dojo.byId('thumbs_'+id).src = '/images/tu_on.png'
}
function removegreen(id){
	dojo.byId('thumbs_'+id).src = '/images/tu_off.png'
}
function removethumbevents(id){
	dojo.byId('thumbs_'+id).onmouseout = '';
	dojo.byId('thumbs_'+id).onmouseover = '';
}
function markTaskProgress(taskId,isComplete,id,week,year){
	var taskid = taskId;
	var is_complete = isComplete;
	
	var xhrArgs = {
	url:'/progress/new',
	content:{
		taskid:taskid,
		iscomplete:is_complete,
		week:week,
		year:year
	},
	headers:{
		'X-CSRF-Token':''          
	},
	load:function(data){
		showgreen(id);
		removethumbevents(id);
		calculateWeeklyScore();
	},
	error:function(data) {
		alert('failed to complete task');
		removegreen(id);
	}
	};
	new dojo.xhrGet(xhrArgs);
}

function calculateWeeklyScore(){
	var start = parseInt(dojo.byId('startWeek').innerHTML);
	var end = parseInt(dojo.byId('endWeek').innerHTML);
	for(var i=start;i<=end;i++){
		var allThumbs = dojo.query('.group'+i+' img');
		var upCount = 0;
		var downCount = 0;
		allThumbs.forEach(function(node) {
			if(node.src.indexOf('tu_on.png') != -1){
				upCount = upCount + 1;
			}else if(node.src.indexOf('tu_off.png') != -1){
				downCount = downCount + 1;
			}
		})
		if(upCount+downCount == 0){
			dojo.byId('week-score-'+i).innerHTML = '-';
		}else{
			dojo.byId('week-score-'+i).innerHTML = (upCount*100/(upCount+downCount)) + '%';
		}
	}
}

function getGoalTaskProgress(goalid){
	var goalid = goalid;
	
	var xhrArgs = {
	url:'/progress',
	content:{
		id:goalid
	},
	headers:{
		'X-CSRF-Token':''          
	},
	load:function(data){
		dojo.byId('progress_ajax_'+goalid).innerHTML = data;
		dojo.byId('progressBoard_'+goalid).style.display = 'block';
		dojo.removeClass('dim','hidediv');
		calculateWeeklyScore();
	},
	error:function(data) {
		alert('failed to complete task');
	}
	};
	new dojo.xhrGet(xhrArgs);
}
function closeProgressBox(goalid) {
	dojo.byId('progressBoard_'+goalid).style.display = 'none';
	dojo.addClass('dim','hidediv');
}

function changeEntryWeek(){
	var selIndex = dojo.byId('entry_week_change').selectedIndex;
	var selValue = dojo.byId('entry_week_change').options[selIndex].value;
	window.location = "/scoreentry?week="+selValue;
}
function changeReportWeek(){
	var selIndex = dojo.byId('entry_week_change').selectedIndex;
	var selValue = dojo.byId('entry_week_change').options[selIndex].value;
	window.location = "/scorecard?week="+selValue;
}
function updateTaskComplete(taskid,goalid,is_complete){
	var taskid = taskid;
	var goalid = goalid;
	var xhrArgs = {
	url:'/scoreentry/'+taskid+'/edit',
	content:{
		taskid:taskid,
		is_complete:is_complete
	},
	headers:{
		'X-CSRF-Token':''          
	},
	load:function(data){
		if(is_complete == 1){
			dojo.addClass('thumbs_img_'+taskid,'checkImageOn');
			dojo.removeClass('thumbs_img_'+taskid,'checkImageOff');
			dojo.byId('thumbs_img_'+taskid).onclick = function () { updateTaskComplete(taskid,goalid,0);};
		}else{
			dojo.addClass('thumbs_img_'+taskid,'checkImageOff');
			dojo.removeClass('thumbs_img_'+taskid,'checkImageOn');
			dojo.byId('thumbs_img_'+taskid).onclick = function () { updateTaskComplete(taskid,goalid,1);};
		}
	},
	error:function(data) {
		alert('failed to complete task');
	}
	};
	new dojo.xhrGet(xhrArgs);
}
function markTaskProgressEntry(taskId,isComplete,id,week,year){
	var taskid = taskId;
	var isComplete = isComplete;
	var xhrArgs = {
	url:'/progress/new',
	content:{
		taskid:taskid,
		week:week,
		iscomplete:isComplete,
		year:year
	},
	headers:{
		'X-CSRF-Token':''          
	},
	load:function(data){
		if(isComplete == 1){
			dojo.addClass('tu_img_'+taskid,'tupImage');
			dojo.removeClass('tu_img_'+taskid,'tdownImage');
			dojo.byId('tu_img_'+taskid).onclick = function () { markTaskProgressEntry(taskid,0,id,week,year);};
			
		}else{
			dojo.addClass('tu_img_'+taskid,'tdownImage');
			dojo.removeClass('tu_img_'+taskid,'tupImage');
			dojo.byId('tu_img_'+taskid).onclick = function () { markTaskProgressEntry(taskid,1,id,week,year);};
		}
        if( dojo.byId('effort_score_'+id)){
            calculateWeeklyEffortScore(id);
        }

	},
	error:function(data) {
		alert('failed to complete task');
	}
	};
	new dojo.xhrGet(xhrArgs);
}

function calculateWeeklyEffortScore(goalid){

    var allThumbs = dojo.query('#task_area_'+goalid+' .tdownImage');
    var allThumbsUp = dojo.query('#task_area_'+goalid+' .tupImage');

    var upCount = allThumbsUp.length;
    var downCount = allThumbs.length;
    var score = (upCount)/(upCount +downCount)*100 ;
    dojo.byId('effort_score_'+goalid).innerHTML = score;

}

function openScoreCardDetails(domainType,rowType,goalid){
    var allGoals = dojo.query('.effort_row_'+rowType+'_'+domainType+'_'+goalid);
    allGoals.forEach(function(node) {
        if(node.style.display == 'none'){
            node.style.display = 'block';
            dojo.byId('plus_div_'+rowType+'_'+domainType+'_'+goalid).innerHTML = '[-]';
        }else {
            console.log(rowType);
            if(goalid == 0 && rowType == 3){
                var allSubMinorGoals = dojo.query('.effort_row_4_'+domainType);
                console.log(allSubMinorGoals.length);
                allSubMinorGoals.forEach(function(node1) {
                    node1.style.display='none';
                })
            }
            node.style.display = 'none';
            dojo.byId('plus_div_'+rowType+'_'+domainType+'_'+goalid).innerHTML = '[+]';
        }
    })

}
var Mim = {
    
    up: -1,
    
    init: function(){
		if(dojo.byId('infomim')){
			dojo.connect(dojo.byId('infomim'),'onclick',{},Mim.toggleInfo);  
			dojo.connect(dojo.byId('mimbird'),'onclick',{},Mim.toggleInfo); 
		}
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
       // dojo.connect(dojo.byId('infoscore'),'onclick',{},Score.toggleInfo);  
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
        Goals.showActiveComplete();
        
        
        //dojo.connect(dojo.byId('searchdiv'),'onclick',{},Goals.showSearch);
        //dojo.connect(dojo.byId('userdirectory'),'onclick',{},Goals.showSearch);

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

