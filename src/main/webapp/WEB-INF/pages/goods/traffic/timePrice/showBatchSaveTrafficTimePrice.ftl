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
<script type="text/javascript" src="/vst_admin/js/lvmama-dialog.js"></script>

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
		 				<#if goodsList??>
		 					<div class="nfadd_div nfadd_title">
				 				<#list goodsList as good>
				 					<label class="radio">
				 						<input type="checkbox" name="suppGoodsId" value="${good.suppGoodsId}" data_name="${good.goodsName}" data="${suppGoods.suppSupplier.supplierId}" goodsbu="${good.bu}"  class="good adult_child" /><#if good.prodProductBranch.cancelFlag!='Y'><span style="color:red">[无效]</span></#if>${good.prodProductBranch.branchName}[${good.prodProductBranch.productBranchId}]-<#if good.cancelFlag!='Y'><span style="color:red">[无效]</span></#if>${good.goodsName}[${good.suppGoodsId}]<#if good.cancelFlag!='Y'><span class="poptip-mini poptip-mini-warning"><div class="tip-sharp tip-sharp-left"></div>-商品无效</span></#if>
				 					</label>
				 				</#list>
			 				</div>
		 				</#if>	 				
					</li>
					<div class="p_date">
						<li>
							<div class="nfadd_div"><label><input type="radio" value="selectDate" name="nfadd_date" checked>选择日期：</div>
							<div class="nfadd_div">
								<div id="divContainer" class="right"></div>
							    <div class="right">
							    	<div>已选日期:</div>
									<div id="divResult">
							        	<select multiple="true" id="selDate"></select>
							            <br/>
							            <input type="button" value="删除" id="btnDel"/>
							        </div>
							    </div>
							    <div class="clear"></div>						
							</div>
						</li>
						<li>
							<div class="nfadd_div"><label><input type="radio" value="selectTime"" name="nfadd_date">选择时间段：</div>
							<div class="nfadd_div">
								<div style="width:675px;">
									<p class="nfadd_line">
										<label>
											<input name="startDate" class="Wdate" id="d4321" onfocus="WdatePicker({readOnly:true,minDate:'%y-%M-{%d}',maxDate:'#F{$dp.$D(\'d4322\',{d:0});}'})" type="text" readonly="" errorele="selectDate">
											<input name="endDate" class="Wdate" id="d4322" onfocus="WdatePicker({maxDate:'#F{$dp.$D(\'d4321\',{y:2});}',readOnly:true,minDate:'#F{$dp.$D(\'d4321\',{d:0});}'})" type="text" readonly="" errorele="selectDate">
										</label>
									</p>
								</div> 
							</div>
						</li>
						<li>
							<div class="nfadd_div"><label>适用日期：</label></div>
							<div class="nfadd_div">
								<div style="width:675px;">
									<p class="nfadd_line">
										<label><input type="checkbox" name="weekDayAll">全部</label>
										<label><input type="checkbox" name="weekDay" value="2">周一</label>
										<label><input type="checkbox" name="weekDay" value="3">周二</label>
										<label><input type="checkbox" name="weekDay" value="4">周三</label>
										<label><input type="checkbox" name="weekDay" value="5">周四</label>
										<label><input type="checkbox" name="weekDay" value="6">周五</label>
										<label><input type="checkbox" name="weekDay" value="7">周六</label>
										<label><input type="checkbox" name="weekDay" value="1">周日</label>
									</p>
								</div> 
							</div>
						</li>
					</div>				
					<li>
						<div class="nfadd_div nfadd_title">设置价格：</div>
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
						<td>结算价：<input type="text" max="999999999" name="auditSettlementPrice{index}" class="adult" data="auditSettlementPrice"></td>
						<td>销售价：<input type="text" max="999999999" name="auditPrice{index}" class="adult" data="auditPrice"></td>
						<td width="200"><input type="checkbox" class="saleAble" name="adult">禁售</td>
					</tr>
					<tr>
						<td style="text-align:right;"><span>&nbsp;儿童&nbsp;</span></td>
						<td>结算价：<input type="text" max="999999999" name="childSettlementPrice{index}" class="child" data="childSettlementPrice"></td>
						<td>销售价：<input type="text" max="999999999" name="childPrice{index}" class="child" data="childPrice"></td>
						<td><input type="checkbox" class="saleAble" name="child">禁售</td>
					</tr>
	            </tbody>
	       </table>
		</div>
	       
	      <#if suppGoods??&&suppGoods.bizCategory??&&suppGoods.bizCategory.categoryId==25>
	     <!-- 多价格库存  其它巴士--> 
	     <div id="multiple_stock_template">
	       <table class="e_table form-inline" goodsId="">
	             <tbody>
	               <tr><td colspan="4">{{}}</td></tr>
					<tr>
						<td width="50"></td>
						<td></td>					
						<td >
						 是否限制日库存：&nbsp;<!-- <input type="radio" class="typeSelect"  name="stockType"  value="INQUIRE_NO_STOCK">不限制日库存  -->
						    <input type="radio" class="typeSelect" name="stockType" value="CONTROL" checked="checked"/>限制日库存 
							<input type="text" maxlength="11" class="nfadd_middText" name="stockIncrease1_{index}"  >
						</td>
						<td>
						        是否可超卖&emsp;
							<select class="w10" >
		                   <!-- 	<option value="Y">是</option> -->
		                    	<option value="N">否</option>
			                </select>
						</td>	
					</tr>
	             </tbody>
	           </table> 
	        </div>  
	      <#else>
	      <!-- 多价格库存 --> 
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
								<input type="radio" class="typeSelect"  name="stockType" value="INQUIRE_WITH_STOCK">现询日库存
							</label>
							<input type="text" maxlength="11" class="nfadd_middText" name="stockIncrease_{index}" disabled=disabled>
						</td>
						<td>是否可超卖&emsp;
							<select class="w10" disabled=disabled>
		                    	<option value="Y">可超卖</option>
		                    	<option value="N">不可超卖</option>
			                </select>
						</td>					
					</tr>
					<tr>
						<td width="50"></td>
						<td></td>					
						<td>
							<label><input type="radio" class="typeSelect" name="stockType" value="CONTROL"/>确定日库存</label>
							<input type="text" maxlength="11" class="nfadd_middText" name="stockIncrease1_{index}" disabled=disabled>
						</td>
						<td>是否可超卖&emsp;
							<select class="w10" disabled=disabled>
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
	                    	<select class="w10 mr10" name="aheadBookTime_day">
			                    <#if prodProduct.bizCategoryId == 21>
				                      	<#list 0..180 as i>
				                      <option value="${i}">${i}</option>
				                      </#list>
			                      	<#else>
			                      		<#list 0..50 as i>
				                      <option value="${i}">${i}</option>
				                      </#list>
			                      </#if>
			                </select>天
			                <select class="w10 mr10" name="aheadBookTime_hour">
			                      <#list 0..23 as i>
			                      <option value="${i}" <#if i==10>selected=selected</#if> >${i}</option>
			                      </#list>
			                </select>点
			                <select class="w10 mr10" name="aheadBookTime_minute">
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
				}
			$("#adult_child_preSale").find("div.preSaleDiv").find("input."+claszz+goodsId).attr("disabled","disabled");
			$("#adult_child_preSale").find("div.preSaleDiv").find("input."+claszz+goodsId).val("");  
			}
		});
	});	
	
	//设置选择日期数据
	function setSelectDate(){
		var selectCalendar = $('input[name=nfadd_date]:checked').val();
		$("#timePriceFormContent").append('<input type="hidden" name="selectCalendar" value="'+selectCalendar+'">');
		if(selectCalendar=='selectDate'){
			$("#selDate option").each(function(){
				$("#timePriceFormContent").append('<input type="hidden" name="selectDates" value="'+$(this).val()+'">');
			});
		}
	}
	
	//设置库存表单数据
	function setStockFormData(){
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
    					$("#timePriceFormContent").append(clone1);
    					var obj2 = $(this).closest("tr").find("td").eq(3).find("select");
    					var clone2 = obj2.clone();
    					clone2.removeAttr('disabled');
	    				clone2.attr("name","timePriceList["+i+"].oversellFlag");
	    				clone2.val(obj2.val());
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
	
	//设置价格表单数据
	function setPriceFormData(){
		$(".priceDiv").each(function(i){
	    	var that = $(this);
	    	//创建商品Id
	    	$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].suppGoodsId" value="'+that.attr("goodsId")+'">');
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
		
		//预付预授权限制 默认值
		var goodsbu = that.attr("goodsbu");
		if("LOCAL_BU"==goodsbu){
		   $(".form-inline #bookLimitType"+globalIndex).val("NOT_PREAUTH");
		}
		
		globalIndex++;
	});	
	
	
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
            		$(this).rules("add",{required : true, number : true, isNum:true, min : 0,messages : {min:'价格必须大于等于0',isNum:'价格格式不正确(填多2位小数正数)'}});
            	}
            }
        });
	   
	    //库存
    	$(".stockDiv").find("input[type=radio]:checked").each(function(){
    		var size = $(this).closest('tr').find('input[type=text]').size();
    		if(size>0){
				$(this).closest('tr').find('input[type=text]').rules("add",{required : true,isIntegerWith0:true ,min:0,messages : {min:'库存必须为大于等于0的整数'}});    		
    		}
    	});
	}	
	
	$(".typeSelect").live('click',function(){
		var that = $(this);
		//首先将其他所有的置为disabled
		$(this).parents("table").find("input[type=text],.w10").attr("disabled","disabled");
		if(that.val()=='INQUIRE_WITH_STOCK' || that.val()=='CONTROL'){
			$(this).parents("tr").find("input[type=text],.w10").removeAttr("disabled");
		}
	});	
	
	// 保存
	$("#timePriceSaveButton").click(function(){
		var timePriceFormValidate = $("#timePriceForm").validate();
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
		 
		if($('input[name=nfadd_date]:checked').val()=='selectDate'){
			if($('#selDate').find('option').size()==0){
				alert("请选择日期");
				return;
			}
		}else{
			if($("input[type=checkbox][name=weekDay]:checked").size()==0){
			 	alert("请选择适用日期");
				return;
			}
			 if($('#d4321').val().length<=0){
			 	alert("请选择开始时间");
			 	return;
			 }
			 if($('#d4322').val().length<=0){
			 	alert("请选择结束时间");
			 	return;			 
			 }				
		}		 
		 
		//构造Form提交数据
		$("#timePriceFormContent").empty();		 
	  	setIsOrNotValidate();	 
		
		if(!timePriceFormValidate.form()){
			return;
		}
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
	    //设置产品ID
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
				window.parent.bacthButtonDialog.close();
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
		window.parent.bacthButtonDialog.close();
	});	
	isView();
</script>