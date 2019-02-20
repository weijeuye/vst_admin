
			 var $document = $(document);
		 	$(".choose-delete-btn").off("click");
		 	$(".choose-delete-btn").on("click",function () {
        	 var $this=$(this);;
        	var hotelTimeId=$this.siblings().data("id");
            nova.dialog({
                content:"删除时间段将同时删除该时间段下设置的所适用酒店，您确定要删除吗？",
                okCallback:function () {
					//回调函数
					deleteTime(hotelTimeId);
				},
                okClassName:"btn-blue",
                okText: "确定",
                cancelCallback: true,
                cancelText: "取消",
                wrapClass:"delete-all-dialog"
            })
            
        	});
        
      
		//新增时间段
		 $(".js-add-date").off("click");
		$(".js-add-date").on("click",function () {
			$(".date-change-box").empty();
			var recommendId=$('#hotelRuleTable').val();
			queryRouteNum(recommendId);
			
		});
		 function timeDialog(routeNum){
			 var selectedTime="";
				$('.check-in-time').find('em').each(function(){
					selectedTime=selectedTime+$(this).text();
				});
				if(routeNum > 0){
				  for(var i=1;i<routeNum;i++){
				  	 var day ="D"+i;
				  	if(selectedTime.indexOf(i) > 0){
				  	$(".date-change-box").append("<label><input type='checkbox' disabled='disabled'>"+day+"</label>");
				  	}else{
				  	$(".date-change-box").append("<label><input type='checkbox'>"+day+"</label>");
				  	}
				  }
				}
				var $dateChange = $(".date-change-box");
				nova.dialog({
					content:$dateChange.clone(),
					title:"选择日期组合时间段",
					wrapClass: "add-date-dialog",
					width: 450,
					okCallback:function () {
						var time;
						var flag=false;
						//获取选择的时间
						$(".date-change-box").find('input:checkbox:checked').each(function(){
							if(flag){
							time=time+","+$.trim($(this).parent().text().replace("D",""));
							}else{
							flag=true;
							time=$.trim($(this).parent().text().replace("D",""));
							}
						});
						//回调函数
						if(time!=undefined && time!=null){
							addTime(time);
						}
					},
					okClassName:"btn-blue",
					okText: "确定"
				})
			 
		 }
		 function addTime(hotelTime){
			var recommendId=$('#hotelRuleTable').val();
        	$.ajax({
				url : "/vst_admin/superfreetour/travelHotelRule/addTravelHotelTime.do",
				type : "post",
				dataType : 'json',
				data :{hotelTime:hotelTime,
					  recommendId:recommendId},
				success : function(result) {
					if(result.code == "success"){
				    	nova.dialog({
				    		 okClassName:"btn-blue",
				    	    content: result.message,
				    	    okCallback: function(){
				    	    	//重新查询酒店规则
					   			queryHotelRule(recommendId);
				    	    }
				    	});
				   	} else {
				   	 nova.dialog({
 						content:result.message,
 						okCallback: true, 
 					    okText: "确定",
 					    okClassName:"btn-blue",
 					    time:2000 //定时关闭 
 					});
				 	}
				},
				error : function() {
					alert('网络服务异常, 请稍后重试');
				}
			});
        }
        
        	//根据时间段Id删除时间段
	 		function deleteTime(hotelTimeId){
	 		var recommendId =$('#hotelRuleTable').val();	
        	$.ajax({
				url : "/vst_admin/superfreetour/travelHotelRule/deleteTravelHotelTime.do",
				type : "post",
				dataType : 'json',
				data :{hotelTimeId:hotelTimeId},
				success : function(result) {
					if(result.code == "success"){
				    	nova.dialog({
				    		okClassName:"btn-blue",
				    	    content: result.message,
				    	    okCallback: function(){
				    	    	//重新查询酒店规则
					   			queryHotelRule(recommendId);
				    	    }
				    	});
				   	} else {
				   		nova.alert(result.message);
				 	}
				},
				error : function() {
					alert('网络服务异常, 请稍后重试');
				}
			});
        }
		//查询时间段
		 function queryRouteNum(recommendId){
        	$.ajax({
				url : "/vst_admin/superfreetour/travelRecommendRoute/getRouteNum.do",
				type : "post",
				dataType : 'json',
				data : {recommendId:recommendId},
				success : function(result) {
					if(result.code == 'success'){
						var routeNum= result.attributes.routeNum;
						timeDialog(routeNum);
					}else{
						alert(result.message);
					}
					
				},
				error : function() {
					alert('网络服务异常, 请稍后重试');
				}
			});
        }
		
		/*$document.on("change",".add-date-dialog label input",function () {
			$(this).attr("disabled",true);
			var $thisVal = $(this).val();
			console.log($thisVal);
		});*/
		//升级
		//var $up = $(".up-btn");
		$(".up-btn").die("click");
		$(".up-btn").live("click", function () {
		    var $this = $(this);
		    var $thisTr = $this.parents("tr");
		    var $thisIndex = $thisTr.index();
		    if($thisIndex !=0){
		        $thisTr.prev().before($thisTr);
		    }
		    else{
		        nova.dialog({
		            content:"已经是第一条了，不可再升级了哦~",
		            time:2000,
		            width:265,
		            masked:false,
		            wrapClass:"up-down-dialog"
		        })
		    }
		});
		//降级
		//var $down = $(".down-btn");
		$(".down-btn").die("click");
		$(".down-btn").live("click",function () {
		    var $this = $(this);
		    var $thisParent = $this.parents(".display-table");
		    var $thisTr = $this.parents("tr");
		    var $thisIndex = $thisTr.index();

		    var $len = $thisParent.find("tr").length - 1;
		    console.log($len);
		    if($thisIndex != $len-1){
		        $thisTr.next().after($thisTr);
		    }
		    else{
		        nova.dialog({
		            content:"已经是最后一条了，不可再降级了哦~",
		            time:2000,
		            width:265,
		            masked:false,
		            wrapClass:"up-down-dialog"
		        })
		    }
		});

		//清除全部适用酒店
		$(".js-delete-all").die("click");
		$(".js-delete-all").live("click",function () {
			var hotelTimeId=$(this).data("timeid");
			nova.dialog({
				content:"您确定要清除该时间段下全部适用酒店吗？",
				okCallback: function () {
					deleteHotelSort(hotelTimeId);
				},
				okClassName:"btn-blue",
				okText: "确定",
				cancelCallback: true,
				cancelText: "取消",
				wrapClass:"delete-all-dialog"
			})
		});
		//删除行
		//(".delete-btn").die("click");
		$(".delete-btn").live("click",function () {
			$(this).parents("tr").remove();
		});
        //设置酒店
		
		$document.on("click",".set-hotel",function(){
        	var hotelTimeId=$(this).data("timeid");
        	if(hotelTimeId==undefined || hotelTimeId=="" ){
        		nova.dialog({
					content:"请先设置时间段！",
					okCallback: true, 
				    okText: "确定",
				    okClassName:"btn-blue",
				    time:2000 //定时关闭 
				});
        		return;
        	}
            var url="/vst_admin/superfreetour/travelRecommendTrafficRule/showHotelSetBox.do?hotelTimeId="+hotelTimeId;
            var winHeight = $(window).height();
            nova.dialog({
                url:true,
                content: url,
                title:"选择适用酒店",
                width:1000,
                initHeight: winHeight-38,  //iframe高度
                height: winHeight,
                wrapClass:"hotel-set-dialog"
            });
        
		})
         //查询时间段
		 function showHotelSetBox(timeId){
        	$.ajax({
				url : "/vst_admin/superfreetour/travelRecommendTrafficRule/showHotelSetBox.do",
				type : "get",
				dataType : 'html',
				data : {timeId:timeId},
				success : function(result) {
					return result;
				},
				error : function() {
					alert('网络服务异常, 请稍后重试');
				}
			});
        }
		//查询酒店规则
		 function queryHotelRule(recommendId){
        	$.ajax({
				url : "/vst_admin/superfreetour/travelHotelRule/showHotelRule.do",
				type : "get",
				dataType : 'text',
				data : {recommendId:recommendId},
				success : function(data) {
				   $('#hotelRuleTabContent').html("");
				   $('#hotelRuleTabContent').html(data);
				},
				error : function() {
					alert('网络服务异常, 请稍后重试');
				}
			});
        }	
		 //点击不同的时间段 异步请求对应的酒店
		 //$(".check-hotel-list li").die("click");
		  $(".check-hotel-list li").live("click",function () {
		        var $this = $(this);
		        var hotelTimeId=$(this).data("timeid");
		        var $thisIndex = $this.index();
		        $this.addClass("active").siblings().removeClass("active");
		        $(".js-hotel-set-box").eq($thisIndex).show().siblings(".js-hotel-set-box").hide();
		        searchHotelByTimeId(hotelTimeId);
		    });
		  
		  // 获取某天的酒店排序结果
		  function searchHotelByTimeId(hotelTimeId){
			$.ajax({
				url : "/vst_admin/superfreetour/travelHotelRule/getHotelSortList.do",
				type : "get",
				dataType :'html',
				data :{hotelTimeId:hotelTimeId},
				success : function(data) {
				$('#hotelValue').html(data);	
				},
				error : function() {
					alert('网络服务异常, 请稍后重试');
				}
			});
		
		  }
		  
		$('.save-hotel-btn').find('.btn-blue').die("click");
		$('.save-hotel-btn').find('.btn-blue').live("click",function(){
			var timeId=$(this).data("timeid");
			var timeName=$(this).data("timename");
			if(timeId==undefined || timeId=="" ){
        		nova.dialog({
					content:"请先设置时间段！",
					okCallback: true, 
				    okText: "确定",
				    okClassName:"btn-blue",
				    time:2000 //定时关闭 
				});
        		return;
        	}
			var saveHotels=getSaveHotels(timeId);
			/*if(saveHotels.length == 0){
				nova.dialog({
            	 	content: "数据为空！",
            	 	time: 2000,
            	 	okCallback:true,
            	    okText: "确定",
            		});
				return;
			}*/
			saveHotelSort(saveHotels,timeId);
		})
		
		//获取当页即将要保存的酒店列表
		function getSaveHotels(timeId){
			var saveHotelArray = new Array();
			$("#"+timeId).find('tbody').find('tr').each(function (){
       		 var saveHotel = {};
       		 saveHotel.recommendId =$('#hotelRuleTable').val();
       		 saveHotel.hotelId = $(this).find('#hotelId').text();
       		 saveHotel.priority = $(this).find('#priority').text();
       		 saveHotel.hotelName = $(this).find('#hotelName').text();
       		 saveHotel.hotelPrice = $(this).find('#hotelPrice').attr("value");
       		 saveHotel.starLevel = $(this).find('#starLevel').attr("value");
       		 saveHotel.goodComments = $.trim($(this).find('#goodComments').attr("value"));
       		 saveHotel.hotelAddress = $.trim($(this).find('#hotelAddress').text());
       		 saveHotelArray.push(saveHotel);
			});
			return saveHotelArray;
		}
		function saveHotelSort(saveHotelArray,hotelTimeId){
			  var loading = nova.loading('<div class="nova-dialog-body-loading"><i></i><br>保存中...</div>');
			$.ajax({
				url : "/vst_admin/superfreetour/travelHotelRule/saveTravelHotelSort.do",
				type : "post",
				dataType :'json',
				data :{hotelSortStr:JSON.stringify(saveHotelArray),
					    hotelTimeId:hotelTimeId},
				success : function(data) {
				    loading.close();
                    if(data.code == "success"){
                    	nova.dialog({
                    	 	content: "保存成功！",
                    	 	time: 2000,
                    	 	okCallback:true,
                    	    okClassName:"btn-blue",
                    	    okText: "确定",
                    		});
                    }else {
                        loading.close();
                        nova.alert(data.message);
                    }
				},
				error : function() {
					alert('网络服务异常, 请稍后重试');
				}
			});
		}
		
		function deleteHotelSort(hotelTimeId){
			  var loading = nova.loading('<div class="nova-dialog-body-loading"><i></i><br>正在删除中...</div>');
			$.ajax({
				url : "/vst_admin/superfreetour/travelHotelRule/deleteTravelHotelSort.do",
				type : "post",
				dataType :'json',
				data :{hotelTimeId:hotelTimeId},
				success : function(data) {
					  loading.close();
	                    if(data.code == "success"){
	                    	nova.dialog({
	                    	 	content: "清除成功！",
	                    	 	time: 2000,
	                    	 	okCallback:true,
	                    	    okClassName:"btn-blue",
	                    	    okText: "确定",
	                    		});
	                      //删除成功 则刷新页面
	     				   searchHotelByTimeId(hotelTimeId);
	                    }else {
	                        loading.close();
	                        nova.alert(data.message);
	                    }	
				},
				error : function() {
					alert('网络服务异常, 请稍后重试');
				}
			});
		}
//# sourceURL=travelRecommendHotelRule.js