 $(function () {
	   
        var $document= $(document);
        $document.on("click",".js-sure-choose",function () {
        	var hotelTimeId = $(this).data("timeid");
        	var hotelArray = new Array();
        	var hotelName;
        	var flag=false;
        	var saveHotels=parent.getSaveHotels(hotelTimeId);
        	$(".hotel-set-box").find('input:checkbox:checked').parent().parent().parent().each(function (){
        		 var hotel = {};
        		 hotel.hotelId = $(this).find('#hotelId').text();
        		 hotel.priority = $(this).find('#priority').text();
        		 hotel.hotelName = $(this).find('#hotelName').text();
        		 hotel.hotelPrice = $(this).find('#hotelPrice').attr("value");
        		 hotel.starLevelValue = $(this).find('#starLevel').attr("value");
        		 hotel.starLevel = $(this).find('#starLevel').text();
        		 hotel.goodComments = $.trim($(this).find('#goodComments').attr("value"));
        		 hotel.hotelAddress = $.trim($(this).find('#hotelAddress').text());
        		 $.each(saveHotels,function(index,item){
        			 if(hotel.hotelId==item.hotelId){
        				 if(flag){
        				 hotelName=hotelName+","+hotel.hotelName;  
        				 }else{
        				 flag=true;
        				 hotelName=hotel.hotelName;
        				 }
        			 }
        		 });
        		 if(hotel.hotelId !=null && hotel.hotelId !=""){
        			 hotelArray.push(hotel);
        		 }
        		
        	});
        	 if(hotelName!=undefined || hotelName !=null ){
        		 nova.dialog({
						content:"该时间段列表已经存在酒店："+hotelName+",请去除勾选!",
						okCallback: true, 
					    okText: "确定",
					    okClassName:"btn-blue"
					    //time:2000 //定时关闭 
					});
    			 return;
    		 }else{
    			 if(hotelArray.length == 0){
    				 //nova.alert("未选择酒店！");
    				 nova.dialog({
    						content:"未选择酒店！",
    						okCallback: true, 
    					    okText: "确定",
    					    okClassName:"btn-blue",
    					    time:2000 //定时关闭 
    					});
    				return;
    			}
    			 if(hotelArray.length + saveHotels.length > 50){
    				 nova.dialog({
 						content:"每个时间段最多选择50个酒店,请去除勾选多余的酒店！",
 						okCallback: true, 
 					    okText: "确定",
 					    okClassName:"btn-blue"
 					    //time:2000 //定时关闭 
 					});
    			 }
    			//弹框选中内容显示在页面对应的时间段上
	        	setHtml(hotelArray,hotelTimeId,saveHotels);
	            $(window.parent.document).find(".nova-overlay").remove();
	            $(window.parent.document).find(".hotel-set-dialog").remove();
    		 }
        })
    })
     //设置适用酒店
    $(".condition-btn input").on("change",function () {
        var $this = $(this);
        var $thisParent = $this.parents(".hotel-condition");
        if($this.prop("checked") == true){
            $thisParent.removeClass("disabled-box").siblings().addClass("disabled-box");
            $thisParent.find("select").attr("disabled",false);
            $thisParent.find(".js-boat-select").attr("disabled",false);
            $thisParent.siblings(".hotel-condition").find("select").attr("disabled",true);
            $thisParent.siblings(".hotel-condition").find(".js-boat-select").attr("disabled",true);
        }
    })
    
    function setHtml(hotelArray,hotelTimeId,saveHotels){
	 var num=saveHotels.length;
	 $.each(hotelArray, function(index, item) {
		    var priority=num+index+1;
	        //var htmlTr = '<tr><td>'+value.categoryName+'</td><td>'+value.productId+'</td><td>'+value.productName+'</td><td>'+value.branchName+'</td><td><a data="'+value.productBranchId+'">删除</a></td></tr>';
	        var html="<tr>"
					 	+"<td  id='hotelId' style='display:none;'>"+item.hotelId+"</td>"
			            +"<td  id='priority' >"+priority+"</td>"
			            +"<td  id='hotelName' >"+item.hotelName+"</td>"
			            +"<td  id='hotelPrice' value='"+item.hotelPrice+"'>"
			            +"    &yen;"+item.hotelPrice+"</td>"
			            +"<td id='starLevel' value='"+item.starLevelValue+"'>" +item.starLevel+"</td>"
			            +"<td  id='goodComments' value='"+item.goodComments+"'>"
			            if(item.goodComments ==undefined || item.goodComments ==""){
			            	html=html+"无</td>"
			            }else{
			            	html=html+item.goodComments+"%</td>"
			            }
	         			html= html+"<td  id='hotelAddress'>"+item.hotelAddress+"</td>"
			            +"<td>"
			             +"   <a href='javascript:;' class='up-btn'>升级</a>"
			             +"   <a href='avascript:;' class='down-btn'>降级</a>"
			             +"   <a href='javascript:;' class='delete-btn'>删除</a>"
			            +"</td>"
			        +"</tr>";
	        var parentHtml=parent.$('#hotelValue').find('#'+hotelTimeId);
	        if(parentHtml.length > 0){
	        	 parent.$('#hotelValue').find('#'+hotelTimeId).find('table').find('tbody').append(html);
	        }else{
	        	parent.$('#hotelValue').empty();
	        var titleHtml=
			     "<div id="+hotelTimeId+" class='js-hotel-set-box' style='display: block'>"
			         +"   <div class='manage-box'> 已选酒店"
			         +"  <a class='btn btn-blue set-hotel' data-timeId="+hotelTimeId+" >设置适用酒店</a>"
			         +"  <a class='btn js-delete-all' data-timeId="+hotelTimeId+">清除全部适用酒店</a>"
			        +"</div>"
			       +"<table class='display-table'>"
			           +"<thead>"
			           +"<tr>"
			           +" <th width='50'>匹配度</th>"
			           +" <th width='8%'>酒店名称</th>"
			           +"  <th width='50'>价格</th>"
			           +" <th width='5%'>星级标准</th>"
			           +" <th width='5%'>好评度</th>"
			           +" <th width='8%'>地址</th>"
			           +" <th width='80'>操作</th>"
			           +" </tr>"
			           +" </thead>"
			           +"<tbody>"
			           +"</tbody>"
			        +"</table>"
			      +"<div>"
			      +"<div class='save-hotel-btn'>"
			       +"<a class='btn btn-blue' data-timeId="+hotelTimeId+">保存</a>"
			      +"</div>"
			    +"</div>";
	        parent.$('#hotelValue').append(titleHtml).find('#'+hotelTimeId).find('table').find('tbody').append(html);
	        }
	       
	        //$("#packagedBranchTbody").append(html);
	    });
 	}
    $('.search-hotel-btn').find('a').die("click");
    $('.search-hotel-btn').find('a').live("click",function (){
    	var recommendId=parent.$('#hotelRuleTable').val();
    	//var destId=79;
    	queryHotel(recommendId);
    	
    });
    
    function queryHotel(recommendId){
    	$.ajax({
			url : "/vst_admin/superfreetour/travelHotelRule/searchHotel.do?recommendId="+recommendId,
			contentType: "application/x-www-form-urlencoded; charset=utf-8",
			type : "Post",
			dataType : 'html',
			data : $('#searchHotelForm').serialize(),
			success : function(result) {
				$('#hotelBoxResult').html(result);
			},
			error : function() {
				alert('网络服务异常, 请稍后重试');
			}
		});
    }
    $(".JS_result_select_all").die("change");
    $(".JS_result_select_all").live("change", function () {
        var $this = $(this);
        if ($this.is(":checked")) {
        	$(".JS_result_select").prop("checked", true)
        } else {
        	$(".JS_result_select").prop("checked", false)
        }
    });
    $(".JS_result_select").die("change");
    $(".JS_result_select").live("change", function () {
        var isAllChecked = true;
        $(".JS_result_select").each(function (index, dom) {
            if (!$(dom).is(":checked")) {
                isAllChecked = false;
            }
        });
        if (isAllChecked) {
        	$(".JS_result_select_all").prop("checked", true)
        } else {
        	$(".JS_result_select_all").prop("checked", false)
        }
    });

  //# sourceURL=searchHotel.js