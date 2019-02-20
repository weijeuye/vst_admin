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
			            <input type="hidden" name="isSetPrice">
			            <input type="hidden" name="isSetStock">
			            <input type="hidden" name="isSetAheadBookTime">
			            <input type="hidden" name="adult" id="adult">
			            <input type="hidden" name="child" id="child">
			            <input type="hidden" name="gap" id="gap">
			            <input type="hidden" name="cancelStrategy" id="cancelStrategy">
			            <div style="display:none" id="timePriceFormContent"></div>
		            </form>
				</div>				
				<li>
					<div class="nfadd_div nfadd_title">设置退改规则：</div>
					<div class="nfadd_div">
						<label><input type="radio" name="selectCancelStrategy" value="MANUALCHANGE" checked>人工退改</label>
						<label><input type="radio" name="selectCancelStrategy" value="UNRETREATANDCHANGE">不退不改</label>
					</div>
				</li>
			</ul>
		</div>
		<div class="fl operate">
			<a href="javascript:;" class="btn btn_cc" id="timePriceSaveButton">保&emsp;存</a>
			<a href="javascript:;" class="btn btn_cc" id="timePriceCancelButton">取&emsp;消</a>
		</div>
	</div>	
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
	
	//设置退改规则数据
	function setCancelStrategy(){
		var canCelStategy = $('input[name=selectCancelStrategy]:checked').val();
		$('#cancelStrategy').val(canCelStategy);
	}
	
	//设置选择日期数据
	function setSelectDate(){
		var selectCalendar = $('input[name=nfadd_date]:checked').val();
		$("#timePriceFormContent").append('<input type="hidden" name="selectCalendar" value="'+selectCalendar+'">');
		if(selectCalendar=='selectDate'){
			$("#selDate option").each(function(){
				$("#timePriceFormContent").append('<input type="hidden" name="specDates" value="'+$(this).val()+'">');
			});
		}
	}
	
	//删除模板
	function deleteTemplate(goodsId){
		$("div[goodsid="+goodsId+"]").remove();
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
	    //设置退改规则数据
	    setCancelStrategy();
	    
	    //设置产品ID
	    $("#timePriceFormContent").append('<input type="hidden" value="${prodProductId}" name="productId">')
		var loading = top.pandora.loading("正在努力保存中...");
		$.ajax({
			url : "/vst_admin/lineMultiroute/goods/timePrice/editLineMultiRouteCancelStrategy.do",
			data :　$("#timePriceForm").serialize(),
			dataType:'JSON',
			type: "POST",
			success : function(result){
				alert(result.message);
				loading.close();
				window.parent.document.getElementById('search_button').click();
				window.parent.backRulesButtonDialog.close();
			},
			error : function(){
				alert('服务器错误');
				loading.close();
			}
		})
	});	
	
	$('#timePriceCancelButton').live('click',function(){
		window.parent.backRulesButtonDialog.close();
	});		
	
	isView();
</script>