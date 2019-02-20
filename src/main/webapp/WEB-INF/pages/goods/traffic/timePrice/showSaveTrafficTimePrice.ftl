<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="/vst_admin/css/lineMultiRoute.css" type="text/css"/>
<link rel="stylesheet" href="/vst_admin/css/lineMultiRouteAdd.css" type="text/css"/>
<link href="http://pic.lvmama.com/min/index.php?f=/styles/v5/modules/calendar.css " rel="stylesheet" />
<script src="/vst_admin/js/jquery-1.7.2.min.js" type="text/javascript"></script>
<script type="text/javascript" src="/vst_admin/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.validate.expand.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_validate.js"></script>
<script src="http://pic.lvmama.com/min/index.php?f=/js/v6/modules/pandora-calendar.js" type="text/javascript"></script>
<script src="/vst_admin/js/js.js" type="text/javascript"></script>
<script type="text/javascript" src="/vst_admin/js/messages_zh.js"></script>

<style>
	.calmonth .caldate, .calmonth .nodate{
		min-height:0px;
	}
	
	.left{
		float:left;
	}
	.right{
		float:left;
		margin-left:20px;
	}
	.clear{
		clear:both;
	}
	#selDate{
		width:120px;
		height:220px;
		margin-bottom:10px;
	}
	.calSelected{
		background: none repeat scroll 0 0 #FF77BB;
		box-shadow: 2px 2px 10px -7px #666666 inset;
		color: #FFFFFF;
	}	

</style>

</head>
<body>
	<div class="nfadd_dialog">
		<a href="javascript:;" class="nfadd_close"></a>
		<form id="timePriceForm">
			<div class="nfadd_dialogB">
				<ul class="nfadd_List">
					<li>
						<div class="nfadd_div">
						    <div class="right">
						    	<div>出发日期: ${spec_date}</div>
						    	<input type="hidden" value="${spec_date}" id="spec_date"/>
						    </div>
						</div>
					</li>
					<li>
		 				<#if goodsList??>
		 					<div class="nfadd_div nfadd_title">
				 				<#list goodsList as good>
				 					<label class="radio">
				 						<input type="checkbox" name="suppGoodsId" value="${good.suppGoodsId}" data_name="${good.goodsName}" goodbu="${good.bu}" data="${suppGoods.suppSupplier.supplierId}"  class="good adult_child" /><#if good.prodProductBranch.cancelFlag!='Y'><span style="color:red">[无效]</span></#if>${good.prodProductBranch.branchName}[${good.prodProductBranch.productBranchId}]-<#if good.cancelFlag!='Y'><span style="color:red">[无效]</span></#if>${good.goodsName}[${good.suppGoodsId}]<#if good.cancelFlag!='Y'><span class="poptip-mini poptip-mini-warning"><div class="tip-sharp tip-sharp-left"></div>-商品无效</span></#if>
				 					</label>
				 				</#list>
			 				</div>
		 				</#if>	 				
					</li>
					<li>
						<div class="nfadd_div nfadd_title" style="width:200px;">设置价格：</div>
						<div id="adult_child_price"></div>
						<div id="addition_price"></div>
						<div id="upgrade_price"></div>
						<div id="change_price"></div>
					</li>
					<li>
						<div class="nfadd_div nfadd_title">设置库存：</div>
				        <div id="adult_child_stock"></div>
						<div id="addition_stock"></div>
						<div id="upgrade_stock"></div>
						<div id="change_stock"></div>					
					</li>
					<li>
						<div class="nfadd_div nfadd_title">设置提前预定时间：</div>
				        <div id="adult_child_time"></div>
						<div id="addition_time"></div>
						<div id="upgrade_time"></div>
						<div id="change_time"></div>					
					</li>
					<li>
						<div class="nfadd_div nfadd_title">设置预售：</div>
				        <div id="adult_child_preSale"></div>
					</li>
				</ul>
			</div>
			<div style="display:none" id="timePriceFormContent"></div>
		</form>
		<div class="fl operate">
			<a href="javascript:;" class="btn btn_cc" id="timePriceSaveButton">保&emsp;存</a>
			<a href="javascript:;" class="btn btn_cc" id="timePriceCancelButton">取&emsp;消</a>
		</div>
	</div>
	<div id="templateDiv" style="display:none">
		 <!-- 多价格价格 --> 
		<div id="multiple_price_template">
			<table align="center" class="e_table form-inline" goodsid="">
	             <tbody>       
					<tr>
						<td width="100" style="text-align:right;"><span>{{}}&nbsp;成人&nbsp;</span></td>
						<td>结算价：<input type="text" max="999999999" id="auditSettlementPrice{index}" name="auditSettlementPrice{index}" class="adult" data="auditSettlementPrice"></td>
						<td>销售价：<input type="text" max="999999999" id="auditPrice{index}" name="auditPrice{index}" class="adult" data="auditPrice"></td>
						<td width="200"><input type="checkbox" id="adult{index}" class="saleAble" name="adult">禁售</td>
					</tr>
					<tr>
						<td style="text-align:right;"><span>&nbsp;儿童&nbsp;</span></td>
						<td>结算价：<input type="text" max="999999999" id="childSettlementPrice{index}" name="childSettlementPrice{index}" class="child" data="childSettlementPrice"></td>
						<td>销售价：<input type="text" max="999999999" id="childPrice{index}" name="childPrice{index}" class="child" data="childPrice"></td>
						<td><input type="checkbox" class="saleAble" id="child{index}" name="child">禁售</td>
					</tr>
	            </tbody>
	       </table>
		</div>
	       
	    <!-- 多价格库存 --> 
	    <#if prodProduct??&&prodProduct.bizCategoryId==25>
	      <!-- 多价格库存 --> 
	   	 <div id="multiple_stock_template">
       		<table class="e_table form-inline" goodsId="">
       		   <input type="hidden"  id="categoryId" name="categoryId" value="${prodProduct.bizCategoryId}">
	             <tbody>
	               <tr><td colspan="4">{{}}</td></tr>
					<tr>
						<td width="50"></td>
						<td></td>
						<td >
						        是否限制日库存：<!--<label> <input type="radio" class="typeSelect"  name="stockType"  value="INQUIRE_NO_STOCK">不限制日库存</label>  -->
						 
							<label><input type="radio" id="CONTROL{index}" class="typeSelect" name="stockType" value="CONTROL"  checked="checked" />限制日库存</label>
							<input type="text" maxlength="11" class="nfadd_middText" id="CONTROL_{index}" name="stockIncrease1_{index}" >
						 </td><td>
						     是否可超卖&emsp;
							<select class="w10" name="oversellFlag{index}" >
		                  <!--   	<option value="Y">是</option>  -->
		                     	<option value="N">否</option>
			                </select>
						</td>	
					</tr>
				 
	             </tbody>
            </table> 
        </div>  
	  <#else>
	   	 <div id="multiple_stock_template">
       		<table class="e_table form-inline" goodsId="">
	             <tbody>
					<tr>
						<td width="50"></td>
						<td>{{}}</td>
						<td width="200">
							<label><input type="radio" class="typeSelect"  name="stockType" checked="checked" value="INQUIRE_NO_STOCK">现询-未知库存</label>
						</td>
						<td></td>
					</tr>
					<tr>
						<td width="50"></td>
						<td></td>
						<td>
							<label>
								<input type="radio" class="typeSelect" id="INQUIRE_WITH_STOCK{index}" name="stockType" value="INQUIRE_WITH_STOCK">现询日库存
							</label>
							<input type="text" maxlength="11" class="nfadd_middText" id="INQUIRE_WITH_STOC_{index}" name="stockIncrease_{index}" name="stockIncrease_{index}" disabled=disabled>
						</td>
						<td>是否可超卖&emsp;
							<select class="w10" name="oversellFlag{index}" disabled=disabled>
		                    	<option value="Y">可超卖</option>
		                    	<option value="N">不可超卖</option>
			                </select>
						</td>					
					</tr>
					<tr>
						<td width="50"></td>
						<td></td>					
						<td>
							<label><input type="radio" id="CONTROL{index}" class="typeSelect" name="stockType" value="CONTROL"/>确定日库存</label>
							<input type="text" maxlength="11" class="nfadd_middText" id="CONTROL_{index}" name="stockIncrease1_{index}" disabled=disabled>
						</td>
						<td>是否可超卖&emsp;
							<select class="w10" name="oversellFlag{index}" disabled=disabled>
		                    	<option value="Y">可超卖</option>
		                    	<option value="N">不可超卖</option>
			                </select>
						</td>	
					</tr>
	             </tbody>
            </table> 
        </div>  
	 </#if>         
        <!-- 提前预定时间 -->  
        <div id="ahead_time_template">
			<table class="e_table form-inline" goodsId="">
	             <tbody>
	             	<tr><td colspan="2">{{}}</td></tr>
	             	<tr>
	                    <td width="150" class="e_label">提前预定时间：</td>
	                    <td>
	                    	<input type="hidden" name="aheadBookTime{index}" id="aheadBookTime"/>
	                    	<select class="w10 mr10" name="aheadBookTime_day" id="aheadBookTime_day{index}">
			                      <#list 0..50 as i>
			                      <option value="${i}">${i}</option>
			                      </#list>
			                </select>天
			                <select class="w10 mr10" name="aheadBookTime_hour" id="aheadBookTime_hour{index}">
			                      <#list 0..23 as i>
			                      <option value="${i}" <#if i==10>selected=selected</#if> >${i}</option>
			                      </#list>
			                </select>点
			                <select class="w10 mr10" name="aheadBookTime_minute" id="aheadBookTime_minute{index}">
			                      <#list 0..59 as i>
			                      <option value="${i}">${i}</option>
			                      </#list>
			                </select>分
	                    </td>
	                </tr>
	                <tr >
	                    <td class="e_label">预付预授权限制：</td>
	                     <td>
		                    <select class="w10" name="bookLimitType" id="bookLimitType{index}">
		                    	<option value="NONE">无限制</option>
		                    	<option value="PREAUTH">一律预授权</option>
		                    	<option value="NOT_PREAUTH">不使用预授权</option>
		                    </select>
	                    </td>
	                </tr>	                
	            </tbody>
	        </table>		       
	    </div>
	<!--预售设置 --->
	     <div id="multiple_preSale_template">
			<table align="center" class="e_table form-inline" goodsid="">
	             <tbody>
	                <tr>
						<td width="80">{{}}</td>
						<td width="100" style="text-align:left;">是否可预售：<td>
						<td>
							<label><input type="radio" goodsId='{isInput}'  name="bringPreSale{isInput}" onchange='isPreSale($(this),{isInput})' value="Y">是</label>
							<label><input type="radio" goodsId='{isInput}'  name="bringPreSale{isInput}" onchange='isPreSale($(this),{isInput})' checked="checked" value="N">否</label>
						</td>
 	                </tr>       
					<tr id="isPreSaleTr{isInput}" name="isPreSaleTr{isInput}" style="display:none">
						<td></td>
						<td>成人结算价：<td>
						<td><input type="text" max="999999999" name="auditShowPreSale_pre{isInput}" class="adult{isInput}" data="auditShowPreSale_pre"></td>
					</tr>
					<tr id="isPreSaleTr{isInput}" name="isPreSaleTr{isInput}" style="display:none">
					    <td></td>
						<td>儿童结算价：<td>
						<td><input type="text" max="999999999" name="childShowPreSale_pre{isInput}" class="child{isInput}" data="childShowPreSale_pre"></td>
					</tr>
	            </tbody>
	       </table>
		</div>
	
	<div>	
</body>
</html>
<script>

	<#if categoryCode=='category_route_hotelcomb'>
		//将无效的隐藏
		$("label[cancelFlag='Y']").hide();
	</#if>

	var globalIndex = 0;
	
    //设置week选择,全选
	$("input[type=checkbox][name=weekDayAll]").click(function(){
		if($(this).attr("checked")=="checked"){
			$("input[type=checkbox][name=weekDay]").attr("checked","checked");
		}else {
			$("input[type=checkbox][name=weekDay]").removeAttr("checked");
		}
	})
	
	 //设置week选择,单个元素选择
	$("input[type=checkbox][name=weekDay]").click(function(){
		if($("input[type=checkbox][name=weekDay]").size()==$("input[type=checkbox][name=weekDay]:checked").size()){
			$("input[type=checkbox][name=weekDayAll]").attr("checked","checked");
		}else {
			$("input[type=checkbox][name=weekDayAll]").removeAttr("checked");
		}
	});	
	
	//为禁售绑定事件
	$(".saleAble").live('click',function(){
		var that = $(this);
		var claszz = that.attr("name");
		var goodsId= that.parents("div.priceDiv").attr("goodsId");
		$(this).parents("tr").find("input").each(function(){
			if(that.attr("checked")!='checked'){
				if($(this).is("."+claszz)){
					$(this).removeAttr("disabled");
				}
			 $("#adult_child_preSale").find("div.preSaleDiv").find("input."+claszz+goodsId).removeAttr("disabled");
			}else {
				if($(this).is("."+claszz)){
					$(this).attr("disabled","disabled");
					$(this).val('');
				}
			$("#adult_child_preSale").find("div.preSaleDiv").find("input."+claszz+goodsId).attr("disabled","disabled");
			$("#adult_child_preSale").find("div.preSaleDiv").find("input."+claszz+goodsId).val(""); 
			}
		});
	});	
	
	//设置价格表单数据
	function setPriceFormData(){
		$(".priceDiv").each(function(i){
	    	var that = $(this);
	    	//创建商品Id
	    	$("#timePriceForm").append('<input type="hidden" name="timePriceList['+i+'].suppGoodsId" value="'+that.attr("goodsId")+'">');
	    	that.find("input").each(function(){
	    		var clone = $(this).clone();
	    		var name = clone.attr("data");
	    		clone.attr("name","timePriceList["+i+"]."+name);
	    		if(clone.val()!=""){
		    		var clonevalue = clone.val();
		    		var start = clonevalue.lastIndexOf(".");
		    		var len = clonevalue.length-1;
		    		var decimallen = len - start; 
		    		//parseInt精度有问题0.1变0.099
		    		if(clonevalue.indexOf(".") == -1){
		    			clone.val(parseInt(clone.val()*100,0));
		    		}else if(decimallen == 1){
		    			clone.val(clone.val().replace(".","")+"0");
		    		}else if(decimallen == 2){
		    			clone.val(clone.val().replace(".",""));
		    		}
		    		clone.removeAttr('disabled');
		    		$("#timePriceFormContent").append(clone);
	    		}
	    	});
	    });
	}		
	
	//设置选择日期数据
	function setSelectDate(){
		$("#timePriceFormContent").append('<input type="hidden" name="selectCalendar" value="selectDate">');
		var selectCalendar = $('#spec_date').val();
		$("#timePriceFormContent").append('<input type="hidden" name="selectDates" value="'+selectCalendar+'">');
	}
	
	//设置库存表单数据
	function setStockFormData(){
	
	
	var categoryId=$("#categoryId").val();

	if(categoryId==25){
	  $(".stockDiv").each(function(i){
	    var that = $(this);
	    	that.find("input[type=radio][name='onsaleFlag"+i+"']").each(function(){
	    	     if($(this).attr("checked")=='checked'){
	    	        var clone = $(this).clone();
    				clone.attr("name","timePriceList["+i+"].onsaleFlag");
    			    clone.val($(this).val());
    			    $("#timePriceFormContent").append(clone);
	    	     }
	    	});
	  });
	}

	
	   $(".stockDiv").each(function(i){
	    	var that = $(this);
	    	that.find("input[type=radio][class=typeSelect]").each(function(){
	    		if($(this).attr("checked")=='checked'){
	    			var value = $(this).val();
	    			var clone = $(this).clone();
    				clone.attr("name","timePriceList["+i+"].stockType");
    			
    				$("#timePriceFormContent").append(clone);
	    			//如果是现询-已知库存	或者是切位库存
	    			if(value=='INQUIRE_WITH_STOCK' || value=='CONTROL'){
	    				var stockInput = $(this).closest("tr").find("td").eq(2).find("input[type=text]");
	    				//获得库存input
	    				var clone1 = stockInput.clone();
	    				//获得库存的类型
	    				clone1.attr("name","timePriceList["+i+"].stock");
	    				clone1.val(stockInput.val());
	    				clone1.attr("type","hidden");
    					$("#timePriceForm").append(clone1);
    					var obj2 = $(this).closest("tr").find("td").eq(3).find("select");
    					var clone2 = obj2.clone();
	    				clone2.attr("name","timePriceList["+i+"].oversellFlag");
	    				clone2.val(obj2.val());
	    				clone2.removeAttr('disabled');
    					$("#timePriceFormContent").append(clone2);
	    			}
	    		}
	    	});
	    });
	 }	
	 
	//设置提前预定时间表单数据
	function setAheadBookTimeFormData(){
		$(".timeDiv").each(function(i){
		    var that = $(this);
		    //把提前预定时间转换为分钟数	
			var day = parseInt(that.find("select[name=aheadBookTime_day]").val());
			var hour = parseInt(that.find("select[name=aheadBookTime_hour]").val());
			var minute = parseInt(that.find("select[name=aheadBookTime_minute]").val());
		    $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].aheadBookTime" value="'+(day*24*60-hour*60-minute)+'">');	
	    });
	}
	
	//设置授权限制数据
	function setBookLimitTypeFormData(){
		$(".timeDiv").each(function(i){
		    var that = $(this);
		    //把提前预定时间转换为分钟数	
			var bookLimitType = that.find("select[name=bookLimitType]").val();
		    $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].bookLimitType" value="'+bookLimitType+'">');	
	    });
	}	 
	
	function setPreSaleFormData(){
	   $("#adult_child_preSale").find("div.preSaleDiv").each(function(i){
	       var that = $(this);
		    if($.trim(that.html())!=''){
			    var bringPreSale = that.find("[type=radio]:checked").val();
		   		 $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].bringPreSale" value="'+bringPreSale+'">');
		   		 var auditShowPreSale_pre = that.find("input[name='auditShowPreSale_pre"+that.attr("goodsId")+"']").val()*100;
		   		 $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].auditShowPreSale_pre" value="'+auditShowPreSale_pre+'">');
		   		var childShowPreSale_pre = that.find("input[name='childShowPreSale_pre"+that.attr("goodsId")+"']").val()*100;
		   		 $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].childShowPreSale_pre" value="'+childShowPreSale_pre+'">');
		   		  if(that.find("input[name='auditShowPreSale_pre"+that.attr("goodsId")+"']").prop("disabled")){
		   		   $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].auditIsBanSell" value="Y">');
		   		 }else{
		   		  $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].auditIsBanSell" value="N">');
		   		 }
		   		 if(that.find("input[name='childShowPreSale_pre"+that.attr("goodsId")+"']").prop("disabled")){
		   		   $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].childIsBanSell" value="Y">');
		   		 }else{
		   		  $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].childIsBanSell" value="N">');
		   		 }
			}    
	   });
	} 
	//设置选项
	function setTimeUpdateType(){
		if($("#isSetPrice").attr("checked")=="checked"){
	    	$("input[name=isSetPrice]").val("Y");
	    }else {
	    	$("input[name=isSetPrice]").val("N");
	    }
	    if($("#isSetStock").attr("checked")=="checked"){
	    	$("input[name=isSetStock]").val("Y");
	    }else {
	    	$("input[name=isSetStock]").val("N");
	    }
	    if($("#isSetAheadBookTime").attr("checked")=="checked"){
	    	$("input[name=isSetAheadBookTime]").val("Y");
	    }else {
	    	$("input[name=isSetAheadBookTime]").val("N");
	    }
	}
	
	//删除模板
	function deleteTemplate(goodsId){
		$("div[goodsid="+goodsId+"]").remove();
	}	
	
	//商品点击事件
	$(".adult_child").click(function(){
		var that = $(this);
		var name = that.attr("data_name");
		var priceType = that.attr("data_price_type");
		var goodsId = that.val();
		//首先判断是选中还是取消
		if(that.attr("checked")!='checked'){
			//如果是取消，则执行删除模板操作
			deleteTemplate(goodsId);
			return;
		}
		
		//设置价格模板
		var priceTemplate = '<div goodsId='+goodsId+' class="priceDiv">'+ $("#multiple_price_template").html()+'</div>';
		//为模板设置商品名称
		priceTemplate = priceTemplate.replace(/{{}}/g,name);
		priceTemplate = priceTemplate.replace(/{index}/g,globalIndex);
		
		//设置库存模板
		var stockTemplate = '';
		stockTemplate = '<div goodsId='+goodsId+' class="stockDiv">'+ $("#multiple_stock_template").html()+'</div>';
		//为模板设置商品名称
		stockTemplate = stockTemplate.replace(/{{}}/g,name);
		//修改模板radio name(防止冲突)
		stockTemplate = stockTemplate.replace(/stockType/g,'stockType'+globalIndex);
		//修改库存name
		stockTemplate = stockTemplate.replace(/{index}/g,globalIndex);
		
		//设置提前预定时间模板
		var aheadBookTimeTemplate = '';
		aheadBookTimeTemplate = '<div goodsId='+goodsId+' class="timeDiv">'+ $("#ahead_time_template").html()+'</div>';
		//为模板设置商品名称
		aheadBookTimeTemplate = aheadBookTimeTemplate.replace(/{{}}/g,name);
		aheadBookTimeTemplate = aheadBookTimeTemplate.replace(/{index}/g,globalIndex);
		//设置预售模板
		var preSaleTemplate='<div goodsId='+goodsId+' class="preSaleDiv">'+ $("#multiple_preSale_template").html()+'</div>';
		preSaleTemplate = preSaleTemplate.replace(/{isInput}/g,goodsId);
		preSaleTemplate = preSaleTemplate.replace(/{{}}/g,name);
		//如果是成人儿童房差
		if(that.is(".adult_child")){
		 //设置模板
			setAdultChildTemplate(goodsId,priceTemplate,stockTemplate,aheadBookTimeTemplate,preSaleTemplate);
		//如果是	套餐
		}else if(that.is(".comb_hotel")){
			setAdultChildTemplate(goodsId,priceTemplate,stockTemplate,aheadBookTimeTemplate);
		//如果是附加
		}else if(that.is(".addition")){
			setAdditionTemplate(goodsId,priceTemplate,stockTemplate,aheadBookTimeTemplate);
		//如果是升级
		}else if(that.is(".upgrade")){
			setUpgradeTemplate(goodsId,priceTemplate,stockTemplate,aheadBookTimeTemplate);
		//如果是可换酒店
		}else if(that.is(".change_hotel")){
			setChangeTemplate(goodsId,priceTemplate,stockTemplate,aheadBookTimeTemplate);
		}
		
		if(that.attr("checked")=='checked'){
			// 设置商品信息
			searchSuppGoodsInfo(goodsId);
		}	
		
		//预付预授权限制 默认值
		var goodsbu = that.attr("goodbu");
		if("LOCAL_BU"==goodsbu){
		   $(".form-inline #bookLimitType"+globalIndex).val("NOT_PREAUTH");
		}
			
	});	
	
	//根据商品获取其价格、库存、提前预定时间等信息
	function searchSuppGoodsInfo(goodsId){
		var spec_date = $('#spec_date').val();
		url = "/vst_admin/lineMultiroute/goods/timePrice/findSuppGoodsInfoByIdAndSpecDate.do";
		$.ajax({
	        url: url,
	        type: "POST",
	        dataType: "JSON",
	        data : {'suppGoodsId':goodsId,'specDate':spec_date},
	        success: function (json) {
	           setData(json);
	        },error: function () {}
   		});		
		
		function setData(data){
			data.forEach(function (arr) {
				// 设置成人价格
				var auditSettlementPrice = arr.auditSettlementPrice;
				var auditPrice = arr.auditPrice;		
				if(auditPrice==null){
					$('#adult'+globalIndex).attr('checked',true);
					$('#auditSettlementPrice'+globalIndex).attr("disabled","disabled");
					$('#auditPrice'+globalIndex).attr("disabled","disabled");
					$("#adult_child_preSale").find("input[name='auditShowPreSale_pre"+goodsId+"']").attr("disabled","disabled");
				}else{
					$('#auditPrice'+globalIndex).removeAttr('disabled');
					$('#auditSettlementPrice'+globalIndex).removeAttr('disabled');
					$('#adult'+globalIndex).removeAttr('checked');
					$('#auditSettlementPrice'+globalIndex).val((auditSettlementPrice/100).toFixed(2));
					$('#auditPrice'+globalIndex).val((auditPrice/100).toFixed(2));	
					$("#adult_child_preSale").find("input[name='auditShowPreSale_pre"+goodsId+"']").removeAttr('disabled');				
				}
				
				// 设置儿童价格
				var childSettlementPrice = arr.childSettlementPrice;
				var childPrice = arr.childPrice;	
				if(childPrice==null){
					$('#child'+globalIndex).attr('checked',true);
					$('#childSettlementPrice'+globalIndex).attr("disabled","disabled");
					$('#childPrice'+globalIndex).attr("disabled","disabled");
					$("#adult_child_preSale").find("input[name='childShowPreSale_pre"+goodsId+"']").attr("disabled","disabled");		
				}else{
					$('#childPrice'+globalIndex).removeAttr('disabled');
					$('#childSettlementPrice'+globalIndex).removeAttr('disabled');
					$('#child'+globalIndex).removeAttr('checked');
					$('#childSettlementPrice'+globalIndex).val((childSettlementPrice/100).toFixed(2));
					$('#childPrice'+globalIndex).val((childPrice/100).toFixed(2));
					$("#adult_child_preSale").find("input[name='childShowPreSale_pre"+goodsId+"']").removeAttr('disabled');	
				}
				
				//是否可售
				var onsaleFlag=arr.onsaleFlag
				//$('#'+onsaleFlag+globalIndex).attr('checked','true');
			
				$("#adult_child_stock").find("input[name='onsaleFlag"+globalIndex+"'][data='"+onsaleFlag+globalIndex+"']").attr('checked','true');
				
				
				// 设置库存
				var stockType = arr.stockType;
				var stock = arr.stock;
				var oversell_flag = arr.oversellFlag;
				$('#'+stockType+globalIndex).attr('checked','true');
				if(stockType=='INQUIRE_WITH_STOCK'){
					var obj = $('#INQUIRE_WITH_STOC_'+globalIndex);
					obj.removeAttr('disabled');
					obj.val(stock);
					// 设置是否超卖
					obj.parents('tr').find('select [value='+oversell_flag+']').attr('selected','selected');
					obj.parents('tr').find('select').removeAttr('disabled');
				}else if(stockType=='CONTROL'){
					var obj = $('#CONTROL_'+globalIndex);
					obj.removeAttr('disabled');
					obj.val(stock);
					// 设置是否超卖
					obj.parents('tr').find('select [value='+oversell_flag+']').attr('selected','selected');
					obj.parents('tr').find('select').removeAttr('disabled');
				}
				// 设置提前预定时间
				var aheadBookTime = arr.aheadBookTime;
				var bookLimitType = arr.bookLimitType;
				minutesToDate(aheadBookTime,bookLimitType);
				//设置预售
				var bringPreSale=arr.bringPreSale;
				if(bringPreSale=='Y'){
				$("#adult_child_preSale").find("input[type='radio'][goodsid='"+goodsId+"']").eq(0).attr('checked','checked');
				$("#adult_child_preSale").find("tr[name='isPreSaleTr"+goodsId+"']").show();
				$("#adult_child_preSale").find("input[name='auditShowPreSale_pre"+goodsId+"']").val(arr.auditShowPreSale_pre/100==0?'':(arr.auditShowPreSale_pre/100).toFixed(2));
				$("#adult_child_preSale").find("input[name='childShowPreSale_pre"+goodsId+"']").val(arr.childShowPreSale_pre/100==0?'':(arr.childShowPreSale_pre/100).toFixed(2));
				if(arr.auditIsBanSell=='Y'){
				$("#adult_child_preSale").find("input[name='auditShowPreSale_pre"+goodsId+"']").attr("disabled","disabled")
				}
				if(arr.childIsBanSell=='Y'){
				$("#adult_child_preSale").find("input[name='childShowPreSale_pre"+goodsId+"']").attr("disabled","disabled")
				}
				}else{
				$("#adult_child_preSale").find("input[type='radio'][goodsid='"+goodsId+"']").eq(1).attr('checked','checked');
				$("#adult_child_preSale").find("tr[name='isPreSaleTr"+goodsId+"']").hide();
				}
			});
			
			globalIndex++;
		}
		//将分钟数转换为天/时/分
        function minutesToDate(time,bookLimitType){
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
			$('#aheadBookTime_day'+globalIndex).find("option[value='"+day+"']").attr("selected",true);
			$('#aheadBookTime_hour'+globalIndex).find("option[value='"+hour+"']").attr("selected",true);
			$('#aheadBookTime_minute'+globalIndex).find("option[value='"+minute+"']").attr("selected",true);
			$('#bookLimitType'+globalIndex).find("option[value='"+bookLimitType+"']").attr("selected",true);
        }			
	}	
	
	//设置成人儿童模板
	function setAdultChildTemplate(goodsId,priceTemplate,stockTemplate,aheadBookTimeTemplate,preSaleTemplate){
		//设置价格模板
		var size = $("#adult_child_price").find("div[goodsId="+goodsId+"]").size();
		if(size == 0){
			$("#adult_child_price").append(priceTemplate);
		}
		//设置库存模板
		var stockSize = $("#adult_child_stock").find("div[goodsId="+goodsId+"]").size();
		if(stockSize == 0){
			$("#adult_child_stock").append(stockTemplate);
		}
		//设置提前预定时间模板
		var timeSize = $("#adult_child_time").find("div[goodsId="+goodsId+"]").size();
		if(stockSize == 0){
			$("#adult_child_time").append(aheadBookTimeTemplate);
		}
		var preSaleSize=$("#adult_child_preSale").find("div[goodsId="+goodsId+"]").size();
		if(stockSize == 0){
			$("#adult_child_preSale").append(preSaleTemplate);
		}
	}
	
	//设置升级
	function setUpgradeTemplate(goodsId,priceTemplate,stockTemplate,aheadBookTimeTemplate){
		//设置价格模板
		var size = $("#upgrade_price").find("div[goodsId="+goodsId+"]").size();
		if(size == 0){
			$("#upgrade_price").append(priceTemplate);
		}
		//设置库存模板
		var stockSize = $("#upgrade_stock").find("div[goodsId="+goodsId+"]").size();
		if(stockSize == 0){
			$("#upgrade_stock").append(stockTemplate);
		}
		//设置提前预定时间模板
		var timeSize = $("#upgrade_time").find("div[goodsId="+goodsId+"]").size();
		if(stockSize == 0){
			$("#upgrade_time").append(aheadBookTimeTemplate);
		}
	}
	
	//设置可换
	function setChangeTemplate(goodsId,priceTemplate,stockTemplate,aheadBookTimeTemplate){
		//设置价格模板
		var size = $("#change_price").find("div[goodsId="+goodsId+"]").size();
		if(size == 0){
			$("#change_price").append(priceTemplate);
		}
		//设置库存模板
		var stockSize = $("#change_stock").find("div[goodsId="+goodsId+"]").size();
		if(stockSize == 0){
			$("#change_stock").append(stockTemplate);
		}
		//设置提前预定时间模板
		var timeSize = $("#change_time").find("div[goodsId="+goodsId+"]").size();
		if(stockSize == 0){
			$("#change_time").append(aheadBookTimeTemplate);
		}
	}
	
	//设置附加模板
	function setAdditionTemplate(goodsId,priceTemplate,stockTemplate,aheadBookTimeTemplate){
		//设置价格模板
		var size = $("#addition_price").find("div[goodsId="+goodsId+"]").size();
		if(size == 0){
			$("#addition_price").append(priceTemplate);
		}
		//设置库存模板
		var stockSize = $("#addition_stock").find("div[goodsId="+goodsId+"]").size();
		if(stockSize == 0){
			$("#addition_stock").append(stockTemplate);
		}
		//设置提前预定时间模板
		var timeSize = $("#addition_time").find("div[goodsId="+goodsId+"]").size();
		if(stockSize == 0){
			$("#addition_time").append(aheadBookTimeTemplate);
		}
	}
	
	$(".typeSelect").live('click',function(){
		var that = $(this);
		//首先将其他所有的置为disabled
		$(this).parents("table").find("input[type=text],select").attr("disabled","disabled");
		if(that.val()=='INQUIRE_WITH_STOCK' || that.val()=='CONTROL'){
			$(this).parents("tr").find("input[type=text],select").removeAttr("disabled");
		}
	});	
	
	//设置验证子项
	function setIsOrNotValidate(){
		//价格
    	$("#adult_child_price,#upgrade_price").find("input[type=text]").each(function(){
    		if($(this).attr("notnumber")!="Y"){
				$(this).rules("add",{required : true, number : true,isNum:true , min : 0,messages : {min:'价格必须大于等于0',isNum:'价格格式不正确(填至多2位小数正数)'}});
    		}
    	});
    	
    	//自备签
    	$("#addition_price").find("input[type=text]").each(function(){
            if($(this).attr("notnumber")!="Y"){
            	if($(this).closest("tbody").find("td:first").text()==="自备签"){
            		$(this).rules("add",{required : true, number : true});
            	}else{
            		$(this).rules("add",{required : true, number : true, isNum:true, min : 0,messages : {min:'价格必须大于等于0',isNum:'价格格式不正确(填至多2位小数正数)'}});
            	}
            }
        });
	   
	    //库存
    	$(".stockDiv").find("input[type=radio]:checked").each(function(){
    		var size = $(this).parents('tr').find('input[type=text]').size();
    		if(size>0){
    			$(this).parents('tr').find('input[type=text]').rules("add",{required : true,isIntegerWith0:true ,min:0,messages : {min:'库存必须为大于等于0的整数'}});
    		}
    	});
	}	
	
	// 保存
	$("#timePriceSaveButton").click(function(){
		
		/**
		//JQuery 自定义验证，销售价不能小于结算价
		 jQuery.validator.addMethod("largeThan", function(value, element) {
		    return !(parseInt($(element).val()) < parseInt($("#settlementPriceInput").val()));
		 }, "销售价不能小于结算价");
		 */
		 jQuery.validator.addMethod("isNum", function(value, element) {
		    var num = /^[1-9]{0}\d+(\.\d{1,2})?$/;
		    return this.optional(element) || (num.test(value));       
		 }, "只能为整数或者最多两位小数");
		 
		jQuery.validator.addMethod("isIntegerWith0", function(value, element) {
			var num1 = /^[1-9]{0}\d*$/;
			return this.optional(element) || (num1.test(value));
		}, "库存只能为整数");	   
		
  		var priceValidate = $("#timePriceForm").validate();
		
	    //清空验证信息
	  	priceValidate.resetForm();	
	  	$("#timePriceFormContent").empty();	
		setIsOrNotValidate();	  		
		
		if(!priceValidate.form()){
			return;
		}
		
		//设置选择日期数据
		setSelectDate();
		setPriceFormData();
		//库存
        setStockFormData();
	    //设置提前预定时间
	    setAheadBookTimeFormData();
	    //设置授权限制数据
	    setBookLimitTypeFormData();	
	      //设置预售
	    setPreSaleFormData();	
		$("#timePriceFormContent").append('<input type="hidden" value="${suppGoods.prodProduct.productId}"" name="productId">');
		var loading = top.pandora.loading("正在努力保存中...");
		
		$.ajax({
			url : "/vst_admin/lineMultiTraffic/goods/timePrice/editGoodsTimePrice.do",
			data :　$("#timePriceForm").serialize(),
			dataType:'JSON',
			type: "POST",
			success : function(result){
				alert(result.message);
				loading.close();
				window.parent.window.search();
				window.parent.saveButtonDialog.close();
			},
			error : function(){
				alert('服务器错误');
				loading.close();
			}
		})
	});
	function isPreSale(obj,goodsId){
	 var parentDiv = obj.parents("#adult_child_preSale").find("div[goodsid='"+goodsId+"']");
	 var val = obj.val();
	 if(val=='Y'){
	 $("tr[name='isPreSaleTr"+goodsId+"']").show();
	 }else{
	  $("tr[name='isPreSaleTr"+goodsId+"']").hide();
	 }
	}
	$('#timePriceCancelButton').live('click',function(){
		window.parent.saveButtonDialog.close();
	});
	
</script>