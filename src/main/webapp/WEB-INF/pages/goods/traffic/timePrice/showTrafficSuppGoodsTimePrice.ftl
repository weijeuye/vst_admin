<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
</head>
<body style="position:relative">
	<div class="iframe_header">
        <ul class="iframe_nav">
            <li>
	            <#if prodProduct != null && prodProduct.bizCategory != null>
		            ${prodProduct.bizCategory.categoryName}&gt;
	            </#if>
            </li>
            <li>商品维护&gt; </li>
            <li><a href="#">销售信息</a>&gt;</li>
            <li class="active">查看/维护时间价格表</li>
        </ul>
    </div>
	<div class="iframe_content mt10">
	  <div class="tiptext tip-warning cc5"><span class="tip-icon tip-icon-warning"></span>友情提示：
	    <p class="pl15">1.可以查询的供应商为在“供应商合同关联”里面维护的供应商</p>
	    <p class="pl15">2.可查询的商品，为当前产品下，供应商关联的当前规格的所有商品</p>
	    <p class="pl15">3.可设置的为，有效的商品</p>
	  </div>
	  <div class="p_box">
		<form method="post" action='/vst_admin/lineMultiTraffic/goods/timePrice/findGoodsTimePriceList.do' id="searchForm">
			<input type="hidden" id="productId" value="${suppGoods.prodProduct.productId}" />
			<input type="hidden" id="supplierId" value="${suppGoods.suppSupplier.supplierId}" />
			<input type="hidden" id="supplierName" value="${suppGoods.suppSupplier.supplierName}" />
			<input type="hidden" id="categoryCode" value="${bizCategory.categoryCode}" />
			<input type="hidden" id="categoryId" value="${bizCategory.categoryId}" />
			<input type="hidden" id="suppGoodsId" />
			
	        <table class="s_table">
	            <tbody>
	            	<tr>          
	                    <td class="s_label">供应商:</td>
	                    <td >${suppGoods.suppSupplier.supplierName}</td>
	            	</tr>
	            </tbody>
	        </table>	
		</form>
	  </div>  
	  <div class="clearfix title">
		<h2 class="f16">商品销售信息查询</h2>
	  </div  
	  <form id="timePriceForm">
		  <div class="p_box box_info">
			<div class="p_box clearfix">
		 		<table class="e_table">
	 				<#if goodsList??>
		 				<#assign index=0>
		 				<#list goodsList as good>
		 					<#if index%5==0>
		 						<tr>
		 					</#if>
				 				<td>
				 					<label class="radio" style="color:${hasTimePriceMap[good.suppGoodsId+'']}">
				 					<input type="radio" name="timePriceList[0].suppGoodsId" value="${good.suppGoodsId}" data="${suppGoods.suppSupplier.supplierId}"  class="good" />
				 					<#if good.prodProductBranch.cancelFlag!='Y'><span style="color:red">[无效]</span></#if>${good.prodProductBranch.branchName}[${good.prodProductBranch.productBranchId}]-<#if good.cancelFlag!='Y'><span style="color:red">[无效]</span></#if>${good.goodsName}[${good.suppGoodsId}]<#if good.cancelFlag!='Y'><span class="poptip-mini poptip-mini-warning"><div class="tip-sharp tip-sharp-left"></div>-商品无效</span></#if></label>
				 				</td>
				 				<#assign index = index+1>
			 				<#if index%5==0||index==goodsList?size>
			 					</tr>
			 				</#if>
		 				</#list>
	 				</#if>
		 		</table>
			 </div>			 
			 <div class="p_box box_info">
	  			<div class="title clearfix">
			 		<div class="fl operate">
						<table>
							<tr>
								<td width=300">
						  			<div class="title clearfix">
									    <h2 class="f16 fl" id="timePriceArrowView" style="cursor:pointer">时间价格表</h2>
									    <div id="timePriceArrow" class="J_date_more date_more active"><span>收起</span><span style=" position:relative; top:8px; left:26px; float:left"><i class="ui-arrow-bottom blue-ui-arrow-bottom"></i></span></div>
						            </div>								
								</td>
					                <#if suppGoodsMap??> 
					                  <#assign index=0>
						                <#list suppGoodsMap?keys as testKey>
						                	<#assign suppGoodsList=suppGoodsMap[testKey] >          
								            <#if suppGoodsList?? && suppGoodsList?size &gt; 0> 
												<td><a class="btn btn_cc1" data="${testKey?substring(testKey?last_index_of("_")+1,testKey?length)}" id="batch_button">批量录入</a></td>
												<td><a class="btn btn_cc1" data="${testKey?substring(testKey?last_index_of("_")+1,testKey?length)}" id="update_settlementPrice_button">批量修改销售价</a></td>
												<td><a class="btn btn_cc1" data="${testKey?substring(testKey?last_index_of("_")+1,testKey?length)}" id="update_price_button">批量修改结算价</a></td>
												<td><a class="btn btn_cc1" data="${testKey?substring(testKey?last_index_of("_")+1,testKey?length)}" id="batch_lockup_button">批量禁售</a></td>	
												<#assign index = index+1>							            	
								            </#if>	
								        </#list>
								    </#if>	
								    <td>
								    	<a href="javascript:void(0);" style="margin-left:100px;" class="showLogDialog btn btn_cc1" param='objectId=${suppGoods.prodProduct.productId}&objectType=SUPP_GOODS_GOODS&sysName=VST'>操作日志</a>
								    </td>						
							</tr>
						</table>
			 		</div>
	            </div>
		 		<div id="timePriceDiv" class="time_price"></div>
			 </div>
		 </div>
	</form> 
	<#include "/base/foot.ftl"/>
	</body>
</html>
<script src="/vst_admin/js/pandora-calendar.js"></script>
<script>
		
		$('.J_tip').lvtip({
	                templete: 3,
	                place: 'bottom-left',
	                offsetX: 0,
	                events: "live" 
	         });
	
		var good = {};
		var specDate;
	
		$("#backToLastPageButton").click(function(){
			window.history.go(-1);
		});		
		
		//时间价格表的隐藏和显示
		$("#timePriceArrowView,#timePriceArrow").click(function(){
			var arrow = $("#timePriceArrow");
			if(arrow.is(".active")){
				arrow.removeClass("active");
				arrow.find("span").eq(0).html("展开");
				$("#timePriceDiv").show();
			}else {
				arrow.addClass("active");
				$("#timePriceDiv").hide();
				arrow.find("span").eq(0).html("关闭");
			}
		});
            
     	var template = {
            warp: '<div class="ui-calendar"></div>',
            calControl: '<span class="month-prev" {{stylePrev}} title="上一月">‹</span><span class="month-next" {{styleNext}} title="下一月">›</span>',
            calWarp: '<div class="calwarp clearfix">{{content}}</div>',
            calMonth: '<div class="calmonth">{{content}}</div>',
            calTitle: '<div class="caltitle"><span class="mtitle">{{month}}</span></div>',
            calBody: '<div class="calbox">' +
                        '<i class="monthbg">{{month}}</i>' +
                        '<table cellspacing="0" cellpadding="0" border="0" class="caltable">' +
                            '<thead>' +
                                '<tr>' +
                                    '<th class="sun">日</th>' +
                                    '<th class="mon">一</th>' +
                                    '<th class="tue">二</th>' +
                                    '<th class="wed">三</th>' +
                                    '<th class="thu">四</th>' +
                                    '<th class="fri">五</th>' +
                                    '<th class="sat">六</th>' +
                                '</tr>' +
                            '</thead>' +
                            '<tbody>' +
                                '{{date}}' +
                            '</tbody>' +
                        '</table>' +
                    '</div>',
            weekWarp: '<tr>{{week}}</tr>',
            day: '<td {{week}} {{dateMap}} >' +
                    '<div {{className}}>' +
                        '<span class="calday">{{day}}</span>' +
                        '<span class="calinfo"></span>' +
                        '<div class="fill_data"></div>' +
                    '</div>' +
                 '</td>'
        };
     
        //是否有权限查看结算价
        function isPermissionFn(permission){
              return "true" == permission;
            }
       	// 填充日历数据
        function fillData() {
            var that = this,
            url = "/vst_admin/lineMultiTraffic/goods/timePrice/findGoodsTimePriceList.do";
            var month = that.options.date.getMonth();
            var year = that.options.date.getFullYear();
            var day = that.options.date.getDate();
            specDate = year+"-"+(month+1)+"-"+day;
            function setData(data) {
                if (data === undefined) {
                    return;
                }
                data.forEach(function (arr) {
                    var isPermission = isPermissionFn(arr.permission);
                    var $td = that.warp.find("td[date-map=" + arr.specDateStr + "]");
                        html = "";
                    html = '<ul>'+
                                '<li><span class="cc3">售：</span>'+ (arr.price/100).toFixed(2) +(isPermission?' <span class="cc3">结：</span>'+(arr.settlementPrice/100).toFixed(2):'')+'</li>' +
                                '<li class="mb10"><span class="cc3">提前：</span>1天19时29分</li>' +
                            '</ul>';
                    var liArray = [];
                    //判断有无结/售数据
                    if(arr.auditPrice!=null || arr.auditSettlementPrice!=null){
                    	liArray.push('<li><span class="cc3">成人 售：</span>'+ (arr.auditPrice/100).toFixed(2) +(isPermission?' <span class="cc3">结：</span>'+(arr.auditSettlementPrice/100).toFixed(2):'')+'</li>');
                    }else {
                    	liArray.push('<li><span class="cc3">成人：</span>禁售</li>');
                    }  
                    if(arr.childPrice!=null || arr.childSettlementPrice!=null){
                    	liArray.push('<li><span class="cc3">儿童 售：</span>'+ (arr.childPrice/100).toFixed(2) +(isPermission?' <span class="cc3">结：</span>'+(arr.childSettlementPrice/100).toFixed(2):'')+'</li>');
                    } else {
                    	liArray.push('<li><span class="cc3">儿童：</span>禁售</li>');
                    } 
                     if(arr.bringPreSale=='Y'){
                         liArray.push('<li><span class="cc3">是否预售：</span>是 </li>' );
                          if(arr.auditIsBanSell=='Y'){
                            liArray.push('<li><span class="cc3">成人：</span>禁售</li>');
                          }else {
                        	liArray.push('<li><li><span class="cc3">成人价 结：</span>'+(arr.auditShowPreSale_pre/100).toFixed(2)+'</li>');
                          }
                          if(arr.childIsBanSell=='Y'){
                        	liArray.push('<li><span class="cc3">儿童：</span>禁售</li>');
                           }else {
                        	liArray.push('<li><span class="cc3">儿童价 结：</span>'+(arr.childShowPreSale_pre/100).toFixed(2)+'</li>');
                           }
                        }else{
                         liArray.push('<li><span class="cc3">是否预售：</span>否</li>');
                        }
                    if(arr.stockType!=null){
                    	var stockTypeName = arr.stockType == 'INQUIRE_NO_STOCK' ? '现询-未知库存' : arr.stockType == 'CONTROL' ? '确定日库存' :  arr.stockType == 'INQUIRE_WITH_STOCK' ? '现询库存' : '';
                    	if(arr.stockType=='CONTROL' || arr.stockType=='INQUIRE_WITH_STOCK'){
                    		var oversaleName  = arr.oversellFlag == 'Y' ? '可超卖' : '不可超卖';
                    		liArray.push('<li><span class="cc3">'+stockTypeName+'</span>         '+arr.stock+'   '+oversaleName+'</li>');
                    	}else {
                    		liArray.push('<li><span class="cc3">'+stockTypeName+'</span></li>');
                    	}
                    }
                    
                    //判断有无提前预定数据
                    if(arr.aheadBookTime!=null){
                    	var time = minutesToDate(parseInt(arr.aheadBookTime));
                    	liArray.push('<li class="mb10"><span class="cc3">提前预定时间：</span>'+time+'</li>');
                    }      
                 	
                 	//授权限制
                    if(arr.bookLimitType!=null){
                    	if(arr.bookLimitType=="NONE"){
	                        liArray.push('<li class="mb10"><span class="cc3">授权限制：</span>无限制</li>');
                		}else if(arr.bookLimitType=="PREAUTH"){
                			liArray.push('<li class="mb10"><span class="cc3">授权限制：</span>一律预授权</li>');
                		}else if(arr.bookLimitType=="NOT_PREAUTH"){
                    		liArray.push('<li class="mb10"><span class="cc3">授权限制：</span>不使用预授权</li>');
                    	}
                    }
                    
                    $td.find("div.fill_data").html("<ul>"+liArray.join('')+"</ul>");
                });
            }
            
            //将分钟数转换为天/时/分
            function minutesToDate(time){
            	var time = parseInt(time);
				var day=0;
				var hour=0;
				var minute=0;
				if(time >  0){
					day = Math.ceil(time/1440);
					if(time%1440==0){
						hour = 0;
						minute = 0;
					}else {
						hour = parseInt((1440 - time%1440)/60);
						minute = parseInt((1440 - time%1440)%60);
					}
					
				}else if(time < 0 ){
					time = -time;
					hour = parseInt(time/60);
					minute = parseInt(time%60);
				}
				if(hour<10)
					hour = "0"+hour;
				if(minute<10)
					minute = "0"+minute;
				return day+"天"+hour+"点"+minute+"分";
            }               
            $.ajax({
                url: url,
                type: "POST",
                dataType: "JSON",
                data : {suppGoodsId:good.goodsId,supplierId:good.supplierId,specDate:specDate,productId:good.productId},
                success: function (json) {
                   setData(json);
                },
                error: function () { }
            });

        }
         
        $("input[type=radio][class=good]").click(function () {
     		var goodsId = $(this).val();
			var supplierId = $(this).attr("data");
			good.goodsId = goodsId;
			good.supplierId = supplierId;
			good.productId = $('#productId').val();
			$('#suppGoodsId').val(goodsId);
            pandora.calendar({
                sourceFn: fillData,
                autoRender: true,
                frequent: true,
                showNext: true,
                mos :0,
                template: template,
                target: $("#timePriceDiv")
            });
        }); 
        
         //如果传入了商品ID，则选中该商品
     	$("input[type=radio][name=good][value=${suppGoods.suppGoodsId}]").click();
     	$("input[type=radio][name=good][value=${suppGoods.suppGoodsId}]").attr("checked","checked");
     	
     	//设置右上角的说明
     	$("#showTips").bind("mouseover",function(){
     		$("#tips").show();
     	}).bind("mouseout",function(){
     		$("#tips").hide();
     	});		
		
		var bacthButtonDialog,settlementPriceButtonDialog,priceButtonDialog,batchLockupButtonDialog,saveButtonDialog;
		//批量录入
        $("#batch_button").bind("click",function(i){
        	var branchId = $(this).attr('data');
        	var size = $("input[type=radio][class=good]:checked").size();
     		var str = '/vst_admin/lineMultiTraffic/goods/timePrice/showBatchSaveTrafficTimePrice.do?';
     		var url = connectUrl(str,branchId);
			bacthButtonDialog = new xDialog(url,{}, {title:"批量录入",width:900,height:800,iframe:true})
		});
		
		//批量修改销售价
        $("#update_settlementPrice_button").bind("click",function(i){
        	var branchId = $(this).attr('data');
        	var size = $("input[type=radio][class=good]:checked").size();
     		var str = '/vst_admin/lineMultiTraffic/goods/timePrice/showBatchSavePrice.do?';
     		var url = connectUrl(str,branchId);
			settlementPriceButtonDialog = new xDialog(url,{}, {title:"批量修改销售价",width:1000,height:800,iframe:true})
		});	
		
		//批量修改结算价
        $("#update_price_button").bind("click",function(i){
       	 	var branchId = $(this).attr('data');
        	var size = $("input[type=radio][class=good]:checked").size();
     		var str = '/vst_admin/lineMultiTraffic/goods/timePrice/showBatchSaveSellmentPrice.do?';
     		var url = connectUrl(str,branchId);
			priceButtonDialog = new xDialog(url,{}, {title:"批量修改结算价",width:900,height:800,iframe:true})
		});
		
		//批量禁售
        $("#batch_lockup_button").bind("click",function(i){
        	var branchId = $(this).attr('data');
        	var size = $("input[type=radio][class=good]:checked").size();
     		var str = '/vst_admin/lineMultiTraffic/goods/timePrice/showBatchSuppGoodsLockUp.do?';
     		var url = connectUrl(str,branchId);
			batchLockupButtonDialog = new xDialog(url,{}, {title:"批量禁售",width:900,height:800,iframe:true})
		});	
		
		// 单个产品录入
		$('.caltable td').live('click',function(){
        	var branchId = $('#batch_button').attr('data');
			var date = $(this).attr('date-map');
			if(!checkEndTime(date)){
				if(date!='undefined' && date!=null){
		     		var str = '/vst_admin/lineMultiTraffic/goods/timePrice/showSaveTrafficTimePrice.do?';
		     		var url = connectUrl(str,branchId);
					saveButtonDialog = new xDialog(url+'&spec_date='+date,{}, {title:"单个产品录入",width:900,height:800,iframe:true})		
				}
			}
		});		
		
		function checkEndTime(startTime){  
		    var start=new Date(startTime.replace("-", "/").replace("-", "/"));  
		    var end=new Date();
			var year = end.getFullYear();       //年
        	var month = end.getMonth() + 1;     //月
        	var day = end.getDate();
        	var endTime = year+'-'+month+'-'+day;
        	var endDate = new Date(endTime.replace("-", "/").replace("-", "/"));  		    
		    if(endDate<=start){  
		        return false;  
		    }  
	    	return true;  
		}		
		
		function connectUrl(str,branchId){
        	var productId = $('#productId').val();
        	var supplierId = $('#supplierId').val();
        	var supplierName = $('#supplierName').val();
        	var categoryId = $('#categoryId').val();
        	var categoryCode = $('#categoryCode').val();
     		var suppGoodsId = $('#suppGoodsId').val();
			
			var url = str+'prodProduct.productId='+productId+'&prodProductBranch.bizBranch.branchId='
     		+branchId+'&suppSupplier.supplierId='+supplierId+'&suppSupplier.supplierName='
     		+supplierName+'&bizCategory.categoryId='+categoryId+'&bizCategory.categoryCode='+categoryCode;
     		return url;
		}			
		
		function search(){
			$("input[type=radio][class=good]:checked").click();
		}	
		
</script>
