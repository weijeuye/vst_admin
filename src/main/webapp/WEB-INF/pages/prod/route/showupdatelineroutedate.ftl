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
						<li>
							<div class="nfadd_div"><label>选择适用行程：</label></div>
							<div class="nfadd_div">
								<div style="width:675px;">
									<select name="lineRouteId">
										<#if prodLineRouteList?? && prodLineRouteList?size &gt; 0>
											<#list prodLineRouteList as prodLineRoute>
												<option value='${prodLineRoute.lineRouteId}'>${prodLineRoute.routeName}</option>
											</#list>
										<#else>
											<option value=''>请选择</option>
										</#if>
									</select>
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
			</ul>
		</div>
		<div class="fl operate">
			<a href="javascript:;" class="btn btn_cc" id="timePriceSaveButton">保&emsp;存</a>
			<a href="javascript:;" class="btn btn_cc" id="timePriceCancelButton">取&emsp;消</a>
		</div>
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
	
	//验证销售价和结算价关系
	function validatePrice(){
		var result = "";
		var index = 0;
		//判断成人儿童方差
		$("#adult_child_price").find(".priceDiv").each(function(i){
            var that = $(this);
            var auditSettlementPriceVal = $("input[disabled!=disabled][name=auditSettlementPrice"+i+"]").val();
			var auditPriceVal = $("input[disabled!=disabled][name=auditPrice"+i+"]").val();
			if(auditSettlementPriceVal!=null && (parseFloat(auditSettlementPriceVal) > parseFloat(auditPriceVal))){
                result = "成人儿童房差 ";
				return false;
			}

            var childSettlementPriceVal = $("input[disabled!=disabled][name=childSettlementPrice"+i+"]").val();
            var childPriceVal = $("input[disabled!=disabled][name=childPrice"+i+"]").val();
            if(childSettlementPriceVal!=null && (parseFloat(childSettlementPriceVal) > parseFloat(childPriceVal))){
                result = "成人儿童房差 ";
                return false;
            }

            var gapSettlementPriceVal = $("input[disabled!=disabled][name=grapSettlementPrice"+i+"]").val();
            var gapPriceVal = $("input[disabled!=disabled][name=gapPrice"+i+"]").val();
            if(gapSettlementPriceVal!=null && (parseFloat(gapSettlementPriceVal) > parseFloat(gapPriceVal))){
                result = "成人儿童房差 ";
                return false;
            }

			//酒店套餐
            var auditSettlementPriceVal_hotel = $("input[name=auditSettlementPrice_"+i+"]").val();
            var auditPriceVal_hotel = $("input[name=auditPrice_"+i+"]").val();
            if(auditSettlementPriceVal_hotel!=null && (parseFloat(auditSettlementPriceVal_hotel) > parseFloat(auditPriceVal_hotel))){
                result = "套餐 ";
                return false;
            }
        });
        index = $("#adult_child_price").find(".priceDiv").size();
		//判断附加
        $("#addition_price").find(".priceDiv").each(function(i){
            var that = $(this);
            var auditSettlementPriceVal = $("input[name=auditSettlementPrice_"+(i+index)+"]").val();
            var auditPriceVal = $("input[name=auditPrice_"+(i+index)+"]").val();
            if(parseFloat(auditSettlementPriceVal) > parseFloat(auditPriceVal)){
                result = result + "附加 ";
                return false;
            }
        });
        index = index  + $("#addition_price").find(".priceDiv").size();
		//判断升级
        $("#upgrade_price").find(".priceDiv").each(function(i){
            var that = $(this);
            var auditSettlementPriceVal = $("input[name=auditSettlementPrice"+(i+index)+"]").val();
            var auditPriceVal = $("input[name=auditPrice"+(i+index)+"]").val();
            if(parseFloat(auditSettlementPriceVal) > parseFloat(auditPriceVal)){
                result = result + "升级 ";
                return false;
            }
        });
        index = index  + $("#addition_price").find(".priceDiv").size();
		//判断可换
        $("#change_price").find(".priceDiv").each(function(i){
            var that = $(this);
            var auditSettlementPriceVal = $("input[name=auditSettlementPrice"+(i+index)+"]").val();
            var auditPriceVal = $("input[name=auditPrice"+(i+index)+"]").val();
            if(parseFloat(auditSettlementPriceVal) > parseFloat(auditPriceVal)){
                result = result + "可换酒店 ";
                return false;
            }
        });
		return result;
	}	
	
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
		    		$("#timePriceFormContent").append(clone);
	    		}
	    	});
	    });
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
	    				var stockInput = $(this).closest("tr").find("td").eq(0).find("input[type=text]");
	    				//获得库存input
	    				var clone1 = stockInput.clone();
	    				//获得库存的类型
	    				clone1.attr("name","timePriceList["+i+"].stock");
	    				clone1.val(stockInput.val());
    					$("#timePriceFormContent").append(clone1);
    					var obj2 = $(this).closest("tr").find("td").eq(1).find("input[type=radio]:checked");
    					var clone2 = obj2.clone();
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
	
	//设置退改规则数据
	function setCancelStrategy(){
		var cancelStrategy = $('input[name=selectCancelStrategy]:checked').val();
		$('#cancelStrategy').val(cancelStrategy);
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
	
	// 保存
	$("#timePriceSaveButton").click(function(){
		if($('input[name=nfadd_date]:checked').val()=='selectDate'){
			if($('#selDate').find('option').size()==0){
				alert("请选择日期");
				return;
			}
		}else{
			 if($("input[type=checkbox][name=weekDay]:checked").size()==0){
			 	alert("请选择适用日期0");
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
	    //设置库存表单
	    setStockFormData();
	    //设置提前预定时间
	    setAheadBookTimeFormData();
	    //设置授权限制数据
	    setBookLimitTypeFormData();
	    //设置选项
	    setTimeUpdateType();
	    //设置退改规则数据
	    setCancelStrategy();
	    //判断销售价和结算价关系
		var res = validatePrice();
		if(res!=""){
			if(!confirm(res+"销售价低于结算价,是否继续")){
				return;
			}
		}

	    $("input:checkbox.saleAble").each(function(){
	        var id = $(this).attr("name");
	        var value = $(this).is(':checked')?"Y":"N";
        	if($("#"+id).val()===""){
        		$("#"+id).val(value);
        	}
	    });
	    
	    //设置产品ID
	    $("#timePriceForm").append('<input type="hidden" value="${prodProduct.productId}" name="productId">')
		var loading = top.pandora.loading("正在努力保存中...");
		$.ajax({
			url : "/vst_admin/prod/prodLineRoute/updateLineRouteDate.do",
			data :　$("#timePriceForm").serialize(),
			dataType:'JSON',
			type: "POST",
			success : function(result){
				alert(result.message);
				loading.close();
				window.parent.document.getElementById('search_button').click();
				window.parent.batchProdRouteDialog.close();
			},
			error : function(){
				alert('服务器错误');
				loading.close();
			}
		})
	});	
	
	isView();
</script>