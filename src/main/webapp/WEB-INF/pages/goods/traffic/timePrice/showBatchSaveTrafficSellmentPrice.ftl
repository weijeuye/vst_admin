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
	 				<#if goodsList??>
	 					<div class="nfadd_div nfadd_title">
			 				<#list goodsList as good>
			 					<label class="radio">
			 						<input type="checkbox" name="suppGoodsId" value="${good.suppGoodsId}" data_name="${good.goodsName}" data="${suppGoods.suppSupplier.supplierId}"  class="good adult_child" /><#if good.prodProductBranch.cancelFlag!='Y'><span style="color:red">[无效]</span></#if>${good.prodProductBranch.branchName}[${good.prodProductBranch.productBranchId}]-<#if good.cancelFlag!='Y'><span style="color:red">[无效]</span></#if>${good.goodsName}[${good.suppGoodsId}]<#if good.cancelFlag!='Y'><span class="poptip-mini poptip-mini-warning"><div class="tip-sharp tip-sharp-left"></div>-商品无效</span></#if>
			 					</label>
			 				</#list>
						</div>		 				
	 				</#if>			
				</li>
				<form id="timePriceForm">				
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
						<!--在这里构造提交数据-->
			            <input type="hidden" name="isSetPrice">
			            <input type="hidden" name="isSetStock">
			            <input type="hidden" name="isSetAheadBookTime">
			            <input type="hidden" name="adult" id="adult">
			            <input type="hidden" name="child" id="child">
			            <input type="hidden" name="gap" id="gap">
			            <input type="hidden" name="cancelStrategy" id="cancelStrategy">
			            <div style="display:none" id="timePriceFormContent"></div>
					</div>				
					<li>
						<div id="adult_child_price"></div>
						<div id="addition_price"></div>
						<div id="upgrade_price"></div>
						<div id="change_price"></div>
					</li>
				</form>
			</ul>
		</div>
		<div class="fl operate">
			<a href="javascript:;" class="btn btn_cc" id="timePriceSaveButton">保&emsp;存</a>
			<a href="javascript:;" class="btn btn_cc" id="timePriceCancelButton">取&emsp;消</a>
		</div>
	</div>
	<div id="templateDiv" style="display:none">
		 <!-- 多价格价格 --> 
		<div id="multiple_price_template">
			<table align="center" class="e_table form-inline" style="width:600px;" goodsid="">
	             <tbody>       
					<tr>
						<td width="100" style="text-align:right;"><span>{{}}&nbsp;成人&nbsp;</span></td>
						<td>结算价：<input type="text" max="999999999" name="auditSettlementPrice{index}" class="adult" data="auditSettlementPrice"></td>
					</tr>
					<tr>
						<td style="text-align:right;"><span>&nbsp;儿童&nbsp;</span></td>
						<td>结算价：<input type="text" max="999999999" name="childSettlementPrice{index}" class="child" data="childSettlementPrice"></td>
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
	
	//设置验证子项
	function setIsOrNotValidate(){
		//价格
    	$("#adult_child_price,#upgrade_price").find("input[type=text]").each(function(){
    		if($(this).attr("notnumber")!="Y"){
				$(this).rules("add",{required : true, number : true,isNum:true , min : 0,messages : {min:'价格必须大于等于0',isNum:'价格格式不正确(填至多2位小数正数)'}});
    		}
    	});
	}		
	
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
		var priceTemplate = '<div goodsId='+goodsId+' class="priceDiv">'+ $("#multiple_price_template").html()+'</div>';
 
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
		
		setPriceModelType();
	});	
	
	//销售价模式
	function setPriceModelType(){
		$('.priceDiv').find('.saleAble').each(function(){
			var that = $(this);
			if(that.attr('checked')=='checked'){
				that.parents('tr').find('input[type=text]').attr("disabled","disabled");
				that.parents('tr').find('input[type=text]').val("");
			}else{
				that.parents('tr').find('input[type=text]').removeAttr('disabled');
			}
		});
	}
	
	$('.priceDiv').find('.saleAble').live('click',function(){
		setPriceModelType();
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
		
  		var priceValidate = $("#timePriceForm").validate();
	    //清空验证信息
	  	priceValidate.resetForm();			
		
		setIsOrNotValidate();

		if(!priceValidate.form()){
			return;
		}

		//构造Form提交数据
		$("#timePriceFormContent").empty();
		setSelectDate();
		//设置价格表单
	    setPriceFormData();
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
	    $("#timePriceFormContent").append('<input type="hidden" value="${suppGoods.prodProduct.productId}" name="productId">');
		var loading = top.pandora.loading("正在努力保存中...");
		$.ajax({
			url : "/vst_admin/lineMultiTraffic/goods/timePrice/editTrafficPrice.do",
			data :　$("#timePriceForm").serialize(),
			dataType:'JSON',
			type: "POST",
			success : function(result){
				alert(result.message);
				loading.close();
				window.parent.window.search();
				window.parent.priceButtonDialog.close();
			},
			error : function(){
				alert('服务器错误');
				loading.close();
			}
		})
	});	
	
	$('#timePriceCancelButton').live('click',function(){
		window.parent.priceButtonDialog.close();
	});	
	
	isView();
	
</script>