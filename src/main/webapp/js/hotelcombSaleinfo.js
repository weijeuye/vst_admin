/**
 * 销售信息-页面逻辑处理JS
 */
var isHotelComb="";
$(function(){
	//将无效的隐藏
	if(hideLabel){
		$("label[cancelFlag='Y']").hide();
	}
	var hotelcombValue = $("#category_route_hotelcomb_input").val();
	if(hotelcombValue=='category_route_hotelcomb'){
		isHotelComb="Y";
	}else{
		isHotelComb="N";
	}
	//初始化价格校验器
	validInitPrice();
	
	//事件绑定
	$("label").delegate(".my_adult_child,.my_comb_hotel,.my_addition,.my_upgrade,.my_change_hotel","click",goodsEventHandler);
	//保存按钮-事件
	$("div[class='btn-group text-center']").delegate("#updateSaleInfoBtn","click",saveSaleInfo);
	//日历input框change事件
	$("#d4321,#d4322").on("change", getDataIfSameDay);
	//库存类型事件
	$("#stockContainer").delegate(":radio[name*=adultStock]","click",stockTypeHandler);
	//价格禁售事件
	$("#priceContainer").delegate(".JS_checkbox_lock_item,.JS_checkbox_lock_all","click",priceLockHandler);
	//日历 日期上的选中事件
	$(".JS_select_date").delegate("div[class*=caldate]","click",getDataIfSameDay);
	//取消按钮事件
	$("div[class='btn-group text-center']").delegate("#cancelSaleInfoBtn","click",cancelEditBtnHandler);
	//日期类型事件
	$("label[class=radio]").delegate(":radio[name=nfadd_date]","click",dateTypeChangeHandler);
	//新增退改规则按钮-事件
	$("#strategyContainer").delegate("#btnAddLadder","click",ladderEventHandler);	
	$('input[name=selectCancelStrategy]').click(function(){
		if(this.value == "RETREATANDCHANGE"){
			$("#btnAddLadder").removeAttr("disabled");
			$("#btnAddLadder").show();
			$("#ladderRetreatContainer").show();
			$("#cancelTimeTypeDiv").show();
		}else{
			$("#btnAddLadder").attr("disabled", true);
			$("#btnAddLadder").hide();
			$("#ladderRetreatContainer").hide();
			$("#cancelTimeTypeDiv").hide();
		}
	});

	
});
 
	
	var  validateSingle = null;	

	var globalIndex = 0;
	
	var errEles = [];
	
	var lowPriceDialog = null;
	
	var saveInfoUrl = "";
	
	
	var ladderIndex = 0;//阶梯退改索引
	//商品点击事件【1、添加模板到页面 2、如果当前日期只有一天，那么加载这一天这个商品的信息】
	function goodsEventHandler1(obj){
		var that = $(obj);
		var name = that.attr("data_name");
		var priceType = that.attr("data_price_type");
		var goodsId = that.val();
		var classType = that.attr("class");
		//首先判断是选中还是取消
		if(that.attr("checked")!='checked'){
			//如果是取消，则执行删除模板操作
			deleteTemplate(goodsId,classType);  
			return;
		}
		
		//设置价格模板
		var priceTemplate = '';
		var priceTemplate_pre = '';//买断设置模板
		var preSaleTemplate=''; //设置预售模板
		if(priceType=="SINGLE_PRICE"){
			priceTemplate = '<div goodsId='+goodsId+' class="priceDiv" divType="'+classType+'">'+ $("#setter_single_price_template").html()+'</div>';
			priceTemplate_pre = '<div goodsId='+goodsId+' class="priceDiv" divType="'+classType+'">'+ $("#setter_single_price_template_pre").html()+'</div>';
			preSaleTemplate='<div goodsId='+goodsId+' class="preSaleDiv" divType="'+classType+'">'+$("#multiple_preSale_template_new_preSale").html()+'</div>';
		}else if(priceType=="MULTIPLE_PRICE"){
			priceTemplate = '<div goodsId='+goodsId+' class="priceDiv" divType="'+classType+'">'+ $("#setter_multiple_price_template").html()+'</div>';
			priceTemplate_pre = '<div goodsId='+goodsId+' class="priceDiv" divType="'+classType+'">'+ $("#setter_multiple_price_template_pre").html()+'</div>';
		}else {
			alert("该商品未设置价格类型!");
			return false;
		}
		//为模板设置商品名称
		priceTemplate = priceTemplate.replace(/{{}}/g,name);
		priceTemplate_pre= priceTemplate_pre.replace(/{{}}/g,name);
		var res = "^-?([1-9]\\d{0,8}|[1-9]\\d{0,8}\\.\\d{1,2}|0\\.\\d{1,2}|0?\\.0{1,2}|0)$";
		var res2 = "^\\d{1,8}(\\.\\d{1,2})?$";
		if(name.indexOf('自备签') >= 0){
				priceTemplate = priceTemplate.replace(/{data-validate-regular}/g,res);
				priceTemplate_pre = priceTemplate_pre.replace(/{data-validate-regular}/g,res);
		}else{
			priceTemplate = priceTemplate.replace(/{data-validate-regular}/g,res2);
			priceTemplate_pre = priceTemplate_pre.replace(/{data-validate-regular}/g,res2);
		}
		priceTemplate = priceTemplate.replace(/{index}/g,globalIndex);
		priceTemplate = priceTemplate.replace(/{thisGoodsId}/g,goodsId);
		
		priceTemplate_pre = priceTemplate_pre.replace(/{index}/g,globalIndex);
		priceTemplate_pre = priceTemplate_pre.replace(/{thisGoodsId}/g,goodsId);
		
		preSaleTemplate = preSaleTemplate.replace(/{{}}/g,name);
		preSaleTemplate=preSaleTemplate.replace(/{isInput}/g,goodsId);
		//设置库存模板
		var stockTemplate = '';
		stockTemplate = '<div goodsId='+goodsId+' class="stockDiv" divType="'+classType+'">' + $("#setter_stock_template").html() +'</div>';
		stockTemplate = stockTemplate.replace(/{{}}/g,name);
		stockTemplate = stockTemplate.replace(/{index}/g,globalIndex);
		stockTemplate = stockTemplate.replace(/{thisGoodsId}/g,goodsId);
		//设置提前预定时间模板
		var aheadBookTimeTemplate = '';
		aheadBookTimeTemplate = '<div goodsId='+goodsId+' class="timeDiv" divType="'+classType+'">' + $("#setter_ahead_time_template").html() +'</div>';
		aheadBookTimeTemplate = aheadBookTimeTemplate.replace(/{{}}/g,name);
		aheadBookTimeTemplate = aheadBookTimeTemplate.replace(/{thisGoodsId}/g,goodsId);
		//设置价格模板
		var size = $("#priceContainer").find("div[goodsId="+goodsId+"]").size();
		if(size == 0){
			insertTemplateToContainer(classType,priceTemplate,$("#priceContainer"),goodsId);
			if(classType=='my_adult_child' || classType=='my_comb_hotel'){
				insertTemplateToContainer(classType,priceTemplate_pre,$("#priceContainer_pre"),goodsId);
			}
		}
		
		
		//如果是酒店套餐，那么没有商品的单 禁售
		if(thisCategoryId == 17){
			var checkBoxes = $(":checkbox[class*=JS_checkbox_lock_item]",$("#priceContainer").find("div[goodsId="+goodsId+"]"));
			if(checkBoxes.length > 1){
				checkBoxes.each(function(){
					$(this).parents("label[class*=checkbox]").hide();
				});
			}
		}
		
		//在库存tab页下增加
		size=$("#stockContainer").find("div[goodsId="+goodsId+"]").size();
		if(size == 0){
			insertTemplateToContainer(classType,stockTemplate,$("#stockContainer"),goodsId);
		}
		//在提前预定时间tab页下增加
		size=$("#headTimeContainer").find("div[goodsId="+goodsId+"]").size();
		if(size == 0){
			insertTemplateToContainer(classType,aheadBookTimeTemplate,$("#headTimeContainer"),goodsId);
		}
		//预售价格设置
		 size= $("#Set_PreSale").find("div[goodsId="+goodsId+"]").size();
		 if(size == 0){
				insertTemplateToContainer(classType,preSaleTemplate,$("#Set_PreSale"),goodsId);
		}		
		getOneDayData(goodsId);
		globalIndex++;
		validInitPrice();
		//hidePreControl(goodsId);
		if(thisCategoryId == 17){
			closeHotelCombPrice();
		}
	};
	
	
	function goodsEventHandler(){
		var that = $(this);
		var name = that.attr("data_name");
		var priceType = that.attr("data_price_type");
		var goodsId = that.val();
		var classType = that.attr("class");
		//首先判断是选中还是取消
		if(that.attr("checked")!='checked'){
			//如果是取消，则执行删除模板操作
			deleteTemplate(goodsId,classType);  
			return;
		}
		
		//设置价格模板
		var priceTemplate = '';
		var priceTemplate_pre = '';//买断设置模板
		var preSaleTemplate=''; //设置预售模板
		if(priceType=="SINGLE_PRICE"){
			priceTemplate = '<div goodsId='+goodsId+' class="priceDiv" divType="'+classType+'">'+ $("#setter_single_price_template").html()+'</div>';
			priceTemplate_pre = '<div goodsId='+goodsId+' class="priceDiv" divType="'+classType+'">'+ $("#setter_single_price_template_pre").html()+'</div>';
			preSaleTemplate='<div goodsId='+goodsId+' class="preSaleDiv" divType="'+classType+'">'+$("#multiple_preSale_template_new_preSale").html()+'</div>';
		}else if(priceType=="MULTIPLE_PRICE"){
			priceTemplate = '<div goodsId='+goodsId+' class="priceDiv" divType="'+classType+'">'+ $("#setter_multiple_price_template").html()+'</div>';
			priceTemplate_pre = '<div goodsId='+goodsId+' class="priceDiv" divType="'+classType+'">'+ $("#setter_multiple_price_template_pre").html()+'</div>';
		}else {
			alert("该商品未设置价格类型!");
			return false;
		}
		//为模板设置商品名称
		priceTemplate = priceTemplate.replace(/{{}}/g,name);
		priceTemplate_pre= priceTemplate_pre.replace(/{{}}/g,name);
		var res = "^-?([1-9]\\d{0,8}|[1-9]\\d{0,8}\\.\\d{1,2}|0\\.\\d{1,2}|0?\\.0{1,2}|0)$";
		var res2 = "^\\d{1,8}(\\.\\d{1,2})?$";
		if(name.indexOf('自备签') >= 0){
				priceTemplate = priceTemplate.replace(/{data-validate-regular}/g,res);
				priceTemplate_pre = priceTemplate_pre.replace(/{data-validate-regular}/g,res);
		}else{
			priceTemplate = priceTemplate.replace(/{data-validate-regular}/g,res2);
			priceTemplate_pre = priceTemplate_pre.replace(/{data-validate-regular}/g,res2);
		}
		priceTemplate = priceTemplate.replace(/{index}/g,globalIndex);
		priceTemplate = priceTemplate.replace(/{thisGoodsId}/g,goodsId);
		
		priceTemplate_pre = priceTemplate_pre.replace(/{index}/g,globalIndex);
		priceTemplate_pre = priceTemplate_pre.replace(/{thisGoodsId}/g,goodsId);
		
		preSaleTemplate = preSaleTemplate.replace(/{{}}/g,name);
		preSaleTemplate=preSaleTemplate.replace(/{isInput}/g,goodsId);
		//设置库存模板
		var stockTemplate = '';
		stockTemplate = '<div goodsId='+goodsId+' class="stockDiv" divType="'+classType+'">' + $("#setter_stock_template").html() +'</div>';
		stockTemplate = stockTemplate.replace(/{{}}/g,name);
		stockTemplate = stockTemplate.replace(/{index}/g,globalIndex);
		stockTemplate = stockTemplate.replace(/{thisGoodsId}/g,goodsId);
		//设置提前预定时间模板
		var aheadBookTimeTemplate = '';
		aheadBookTimeTemplate = '<div goodsId='+goodsId+' class="timeDiv" divType="'+classType+'">' + $("#setter_ahead_time_template").html() +'</div>';
		aheadBookTimeTemplate = aheadBookTimeTemplate.replace(/{{}}/g,name);
		aheadBookTimeTemplate = aheadBookTimeTemplate.replace(/{thisGoodsId}/g,goodsId);
		//设置价格模板
		var size = $("#priceContainer").find("div[goodsId="+goodsId+"]").size();
		if(size == 0){
			insertTemplateToContainer(classType,priceTemplate,$("#priceContainer"),goodsId);
			if(classType=='my_adult_child' || classType=='my_comb_hotel'){
				insertTemplateToContainer(classType,priceTemplate_pre,$("#priceContainer_pre"),goodsId);
			}
		}
		
		
		//如果是酒店套餐，那么没有商品的单 禁售
		if(thisCategoryId == 17){
			var checkBoxes = $(":checkbox[class*=JS_checkbox_lock_item]",$("#priceContainer").find("div[goodsId="+goodsId+"]"));
			if(checkBoxes.length > 1){
				checkBoxes.each(function(){
					$(this).parents("label[class*=checkbox]").hide();
				});
			}
		}
		
		//在库存tab页下增加
		size=$("#stockContainer").find("div[goodsId="+goodsId+"]").size();
		if(size == 0){
			insertTemplateToContainer(classType,stockTemplate,$("#stockContainer"),goodsId);
		}
		//在提前预定时间tab页下增加
		size=$("#headTimeContainer").find("div[goodsId="+goodsId+"]").size();
		if(size == 0){
			insertTemplateToContainer(classType,aheadBookTimeTemplate,$("#headTimeContainer"),goodsId);
		}
		//预售价格设置
		 size= $("#Set_PreSale").find("div[goodsId="+goodsId+"]").size();
		 if(size == 0){
				insertTemplateToContainer(classType,preSaleTemplate,$("#Set_PreSale"),goodsId);
		}		
		getOneDayData(goodsId);
		globalIndex++;
		validInitPrice();
		//hidePreControl(goodsId);
		if(thisCategoryId == 17){
			closeHotelCombPrice();
		}
	};
	
	
	//添加阶梯退改规则
	function ladderEventHandler(){
		var ladderTemplate = "";
		var res = "^\\d{1,8}(\\.\\d{1,2})?$";
		var container = $("#ladderRetreatContainer");
		ladderTemplate = "<div divType='my_ladder_retreat'>"+$("#ladder_retreat_template").html()+"</div>";
		ladderTemplate = ladderTemplate.replace(/{{}}/g,(ladderIndex+1));
		ladderTemplate = ladderTemplate.replace(/{indexId}/g,ladderIndex);
		ladderTemplate = ladderTemplate.replace(/{data-validate-regular}/g,res);
		var ladderRetreats = $("div[divType=my_ladder_retreat]",$(container));
		if(ladderRetreats.length>0){
			$(ladderTemplate).insertAfter(ladderRetreats.last());
		}else{
			$(container).append(ladderTemplate);
		}
		container.show();
		validInitPrice();
		ladderIndex = ladderIndex+1;
	}	
	//删除阶梯退改规则
	function deleteLadderRetreatRule(index){
		var _div = $("#ladderRetreat_value_"+index).parent().parent().parent();
		_div.remove();
		for(var i = index+1;i<ladderIndex;i++){
			var day = $('#ladderRetreatTime_day_'+i).val();
		    var hour = $('#ladderRetreatTime_hour_'+i).val();
		    var minute = $('#ladderRetreatTime_minute_'+i).val();
		    var type = $('#ladderRetreat_type_'+i).val();
		    var rule = $('#ladderRetreat_rule_'+i).val();
		    var value = $('#ladderRetreat_value_'+i).val();
		    var ladderTemplate = "";
			var res = "^\\d{1,8}(\\.\\d{1,2})?$";
			var container = $("#ladderRetreatContainer");
			ladderTemplate = "<div divType='my_ladder_retreat'>"+$("#ladder_retreat_template").html()+"</div>";
			ladderTemplate = ladderTemplate.replace(/{{}}/g,(i));
			ladderTemplate = ladderTemplate.replace(/{indexId}/g,i-1);
			ladderTemplate = ladderTemplate.replace(/{data-validate-regular}/g,res);
			var ladderRetreats = $("div[divType=my_ladder_retreat]",$(container));
			if(ladderRetreats.length>0){
				$(ladderTemplate).insertAfter(ladderRetreats.last());
			}else{
				$(container).append(ladderTemplate);
			}
			var _div = $("#ladderRetreat_value_"+i).parent().parent().parent();;
			_div.remove();
			var j = i -1;
			$('#ladderRetreatTime_day_'+j).val(day);
		    $('#ladderRetreatTime_hour_'+j).val(hour);
		    $('#ladderRetreatTime_minute_'+j).val(minute);
		    $('#ladderRetreat_type_'+j).val(type);
		    $('#ladderRetreat_rule_'+j).val(rule);
		    $('#ladderRetreat_value_'+j).val(value);
			container.show();
			changeLadderRetreatRule(j);
		}
		ladderIndex = ladderIndex-1;
		validInitPrice();
	}
	
	//改变阶梯退改中用户申请类型
	function changeLadderRetreatRule(index){
		if($("#ladderRetreat_rule_"+index).val() == "PERCENT"){
			$("#ladderRetreat_value_"+index).attr("max","100");
			$("#ladderRetreat_value_"+index).parent().next("span[class='JS_ladder_price_percent']").html("%");
		}else{
			$("#ladderRetreat_value_"+index).attr("max","9999999");
			$("#ladderRetreat_value_"+index).parent().next("span[class='JS_ladder_price_percent']").html("元");
		}
		validInitPrice();
	}
	
	//获取若干个商品在这一天的数据
	function getOneDayData(goodsIds){
		var thisDate = "";
		thisDate = getDateIfOneDaySelected();
		if(thisDate !="" && goodsIds != ""){
			
			var getOneDayGoodsInfoUrl = "/vst_admin/lineMultiroute/goods/timePrice/getOneDaySalesInfo.do";
			$.ajax({
				url:getOneDayGoodsInfoUrl,
				data:{
					specDate:thisDate,
					suppGoodsIds:goodsIds,
					categoryCode:$("input[name='categoryCode']").val(),
					productId:$("#thisProductId").val()
				},
				type:"GET",
				async:true,
				dataType:"json",
				success:function(data){
						//处理有数据的
						var goodsArr=[];
						if(!(data == null || data == "") ){
							for(var d in data){
								fillInData(data[d],data[d].suppGoodsId);
								goodsIds = goodsIds.replace(data[d].suppGoodsId,"");
								goodsArr.push(data[d].suppGoodsId);
							}
						}
						
						var empGoodsArr = [];
						var exp = /\d{1,}/g;
						var ret = exp.exec(goodsIds);
						while(ret != null){
							var d = ret[0];
							if($.isNumeric(d)){
								empGoodsArr.push(d);
							}
							ret = exp.exec(goodsIds);
						}
						initGoodsInfo(empGoodsArr);
					if(thisCategoryId == 17){
						closeHotelCombPrice();
					}
				},
				error:function(){

				}
			});
		}
	}
	
	//判断是否是同一天，如果是同一天那么需要去查询数据
	function getDataIfSameDay(){
		//行程初始化
		$("select[name=lineRouteId]").find("option:first-child").attr("selected","selected");
		
		var thisDate = "";
		thisDate = getDateIfOneDaySelected();
		if(thisDate == ""){
			return false;
		}
		var goodsArr = [];
		$(".my_adult_child,.my_comb_hotel,.my_addition,.my_upgrade,.my_change_hotel").each(function(){
			var _this = $(this);
			if(_this.attr("checked") == 'checked'){
				goodsArr.push(_this.val());
			}
		});
		var goodsIds = goodsArr.join("##");
		//alert(goodsIds);
		getOneDayData(goodsIds);
	}
	
	//设置提前预定时间表单数据
	function getTotalMinute(day,hour,minute){
			if(day == -1){
				day =0;
			}
			if(hour == -1){
				hour =0;
			}
			if(minute == -1){
				minute =0;
			}
			return  (day*24*60-hour*60-minute);	
	}
	
	
	//删除模板【并且处理附加俩字】
	function deleteTemplate(goodsId,classType){
		var thisDIV =$("div[goodsid="+goodsId+"]");
		thisDIV.remove(); 
		var fujia = $("div[divType="+classType+"]:first","#priceContainer").find(".fujia");
		fujia.show();
	}
	
	
	
	//填充这个商品的数据
	function fillInData(data,goodsId){
		var arr = data;
		// 设置库存
		var thisStockType = arr.stockType;
		var thisStockValue = arr.totalStock;
		var thisStockOutSell = arr.oversellFlag;
		var thisStockDIV = $("div[goodsid="+goodsId+"]","#stockContainer");
		$("i[class*=error]",thisStockDIV).remove();
		$(":text[class*=error]",thisStockDIV).removeClass("error");
		var stockTypeRadio = $("#"+thisStockType+"_"+goodsId);						
		stockTypeRadio.attr('checked','checked');
		if(thisStockType!='INQUIRE_NO_STOCK'){
			var stockRadioDIV = stockTypeRadio.parents(".JS_radio_switch_box");
			var stockInput = stockRadioDIV.find(":text[class*=form-control]");
			stockInput.val(thisStockValue).removeAttr("disabled");
		}else{
			var stockRadioDIV = stockTypeRadio.parents(".JS_radio_switch_group");
			var stockInputs = stockRadioDIV.find(":text[class*=form-control]");
			stockInputs.each(function(){
				$(this).val("").attr("disabled","disabled");
			});
			
		}
		var outSellRadio = stockTypeRadio.parents("div[class*='row JS_radio_switch_group']").find(":radio[name*=adultOversold][value="+thisStockOutSell+"]");
		outSellRadio.attr('checked','checked');
		
		// 设置价格
		//是否禁售
		var thisPriceDIV = $("div[goodsid="+goodsId+"]","#priceContainer");
		$("i[class*=error]",thisPriceDIV).remove();
		$(":text[class*=error]",thisPriceDIV).removeClass("error");
		var lockUp = arr.onsaleFlag;
		var lockUpBox = $(":checkbox",thisPriceDIV).last();
		//这个标记有点乱，等价格禁售和商品禁售的关系确定后，要稍稍理一下代码
		lockUpBox.removeAttr('checked');
		var hotelcombValue = $("#category_route_hotelcomb_input").val();
		if(hotelcombValue=="category_route_hotelcomb"){//酒店套餐
			var onsaleFlag = lockUp;
			if(onsaleFlag=="N"){
				$("#forbidSaleFlag_"+goodsId).attr("checked",true);
				$("#onSaleFlagHidden_"+goodsId).attr("checked",true);
				$("#onSaleFlagHidden_"+goodsId).val("1");
			}else{
				$("#onSaleFlag_"+goodsId).attr("checked",true);
				$("#onSaleFlagHidden_"+goodsId).attr("checked",false);
				$("#onSaleFlagHidden_"+goodsId).val("1");
			}
		}else{//其他
			if( (lockUp == 'n' || lockUp == 'N') && $(":checkbox[class*=JS_checkbox_lock_item]",thisPriceDIV).length == 1 && arr.auditSettlementPrice == null ){
				lockUp = 'N';
			}else{
				lockUp = 'Y';
			}
		}
		
		if(arr.auditSettlementPrice == null ){
			lockUp = 'N';
		}
		
		if(lockUp == 'N'){
			lockUpBox.trigger("click");
			priceLockHandler.call(lockUpBox);
			lockUpBox.attr('checked','checked');
		}else{
			lockUpBox.removeAttr('checked');
			priceLockHandler.call(lockUpBox);
		}
		var hotelcombValue = $("#category_route_hotelcomb_input").val();
		if(hotelcombValue=="category_route_hotelcomb"){//酒店套餐
			var onsaleFlag = lockUp;
			if(onsaleFlag=="N"){
				$("#forbidSaleFlag_"+goodsId).attr("checked",true);
				$("#onSaleFlagHidden_"+goodsId).attr("checked",true);
				$("#onSaleFlagHidden_"+goodsId).val("1");
			}else{
				$("#onSaleFlag_"+goodsId).attr("checked",true);
				$("#onSaleFlagHidden_"+goodsId).attr("checked",false);
				$("#onSaleFlagHidden_"+goodsId).val("1");
			}
		}
		// 设置成人价格
		var auditSettlementPrice = arr.auditSettlementPrice;
		var auditPrice = arr.auditPrice;		
		if(auditSettlementPrice==null){
			
		}else{
			if(!hideLabel){//酒店套餐
				$('#adultSettlePrice_'+goodsId).removeAttr("readonly").val((auditSettlementPrice/100).toFixed(2));
				$('#adultPrice_'+goodsId).removeAttr("readonly").val((auditPrice/100).toFixed(2));	
			}
			$('#adultSettlePrice_'+goodsId).removeAttr("readonly").val((auditSettlementPrice/100).toFixed(2));
			$('#adultPrice_'+goodsId).removeAttr("readonly").val((auditPrice/100).toFixed(2));					
		}
		
		// 设置儿童价格
		var childSettlementPrice = arr.childSettlementPrice;
		var childPrice = arr.childPrice;	
		if(childSettlementPrice==null){
			var jsCheckBoxes = $(":checkbox[class*=JS_checkbox_lock_item]",thisPriceDIV);
			if(jsCheckBoxes.length > 1){
				jsCheckBoxes.eq(1).trigger("click");
				priceLockHandler.call(jsCheckBoxes.eq(1));
				jsCheckBoxes.eq(1).attr('checked','checked');
			}
		}else{
			$('#childSettlePrice_'+goodsId).removeAttr("readonly").val((childSettlementPrice/100).toFixed(2));
			$('#childPrice_'+goodsId).removeAttr("readonly").val((childPrice/100).toFixed(2));	
			$(":checkbox[class*=JS_checkbox_lock_item]",thisPriceDIV).eq(1).removeAttr('checked').removeAttr("disabled");
			$("select",thisPriceDIV).eq(1).removeAttr("disabled");
			lockUpBox.removeAttr('checked');
		}
		
		// 设置房差价格
		var grapSettlementPrice = arr.grapSettlementPrice;
		var gapPrice = arr.gapPrice;	
		if(grapSettlementPrice==null){
//			$('#gapSettlePrice_'+goodsId).attr("readonly","");
//			$('#gapPrice_'+goodsId).attr("readonly","");
			var jsCheckBoxes = $(":checkbox[class*=JS_checkbox_lock_item]",thisPriceDIV);
			if(jsCheckBoxes.length > 1){
				jsCheckBoxes.eq(2).trigger("click");
				priceLockHandler.call(jsCheckBoxes.eq(2));
				jsCheckBoxes.eq(2).attr('checked','checked');
			}
		}else{
			$('#gapSettlePrice_'+goodsId).removeAttr("readonly").val((grapSettlementPrice/100).toFixed(2));
			$('#gapPrice_'+goodsId).removeAttr("readonly").val((gapPrice/100).toFixed(2));		
			$(":checkbox[class*=JS_checkbox_lock_item]",thisPriceDIV).eq(2).removeAttr('checked').removeAttr("disabled");
			$("select",thisPriceDIV).eq(2).removeAttr("disabled");
			lockUpBox.removeAttr('checked');
		}
		if(lockUpBox.attr("checked") != "checked" && $(":checkbox[class*=JS_checkbox_lock_item]",thisPriceDIV).length > 1){
			$(":checkbox[class*=JS_checkbox_lock_item]",thisPriceDIV).removeAttr("disabled");
		}
		
		$(":checkbox[class*=modifybox]",thisPriceDIV).removeAttr("disabled").removeAttr("checked");
		
		
		
		// 设置提前预定时间
		var aheadBookTime = arr.aheadBookTime;
		var bookLimitType = arr.bookLimitType;
		var time = parseInt(aheadBookTime);
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
		$('#aheadBookTime_day_'+goodsId).find("option[value='"+day+"']").attr("selected",true);
		$('#aheadBookTime_hour_'+goodsId).find("option[value='"+hour+"']").attr("selected",true);
		$('#aheadBookTime_minute_'+goodsId).find("option[value='"+minute+"']").attr("selected",true);
		$('#bookLimitType_'+goodsId).find("option[value='"+bookLimitType+"']").attr("selected",true);
		
		// 退改
		var strategyType = arr.cancelStrategy;
		$(":radio[name=selectCancelStrategy][value="+strategyType+"]","#strategyContainer").attr("checked","checked");
		
		//加载阶梯退改规则
		if(arr.cancelStrategyRules!=null){
			loadExistRefundRules(arr.cancelStrategyRules);
		}
		if(strategyType == "RETREATANDCHANGE"){
			$("#btnAddLadder").removeAttr("disabled");
			$("#btnAddLadder").show();
			$("#ladderRetreatContainer").show();
			$("#cancelTimeTypeDiv").show();
		}else{
			$("#btnAddLadder").attr("disabled", true);
			$("#btnAddLadder").hide();
			$("#ladderRetreatContainer").hide();
			$("#cancelTimeTypeDiv").hide();
		}
		
		
		// 行程
		var lineValue = arr.routeName;
		$("select[name=lineRouteId]","#lineRouteContainer").find("option[value="+lineValue+"]").attr('selected','selected');
		$(":radio[name=selectCancelStrategy][value="+strategyType+"]","#strategyContainer").attr("checked","checked");
		
		//设置买断
		
		
		var objs = $(":radio[name=isPreControlPrice"+goodsId+"]");
		if(arr.isPreControl=='Y'){
			objs.eq(1).removeAttr("checked");
			objs.eq(0).attr("checked","checked");
			var rePreSaleFlag = arr.preSaleFlag;
			var preSaleFlagRadios = $(":radio[name=useBudgePrice"+goodsId+"]");
			if(rePreSaleFlag == "Y"){
				preSaleFlagRadios.eq(1).removeAttr("checked");
				preSaleFlagRadios.eq(0).attr("checked","checked");
			}else{
				preSaleFlagRadios.eq(0).removeAttr("checked");
				preSaleFlagRadios.eq(1).attr("checked","checked");
				showPreControl(preSaleFlagRadios.eq(1));
			}
			
			var thisPriceDIV = $("div[goodsid="+goodsId+"]","#priceContainer_pre");
			// 设置成人价格
			var auditSettlementPrice_pre = arr.auditSettlementPrice_pre;
			var auditPrice_pre = arr.auditPrice_pre;		
			if(auditSettlementPrice_pre==null){
				
			}else{
				$('#adultSettlePrice_pre_'+goodsId).removeAttr("readonly").val((auditSettlementPrice_pre/100).toFixed(2));
				$('#adultPrice_pre_'+goodsId).removeAttr("readonly").val((auditPrice_pre/100).toFixed(2));					
			}
				
			// 设置儿童价格
			var childSettlementPrice_pre = arr.childSettlementPrice_pre;
			var childPrice_pre = arr.childPrice_pre;	
			if(childSettlementPrice_pre==null){
				var jsCheckBoxes = $(":checkbox[class*=JS_checkbox_lock_item]",thisPriceDIV);
				if(jsCheckBoxes.length > 1){
					jsCheckBoxes.eq(1).trigger("click");
					priceLockHandler.call(jsCheckBoxes.eq(1));
					jsCheckBoxes.eq(1).attr('checked','checked');
				}
			}else{
				$('#childSettlePrice_pre_'+goodsId).removeAttr("readonly").val((childSettlementPrice_pre/100).toFixed(2));
				$('#childPrice_pre_'+goodsId).removeAttr("readonly").val((childPrice_pre/100).toFixed(2));	
				$(":checkbox[class*=JS_checkbox_lock_item]",thisPriceDIV).eq(1).removeAttr('checked').removeAttr("disabled");
				$("select",thisPriceDIV).eq(1).removeAttr("disabled");
			}	
		}else
		{
			objs.eq(0).removeAttr("checked");
			objs.eq(1).attr("checked","checked");
			var isMulti = null;
			var o = $(":checkbox[value="+goodsId+"][data_price_type*=_PRICE]");
			isMulti = o.attr("data_price_type") == "SINGLE_PRICE";
			if(!isMulti){
				objs.eq(1).trigger("click");
			}else{
				objs.eq(1).trigger("click");
			}	
		}
		if(arr.bringPreSale=='Y'){
			$("#Set_PreSale").find("div[goodsId="+goodsId+"]").find("input[name='bringPreSale"+goodsId+"']").eq(0).attr("checked","checked");
			$("#Set_PreSale").find("div.isPreSaleDiv"+goodsId).show();
			$("#Set_PreSale").find("div[goodsId="+goodsId+"]").find("input[name='showPreSale_pre'][goods='hotel"+goodsId+"']").val(arr.hotelShowPreSale_pre/100==0?'':(arr.hotelShowPreSale_pre/100).toFixed(2));
			if(arr.hotelIsBanSell=='Y'){
				$("#Set_PreSale").find("div[goodsId="+goodsId+"]").find("input[name='showPreSale_pre'][goods='hotel"+goodsId+"']").attr("disabled","disabled");	
			}
		}else{
			$("#Set_PreSale").find("div[goodsId="+goodsId+"]").find("input[name='bringPreSale"+goodsId+"']").eq(1).attr("checked","checked");
			$("#Set_PreSale").find("div[goodsId="+goodsId+"]").find("input[name='showPreSale_pre'][goods='hotel"+goodsId+"']").val("");
			$("#Set_PreSale").find("div.isPreSaleDiv"+goodsId).hide();
			if(arr.hotelIsBanSell=='Y'){
				$("#Set_PreSale").find("div[goodsId="+goodsId+"]").find("input[name='showPreSale_pre'][goods='hotel"+goodsId+"']").attr("disabled","disabled");	
			}
		}
	}
	
	//加载已有的退改规则
	 function loadExistRefundRules(rules){
		 $("#ladderRetreatContainer").empty();
		 ladderIndex = 0;
	 	rules.forEach(function (rule) {
			if(rule.cancelTimeType == 'OTHER') {
				$("#cancelTimeType").attr("checked", true);
				$("#ladderRetreat_rule_indexId").val(rule.deductType);
				$("#ladderRetreat_type_indexId").val(rule.applyType);
				$("#ladderRetreat_value_indexId").val(rule.deductValueYuan);
			}else {
				ladderEventHandler();
				var time = parseInt(rule.cancelTime);
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
				var j = ladderIndex - 1;
				$('#ladderRetreatTime_day_'+j).val(day);
				$('#ladderRetreatTime_hour_'+j).val(hour);
				$('#ladderRetreatTime_minute_'+j).val(minute);
				$('#ladderRetreat_type_'+j).val(rule.applyType);
				$('#ladderRetreat_rule_'+j).val(rule.deductType);
				$('#ladderRetreat_value_'+j).val(rule.deductValueYuan);
				changeLadderRetreatRule(j);
			}
	 	});
	 }
	
	//设置选择日期数据
	function setSelectDate(){
		var selectCalendar = $('input[name=nfadd_date]:checked').val();  //取值：selectDate【日历框】  selectTime 【时间段】
		$("#timePriceFormContent").append('<input type="hidden" name="selectCalendar" value="'+selectCalendar+'">');
		//如果是日历框
		if(selectCalendar=='selectDate'){
			$("#selDate option").each(function(){
				$("#timePriceFormContent").append('<input type="hidden" name="selectDates" value="'+$(this).val()+'">');
			});
		}
	}
	//错误提示集合地
	function getErrorInfo(index,eles){
		$.map(eles,function(ele){
			if($(ele).length>0)
			$(ele).addClass("red-border-err");
		});
		errEles=[];
		return ["请校验库存类型以及相应的库存数（库存数必须是数字）",
		        "请校验相应库存数（库存数不能小于0）",
		        "请选择具体行程",
		        "请校验您输入的价格（商品价格必须是数字）",
		        "请校验您输入的价格（商品价格不能为负数）",
		        "请校验您选择的退改规则",
		        "禁售时，价格应该为空",
		        "最大不能超过9999999",
		        "请选择对应商品的预授权限制",
		        "请选择提前预定时间",
		        "价格最大不能超过100000000",		        
		        "阶梯退改退款值或者退款比例不能为空",
		        "扣款比例不能超过100%"][index];
	}
	
	
	//获取页面数据，发送后台
	function saveSaleInfo(e){
		if($('input[name=nfadd_date]:checked').val()=='selectDate'){
			if($('#selDate').find('option').size()==0){
				alert("请选择日期");
				return false;
			}
		}else{
			 if($("input[type=checkbox][name=weekDay]:checked").size()==0){
			 	alert("请选择适用日期");
			 	return false;
			 }
			 if($('#d4321').val().length<=0){
			 	alert("请选择开始时间");
			 	return false;
			 }
			 if($('#d4322').val().length<=0){
			 	alert("请选择结束时间");
			 	return false;			 
			 }
			 var weeks = []; 
			 $("input[type=checkbox][name=weekDay]:checked").each(function(){
				weeks.push($(this).val());
			 
			 })
			 var a = $('#d4321').val() ; 
			 var b = $('#d4322').val();
			 
			 if(!validWeekHasDate(a,b,weeks)){
				 alert("开始时间到结束时间，不在你所选择的适用日期中");
				 return false;
			 }
			 
		}
		//如果是品类是酒店套餐 
		var hotelcombValue = $("#category_route_hotelcomb_input").val();
		if(hotelcombValue=="category_route_hotelcomb"){//酒店套餐

			//Added by yangzhenzhong 价格标签如果没有选中，不保存，则不校验
			var priceStatus= $("#priceContainer").attr("class");
			if(priceStatus=="tab-pane active"){
				//校验开售状态
				var forbieValue = validateForbiebutton();
				if(forbieValue==false)
				{
					alert("请选择销售状态");
					return;
				}
			}
		  	//校验价格
		  	var modifyResult = validateModifyCheckbox();
			if(modifyResult==false)
		  	{
		  		return;
		  	}
		}else{
			validInitPrice();
			}
		var tabPage = $("ul[class*=JS_tab_main]"); 
		var tab = tabPage.find("li[class=active]");
		var tabIndex = tabPage.find("li").index(tab);
		var $partFromContent=$("#timePriceFormContent");
		$partFromContent.empty();
		$(".red-border-err").removeClass("red-border-err");
		//选择的时间日子
		setSelectDate();
		var formChecked = false;
		formChecked = $(".my_adult_child:checked,.my_comb_hotel:checked,.my_addition:checked,.my_upgrade:checked,.my_change_hotel:checked").length > 0;
		if(formChecked == false && tabIndex!=4 && tabIndex!=3){
			alert("请勾选你需要修改的商品");
			return false;
		}
		//整合商品的【价格，禁售】，【库存，是否超卖】，【提前预定时间，预付预授权限制】 信息
		switch(tabIndex){
			case 0:
				var ob = stockTypeChange();
				if(jQuery.type(ob) === "object"){
					if(!isNaN(ob.code)){
						var datas = ob.datas;
						var text = "商品：[ ";
						for(var d in datas){
							var data = datas[d];
							var id = data.goodsId;
							var goodsName = $(":checkbox[value="+id+"]").attr("data_name");
							text = text + goodsName +",";
						}
						text = text.substring(0,text.length-1) + " ];\r\n";
						text = text + "在你选择的日期内存在买断价，如库存类型从切位变为其他类型，系统将自动禁用该日期的买断价;\r\n";
						text = text + "\r\n是否继续修改？\r\n";
						var ret = confirm(text);
						
						if(!ret ){
							return false;
						}else{
							
						}
					}
				}else{
					alert("系统出错，请重试");
					return false;
				}
				
				
				
				//库存
				saveInfoUrl="/vst_admin/lineMultiroute/goods/timePrice/editExistsSuppGoods.do?updateWhat=0&categoryId=17";
				var ret = scaleGoodsStock();
				if(ret!=-1){
					alert(getErrorInfo(ret,errEles));
					return false;
				}
				break;
			case 1:
				//价格
				saveInfoUrl="/vst_admin/lineMultiroute/goods/timePrice/editExistsSuppGoods.do?updateWhat=1";
				var hotelcombValue = $("#category_route_hotelcomb_input").val();
				//不是酒店套餐执行以前的逻辑
				 if(hotelcombValue!="category_route_hotelcomb"){//酒店套餐
					var modifyCheckbox = $("#priceContainer").find(":checkbox[class*=modifybox]");
					var hasModify = false;
					modifyCheckbox.each(function(k){
						var mb = modifyCheckbox.eq(k);
						if(mb.attr("checked") == "checked"){
							hasModify = true;
						}
					});
					if(hasModify == false){
						alert("您没有修改任何价格，勿忘勾选修改标记");
						return false;
					}
					var ret = scaleGoodsPrice();
					if(ret!=-1){
						alert(getErrorInfo(ret,errEles));
						return false;
					}
				}else{
					addHotelCombGoodsPrice();
				}
				break;
			case 2:
				//预定时间
				saveInfoUrl="/vst_admin/lineMultiroute/goods/timePrice/editExistsSuppGoods.do?updateWhat=2";
				var ret = scaleGoodsAheadTime();
				if(ret != -1){
					alert(getErrorInfo(ret,errEles));
					return false;
				}
				break;
			case 3:
				//退改规则
				saveInfoUrl="/vst_admin/prod/refund/editExistsProductReFund.do";

				var canCelStategy = $('input[name=selectCancelStrategy]:checked').val();
				if(!canCelStategy){
					alert('请选择退改规则');
					return false;
				}

				var ret = setCancelStrategy();
				//如果是日历框
				var selectCalendar = $('input[name=nfadd_date]:checked').val();  //取值：selectDate【日历框】  selectTime 【时间段】
				if(selectCalendar=='selectDate'){
					$("#selDate option").each(function(){
						$("#timePriceFormContent").append('<input type="hidden" name="specDates" value="'+$(this).val()+'">');
					});
				}
				if(ret != -1){
					if(ret == -2){
						return false;
					}
					alert(getErrorInfo(ret,errEles));
					return false;
				}
				
				break;
			case 4:
				//行程
				saveInfoUrl="/vst_admin/prod/prodLineRoute/updateExistsLineRouteDate.do";
				var select = $("select[name*=lineRouteId] option:selected").val();
				if(select == -1){
					alert(getErrorInfo(2,errEles));
					return false;
				}
				//行程已经在form中有了
				break;
			case 5:
				//买断价格设置 
				saveInfoUrl="/vst_admin/lineMultiroute/goods/timePrice/editExistsSuppGoods.do?updateWhat=5";
				var modifyCheckbox = $("#priceContainer_pre").find(":checkbox[class*=modifybox]:[class*=isPreMod]");
				var hasModify = false;
				var isBudgePrice = '';
				modifyCheckbox.each(function(k){
					var mb = modifyCheckbox.eq(k);
					if(mb.attr("checked") == "checked"){
						hasModify = true;
					}
				});
				if(hasModify == false && modifyCheckbox.length!=0){
					alert("您没有修改任何价格，勿忘勾选修改标记");
					return false;
				}
				
				var ret;
				var type = $('.priceDiv').attr('divtype');
				if(type=='my_comb_hotel'){
					ret = scaleCombHotel();
				}
				
				if(type=='my_adult_child'){
					//判断是否更新买断设置
					var isBudge  = toPreBudgeGoodsEdit(isBudgePrice);
					if(isBudge){
						ret = scalePreGoodsPrice();
						isBudgePrice = null;
					}else{
						return false;
					}					
				}
				if(ret!=-1){
					alert(getErrorInfo(ret,errEles));
					return false;
				}
				break;
			case 6:
				saveInfoUrl="/vst_admin/lineMultiroute/goods/timePrice/editExistsSuppGoods.do?updateWhat=6";
				var ret = setPreSaleIdData();
				if(ret != -1){
					alert(getErrorInfo(ret,errEles));
					return false;
				}
				break;
		}
		
		//alert(saveInfoUrl);
		//check  毛利
		var result = getLowerGrossMargin();
		if(result!=null&&result.code=='WITH_LOWER'){
			lowPriceDialog = new xDialog("/vst_admin/goods/grossMargin/showAddLowPrice.do",{},{title:"低毛利上架原因",width:"600"});
        }else{
        	submitTimePrice(saveInfoUrl);
        }
		
		
	    
	}
	//提交毛利
	function submitLowPrice(){
		$.ajax({
            url : '/vst_admin/goods/grossMargin/saveGrossMarginLogs.do',
            method: 'POST',
            data : $("#lowPriceForm,#timePriceForm").serialize(),
            async : false,
            success : function(result){
                lowPriceDialog.close();
            }
        })
	}
	
	//毛利回调  ~  保存修改。
	function submitTimePrice(saveInfoUrl){
		var postUrl = "";
		if(saveInfoUrl!= 'undefined' && saveInfoUrl != ""){
			postUrl = saveInfoUrl;
		}
		if(postUrl == ""){
			alert("postUrl 错误！");
			return false;
		}
		//step3 : submitData
	    var loading = top.pandora.loading("正在努力保存中...");
		$.ajax({
			url : postUrl,
			data :$("#timePriceForm").serialize(),
			dataType:'JSON',
			type: "POST",
			success : function(result){
				var msg = result.message ;
				if(result.code == 'validateStock'){ //Added by yangzhenzhong 酒店套餐校验库存
					alert("库存数不能小于"+msg+"(已售出的库存数)");
				}else{
					alert(result.message + "（注：系统只针对已存在的商品做修改操作）");
					if((msg+"").indexOf("成功")>= 0 ){
						clearPageDataAfterUpdate();
						window.location.reload();
					}
				}
			},
			complete:function(){
				loading.close();
			}
		});
	}
	
	//选中日历框的日期
	function selectDateCallback(){
		getDataIfSameDay();
	}
	
	//校验是否是只有一天，如果只有一天的话，返回该日期。
	function getDateIfOneDaySelected(){
		var thisDate = "";
		//如果是日历框
		var selectCalendar = $('input[name=nfadd_date]:checked').val();  //取值：selectDate【日历框】  selectTime 【时间段】
		if(selectCalendar=='selectDate'){
			var dates = $("#selDate option");
			if(dates.length == 1){
				thisDate =$("#selDate option").eq(0).val(); 
			}
			if(dates.length != 1){
				var goodsArr= [];
				$(".my_adult_child,.my_comb_hotel,.my_addition,.my_upgrade,.my_change_hotel").each(function(){
					var _this = $(this);
					if(_this.attr("checked") == 'checked'){
						goodsArr.push(_this.val());
					}
				});
				initGoodsInfo(goodsArr);
				if(dates.length == 0){
					//行程初始化
					$("select[name=lineRouteId]").find("option:first-child").attr("selected","selected");
				}
				var hotelcombValue = $("#category_route_hotelcomb_input").val();
				if(hotelcombValue=="category_route_hotelcomb"){//酒店套餐
					initializeBranchPrice();
					$("#branchAdultPrice").attr("readonly","readonly");
					$(".JS_price_settlement").attr("readonly","readonly");
					$(".JS_price_selling").attr("readonly","readonly");
					$(".cleanSelected").attr("checked",false);
					$(".JS_checkbox_lock_item").val("");
				}
				
			}
		}else{
			var startDate = $("#d4321").val();
			var endDate = $("#d4322").val();
			if(startDate == endDate){
				thisDate = startDate;
			}else{
				var goodsArr= [];
				$(".my_adult_child,.my_comb_hotel,.my_addition,.my_upgrade,.my_change_hotel").each(function(){
					var _this = $(this);
					if(_this.attr("checked") == 'checked'){
						goodsArr.push(_this.val());
					}
				});
				initGoodsInfo(goodsArr);
				if(startDate == "" || endDate == ""){
					//行程初始化
					$("select[name=lineRouteId]").find("option:first-child").attr("selected","selected");
				}
			}
		}
		var hotelcombValue = $("#category_route_hotelcomb_input").val();
		if(hotelcombValue=="category_route_hotelcomb"){//酒店套餐
			closeHotelCombPrice();
		}
		return thisDate ;
	}
	
	//设置退改规则数据
	function setCancelStrategy(){	
		var ret=-1;		
		var canCelStategy = $('input[name=selectCancelStrategy]:checked').val();
		$(".red-border-err").removeClass("red-border-err");
		if("MANUALCHANGE UNRETREATANDCHANGE RETREATANDCHANGE".indexOf(canCelStategy)<0){
			return 5;
		}
		var timeStr = "";//时间拼接（用以判断是否有重复）
		var numStr = "";//退改金额拼接（用以判断金额是否重复）
		$('#cancelStrategy').val(canCelStategy);
		if(canCelStategy=="RETREATANDCHANGE"){
			$("#ladderRetreatContainer").find("div[divtype='my_ladder_retreat']").each(function(i){
			    var that = $(this);
				if($.trim(that.html())!=''){
				    var day = parseInt(that.find("select[name=ladderRetreatTime_day]").val());
					if(day == -1){
						alert("阶梯退改第"+(i+1)+"条，提前天数不能为空");
						ret = -2;
						return ret;
					}
					var hour = parseInt(that.find("select[name=ladderRetreatTime_hour]").val());
					if(hour == -1){
						alert("阶梯退改第"+(i+1)+"条，提前小时不能为空");
						ret = -2;
						return ret;
					}
					var minute = parseInt(that.find("select[name=ladderRetreatTime_minute]").val());
					if(minute == -1){
						alert("阶梯退改第"+(i+1)+"条，提前时间分钟不能为空");
						ret = -2;
						return ret;
					}

					var time = day+"_"+hour+"_"+minute;
					if(timeStr.indexOf(time) > 0){
						alert("阶梯退改第"+(i+1)+"条，提前时间重复");
						ret = -2;
						return ret;
					}
					timeStr = timeStr + "%" + time;

					var rule = that.find("select[name=ladderRetreatRule]").val();
					var value = that.find("input[name=ladderRetreatValue]").val();
					if(rule == "PERCENT" && value > 100){
						alert("阶梯退改第"+(i+1)+"条，扣款类型为百分比时，比例不能超过100");
						ret = -2;
						return ret;
					}
					if(rule == "PERCENT" && value == ""){
						alert("阶梯退改第"+(i+1)+"条，扣款比例不能为空");
						ret = -2;
						return ret;
					}
					if(rule == "AMOUNT" && value == ""){
						alert("阶梯退改第"+(i+1)+"条，扣款值不能为空");
						ret = -2;
						return ret;
					}

					var num = rule+"_"+value;
					if(numStr.indexOf(num) > 0){
						alert("阶梯退改第"+(i+1)+"条，扣款值和扣款类型重复");
						ret = -2;
						return ret;
					}
					numStr = numStr + "%" + num;
				}
			        
		    });
			if($("#cancelTimeType").attr("checked")) {
				var rule = $('#ladderRetreat_rule_indexId').val();
				var clonevalue = $('#ladderRetreat_value_indexId').val();
				if(rule == "PERCENT" && clonevalue > 100){
					alert("阶梯退改最后一条，扣款类型为百分比时，比例不能超过100");
					ret = -2;
					return ret;
				}
				if(rule == "PERCENT" && (clonevalue == ""||clonevalue=="undefined")){
					alert("阶梯退改最后一条，扣款比例不能为空");
					ret = -2;
					return ret;
				}
				if(rule == "AMOUNT" && (clonevalue == ""||clonevalue=="undefined")){
					alert("阶梯退改最后一条，扣款值不能为空");
					ret = -2;
					return ret;
				}
				var num = rule+"_"+clonevalue;
				if(numStr.indexOf(num) > 0){
					alert("阶梯退改最后一条，扣款值和扣款类型重复");
					ret = -2;
					return ret;
				}
				numStr = numStr + "%" + num;
			}

			//判断阶梯退改规则是否是至少有一条
			if(canCelStategy=="RETREATANDCHANGE"){
				if(ladderIndex == 0 && !$("#cancelTimeType").attr("checked")){
					alert("可退改规则至少存在一条");
					ret = -2;
					return ret;
				}
			}

			//设置阶梯退改规则数据
	    	setCancelStrategyRules();
		}
		return ret;
	}
	//设置阶梯退改规则详情
	function setCancelStrategyRules(){
		for (var i=0;i<ladderIndex;i++){
			var day = $('#ladderRetreatTime_day_'+i).val();
		    var hour = $('#ladderRetreatTime_hour_'+i).val();
		    var minute = $('#ladderRetreatTime_minute_'+i).val();
		    var type = $('#ladderRetreat_type_'+i).val();
		    var rule = $('#ladderRetreat_rule_'+i).val();
		    var clonevalue = $('#ladderRetreat_value_'+i).val();
		   
		    var totalMinutes = getTotalMinute(day,hour,minute);
		    $("#timePriceFormContent").append('<input type="hidden" name="prodRefundRules['+i+'].cancelTime" value="'+totalMinutes+'">');
		    $("#timePriceFormContent").append('<input type="hidden" name="prodRefundRules['+i+'].applyType" value="'+type+'">');
		    $("#timePriceFormContent").append('<input type="hidden" name="prodRefundRules['+i+'].deductType" value="'+rule+'">');
		    
		    var start = clonevalue.lastIndexOf(".");
    		var len = clonevalue.length-1;
    		var decimallen = len - start;  
		    //parseInt精度有问题0.1变0.099
    		if(clonevalue.indexOf(".") == -1){    			
    			inputValue = parseInt(clonevalue*100,0);
    		}else if(decimallen == 1){
    			inputValue = clonevalue.replace(".","")+"0";    			
    		}else if(decimallen == 2){
    			inputValue = clonevalue.replace(".","");
    		}
		    inputValue = parseInt(inputValue);
		    
		    $("#timePriceFormContent").append('<input type="hidden" name="prodRefundRules['+i+'].deductValue" value="'+inputValue+'">');
		}
		if($("#cancelTimeType").attr("checked")){
			var type = $('#ladderRetreat_type_indexId').val();
			var rule = $('#ladderRetreat_rule_indexId').val();
			var clonevalue = $('#ladderRetreat_value_indexId').val();
			var start = clonevalue.lastIndexOf(".");
			var len = clonevalue.length-1;
			var decimallen = len - start;
			if(clonevalue.indexOf(".") == -1){
				inputValue = parseInt(clonevalue*100,0);
			}else if(decimallen == 1){
				inputValue = clonevalue.replace(".","")+"0";
			}else if(decimallen == 2){
				inputValue = clonevalue.replace(".","");
			}
			inputValue = parseInt(inputValue);
			$("#timePriceFormContent").append('<input type="hidden" name="prodRefundRules['+ladderIndex+'].applyType" value="'+type+'">');
			$("#timePriceFormContent").append('<input type="hidden" name="prodRefundRules['+ladderIndex+'].deductType" value="'+rule+'">');
			$("#timePriceFormContent").append('<input type="hidden" name="prodRefundRules['+ladderIndex+'].deductValue" value="'+inputValue+'">');
			$("#timePriceFormContent").append('<input type="hidden" name="prodRefundRules['+ladderIndex+'].cancelTimeType" value="OTHER">');
		}
	}
	//库存信息
	function scaleGoodsStock(){

		var ret=-1;
		$(".stockDiv").each(function(i){
			var that = $(this);
			var goodsId = that.attr("goodsId");
	    	//创建商品Id
	    	$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].suppGoodsId" value="'+goodsId+'">');
		    	//库存类别
		    	var stockType=that.find(':radio[name*=adultStock]:checked').eq(0).val();
		    	if(stockType!='INQUIRE_NO_STOCK'){
		    		var stockEle = that.find(':radio[name*=adultStock]:checked').eq(0).parents(".JS_radio_switch_box").find(":text[class*=form-control]").eq(0);
		    		var stockValue= stockEle.val();
		    		if(!$.isNumeric(stockValue)){
		    			errEles.push(stockEle);
		    			ret=0;
		    		}else if(stockValue < 0 ){
		    			errEles.push(stockEle);
		    			ret=1;
		    		}
		    		$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].stock" value="'+stockValue+'">');
		    	}
		    	if(stockType==null || stockType==''){
		    		stockType = 'INQUIRE_NO_STOCK';
		    	}
	    		$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].stockType" value="'+stockType+'">');
	    		//是否可超卖
	    		var isAdultOversold=that.find(':radio[name*=adultOversold]:checked').eq(0).val();
	    		$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].oversellFlag" value="'+isAdultOversold+'">');
	    });
		return ret ;
	}
	//提前预定时间
	function scaleGoodsAheadTime(){
		var ret = -1;
		$(".timeDiv").each(function(i){
			var that = $(this);
			var goodsId = that.attr("goodsId");
	    	//创建商品Id
	    	$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].suppGoodsId" value="'+goodsId+'">');
		    //该商品的提前预定时间-转成分xxxxx
		    var day = that.find('select[name*=aheadBookTime_day] option:selected').val();
		    var hour = that.find('select[name*=aheadBookTime_hour]  option:selected').val();
		    var minute = that.find('select[name*=aheadBookTime_minute]  option:selected').val();
		    if(day ==-1 && hour ==-1 && minute ==-1){
		    	ret = 9;
		    	return false;
		    }
		    var totalMinutes = getTotalMinute(day,hour,minute);
		    $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].aheadBookTime" value="'+totalMinutes+'">');
		    //该商品的预付预授权限制
		    var bookLimitType = that.find('select[name*=bookLimitType]  option:selected').val();
		    $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].bookLimitType" value="'+bookLimitType+'">');
		    if(bookLimitType == -1){
		    	ret = 8;
		    	errEles.push(that.find('select[name*=bookLimitType]'));
		    }
	    });
		return ret ;
	}
	
	//整合商品价格信息
	function scaleGoodsPrice(){
		
		var ret = -1;
		//用来放置商品列表的下标
		var goodNum = 0;
		$(".priceDiv").each(function(i){
			var that = $(this);
			var goodsId = that.attr("goodsId");
			goodNum = $("#timePriceFormContent").find(":hidden[name*='].suppGoodsId']").length;
	    	//$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].priceType" value="settlement">');   //price 销售价， settlement结算价
	    	//该商品的价格
	    	//设置禁售  开始
	    	//多价格的禁售
	    	var modifyCheckbox = $(this).find(":checkbox[class*=modifybox]");
	    	//多价格下的修改复选框是否是都没有被选中，只要有一个被选中了，那么就可以传商品禁售标志了。即 allBoxesUnchecked==false时要考虑传onsaleflag 标志，否则不传；
	    	var allBoxesUnchecked = true;
	    	if(modifyCheckbox.length>1){
	    		modifyCheckbox.each(function(t){
	    			var b = modifyCheckbox.eq(t);
	    			if(b.attr("checked") == "checked"){
	    				allBoxesUnchecked = false;
	    			}
	    		});
	    	}
	    	
	    	var allLockupBox = that.find("div[class*=product-lock-up-all] .JS_checkbox_lock_all");
	    	var goodsAllIsLockup="";
	    	if(allLockupBox != null && allLockupBox != 'undefined' && allLockupBox.length > 0 && allBoxesUnchecked == false){
	    		//创建商品Id
		    	$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+goodNum+'].suppGoodsId" value="'+goodsId+'">');
	    		goodsAllIsLockup = allLockupBox.attr("checked");
		    	if(goodsAllIsLockup == 'checked'){
		    		$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+goodNum+'].onsaleFlag" value="N">');
		    	}else{
		    		$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+goodNum+'].onsaleFlag" value="Y">');
		    	}
	    	}
	    	
	    	//单价格的禁售
	    	
	    	var singlebox = null;
	    	if(modifyCheckbox.length ==1 ){
	    		singlebox = modifyCheckbox.eq(0);
	    	}
	    	var firstLockupVal = "";
		    var lockupBoxes = that.find("div[class*=form-group] .JS_checkbox_lock_item");
		    firstLockupVal = lockupBoxes.eq(0).attr("checked");
		   	if(lockupBoxes != null && lockupBoxes.length == 1 && singlebox!=null && singlebox.attr("checked") == "checked"){
		   		
		   		//	创建商品Id
		    	$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+goodNum+'].suppGoodsId" value="'+goodsId+'">');
		   		
		   		if(firstLockupVal == 'checked'){
		    		$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+goodNum+'].onsaleFlag" value="N">');
		    	}else{
		    		$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+goodNum+'].onsaleFlag" value="Y">');
		    	}
	    	}
	    	
	    	//设置禁售结束
			that.find('div[class*=JS_price_group]').each(function(j){
				
				var modifyCheckbox = $(this).find(":checkbox[class*=modifybox]");
				var isModify = false;
				if(modifyCheckbox.length >0){
					var box = modifyCheckbox.eq(0);
					if(box.attr("checked") == "checked"){
						isModify = true;
					}
				}
				if(isModify == false){
					return ;
				}
				
				
				var inputs = $(this).find("*[class*=form-control]");  //获取结算价，操作，操作数的input框
				//结算价
				var settleInput = inputs.eq(0);
				var settlementPrice = settleInput.val();
				//操作  【custom自定义，fixed固定，percent比例加价，equal销售价=结算价】
				var actionType=inputs.eq(1).val();
				// 操作数
				var actionPrice=inputs.eq(2).val();
				//销售价
				var priceInput = inputs.eq(3); 
				var price=priceInput.val(); 
				//成人价还是儿童价   还是房差
				var peopleType = inputs.eq(4).val();
				
				//如果多价格中成人，儿童，房差全部禁售了；或者单价禁售了 ； 则---将价格清空
				if(goodsAllIsLockup == 'checked' || (firstLockupVal=='checked' && lockupBoxes.length == 1)){
					if(hideLabel){//酒店套餐
						price = price * 100;
						settlementPrice = settlementPrice * 100; 
					}else{
						price = "";
						settlementPrice = "";
					}
				}else{
					var isJShou = inputs.eq(0).attr("readonly")=='readonly';
					if(isJShou){
						//是禁售，则不用检验
						if($.trim(price)!='' || $.trim(settlementPrice)!=''){
							if($.trim(settlementPrice)!=''){
								errEles.push(settleInput);
							}
							if($.trim(price)!=''){
								errEles.push(priceInput);
							}
							
							ret = 6;
						}
					}else{
						if(price > 999999990){
							ret = 10;
							errEles.push(priceInput);
							return false;
						}
						if(settlementPrice > 999999990){
							ret = 10;
							errEles.push(settleInput);
							return false;
						}
						
						
						if($.isNumeric(price) && $.isNumeric(settlementPrice)){
							price = price * 100;
							settlementPrice = settlementPrice * 100;
						}else{
							if($.trim(price)!='' && $.trim(settlementPrice)!=''){
								if($.trim(settlementPrice)!=''){
									errEles.push(settleInput);
								}
								if($.trim(price)!=''){
									errEles.push(priceInput);
								}
								ret = 3;
							}else{
								if($.trim(settlementPrice)==''){
									errEles.push(settleInput);
								}
								if($.trim(price)==''){
									errEles.push(priceInput);
								}
								ret = 3;
							}
						}
					}
				}
				
				
				if(peopleType=='child'){
					//$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].actionPrice['+j+']" value="'+actionPrice+'">');		
					//$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].peopleType['+j+']" value="'+peopleType+'">');				
					//儿童销售价
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+goodNum+'].childPrice" value="'+price+'">');
					//儿童结算价
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+goodNum+'].childSettlementPrice" value="'+settlementPrice+'">');
					
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+goodNum+'].modChildFlag" value="Y">');
				}else if(peopleType=='audit'){
					//$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].actionPrice['+j+']" value="'+actionPrice+'">');
					//$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].peopleType['+j+']" value="'+peopleType+'">');
					//成人销售价
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+goodNum+'].auditPrice" value="'+price+'">');
					//成人结算价
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+goodNum+'].auditSettlementPrice" value="'+settlementPrice+'">');
					
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+goodNum+'].modAdultFlag" value="Y">');
				}else if(peopleType=='gap'){
					//房差
					//成人销售价
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+goodNum+'].gapPrice" value="'+price+'">');
					//成人结算价
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+goodNum+'].grapSettlementPrice" value="'+settlementPrice+'">');
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+goodNum+'].modGapFlag" value="Y">');
				}else if(peopleType=='singleprice'){
					//单价格-只有成人的价格
					//成人销售价
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+goodNum+'].auditPrice" value="'+price+'">');
					//成人结算价
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+goodNum+'].auditSettlementPrice" value="'+settlementPrice+'">');
					
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+goodNum+'].modAdultFlag" value="Y">');
				}
				//$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].actionType['+j+']" value="'+actionType+'">'); 
			});
	    });
		return ret;
	}
	//设置预售
	function setPreSaleIdData(){
	     var t = 0 ; 
	     var ret = -1;
		$("#Set_PreSale").find("div.preSaleDiv").each(function(i){
			var that = $(this);
			if($.trim(that.html())!=''){
			var goodsId = that.attr("goodsId");
			$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].suppGoodsId" value="'+goodsId+'">');
			if(that.attr("divtype")=='my_comb_hotel'){
		    	//把提前预定时间转换为分钟数	
				var bringPreSale = that.find("[type=radio]:checked").val();
		   		 $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+t+'].bringPreSale" value="'+bringPreSale+'">');
		   		 var hotelShowPreSale_pre = that.find("input[name='showPreSale_pre']").val()*100;
		   		 $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+t+'].hotelShowPreSale_pre" value="'+hotelShowPreSale_pre+'">');
		   		 if(that.find("input[name='showPreSale_pre']").prop("disabled")){
		   			 $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+t+'].hotelIsBanSell" value="Y">');
		   		 }else{
		   			$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+t+'].hotelIsBanSell" value="N">');
		   		 }
		   		 t++;
			}
			}
		});
		return ret;
	}
	//将一行中的价格清空【禁售，全部禁售】
	function priceLockHandler(){
		var that = $(this);
		var thisCheck = that.attr("checked");
		var goodsDivContainer = that.parents("div[goodsId]");
		var priceGroups = goodsDivContainer.find("div[class*=JS_price_group]");
		var checkBoxes = goodsDivContainer.find(":checkbox").not($(".modifybox"));
		var thisCheckBoxIndex = checkBoxes.index(that);
		var selects = null;
		
		//如果点击的是成人的禁售，那么将全部禁售
		if( checkBoxes.length >1 && thisCheckBoxIndex == 0 && false  ){
			
			checkBoxes.not(checkBoxes.last()).attr("disabled","disabled");
			
			priceGroups.find(":text").each(function(i){
				if(thisCheck == 'checked'){
					if(!hideLabel){//非酒店套餐
						$(this).val("");
					}
					$(this).attr("readonly","");
					checkBoxes.not(checkBoxes.last()).attr("disabled","disabled");
					checkBoxes.attr("checked","checked");
					$(".red-border-err",goodsDivContainer).removeClass("red-border-err");
				}else{
					if(i %3 != 1){
						$(this).removeAttr("readonly");
						checkBoxes.not(checkBoxes.last()).removeAttr("disabled");
					}
				}
			});
			selects = priceGroups.find("select");
		}else{
			if(checkBoxes.length==1 || thisCheckBoxIndex == 3){
				var mBoxes = priceGroups.find(":checkbox[class*=modifybox]");
				priceGroups.find(":text").each(function(i){
					if(thisCheck == 'checked'){
						if(!hideLabel){//非酒店套餐
							$(this).val("");
						}
						$(this).attr("readonly","");
						checkBoxes.not(checkBoxes.last()).attr("disabled","disabled");
						$(".red-border-err",goodsDivContainer).removeClass("red-border-err");
						checkBoxes.attr("checked","checked");
						mBoxes.attr("checked","checked").attr("disabled","disabled");
					}else{
						if(i %3 != 1){
							$(this).removeAttr("readonly");
						}
						checkBoxes.removeAttr("checked");
						mBoxes.removeAttr("checked").removeAttr("disabled");
					}
				});
				selects = priceGroups.find("select");
			}else{
				priceGroups.eq(thisCheckBoxIndex).find(":text").each(function(){
					if(thisCheck == 'checked'){
						if(!hideLabel){//非酒店套餐
							$(this).val("");
						}
						$(this).attr("readonly","");
						$(this).removeClass("red-border-err");
					}else{
						$(this).removeAttr("readonly");
					}
				});
				selects = priceGroups.find("select").eq(thisCheckBoxIndex);
			}
		}
		//隐藏百分号
		if(thisCheck == 'checked'){
			priceGroups.find(".JS_price_percent").hide();
		}
		
		
		selects.each(function(){
			if(thisCheck == 'checked'){
				$(this).attr("disabled","disabled");
			}else{
				$(this).removeAttr("disabled");
			}
			$(this).find("option:first-child").attr("selected",true);
		});
		if(checkBoxes.length > 1){
			var checkLength = 0;
			checkBoxes.each(function(i){
				if($(this).attr("checked") == "checked" && $(this).attr("class").indexOf("JS_checkbox_lock_item")>=0){
					checkLength ++;
				}
			});
			
			if(checkLength == checkBoxes.length-1){
				checkBoxes.last().attr("checked","checked");
			}else{
				checkBoxes.last().removeAttr("checked");
			}
		}
		
	}
	
	//当库存类型变化，对应的库存数要清空
	function stockTypeHandler(e){
		var obj = $(e.target);
		var thisGoodsDIV = $(this).parents("div[goodsId]");
		$(".red-border-err",thisGoodsDIV).removeClass("red-border-err");
		
		var parentDiv = obj.parents('div[class*="stockDiv"]');
		 var goodsId = parentDiv.attr('goodsid');
		 var val = obj.val();
		 var preDiv = $("#priceContainer_pre").find('div[goodsid='+goodsId+']');
		 //现询
		 if(val=='INQUIRE_WITH_STOCK' ||val=='INQUIRE_NO_STOCK')
		 {
			$(".isPreControlDiv"+goodsId+"").hide();
		    var useBudgeRadios = $(":radio[name=useBudgePrice"+goodsId+"]");
		    useBudgeRadios.eq(0).removeAttr("checked").attr("disabled","disabled");
		    useBudgeRadios.eq(1).attr("checked","checked").attr("disabled","disabled");
		    showPreControl(useBudgeRadios.eq(1));
		 }else
		 {		   
		   var nameStr = 'isPreControlPrice'+goodsId;
		   $(".isPreControlDiv"+goodsId+"").show();
		   var obj = $("input[name="+nameStr+"][type=radio][class*=closeBudgePrice]:checked");
		    preDiv.show();
		    preDiv.find("input[type=radio]").removeAttr("disabled");
		    if(obj.val()=='Y')
		    {		     
		     preDiv.find("input[type=text]").removeAttr("disabled");
		    }
		 }
		
	}
	
	//保存成功后，清空初始化条件
	function clearPageDataAfterUpdate(tabIndex){
		tabIndex = 0;
		//1、清空商品的勾选
		$("label .my_adult_child,.my_comb_hotel,.my_addition,.my_upgrade,.my_change_hotel").each(function(){
			$(this).removeAttr("checked");
		});
		
		//2、清空日历，时间段，使用日期
		$("label .JS_checkbox_select_all_item,.JS_checkbox_select_all_switch").each(function(){
			$(this).removeAttr("checked");
		});
		
		$(":radio[value=selectTime]").removeAttr("checked");
		$(":radio[value=selectDate]").attr("checked","checked");
		
		// 日历怎么
		$(".JS_select_date td.calSelected[date-map]").removeClass("calSelected");
		$("#selDate option").remove();
		
		$(":text[name=startDate]").val("");
		$(":text[name=endDate]").val("");
		
		//3、清空想应的tab页
		$("#stockContainer").empty();
		$("#priceContainer").empty();
		$("#headTimeContainer").empty();
		$("#priceContainer_pre").empty();
		
		
		//4、使用行程默认-请选择
		$("select[name=lineRouteId]").find("option:first-child").attr("selected","selected");
		//5、退改规则清空
		$('input[name=selectCancelStrategy]:first').attr("checked","checked");
	}
	
	//这里处理的是：如果只选择了一天，那么如果商品在这一天没有数据的话，那么要初始化这个信息
	function initGoodsInfo(goodsIdArr){
		for(var i=0,j=goodsIdArr.length;i<j;i++){
			var goodsId = goodsIdArr[i];
			//库存
			var stockContainer = $("#stockContainer");
			var stockDIV = $("div[goodsId="+goodsId+"]",stockContainer);
			var stockRadios = stockDIV.find(":radio");
			var stockInputs = stockDIV.find(":text");
			stockRadios.removeAttr("checked");
			stockInputs.val("").attr("disabled","disabled");
			stockRadios.eq(3).attr("checked","checked");
			$("i[class*=error]",stockDIV).remove();
			$(":text[class*=error]",stockDIV).removeClass("error");
			
			//价格
			var priceContainer = $("#priceContainer");
			var priceDIV = $("div[goodsId="+goodsId+"]",priceContainer);
			var priceCheckBoxes = priceDIV.find(":checkbox");
			var priceInputs = priceDIV.find(":text");
			priceCheckBoxes.removeAttr("checked");
			priceInputs.each(function(k){
				$(this).val("");
				if(k==1 || k==4 || k==7){
					$(this).attr("readonly","readonly");
				}else{
					$(this).removeAttr("readonly");
				}
			});
			var selects = priceDIV.find("select");
			selects.each(function(p){
				$(this).removeAttr("disabled").find("option:first-child").attr("selected",true);
			});
			priceDIV.find(".JS_price_percent").hide();
			
			$("i[class*=error]",priceDIV).remove();
			$(":text[class*=error]",priceDIV).removeClass("error");
			
			//提前预定时间
			var aheadTimeContainer = $("#headTimeContainer");
			var aheadTimeDIV = $("div[goodsId="+goodsId+"]",aheadTimeContainer);
			selects = aheadTimeDIV.find("select");
			selects.each(function(p){
				$(this).find("option:first-child").attr("selected",true);
			});
			
			//退改规则
			$("#ladderRetreatContainer").empty();
			 ladderIndex = 0;
			 $("#Set_PreSale").find("div[goodsId="+goodsId+"]").find("input[name='bringPreSale"+goodsId+"']").eq(1).attr("checked","checked");
			$("#Set_PreSale").find("div[goodsId="+goodsId+"]").find("input[name='showPreSale_pre'][goods='hotel"+goodsId+"']").val("");
			$("#Set_PreSale").find("div.isPreSaleDiv"+goodsId).hide();
		}		
	}
	
	//检查最低毛利率
	function getLowerGrossMargin(){
		var result = null;
		//获得最低毛利率
		if($(".adult_child:checked,.comb_hotel:checked").size()!=0){
            result = getLowGoodsMargin("/vst_admin/goods/grossMargin/getLowerGrossMargin_Line.do",$("#timePriceForm").serialize());
            return result;
		}else {
            return result;
		}
	}
	
	function insertTemplateToContainer(classType,template,container,goodsId){
		switch(classType){
			case "my_adult_child":
				//最后一个成人儿童
				var adultChilds = $("div[divType=my_adult_child]",$(container));
				if(adultChilds.length>0){
					$(template).insertAfter(adultChilds.last());
				}else{
					$(container).prepend(template);
				}
				break;
			case "my_addition":
				//最后一个附加
				var additions = $("div[divType=my_addition]",$(container));
				if(additions.length>0){
					$(template).insertAfter(additions.last());
					$(".fujia",$("div[goodsId="+goodsId+"]")).hide();
				}else{
					$(container).append(template);
				}
				break;
			case "my_change_hotel":
				//最后一个套餐
				var taoCans = $("div[divType=my_change_hotel]",$(container));
				if(taoCans.length>0){
					$(template).insertAfter(taoCans.last());
					$(".fujia",$("div[goodsId="+goodsId+"]")).text("可换酒店：").hide();
				}else{
					$(container).append(template);
					$(".fujia",$("div[goodsId="+goodsId+"]")).text("可换酒店：");
				}
				break;
			case "my_upgrade":
				//最有一个升级
				var upgrades = $("div[divType=my_upgrade]",$(container));
				if(upgrades.length>0){
					$(template).insertAfter(upgrades.last());
					$(".fujia",$("div[goodsId="+goodsId+"]")).text("升级：").hide();
				}else{
					$(container).append(template);
					$(".fujia",$("div[goodsId="+goodsId+"]")).text("升级：");
				}
				break;
			case "my_comb_hotel":
				//最有套餐
				var tc = $("div[divType=my_comb_hotel]",$(container));
				if(tc.length>0){
					$(template).insertAfter(tc.last());
					$(".fujia",$("div[goodsId="+goodsId+"]")).text("套餐：").hide();
				}else{
					$(container).append(template);
					$(".fujia",$("div[goodsId="+goodsId+"]")).text("套餐：");
				}
				break;
		}
		/*var tips = $(container).find("div[divType='tips']");
		if(tips.length==0){
			var tipDiv = "<div divType='tips' align=center  >Tips:库存类型由切位更改为其他类型，将自动禁用该日期买断价！</div>"
			$(container).prepend(tipDiv);
		}*/
		
	}
	
	//取消按钮
	function cancelEditBtnHandler(){
		window.parent.cancelEditTimeGoodsDialog.close();
	}
	
	
	function validWeekHasDate(a,b,weeks){
		var dateA = new Date(a.split("-"));
		var dateB = new Date(b.split("-"));
		var days =  parseInt(Math.abs(dateB.getTime() - dateA.getTime()) / 1000 / 60 / 60 /24);		
		if(days<6){
			var hasDate = false;
			if(weeks.indexOf((dateA.getDay()+1).toString()) !=-1){
					hasDate = true;
					return true;
			}
			if(!hasDate){
				for(var i = 1;i<=days;i++){
					var week = dateA.getDate()+1;
					dateA.setDate(week);
					if(weeks.indexOf((dateA.getDay()+1).toString()) !=-1){
						hasDate = true;
						return true;
					}
					
				}
				
			}
			if(hasDate){
				return true;
			}
		}else{
			return true;
		}
			
	
		return false;
	}
	
	//时间类型更换时，执行另一个清空操作
	function dateTypeChangeHandler(){
		var that = $(this);
		var thisValue = that.val();
		if(thisValue == 'selectDate'){
			//选择的是日历
			$("#d4321,#d4322").val("");
			$(":checkbox[name*=weekDay]").removeAttr("checked");
		}else{
			//选择的是文本框
			$(".JS_select_date td.calSelected[date-map]").removeClass("calSelected");
			$("#selDate option").remove();
		}
		//行程初始化
		$("select[name=lineRouteId]").find("option:first-child").attr("selected","selected");
		
		getDataIfSameDay();
		initializeBranchPrice();
	}
	
	//价格校验
	function validInitPrice(){
		var $form = $("#timePriceForm");

		//表单验证
		validateSingle = backstage.validate({
		    $area: $form,
		    //$submit: $btnSave,
		    showError: true
		});
		validateSingle.start();
		validateSingle.watch();

	}
	
	//是否显示买断价格
	function showPreDom(obj){
		var goodsId = obj.attr('goodsId');
		var isPreDiv = 'isPreControlDiv'+goodsId;
		var adultSettlePrice = $("."+isPreDiv).find("input[type=text][id='adultSettlePrice_pre_"+goodsId+"']");
		var adultPrice = $("."+isPreDiv).find("input[type=text][id='adultPrice_pre_"+goodsId+"']");
		var childPrice = $("."+isPreDiv).find("input[type=text][id='childPrice_pre_"+goodsId+"']");
		var childSettlePrice = $("."+isPreDiv).find("input[type=text][id='childSettlePrice_pre_"+goodsId+"']");
		var modifyCheckbox = $("#priceContainer_pre").find(":checkbox[class*=modifybox]");
		if(obj.val()=='Y')
		{			
			$(".useResPrecontrolPrice"+goodsId).show();
			$('.'+isPreDiv).show();	
			adultSettlePrice.removeAttr("disabled");
			adultPrice.removeAttr("disabled");			
			childPrice.removeAttr("disabled");		
			childSettlePrice.removeAttr("disabled");
			modifyCheckbox.each(function(k){
				var mb = modifyCheckbox.eq(k);
				if(mb.attr('goodsid')==goodsId){
					mb.addClass('isPreMod');
				}				
			});
		}else
		{			
			$(".useResPrecontrolPrice"+goodsId).hide();
			adultSettlePrice.attr("disabled","disabled");			
			adultPrice.attr("disabled","disabled");
			childPrice.attr("disabled","disabled");			
			childSettlePrice.attr("disabled","disabled");
			modifyCheckbox.each(function(k){
				var mb = modifyCheckbox.eq(k);
				if(mb.attr('goodsid')==goodsId){
					mb.removeClass('isPreMod');
				}				
			});
			$('.'+isPreDiv).hide();
			//当商品禁止预控的时候，买断价，也要设置为不启用
			var preSaleFlagRadios = $(":radio[name=useBudgePrice"+goodsId+"]");
			preSaleFlagRadios.eq(0).removeAttr("checked");
			preSaleFlagRadios.eq(1).attr("checked","checked");
		}		
	}
	
	/**
	 * 控制买断单模板是否显示
	 */
	function showSingleDom(obj)
	{
		var goodsId = obj.attr('goodsId');
		var preSaleFlagRadios = $(":radio[name=useBudgePrice"+goodsId+"]");
		var a = $("#priceContainer_pre").find("div[goodsid*="+goodsId+"]").find("div[class*=JS_price_group]").eq(0);		
		var c = a.find("div[class*=showdiv]");
		if(obj.val()=='Y'){
			$("div:gt(2)",a).show();
			$("div:gt(2)",a).find("input[type=text]").removeAttr("disabled");
		}else{
			$("div:gt(2)",a).hide();
			c.show();
			$("div:gt(2)",a).find("input[type=text]").attr("disabled","disabled");
			//当商品禁止预控的时候，买断价，也要设置为不启用
			preSaleFlagRadios.eq(0).removeAttr("checked");
			preSaleFlagRadios.eq(1).attr("checked","checked");
		}
		
	}
	
	/**scaleGoodsPrice
	 * 设置买断价格shuj
	 */
	function scalePreGoodsPrice(){
	 var ret = -1;
	 var goodsId;
	 var i = 0 ;
	 var j = 0;
	 var isPreControl = 'N';
	//启用买断价格
	 var preSaleFlag = 'N';
	 var modifyCheckbox = $("#priceContainer_pre").find(":checkbox[class*=modifybox]:[class*=isPreMod]");
	 if(modifyCheckbox.length==0){		 
		 $("input[name='suppGoodsId']:checkbox").each(function(){ 
			 if ($(this).attr("checked")=='checked') { 
				 goodsId= $(this).val(); 
				 $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].isPreControl"  value="'+isPreControl+'">');
				 $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].preSaleFlag"  value="'+preSaleFlag+'">');
				 $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].suppGoodsId_pre" value="'+goodsId+'">'); 
			 } 
			 i++;
		 }); 
	 }else
	 {
		 //parseInt()
	     modifyCheckbox.each(function(){
			 var dataType = $(this).attr("data-type");
			 goodsId = $(this).attr("goodsId");
			 isPreControl = $('input[type="radio"][goodsid='+goodsId+'][@name="isPreControlPrice'+goodsId+'"]:checked').val();
			 var preSaleFlagRadios = $(":radio[name=useBudgePrice"+goodsId+"]");
			 var tmp = preSaleFlagRadios.eq(0);
			 preSaleFlag = "checked".indexOf(tmp.attr("checked"))>=0 ? "Y":"N";
			 if ($(this).attr("checked")=='checked'){
				 if(dataType=='adult_pre'){
					 //获取成人结算
					 var adultSettlePrice = $("#adultSettlePrice_pre_"+goodsId).val();
					 //获取成人销售
					 var adultPrice = $('#adultPrice_pre_'+goodsId).val();
					 
					 if($.trim(adultPrice)!='' && $.trim(adultSettlePrice)!=''){
						 $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].auditSettlementPrice_pre" value="'+parseInt(parseFloat(adultSettlePrice)*100)+'">');
						 $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].auditPrice_pre" value="'+parseInt(parseFloat(adultPrice)*100)+'">');
					 }
					 var iPre = $("#timePriceFormContent").find("input[name='timePriceList\["+i+"\].isPreControl']");				 
					 if(iPre.length==0){
						 $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].isPreControl"  value="'+isPreControl+'">');
						 $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].suppGoodsId_pre" value="'+goodsId+'">');
						 $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].preSaleFlag"  value="'+preSaleFlag+'">');
					 }
					 i++;
				 } 
			 }
			 if ($(this).attr("checked")=='checked'){
				 if(dataType=='child_pre'){
					 //获取儿童结算
					 var childSettlePrice = $("#childSettlePrice_pre_"+goodsId).val();
					 //获取儿童销售
					 var childPrice = $('#childPrice_pre_'+goodsId).val();
					 
					 if($.trim(childSettlePrice)!='' && $.trim(childPrice)!=''){
						 $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+j+'].childSettlementPrice_pre" value="'+parseInt(parseFloat(childSettlePrice)*100)+'">');
						 $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+j+'].childPrice_pre" value="'+parseInt(parseFloat(childPrice)*100)+'">');
					 }
					 var jPre = $("#timePriceFormContent").find("input[name='timePriceList\["+j+"\].isPreControl']");
					 if(jPre.length==0){
						 $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+j+'].isPreControl"  value="'+isPreControl+'">');
						 $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+j+'].suppGoodsId_pre" value="'+goodsId+'">');
						 $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+j+'].preSaleFlag"  value="'+preSaleFlag+'">');
					 }
					 j++;
				 }	 
			 }		
		 }); 
	 }
	  return ret;
	}
	
	/**
	 * 设置酒店套餐修改
	 * @returns
	 */
	function scaleCombHotel(){
		 var i = 0 ;
		 var ret = -1;
		 var goodsId;
		 var modifyCheckbox = $("#priceContainer_pre").find(":checkbox[class*=modifybox]");	
	     var isPreControl = 'Y';
		 modifyCheckbox.each(function(){
			 goodsId =  $(this).attr("goodsId");
			 //获取酒店套餐结算价
			 var adultSettlePrice = $("#adultSettlePrice_pre_"+goodsId).val();
			 //获取酒店套餐销售价
			 var adultPrice = $('#adultPrice_pre_'+goodsId).val();
			 isPreControl = $("input[type=radio][name='isPreControlPrice"+goodsId+"'][checked]").val();
			 var preSaleFlagRadios = $(":radio[name=useBudgePrice"+goodsId+"]");
			 var tmp = preSaleFlagRadios.eq(0);
			 var preSaleFlag = "checked".indexOf(tmp.attr("checked"))>=0 ? "Y":"N";
			 if($.trim(adultPrice)!='' && $.trim(adultSettlePrice)!=''){
				 $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].auditSettlementPrice_pre" value="'+parseInt(parseFloat(adultSettlePrice)*100)+'">');
				 $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].auditPrice_pre" value="'+parseInt(parseFloat(adultPrice)*100)+'">');
			 }
			 $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].isPreControl"  value="'+isPreControl+'">');
			 $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].suppGoodsId_pre" value="'+goodsId+'">');
			 $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].preSaleFlag"  value="'+preSaleFlag+'">');
			 i++;
		 });
		  return ret;
	}

	
	function toPreBudgeGoodsEdit(isBudgePrice){
		var goodsId;
		 var goodsArray = '';
		 var modifyCheckbox = $("#priceContainer_pre").find(":checkbox[class*=modifybox]:[class*=isPreMod]");
		 if(modifyCheckbox.length==0)
		 {		 
			 $("input[name='suppGoodsId']:checkbox").each(function(){ 
				 if ($(this).attr("checked")=='checked') 
				 { 
					 goodsId= $(this).val();
					 if(goodsArray.indexOf(goodsId)==-1){
						 goodsArray = goodsArray+goodsId+","; 
					 }
					 
				 } 
			 }); 
		 }else
		 {
		     modifyCheckbox.each(function(){
				 goodsId = $(this).attr("goodsId");
				 if(goodsArray.indexOf(goodsId) == -1){
					 goodsArray = goodsArray+goodsId+","; 
				 }
			 }); 
		 }	
		 
		   $.ajax({
				url:'/vst_admin/lineMultiroute/goods/timePrice/isPreBudgeGoods.do',
				data:{
					goodsArrays:goodsArray
				},
				type:"GET",
				async:false,
				dataType:"json",
				success:function(result){
				  if(result.data=='Y')
				  {
					if(!confirm(result.errMsg)){
					  isBudgePrice = "N";					
					}else{
					 isBudgePrice = "Y";
					}
				  }else
				  {
				     isBudgePrice = "Y";
				  }
				}				
			 });
		   return isBudgePrice == "Y";
	}


	/**
	 * 禁售
	 */
	function forbidPreContorl(obj,num,type){		
		//priceContainer_pre
		if(type == 'forbidSaleSingle'){
			var goodsId = obj.attr("goodsId");
			if(obj.attr("checked")!='checked'){
				$("#priceContainer_pre").find("div[class*=priceDiv][divtype=my_comb_hotel][goodsId="+goodsId+"]").show();
				$("#priceContainer_pre").find("div[class*=priceDiv][divtype=my_comb_hotel][goodsId="+goodsId+"]").removeAttr("disabled");
				$("#priceContainer_pre").find("div[class*=priceDiv][divtype=my_comb_hotel][goodsId="+goodsId+"]").removeAttr("disabled");
			}else
			{
				$("#priceContainer_pre").find("div[class*=priceDiv][divtype=my_comb_hotel][goodsId="+goodsId+"]").hide();
				$("#priceContainer_pre").find("div[class*=priceDiv][divtype=my_comb_hotel][goodsId="+goodsId+"]").attr("disabled","disabled");
				$("#priceContainer_pre").find("div[class*=priceDiv][divtype=my_comb_hotel][goodsId="+goodsId+"]").attr("disabled","disabled");
			}			
		}else
		{		
			if(obj.attr("checked")!='checked')
			{				
				if(num != 'all'){
					$("#priceContainer_pre").find("div[class*=JS_price_group]").eq(num).show();
					$("#priceContainer_pre").find("div[class*=JS_price_group]").eq(num).find("input[type=text]").removeAttr("disabled");	
				}else
				{
					$("#priceContainer_pre").find("div[class*=priceDiv]").show();
					$("#priceContainer_pre").find("div[class*=priceDiv]").removeAttr("disabled");
				}
			}else{			
				//选中
				if(num != 'all')
				{			  
				  $("#priceContainer_pre").find("div[class*=JS_price_group]").eq(num).hide();
				  $("#priceContainer_pre").find("div[class*=JS_price_group]").eq(num).find("input[type=text]").attr("disabled","disabled");
				}else
				{
					//全部禁售
					$("#priceContainer_pre").find("div[class*=priceDiv]").hide();
					$("#priceContainer_pre").find("div[class*=priceDiv]").attr("disabled","disabled");
					allChecked = true;
				}		
			}
		}

	}
	
	
	//预控买断价格表单数据设置
	function setPreControlPriceFormData(){	
	 var i = 0 ; 
		$("#price_set_pre").find("div[data='priceDiv'][class*=isPreMod][cancelFlag!=Y]").each(function(){
	    	var that = $(this);
	    	var goodsId = that.attr("goodsId");
			
	    	if($.trim(that.html())!=''){
	    		//创建商品Id
		    	$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].suppGoodsId_pre" value="'+that.attr("goodsId")+'">');
		    	var isPreControl = that.find("input[type=radio][name='isPreControlPrice'+goodsId][checked]").val();
		    	$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].isPreControl"  value="'+isPreControl+'">');
		    	that.find("input[data_type=is_input]").each(function(){
		    		var clone = $(this).clone();
		    		var name = clone.attr("data");
		    		var inputName = "timePriceList["+i+"]."+name
		    		var inputValue=  clone.val(); 
		    		if(inputValue!=""){
		    			var clonevalue = clone.val();
			    		var start = clonevalue.lastIndexOf(".");
			    		var len = clonevalue.length-1;
			    		var decimallen = len - start; 
			    		//parseInt精度有问题0.1变0.099
			    		if(clonevalue.indexOf(".") == -1){
			    			inputValue = parseInt(clone.val()*100,0);
			    		}else if(decimallen == 1){
			    			inputValue = clone.val().replace(".","")+"0";
			    		}else if(decimallen == 2){
			    			inputValue = clone.val().replace(".","");
			    		}
			    		inputValue = parseInt(inputValue);
			    		clone.removeAttr('disabled');
		    			$("#timePriceFormContent").append('<input type="hidden" name="'+inputName+'" value="'+inputValue+'">');
		    		}
		    	});
		    	i++;
	    	}	
	    });
	}
	function showPreControl(obj){
		var goodsId = obj.attr('goodsId');
	  	var preDivClass = 'isPreControlDiv'+goodsId;
	   var auditSettlementPrice_pre = $("."+preDivClass).find("input[type=text][name='auditSettlementPrice_pre']");
	   var childSettlementPrice_pre = $("."+preDivClass).find("input[type=text][name='childSettlementPrice_pre']");
	   var auditPrice_pre = $("."+preDivClass).find("input[type=text][name='auditPrice_pre']");
	   var childPrice_pre = $("."+preDivClass).find("input[type=text][name='childPrice_pre']");
		if(obj.val()=='Y')
		{
		    $("."+preDivClass).show(); 
		    auditSettlementPrice_pre.removeAttr("disabled").val("");
			childSettlementPrice_pre.removeAttr("disabled").val("");			
			auditPrice_pre.removeAttr("disabled").val("");		
			childPrice_pre.removeAttr("disabled").val("");
			$("#price_set_pre").find("div[data='priceDiv'][goodsId="+goodsId+"]").addClass('isPreMod');
		}else
		{
		  $("."+preDivClass).hide();
		  auditSettlementPrice_pre.attr("disabled","disabled").val("0");			
		  childSettlementPrice_pre.attr("disabled","disabled").val("0");
		  auditPrice_pre.attr("disabled","disabled").val("0");			
		  childPrice_pre.attr("disabled","disabled").val("0");
		  $("#price_set_pre").find("div[data='priceDiv'][goodsId="+goodsId+"]").removeClass('isPreMod');

			$("div[div=useBudgePriceDiv"+goodsId+"]").show();
		}
	}
	
	function hidePreControl(goodsId,priceType){
		var name1 = "isPreControlPrice"+goodsId;
		var obj1 = $("input[name="+name1+"][type=radio][value=N][class*=closeBudgePrice]");
		obj1.val('N');
		if(priceType=="SINGLE_PRICE"){
			showSingleDom(obj1);
		}else{
			showPreDom(obj1);
		}
	}
	//对批量选项进行初始化
	function initializeBranchPrice()
	{
		$("#branchModify").removeAttr("checked");
		$("#branchAdultSettlePrice").val("");
		$("#branchPriceSelect option[value=custom").attr("selected","select");
	    $("#branchAddPrice").attr("readonly","readonly");
	    $("#branchAddPrice").val("");
	    $("#branchAdultPrice").val("");
	    $("#branchAdultPrice").removeAttr("disabled").removeAttr("readonly");
	}
	//对酒店套餐中的价格输入框进行禁止输入设置
	function closeHotelCombPrice()
	{
		$("#branchAdultSettlePrice").attr("readonly","readonly");
		$("#branchAdultPrice").attr("readonly","readonly");
		$(".JS_price_settlement").attr("readonly","readonly");
		$(".JS_price_added").attr("readonly","readonly");
		$(".JS_price_selling").attr("readonly","readonly");
		$(".JS_price_settlement").filter("input[name='showPreSale_pre']").removeAttr("readonly");
	}
	//对酒店品类开售状态进行判断
	function validateForbiebutton()
	{
		var i=false;
		$("input[data='saleAble']").each(function(){
		  var goodsId = $(this).attr("goodsId");
		  if(goodsId !="" && goodsId != undefined && goodsId != "{thisGoodsId}"){
			  var value = $("#onSaleFlagHidden_"+goodsId).val();
			  if(value !="1"){
					 i=false;
					return false;
				  }else{
					  i=true;
				  }
		  }else{
			  i=true;
		  } 
		});
		return i;
	}
	function addHotelCombGoodsPrice()
	{
		priceDivObj = $("#priceContainer>.priceDiv");
		var ret = -1;
		//用来放置商品列表的下标
		var goodNum = 0;
		priceDivObj.each(function(i){
			var that = $(this);
			goodNum=i;
			var goodsId = that.attr("goodsId");
			//.attr("checked")!='checked'
			forbidFlag = $("#onSaleFlagHidden_"+goodsId).attr("checked");
			//如果是开售
	    	if(forbidFlag !="checked")
	    	{
	    		//创建商品Id
		    	$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+goodNum+'].suppGoodsId" value="'+goodsId+'">');
		        $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+goodNum+'].onsaleFlag" value="Y">');
	    	}else if(forbidFlag=="checked")
	    	{
	    		//如果是禁售
	    		//创建商品Id
		    	$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+goodNum+'].suppGoodsId" value="'+goodsId+'">');
		        $("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+goodNum+'].onsaleFlag" value="N">');
	    	}
				//结算价
	    	    var settleInput = $("#adultSettlePrice_"+goodsId);
				var settlementPrice = settleInput.val();
				//操作  【custom自定义，fixed固定，percent比例加价，equal销售价=结算价】
				var actionType=$("#priceSelect_"+goodsId).val();
				// 操作数
				var actionPrice=$("#addPrice_"+goodsId).val();  
				//销售价
				var priceInput = $("#adultPrice_"+goodsId); 
				var price=priceInput.val(); 
				//成人价还是儿童价   还是房差
				var peopleType = $("#peopleType_"+goodsId).val();   
				
				//如果多价格中成人，儿童，房差全部禁售了；或者单价禁售了 ； 则---将价格清空
				if(forbidFlag == "checked"){
					if(isHotelComb){//酒店套餐
						var start = price.lastIndexOf(".");
			    		var len = price.length-1;
			    		var decimallen = len - start; 
						if(price.indexOf(".") == -1){
							price = parseInt(price*100,0);
			    		}else if(decimallen == 1){
			    			price = price.replace(".","")+"0";
			    		}else if(decimallen == 2){
			    			price = price.replace(".","");
			    		}
						price = parseInt(price);			   
						var start1 = settlementPrice.lastIndexOf(".");
			    		var len1 = settlementPrice.length-1;
			    		var decimallen1 = len1 - start1; 

			    		if(settlementPrice.indexOf(".") == -1){
			    			settlementPrice = parseInt(settlementPrice*100,0);
			    		}else if(decimallen1 == 1){
			    			settlementPrice = settlementPrice.replace(".","")+"0";
			    		}else if(decimallen1 == 2){
			    			settlementPrice = settlementPrice.replace(".","");
			    		}
			    		settlementPrice =parseInt(settlementPrice);	
					}else{
						price = "";
						settlementPrice = "";
					}
				}else{
					var isJShou = $("#adultSettlePrice_"+goodsId).attr("readonly")=='readonly';
					if(isJShou){
						//是禁售，则不用检验
						if($.trim(price)!='' || $.trim(settlementPrice)!=''){
							if($.trim(settlementPrice)!=''){
								errEles.push(settleInput);
							}
							if($.trim(price)!=''){
								errEles.push(priceInput);
							}
							
							ret = 6;
						}
					}else{
						if(price > 999999990){
							ret = 10;
							errEles.push(priceInput);
							return false;
						}
						if(settlementPrice > 999999990){
							ret = 10;
							errEles.push(settleInput);
							return false;
						}
						
						
						if($.isNumeric(price) && $.isNumeric(settlementPrice)){
							var start = price.lastIndexOf(".");
				    		var len = price.length-1;
				    		var decimallen = len - start; 
							if(price.indexOf(".") == -1){
								price = parseInt(price*100,0);
				    		}else if(decimallen == 1){
				    			price = price.replace(".","")+"0";
				    		}else if(decimallen == 2){
				    			price = price.replace(".","");
				    		}
							price = parseInt(price);			   
							var start1 = settlementPrice.lastIndexOf(".");
				    		var len1 = settlementPrice.length-1;
				    		var decimallen1 = len1 - start1; 

				    		if(settlementPrice.indexOf(".") == -1){
				    			settlementPrice = parseInt(settlementPrice*100,0);
				    		}else if(decimallen1 == 1){
				    			settlementPrice = settlementPrice.replace(".","")+"0";
				    		}else if(decimallen1 == 2){
				    			settlementPrice = settlementPrice.replace(".","");
				    		}
				    		settlementPrice =parseInt(settlementPrice);	
						}else{
							if($.trim(price)!='' && $.trim(settlementPrice)!=''){
								if($.trim(settlementPrice)!=''){
									errEles.push(settleInput);
								}
								if($.trim(price)!=''){
									errEles.push(priceInput);
								}
								ret = 3;
							}else{
								if($.trim(settlementPrice)==''){
									errEles.push(settleInput);
								}
								if($.trim(price)==''){
									errEles.push(priceInput);
								}
								ret = 3;
							}
						}
					}
				}
				if(peopleType=='child'){
					//$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].actionPrice['+j+']" value="'+actionPrice+'">');		
					//$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].peopleType['+j+']" value="'+peopleType+'">');				
					//儿童销售价
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+goodNum+'].childPrice" value="'+price+'">');
					//儿童结算价
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+goodNum+'].childSettlementPrice" value="'+settlementPrice+'">');
					
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+goodNum+'].modChildFlag" value="Y">');
				}else if(peopleType=='audit'){
					//$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].actionPrice['+j+']" value="'+actionPrice+'">');
					//$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].peopleType['+j+']" value="'+peopleType+'">');
					//成人销售价
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+goodNum+'].auditPrice" value="'+price+'">');
					//成人结算价
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+goodNum+'].auditSettlementPrice" value="'+settlementPrice+'">');
					
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+goodNum+'].modAdultFlag" value="Y">');
				}else if(peopleType=='gap'){
					//房差
					//成人销售价
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+goodNum+'].gapPrice" value="'+price+'">');
					//成人结算价
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+goodNum+'].grapSettlementPrice" value="'+settlementPrice+'">');
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+goodNum+'].modGapFlag" value="Y">');
				}else if(peopleType=='singleprice'){
					//单价格-只有成人的价格
					//成人销售价
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+goodNum+'].auditPrice" value="'+price+'">');
					//成人结算价
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+goodNum+'].auditSettlementPrice" value="'+settlementPrice+'">');
					
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+goodNum+'].modAdultFlag" value="Y">');
				}
				//$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].actionType['+j+']" value="'+actionType+'">'); 
			});
		   return ret;
	}
	
	function stockTypeChange(){
		var ob = {};
		var goodIds ="";
		$(".my_adult_child,.my_comb_hotel,.my_addition,.my_upgrade,.my_change_hotel").each(function(){
				var _this = $(this);
				if(_this.attr("checked") == 'checked'){
					if($("#CONTROL_"+_this.val()).attr('checked')!='checked'){
						goodIds = goodIds + _this.val()+",";
					}
				}
		});
		 
		var dates = "";
		var startDate ="";
		var endDate="";
		var weekDays="";
		var selectCalendar = $('input[name=nfadd_date]:checked').val();  //取值：selectDate【日历框】  selectTime 【时间段】
			//如果是日历框
		if(selectCalendar=='selectDate'){
			$("#selDate option").each(function(){
				dates = dates + $(this).val() +",";
			});
		}else{
			//时间段
			startDate = $("#d4321").val();
			endDate = $("#d4322").val();
			$("input[type=checkbox][name=weekDay]:checked").each(function(){
				weekDays = weekDays + $(this).val() +",";
			 });
		}
		if(goodIds.length>0){
			$.ajax({
				url:"/vst_admin/percontrol/suppGoods/getResPrecontrolByParams.do", 
				type:"GET",
				async:false,
				data:{
					goodIds:goodIds,
					dates:dates,
					startDate:startDate,
					endDate:endDate,
					weekDays:weekDays,
					selectCalendar:selectCalendar
				},
				dataType:"json",
				success:function(data){
					ob = data;
				},
				error:function(){
					alert("查询商品买断信息失败");
					ob="false";
					return false;
				}
			});
		}else{
			ob = {code:"true"};
		}
			 
		 

		 return ob;
	}