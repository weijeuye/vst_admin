<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title></title>
<link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css"/>
<link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/pandora-calendar.css"/>
<link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/sales-information-iframe.css"/>
</head>
<body>
<script type="text/javascript" src="/vst_admin/js/lvmama-dialog.js"></script>

<div class="add-product">

	<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_local' || categoryCode=='category_route_customized'>
    <div class="row">
        <div class="col w80 mr10 text-right text-gray">成人儿童：</div>
 		<#assign adultChildGoods = goodsMap['adult_child_diff'] />
 		<#if adultChildGoods??>
        <div class="col w650">
            <label class="checkbox">	 					
            	<input type="checkbox" class="checkGoods adult_child" name="suppGoodsId" value="${adultChildGoods.suppGoodsId}" data_name="${adultChildGoods.goodsName}" data_price_type="${adultChildGoods.priceType}" />${adultChildGoods.goodsName}[${adultChildGoods.suppGoodsId}]
            </label>
        </div>
        </#if>
    </div>
    </#if>
    
	<#if categoryCode=='category_route_hotelcomb'>
	<div class="row">
		<div class="col w80 mr10 text-right text-gray">套餐：全选<input type="checkbox"  class="my_comb_hotel1" id="orChecked"></div>
		<div class="col w650">
 		<#assign comboDinnerList = goodsMap['combo_dinner'] />
 		<#list comboDinnerList as comboDinnerGoods>
			<label class="checkbox" <#if comboDinnerGoods.cancelFlag!='Y'>cancelFlag="Y"</#if> >
 				<input type="checkbox" class="checkGoods comb_hotel" name="suppGoodsId" value="${comboDinnerGoods.suppGoodsId}"  data_name="${comboDinnerGoods.goodsName}" data_price_type="${comboDinnerGoods.priceType}" />${comboDinnerGoods.goodsName}[${comboDinnerGoods.suppGoodsId}]
 			</label>
 			<#assign mainProdBranchId = '${comboDinnerGoods.productBranchId}' />
			<#assign mainSuppGoodsId = '${comboDinnerGoods.suppGoodsId}' />
 		</#list>
 		</div>
 	</div>
	</#if>
 			
	<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_local' || categoryCode=='category_route_hotelcomb' || categoryCode=='category_route_customized'>
	<div class="row">	
		<div class="col w80 mr10 text-right text-gray">附加：</div>
		<div class="col w650">
		<#assign additionList = goodsMap['addition'] />
 		<#list additionList as additionGoods>
 			<label class="checkbox"  <#if additionGoods.cancelFlag!='Y'>cancelFlag="Y"</#if>  >
 				<input type="checkbox" class="checkGoods addition" name="suppGoodsId" value="${additionGoods.suppGoodsId}"  data_name="${additionGoods.goodsName}" data_price_type="${additionGoods.priceType}" />${additionGoods.goodsName}[${additionGoods.suppGoodsId}]
 			</label>
 		</#list>
		</div>
	</div>
	</#if> 	
	 
    <#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_customized'>
	<div class="row">	
		<div class="col w80 mr10 text-right text-gray">升级：</div>
 		<div class="col w650">
	 		<#assign upgradList = goodsMap['upgrad'] />
	 		<#list upgradList as upgradGoods>
	 			<label  class="checkbox">
	 				<input type="checkbox" class="checkGoods upgrade" name="suppGoodsId" value="${upgradGoods.suppGoodsId}"  data_name="${upgradGoods.goodsName}" data_price_type="${upgradGoods.priceType}" />${upgradGoods.goodsName}[${upgradGoods.suppGoodsId}]
	 			</label>
	 		</#list>
 		</div>
 	</div>
	</#if>	 
	
    <#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_customized'>
	<div class="row">	
		<div class="col w80 mr10 text-right text-gray">可换酒店：</div>
 		<div class="col w650">
		 		<#assign changedHotelList = goodsMap['changed_hotel'] />
		 		<#list changedHotelList as changedHotelGoods>
		 			<label class="checkbox">
		 				<input type="checkbox" class="checkGoods change_hotel" name="suppGoodsId" value="${changedHotelGoods.suppGoodsId}"  data_name="${changedHotelGoods.goodsName}" data_price_type="${changedHotelGoods.priceType}" />${changedHotelGoods.goodsName}[${changedHotelGoods.suppGoodsId}]
		 			</label>
		 		</#list>
		</div>
	</div>
	</#if>	

	<form id="timePriceForm">
	
	
    <div class="hr"></div>
    <div class="row mt10">
        <div class="col w460 ml10">
            <div class="row">
                <label class="radio">
                    <input type="radio" value="selectDate" name="nfadd_date" checked/>选择日期
                </label>
            </div>
            <div class="JS_select_date"></div>
			<select class="JS_select_date_hidden"  multiple="true" id="selDate"></select>

        </div>
        <div class="col w290">
            <div class="row">
                <label class="radio">
                    <input type="radio" value="selectTime"" name="nfadd_date" />选择时间段
                </label>
            </div>
            <div class="row">
                <div class="col w70 text-right text-gray pr10">起始：</div>
                <div class="col w150">
                    <input type="text" class="datetime form-control w170 J_calendar" name="startDate" id="startDateId"/>
                </div>
            </div>
            <div class="row">
                <div class="col w70 text-right text-gray pr10">结束：</div>
                <div class="col w150">
                    <input type="text" class="datetime form-control w170 J_calendar" name="endDate" id="endDateId"/>
                </div>
            </div>
            <div class="row JS_checkbox_select_all_box">
                <div class="col w70 text-right text-gray pr10">适应日期：</div>
                <div class="col w100">
                    <label>
                        <input type="checkbox" class="JS_checkbox_select_all_switch" name="weekDayAll"/>全部
                    </label>
                </div>
                <div class="col week-group">
                    <p>
                        <label>
                            <input type="checkbox" class="JS_checkbox_select_all_item" name="weekDay" value="2"/> 周一
                        </label>
                    </p>

                    <p>
                        <label>
                            <input type="checkbox" class="JS_checkbox_select_all_item" name="weekDay" value="3"/>周二
                        </label>
                    </p>

                    <p>
                        <label>
                            <input type="checkbox" class="JS_checkbox_select_all_item" name="weekDay" value="4"/>周三
                        </label>
                    </p>

                    <p>
                        <label>
                            <input type="checkbox" class="JS_checkbox_select_all_item" name="weekDay" value="5"/>周四
                        </label>
                    </p>

                    <p>
                        <label>
                            <input type="checkbox" class="JS_checkbox_select_all_item" name="weekDay" value="6"/>周五
                        </label>
                    </p>

                    <p>
                        <label>
                            <input type="checkbox" class="JS_checkbox_select_all_item" name="weekDay" value="7"/>周六
                        </label>
                    </p>

                    <p>
                        <label>
                            <input type="checkbox" class="JS_checkbox_select_all_item" name="weekDay" value="1"/>周日
                        </label>
                    </p>
                </div>
            </div>
        </div>
    </div>

	<!--在这里构造提交数据-->
    <input type="hidden" name="isSetPrice">
    <input type="hidden" name="isSetStock">
    <input type="hidden" name="isSetAheadBookTime">
    <input type="hidden" name="adult" id="adult">
    <input type="hidden" name="child" id="child">
    <input type="hidden" name="gap" id="gap">
    <input type="hidden" name="cancelStrategy" id="cancelStrategy">
    <div style="display:none" id="timePriceFormContent"></div>
   
    <div id="timePriceFormInput">
        <ul class="nav-tabs JS_tab_main">
            <li class="active">修改销售价</li>
            <li>修改结算价</li>
        </ul>
        <div class="tab-content">
            <!--修改销售价 开始-->
            <div class="tab-pane active">
					<div id="adult_child_price"></div>
					<div id="addition_price"></div>
					<div id="upgrade_price"></div>
					<div id="change_price"></div>
            </div>
            <!--修改销售价 结束-->

            <!--修改结算价 开始-->
            <div class="tab-pane">
				<div id="adult_child_price_settement"></div>
				<div id="addition_price_settement"></div>
				<div id="upgrade_price_settement"></div>
				<div id="change_price_settement"></div>
            </div>
            <!--修改结算价 结束-->
        </div>
    </div>
	</form>

    <div class="hr"></div>
    <div class="row">
        <div class="btn-group text-center">
            <a class="btn btn-primary btn-lg JS_btn_save" id="timePriceSaveButton">全部保存</a>
            <a class="btn btn-lg JS_btn_cancel" id="timePriceCancelButton">取消</a>
        </div>
    </div>
    
	<!-- 添加用的模板-->
	<div id="templateDiv" style="display:none">
		<!-- 多价格价格 --> 
		<div id="multiple_price_template">
	       <div class="row JS_radio_switch_group">
                    <div class="col w110 mr10 text-right text-gray">{{}}&nbsp;</div>
                    <div class="col w60">&nbsp;成人价&nbsp;</div>
                    <div class="JS_radio_switch_box">
                        <div class="col w90">
                        <label class="radio"> 
                        <input type="radio" class="JS_radio_switch saleAble" name= "adult{index}" value="add"/>统一加价：</label></div><div class="col w80"><input class="w45 form-control JS_radio_disabled" disabled type="text"  data-validate="{regular:true}" data-validate-regular="^\d{1,9}(\.\d{1,2})?$"  max="999999999" name="addAudlt{index}"/></div>
                    </div>
                    <div class="JS_radio_switch_box">
                        <div class="col w90"><label class="radio"><input type="radio" class="JS_radio_switch saleAble" name="adult{index}" value="sub"/>统一减价：</label></div><div class="col w80"><input class="w45 form-control JS_radio_disabled" disabled type="text" data-validate="{regular:true}" data-validate-regular="^\d{1,9}(\.\d{1,2})?$" max="999999999" name="subAudlt{index}"/></div>
                    </div>
                    <div class="JS_radio_switch_box">
                        <div class="col w80"><label class="radio"><input type="radio" class="JS_radio_switch saleAble" name="adult{index}" value="customer" />自定义：</label></div><div class="col w80"><input class="w45 form-control JS_radio_disabled" disabled type="text" data-validate="{regular:true}" data-validate-regular="^\d{1,9}(\.\d{1,2})?$" max="999999999" name="customAdult{index}"/></div>
                    </div>
                </div>
                
                <div class="row JS_radio_switch_group">
                    <div class="col w110 mr10 text-right text-gray"></div>
                    <div class="col w60">儿童价</div>
                    <div class="JS_radio_switch_box">
                        <div class="col w90"><label class="radio"><input type="radio" class="JS_radio_switch saleAble" name="child{index}" value="add"/>统一加价：</label></div><div class="col w80"><input class="w45 form-control JS_radio_disabled" disabled type="text" data-validate="{regular:true}" data-validate-regular="^\d{1,9}(\.\d{1,2})?$" max="999999999" name="addChild{index}"/></div>
                    </div>
                    <div class="JS_radio_switch_box">
                        <div class="col w90"><label class="radio"><input type="radio" class="JS_radio_switch saleAble" name="child{index}" value="sub"/>统一减价：</label></div><div class="col w80"><input class="w45 form-control JS_radio_disabled" disabled type="text" data-validate="{regular:true}" data-validate-regular="^\d{1,9}(\.\d{1,2})?$" max="999999999" name="subChild{index}"/></div>
                    </div>
                    <div class="JS_radio_switch_box">
                        <div class="col w80"><label class="radio"><input type="radio" class="JS_radio_switch saleAble" name="child{index}" value="customer"/>自定义：</label></div><div class="col w80"><input class="w45 form-control JS_radio_disabled" disabled type="text" data-validate="{regular:true}" data-validate-regular="^\d{1,9}(\.\d{1,2})?$" max="999999999" name="customBaby{index}"/></div>
                    </div>
                </div>
                
                <div class="row JS_radio_switch_group">
                    <div class="col w110 mr10 text-right text-gray"></div>
                    <div class="col w60">房差</div>
                    <div class="JS_radio_switch_box">
                        <div class="col w90"><label class="radio"><input type="radio" class="JS_radio_switch saleAble" name="grapSettlementPrice{index}" value="add"/>统一加价：</label></div><div class="col w80"><input class="w45 form-control JS_radio_disabled" disabled type="text" data-validate="{regular:true}" data-validate-regular="^\d{1,9}(\.\d{1,2})?$" max="999999999" name="addGap{index}"/></div>
                    </div>
                    <div class="JS_radio_switch_box">
                        <div class="col w90">
                            <label class="radio"><input type="radio" class="JS_radio_switch saleAble" name="grapSettlementPrice{index}" value="sub"/>统一减价：</label></div><div class="col w80"><input class="w45 form-control JS_radio_disabled" disabled type="text" data-validate="{regular:true}" data-validate-regular="^\d{1,9}(\.\d{1,2})?$" max="999999999" name="subGap{index}"/></div>
                    </div>
                    <div class="JS_radio_switch_box">
                        <div class="col w80">
                            <label class="radio"><input type="radio" class="JS_radio_switch saleAble" name="grapSettlementPrice{index}" value="customer"/>自定义：</label></div><div class="col w80"><input class="w45 form-control JS_radio_disabled" disabled type="text" data-validate="{regular:true}" data-validate-regular="^\d{1,9}(\.\d{1,2})?$" max="999999999" name="customGap{index}"/></div>
                    </div>
                </div>
		</div>
		<!-- 多价格价格 End-->
		
		<!-- 单价格 --> 
		<div id="single_price_template">
            <div class="row JS_radio_switch_group">
                <div class="col w110 mr10 text-right text-gray"></div>
                <div class="col w60">{{}}</div>
                <div class="JS_radio_switch_box">
                    <div class="col w90">
                        <label class="radio"><input type="radio" class="JS_radio_switch saleAble" value="add" name="adult{index}"/>统一加价：</label></div><div class="col w80"><div class="form-group"><input class="w45 form-control JS_radio_disabled" disabled type="text"  data-validate="{regular:true}" data-validate-regular="^\d{1,9}(\.\d{1,2})?$" max="999999999" name="addBaby{index}" /></div></div>
                </div>
                <div class="JS_radio_switch_box">
                    <div class="col w90"><label class="radio"><input type="radio" class="JS_radio_switch saleAble" value="sub" name="adult{index}"/>统一减价：</label></div><div class="col w80"><div class="form-group"><input class="w45 form-control JS_radio_disabled" disabled type="text" data-validate="{regular:true}" data-validate-regular="^\d{1,9}(\.\d{1,2})?$" max="999999999" name="subBaby{index}"/></div></div>
                </div>
                <div class="JS_radio_switch_box">
                    <div class="col w80">
                        <label class="radio"><input type="radio" class="JS_radio_switch saleAble" value="customer"  name="adult{index}" />自定义：</label></div><div class="col w80"><div class="form-group"><input class="w45 form-control JS_radio_disabled" disabled type="text" data-validate="{regular:true}" data-validate-regular="^\d{1,9}(\.\d{1,2})?$" max="999999999" name="customBaby{index}"/></div></div>
                </div>
            </div>
		</div>
		<!-- 单价格 End-->
					
	<div>	
	<!-- 添加用的模板-->

<script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/pandora-calendar.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/sales-information-modify-price.js"></script>

<script type="text/javascript" src="/vst_admin/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.validate.expand.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_validate.js"></script>
<script src="/vst_admin/js/js.js" type="text/javascript"></script>
<script type="text/javascript" src="/vst_admin/js/messages_zh.js"></script>

</body>
</html>
<script>
	//一键控制全选
	$('#orChecked').change(function(){
		 if($(this).is(':checked')){
		 	$("input[name='suppGoodsId']").attr('checked',true);
		 	$("input[name='suppGoodsId']:checked").each(function(){
	 			combhotelCheck($(this));
	 		});
		 	
		 }else{
		  	$("input[name='suppGoodsId']").attr('checked',false);
		  	$("input[name='suppGoodsId']").not("input:checked").each(function(){
		 		combhotelCheck($(this));
		 	});
		 } 
	});




	<#if categoryCode=='category_route_hotelcomb'>
		//将无效的隐藏
		$("label[cancelFlag='Y']").hide();
	</#if>
	
	var globalIndex = 0;
	
	function combhotelCheck(obj){
	
	var that = $(obj);
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
		var priceSettlmentTemplate = '';
		if(priceType=="SINGLE_PRICE"){
			priceTemplate = '<div goodsId='+goodsId+' class="priceDiv">'+ $("#single_price_template").html()+'</div>';
			priceSettlmentTemplate = '<div goodsId='+goodsId+' class="priceSettlmentDiv">'+ $("#single_price_template").html()+'</div>';
			
		}else if(priceType=="MULTIPLE_PRICE"){
			priceTemplate = '<div goodsId='+goodsId+' class="priceDiv">'+ $("#multiple_price_template").html()+'</div>';
			priceSettlmentTemplate = '<div goodsId='+goodsId+' class="priceSettlmentDiv">'+ $("#multiple_price_template").html()+'</div>';
		}else {
			alert("该商品未设置价格类型!");
			return;
		}
		//为模板设置商品名称
		priceTemplate = priceTemplate.replace(/{{}}/g,name);
		priceTemplate = priceTemplate.replace(/{index}/g,globalIndex++);
		priceSettlmentTemplate = priceSettlmentTemplate.replace(/{{}}/g,name);
		priceSettlmentTemplate = priceSettlmentTemplate.replace(/{index}/g,globalIndex);
		
		//设置库存模板
		var stockTemplate = '';
		
		//设置提前预定时间模板
		var aheadBookTimeTemplate = '';
		
		//如果是成人儿童房差
		if(that.is(".adult_child")){
		 //设置模板
			setAdultChildTemplate(goodsId,priceTemplate,priceSettlmentTemplate,stockTemplate,aheadBookTimeTemplate);
		//如果是	套餐
		}else if(that.is(".comb_hotel")){
			setAdultChildTemplate(goodsId,priceTemplate,priceSettlmentTemplate,stockTemplate,aheadBookTimeTemplate);
		//如果是附加
		}else if(that.is(".addition")){
			setAdditionTemplate(goodsId,priceTemplate,priceSettlmentTemplate,stockTemplate,aheadBookTimeTemplate);
		//如果是升级
		}else if(that.is(".upgrade")){
			setUpgradeTemplate(goodsId,priceTemplate,priceSettlmentTemplate,stockTemplate,aheadBookTimeTemplate);
		//如果是可换酒店
		}else if(that.is(".change_hotel")){
			setChangeTemplate(goodsId,priceTemplate,priceSettlmentTemplate,stockTemplate,aheadBookTimeTemplate);
		}
		globalIndex++;
		
		setPriceModelType();
		
		validInitPrice();
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
		var priceSettlmentTemplate = '';
		if(priceType=="SINGLE_PRICE"){
			priceTemplate = '<div goodsId='+goodsId+' class="priceDiv">'+ $("#single_price_template").html()+'</div>';
			priceSettlmentTemplate = '<div goodsId='+goodsId+' class="priceSettlmentDiv">'+ $("#single_price_template").html()+'</div>';
			
		}else if(priceType=="MULTIPLE_PRICE"){
			priceTemplate = '<div goodsId='+goodsId+' class="priceDiv">'+ $("#multiple_price_template").html()+'</div>';
			priceSettlmentTemplate = '<div goodsId='+goodsId+' class="priceSettlmentDiv">'+ $("#multiple_price_template").html()+'</div>';
		}else {
			alert("该商品未设置价格类型!");
			return;
		}
		//为模板设置商品名称
		priceTemplate = priceTemplate.replace(/{{}}/g,name);
		priceTemplate = priceTemplate.replace(/{index}/g,globalIndex++);
		priceSettlmentTemplate = priceSettlmentTemplate.replace(/{{}}/g,name);
		priceSettlmentTemplate = priceSettlmentTemplate.replace(/{index}/g,globalIndex);
		
		//设置库存模板
		var stockTemplate = '';
		
		//设置提前预定时间模板
		var aheadBookTimeTemplate = '';
		
		//如果是成人儿童房差
		if(that.is(".adult_child")){
		 //设置模板
			setAdultChildTemplate(goodsId,priceTemplate,priceSettlmentTemplate,stockTemplate,aheadBookTimeTemplate);
		//如果是	套餐
		}else if(that.is(".comb_hotel")){
			setAdultChildTemplate(goodsId,priceTemplate,priceSettlmentTemplate,stockTemplate,aheadBookTimeTemplate);
		//如果是附加
		}else if(that.is(".addition")){
			setAdditionTemplate(goodsId,priceTemplate,priceSettlmentTemplate,stockTemplate,aheadBookTimeTemplate);
		//如果是升级
		}else if(that.is(".upgrade")){
			setUpgradeTemplate(goodsId,priceTemplate,priceSettlmentTemplate,stockTemplate,aheadBookTimeTemplate);
		//如果是可换酒店
		}else if(that.is(".change_hotel")){
			setChangeTemplate(goodsId,priceTemplate,priceSettlmentTemplate,stockTemplate,aheadBookTimeTemplate);
		}
		globalIndex++;
		
		setPriceModelType();
		
		validInitPrice();
	});

	//设置成人儿童模板
	function setAdultChildTemplate(goodsId,priceTemplate,priceSettlmentTemplate,stockTemplate,aheadBookTimeTemplate){
		//设置价格模板
		var size = $("#adult_child_price").find("div[goodsId="+goodsId+"]").size();
		if(size == 0){
			$("#adult_child_price").append(priceTemplate);
		}
		//设置价格模板
		var size = $("#adult_child_price_settement").find("div[goodsId="+goodsId+"]").size();
		if(size == 0){
			$("#adult_child_price_settement").append(priceSettlmentTemplate);
		}
	}

	//设置升级
	function setUpgradeTemplate(goodsId,priceTemplate,priceSettlmentTemplate,stockTemplate,aheadBookTimeTemplate){
		//设置价格模板
		var size = $("#upgrade_price").find("div[goodsId="+goodsId+"]").size();
		if(size == 0){
			$("#upgrade_price").append(priceTemplate);
		}
		
		var size = $("#upgrade_price_settement").find("div[goodsId="+goodsId+"]").size();
		if(size == 0){
			$("#upgrade_price_settement").append(priceSettlmentTemplate);
		}
	}
	
	//设置可换
	function setChangeTemplate(goodsId,priceTemplate,priceSettlmentTemplate,stockTemplate,aheadBookTimeTemplate){
		//设置价格模板
		var size = $("#change_price").find("div[goodsId="+goodsId+"]").size();
		if(size == 0){
			$("#change_price").append(priceTemplate);
		}
		
		var size = $("#change_price_settement").find("div[goodsId="+goodsId+"]").size();
		if(size == 0){
			$("#change_price_settement").append(priceSettlmentTemplate);
		}
	}
	
	//设置附加模板
	function setAdditionTemplate(goodsId,priceTemplate,priceSettlmentTemplate,stockTemplate,aheadBookTimeTemplate){
		//设置价格模板
		var size = $("#addition_price").find("div[goodsId="+goodsId+"]").size();
		if(size == 0){
			$("#addition_price").append(priceTemplate);
		}
		
		var size = $("#addition_price_settement").find("div[goodsId="+goodsId+"]").size();
		if(size == 0){
			$("#addition_price_settement").append(priceSettlmentTemplate);
		}
	}	

	//删除模板
	function deleteTemplate(goodsId){
		$("div[goodsid="+goodsId+"]").remove();
	}

	//销售价模式
	function setPriceModelType(){
		$('.priceDiv').find('.saleAble').each(function(){
			var that = $(this);
			if(that.attr('checked')=='checked'){
				that.parents('tr').find('input[type=text]').attr("disabled","disabled");
				that.next().removeAttr('disabled');
			}
		});
		
		$('.priceSettlmentDiv').find('.saleAble').each(function(){
			var that = $(this);
			if(that.attr('checked')=='checked'){
				that.parents('tr').find('input[type=text]').attr("disabled","disabled");
				that.next().removeAttr('disabled');
			}
		});
	}

	$('.priceDiv').find('.saleAble').live('click',function(){
		setPriceModelType();
	});
	
	$('.priceSettlmentDiv').find('.saleAble').live('click',function(){
		setPriceModelType();
	});


	var  validateAddIsTrue = null;	
	//动态绑定页面价格库存等模板 时候,一些校验输入的交互js 需要动态加载js来获取效果
	function validInitPrice(){
			var $form = $("#timePriceFormInput");
			//表单验证
			validateAddIsTrue = backstage.validate({
			    $area: $form,
			    //$submit: $btnSave,
			    showError: true
			});
			validateAddIsTrue.start();
			validateAddIsTrue.watch();
	}

	// 保存
	$("#timePriceSaveButton").click(function(){
		var size = $("input[type=checkbox][name=suppGoodsId]:checked").size();
 		if(size == 0){
 			alert('请选择商品');
 			return;
 		}
		
		if($('input[name=nfadd_date]:checked').val()=='selectDate'){
			if($('#selDate').find('option').size()==0){
				alert("请选择日期");
				return;
			}
		}else if($('input[name=nfadd_date]:checked').val()=='selectTime'){
			if($('#startDateId').val().length<=0){
			 	alert("请选择开始时间");
			 	return;
			}
			if($('#endDateId').val().length<=0){
			 	alert("请选择结束时间");
			 	return;			 
			}	
		}else{
			 if($("input[type=checkbox][name=weekDay]:checked").size()==0){
			 	alert("请选择适用日期");
			 	return;
			 }				 
		}
		//验证价格数据不全为空
		//var textlengt = $("#timePriceFormInput input[type=text]").size();
		//alert(textlengt);
		var flag = false;
		var texts = $("#timePriceFormInput input[type=text]");
		texts.each(function(k){
			 if($(this).val()!=""){
			 	flag = true;
			 }
		});
		if(flag == false){
			alert("至少修改一个商品价格数据");
		 	return;
		}
		
		
	 	//var formValidate =  $("#timePriceForm").validate()
	    //清空验证信息
  		//formValidate.resetForm();
	  	
	  	//setIsOrNotValidate();
	  	
	  	//验证js
	  	validInitPrice();
	  	
		//验证日期
		//if(!formValidate.form()){
		//	return;
		//}	

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
	    $("#timePriceFormContent").append('<input type="hidden" value="${prodProductId}" name="productId">')
		var loading = top.pandora.loading("正在努力保存中...");
		$.ajax({
			url : "/vst_admin/lineMultiroute/goods/timePrice/editLineMultiRoutePrice.do",
			data :　$("#timePriceForm").serialize(),
			dataType:'JSON',
			type: "POST",
			success : function(result){
				alert(result.message);
				loading.close();
				//window.parent.document.getElementById('search_button').click();
				//window.parent.settlementPriceButtonDialog.close();
				$("div[class=priceDiv]").remove();
				$("div[class=priceSettlmentDiv]").remove();
				//清除日历数据
				$(".JS_select_date_hidden option").remove();
				$(".JS_select_date td.calSelected[date-map]").removeClass("calSelected");
				
				$("input[type='checkbox']:checked").each(function(){
					$(this).attr('checked',false);
				});
				
				$("input[type='radio']:checked").each(function(){
					$(this).attr('checked',false);
				});
				
				$('#startDateId').val('');
				$('#endDateId').val('');

			},
			error : function(){
				alert('服务器错误');
				loading.close();
			}
		})
	});	
	
	//取消
	$('#timePriceCancelButton').live('click',function(){
		window.parent.settlementPriceButtonDialog.close();
	});	
	
	isView();

	//设置验证子项
	function setIsOrNotValidate(){
		//价格
    	$("#adult_child_price,#upgrade_price,#change_price,adult_child_price_settement,addition_price_settement,upgrade_price_settement,change_price_settement").find("input[type=text]").each(function(){
			$(this).rules("add",{required : true, number:true,isNum:true, min : 0,messages : {min:'价格必须大于等于0',isNum:'价格格式不正确(填至多2位小数正数)'}});
    	});
	}
	
  	jQuery.validator.addMethod("isNum", function(value, element) {
		var num = /^[1-9]{0}\d+(\.\d{1,2})?$/;
	    return this.optional(element) || (num.test(value));       
	}, "只能为整数或者最多两位小数");
	
	jQuery.validator.addMethod("isNumber0", function(value, element) {
		var num1 = /^(-)?[1-9]{0}\d+(\.\d{1,2})?$/;
		return this.optional(element) || (num1.test(value));
	}, "只能为数字或者最多两位小数");
	
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
	
	//设置价格表单数据
	function setPriceFormData(){
		var priceDivIndex = 0;
		
		//销售价
		$(".priceDiv").each(function(i){
			var that = $(this);
			
			var goodsId = that.attr("goodsId");
	    	//创建商品Id
	    	$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].suppGoodsId" value="'+goodsId+'">');
	    	$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].priceType" value="price">');
	    	
			that.find('input[type=radio]:checked').each(function(j){	
				//var actionPrice = $(this).next().val(); //操作价格
				var actionPrice = $(this).parent().parent().next().find(":input").val();
				var peopleType = $(this).attr('name');
				if(peopleType=='child'){
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].actionPrice['+j+']" value="'+actionPrice+'">');		
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].peopleType['+j+']" value="'+peopleType+'">');				
				}else{
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].actionPrice['+j+']" value="'+actionPrice+'">');
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].peopleType['+j+']" value="'+peopleType+'">');
				}
				var priceType =  $(this).val(); //价格模式： 自定义{customer}、统一加价{add}、统一减价{sub}
				$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].actionType['+j+']" value="'+priceType+'">'); 
			});
			priceDivIndex++;
	    });
	    
	    
	    //结算价
		$(".priceSettlmentDiv").each(function(i){
			i = i+priceDivIndex;
			var that = $(this);
			var goodsId = that.attr("goodsId");
	    	//创建商品Id
	    	$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].suppGoodsId" value="'+goodsId+'">');
	    	$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].priceType" value="settlement">');
			
			that.find('input[type=radio]:checked').each(function(j){
				//var actionPrice = $(this).next().val(); //操作价格
				var actionPrice = $(this).parent().parent().next().find(":input").val();
				var peopleType = $(this).attr('name');
				if(peopleType=='child'){
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].actionPrice['+j+']" value="'+actionPrice+'">');		
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].peopleType['+j+']" value="'+peopleType+'">');				
				}else{
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].actionPrice['+j+']" value="'+actionPrice+'">');
					$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].peopleType['+j+']" value="'+peopleType+'">');
				}
				var priceType =  $(this).val(); //价格模式： 自定义{customer}、统一加价{add}、统一减价{sub}
				$("#timePriceFormContent").append('<input type="hidden" name="timePriceList['+i+'].actionType['+j+']" value="'+priceType+'">'); 
			});
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
</script>