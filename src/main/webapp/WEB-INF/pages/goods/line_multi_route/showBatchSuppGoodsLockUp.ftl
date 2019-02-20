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
		<a href="javascript:;" class="nfadd_close">×</a>
		<div class="nfadd_dialogB">
			<ul class="nfadd_List">
				<li>
					<div class="nfadd_div nfadd_title">
					    <#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_local'|| categoryCode=='category_route_customized'>
					 		<div>成人儿童：
						 		<#assign adultChildGoods = goodsMap['adult_child_diff'] />
						 		<#if adultChildGoods??>
					 				<label style="display:inline">
					 					<input type="checkbox" class="checkGoods adult_child" name="suppGoodsId" value="${adultChildGoods.suppGoodsId}" data_name="${adultChildGoods.goodsName}" data_price_type="${adultChildGoods.priceType}" />${adultChildGoods.goodsName}[${adultChildGoods.suppGoodsId}]</label>
						 		</#if>
					 		</div>
	 					</#if>
					</div>
			 		<div>
			 			<#if categoryCode=='category_route_hotelcomb'>
				 			套餐：
					 		<#assign comboDinnerList = goodsMap['combo_dinner'] />
					 		<#list comboDinnerList as comboDinnerGoods>
					 			<label style="display:inline" <#if comboDinnerGoods.cancelFlag!='Y'>cancelFlag="Y"</#if> ><input type="checkbox" class="checkGoods comb_hotel" name="suppGoodsIdList" value="${comboDinnerGoods.suppGoodsId}"  data_name="${comboDinnerGoods.goodsName}" data_price_type="${comboDinnerGoods.priceType}" />${comboDinnerGoods.goodsName}[${comboDinnerGoods.suppGoodsId}]</label>
					 			<#assign mainProdBranchId = '${comboDinnerGoods.productBranchId}' />
				 				<#assign mainSuppGoodsId = '${comboDinnerGoods.suppGoodsId}' />
					 		</#list>
				 		 </#if>
		 			</div>
					<div class="nfadd_div">
			 			<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_local' || categoryCode=='category_route_hotelcomb'|| categoryCode=='category_route_customized'>
							<div>附加：
								<#assign additionList = goodsMap['addition'] />
						 		<#list additionList as additionGoods>
						 			<label style="display:inline"  <#if additionGoods.cancelFlag!='Y'>cancelFlag="Y"</#if>  ><input type="checkbox" class="checkGoods addition" name="suppGoodsId" value="${additionGoods.suppGoodsId}"  data_name="${additionGoods.goodsName}" data_price_type="${additionGoods.priceType}" />${additionGoods.goodsName}[${additionGoods.suppGoodsId}]</label>
						 		</#list>
							</div>
						</#if> 					
					</div>
					<div class="nfadd_div nfadd_minW">
					    <#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom'|| categoryCode=='category_route_customized'>
					 		<div>升级：
						 		<#assign upgradList = goodsMap['upgrad'] />
						 		<#list upgradList as upgradGoods>
						 			<label style="display:inline"><input type="checkbox" class="checkGoods upgrade" name="suppGoodsId" value="${upgradGoods.suppGoodsId}"  data_name="${upgradGoods.goodsName}" data_price_type="${upgradGoods.priceType}" />${upgradGoods.goodsName}[${upgradGoods.suppGoodsId}]</label>
						 		</#list>
					 		</div>
				 		</#if>					
					</div>
					<div class="nfadd_div nfadd_minW">
					    <#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom'|| categoryCode=='category_route_customized'>
					 		<div>可换酒店：
						 		<#assign changedHotelList = goodsMap['changed_hotel'] />
						 		<#list changedHotelList as changedHotelGoods>
						 			<label style="display:inline"><input type="checkbox" class="checkGoods change_hotel" name="suppGoodsId" value="${changedHotelGoods.suppGoodsId}"  data_name="${changedHotelGoods.goodsName}" data_price_type="${changedHotelGoods.priceType}" />${changedHotelGoods.goodsName}[${changedHotelGoods.suppGoodsId}]</label>
						 		</#list>
					 		</div>
				 		</#if>					
					</div>
				</li>
				<div class="p_date">
					<form id="timePriceForm">
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
											<input name="startDate" class="Wdate" id="d4321" required="true" onfocus="WdatePicker({readOnly:true,minDate:'%y-%M-{%d}',maxDate:'#F{$dp.$D(\'d4322\',{d:0});}'})" type="text" readonly="" errorele="selectDate">
											<input name="endDate" class="Wdate" id="d4322" required="true" onfocus="WdatePicker({maxDate:'#F{$dp.$D(\'d4321\',{y:2});}',readOnly:true,minDate:'#F{$dp.$D(\'d4321\',{d:0});}'})" type="text" readonly="" errorele="selectDate">
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
						<!--在这里构造提交数据-->
			            <div style="display:none" id="timePriceFormContent"></div>
		            </form>
				</div>				
				<li>
					<div id="adult_child_price"></div>
					<div id="addition_price"></div>
					<div id="upgrade_price"></div>
					<div id="change_price"></div>
				</li>
			</ul>
		</div>
		<div class="fl operate">
			<a href="javascript:;" class="btn btn_cc" id="timePriceSaveButton">保&emsp;存</a>
			<a href="javascript:;" class="btn btn_cc" id="timePriceCancelButton">取&emsp;消</a>
		</div>
	</div>
	<div id="templateDiv" style="display:none">
		<div id="templateDiv" style="display:none">
			 <!-- 多价格价格 --> 
			<div id="multiple_price_template">
				<table align="center" class="e_table form-inline" style="width:600px;" goodsid="">
		             <tbody>       
						<tr>
							<td width="140" style="text-align:right;"><span>{{}}&nbsp;</span></td>
							<td width="150" style="text-align:right;">
								成人价&nbsp;<input type="checkbox" name="adult{index}" class="nfadd_middText adult">禁售
							</td>
							<td width="150" style="text-align:right;">
								儿童价：&nbsp;<input type="checkbox" name="child{index}" class="nfadd_middText adult">禁售
							</td>
							<td width="150" style="text-align:right;">
								单房差：&nbsp;<input type="checkbox" name="gap{index}" class="nfadd_middText adult">禁售
							</td>
						</tr>
		            </tbody>
		       </table>
			</div>
			
			<!-- 单价格 --> 
			<div id="single_price_template">
			   <table align="center" class="nfadd_table" style="width:600px;" goodsid="">
		             <tbody>
						<tr>
							<td width="140" style="text-align:right;"><span>{{}}&nbsp;</span></td>
							<td width="150" style="text-align:right;">
								<input type="checkbox" name="adult" class="nfadd_middText adult">禁售
							</td>
							<td width="150"></td>
							<td width="150"></td>
						</tr>
		            </tbody>
		       </table>
			</div>		
		<div>
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
		$(this).parents("tr").find("input").each(function(){
			if(that.attr("checked")!='checked'){
				if($(this).is("."+claszz))
					$(this).removeAttr("disabled");
			}else {
				if($(this).is("."+claszz))
				$(this).attr("disabled","disabled");
			}
		});
	});	
	
	//设置价格表单数据
	function setPriceFormData(){
		$(".priceDiv").each(function(i){
			var that = $(this);
			var goodsId = that.attr("goodsId");
	    	//创建商品Id
	    	$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].suppGoodsId" value="'+goodsId+'">');
			that.find('input[type=checkbox]:checked').each(function(j){
				var name = $(this).attr('name');
				if(name.indexOf('adult')==0){
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].auditSettlementPrice" value="0">');
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].auditPrice" value="0">');
				}else if(name.indexOf('child')==0){
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].childSettlementPrice" value="0">');
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].childPrice" value="0">');				
				}else{
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].grapSettlementPrice" value="0">');
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].gapPrice" value="0">');						
				}
				if(j==0){
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].onsaleFlag" value="Y">');
				}
			});
	    });
	}
	
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
	
	//删除模板
	function deleteTemplate(goodsId){
		$("div[goodsid="+goodsId+"]").remove();
	}	
	
	//商品点击事件
	$(".adult_child,.comb_hotel,.addition,.upgrade,.change_hotel").click(function(){
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
		var priceTemplate = '';
		if(priceType=="SINGLE_PRICE"){
			priceTemplate = '<div goodsId='+goodsId+' class="priceDiv">'+ $("#single_price_template").html()+'</div>';
		}else if(priceType=="MULTIPLE_PRICE"){
			priceTemplate = '<div goodsId='+goodsId+' class="priceDiv">'+ $("#multiple_price_template").html()+'</div>';
		}else {
			alert("该商品未设置价格类型!");
			return;
		}
		//为模板设置商品名称
		priceTemplate = priceTemplate.replace(/{{}}/g,name);
		priceTemplate = priceTemplate.replace(/{index}/g,globalIndex);
		
		//设置库存模板
		var stockTemplate = '';
	 
		//设置提前预定时间模板
		var aheadBookTimeTemplate = '';
		 
		//如果是成人儿童房差
		if(that.is(".adult_child")){
		 //设置模板
			setAdultChildTemplate(goodsId,priceTemplate,stockTemplate,aheadBookTimeTemplate);
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
		globalIndex++;
	});	
	
	
	//设置成人儿童模板
	function setAdultChildTemplate(goodsId,priceTemplate,stockTemplate,aheadBookTimeTemplate){
		//设置价格模板
		var size = $("#adult_child_price").find("div[goodsId="+goodsId+"]").size();
		if(size == 0){
			$("#adult_child_price").append(priceTemplate);
		}
	}
	
	//设置升级
	function setUpgradeTemplate(goodsId,priceTemplate,stockTemplate,aheadBookTimeTemplate){
		//设置价格模板
		var size = $("#upgrade_price").find("div[goodsId="+goodsId+"]").size();
		if(size == 0){
			$("#upgrade_price").append(priceTemplate);
		}
	}
	
	//设置可换
	function setChangeTemplate(goodsId,priceTemplate,stockTemplate,aheadBookTimeTemplate){
		//设置价格模板
		var size = $("#change_price").find("div[goodsId="+goodsId+"]").size();
		if(size == 0){
			$("#change_price").append(priceTemplate);
		}
	}
	
	//设置附加模板
	function setAdditionTemplate(goodsId,priceTemplate,stockTemplate,aheadBookTimeTemplate){
		//设置价格模板
		var size = $("#addition_price").find("div[goodsId="+goodsId+"]").size();
		if(size == 0){
			$("#addition_price").append(priceTemplate);
		}
	}
	
	// 保存
	$("#timePriceSaveButton").click(function(){
		
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
		setSelectDate();
		//设置价格表单
	    setPriceFormData();

	    $("input:checkbox.saleAble").each(function(){
	        var id = $(this).attr("name");
	        var value = $(this).is(':checked')?"Y":"N";
        	if($("#"+id).val()===""){
        		$("#"+id).val(value);
        	}
	    });
	    
	    //设置产品ID
	    $("#timePriceFormContent").append('<input type="hidden" value="${prodProductId}" name="productId">')
		var loading = top.pandora.loading("正在努力保存中...");
		$.ajax({
			url : "/vst_admin/lineMultiroute/goods/timePrice/editLineMultiRouteLockUp.do",
			data :　$("#timePriceForm").serialize(),
			dataType:'JSON',
			type: "POST",
			success : function(result){
				alert(result.message);
				loading.close();
				window.parent.document.getElementById('search_button').click();
				window.parent.batchLockupButtonDialog.close();
			},
			error : function(){
				alert('服务器错误');
				loading.close();
			}
		})
	});	
	
	$('#timePriceCancelButton').live('click',function(){
		window.parent.batchLockupButtonDialog.close();
	});	
	
	isView();
</script>