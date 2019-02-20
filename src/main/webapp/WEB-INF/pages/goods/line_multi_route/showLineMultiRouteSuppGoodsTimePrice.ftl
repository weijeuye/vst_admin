<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>销售信息</title>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/pandora-calendar.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/sales-information.css"/>
    <link href="/vst_admin/css/css.css" rel="stylesheet"/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<#include "/base/head.ftl"/>
	<link rel="stylesheet" href="/vst_admin/css/ui-common.css" type="text/css" />
	<!--<link rel="stylesheet" href="/vst_admin/css/ui-components.css" type="text/css"/>-->
	<link rel="stylesheet" href="/vst_admin/css/iframe.css" type="text/css"/>
	<link rel="stylesheet" href="/vst_admin/css/dialog.css" type="text/css"/>
	<link rel="stylesheet" href="/vst_admin/css/button.css" type="text/css"/>
	<link rel="stylesheet" href="/vst_admin/css/base.css" type="text/css"/>
	<link rel="stylesheet" href="/vst_admin/css/normalize.css" type="text/css"/>
	<link rel="stylesheet" href="/vst_admin/css/calendar.css" type="text/css"/>
	<link rel="stylesheet" href="/vst_admin/css/jquery.jsonSuggest.css" type="text/css"/>
	<link rel="stylesheet" href="/vst_admin/css/jquery.ui.autocomplete.css" type="text/css"/>
	<link rel="stylesheet" href="/vst_admin/css/jquery.ui.theme.css" type="text/css"/>
	<!--<link rel="stylesheet"  href="/vst_admin/css/contentManage/kindEditorConf.css" type="text/css"/>-->
</head>
<body class="sales-information">

<!--页面 开始-->
<div class="everything">

    <h2 class="title">
    	<#if prodProduct != null && prodProduct.bizCategory != null>
            ${prodProduct.bizCategory.categoryName}&gt;
        </#if>销售信息
    </h2>

    <!--友情提示 开始-->
    <div class="tip tip-warning clearfix">
        <span class="pull-left">
            <span class="icon icon-warning"></span>
            友情提示：
        </span>

        <div class="pull-left">
	    	<#if categoryCode!='category_route_hotelcomb'>
				注，成人/儿童/房差，为自动新增，若最小最大起订量需要修改，请到“管理成人儿童房差”，里面修改<br/>
				注，若成人/儿童/房差，维护了儿童价，请对你创建的升级、可换酒店，至少维护掉儿童价。。。不然，将会因为缺少儿童价，而前台不可售<br/>
				注，婴儿、税金、自备签，为自动新增，若最小最大起订量需要修改，请到“管理附加”，里面修改<br/>
				注，管理升级、管理可换+酒店，任何一项有具体商品后，不能维护另外一个<br/>
				注，若某商品暂时不售，请到“管理成人儿童”、“管理附加”、“管理升级”、“管理可换+酒店”，里面设置无效<br/>
				注，升级、可换-酒店，维护的是加价金额；且酒店维护的是区间段的总价，非每天的日价格。<br/>
			</#if>
			<#if categoryCode=='category_route_hotelcomb'>
			注，修改套餐的商品信息，请到“管理套餐”里面维护<br/>
			注，添加维护附加产品，请到“管理附加”里面维护<br/>
			</#if>
        </div>
    </div>
    <!--友情提示 结束-->

    <div class="filter clearfix">
        <div class="col w80">选择商品：</div>
        
            <div class="col">
        		<form id="searchForm">
		    	<input type="hidden" name="specDate" id="specDate1">
				<input type="hidden" value="${prodProductId}" name="productId" id="productId">
				<input type="hidden" value="${categoryId}" id="categoryId">
				<input type="hidden" value="${productType}" id="productType">
				<input type="hidden" value="${packageType}" id="packageType">
				<input type="hidden" value="${categoryCode}" id="categoryCode" name="categoryCode">
				<input type="hidden" value="${subCategoryId}" id="subCategoryId">
				
				
		    	<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_local' || categoryCode=='category_route_customized'>
                <div class="row">
                    <div class="col w80 mr10 text-right text-gray">成人儿童：</div>
					<#assign adultChildGoods = goodsMap['adult_child_diff'] />
					<#if adultChildGoods??>
                    <div class="col w450">
                        <label class="checkbox"><input type="checkbox" class="checkGoods" name="suppGoodsId" value="${adultChildGoods.suppGoodsId}"   data_name="${adultChildGoods.goodsName}" data_price_type="${adultChildGoods.priceType}" />${adultChildGoods.goodsName}[${adultChildGoods.suppGoodsId}]</label>
                    </div>
			 		<#assign mainProdBranchId = '${adultChildGoods.productBranchId}' />
		 			<#assign mainSuppGoodsId = '${adultChildGoods.suppGoodsId}' />
		 			</#if>		 		
                </div>
                </#if>
                
				<#if categoryCode=='category_route_hotelcomb'>
				<div class="row">
					<div class="col w80 mr10 text-right text-gray">套餐：</div>
					<div class="col w450">
			 		<#assign comboDinnerList = goodsMap['combo_dinner'] />
			 		<#list comboDinnerList as comboDinnerGoods>
		 				<label class="checkbox"  <#if comboDinnerGoods.cancelFlag!='Y'>cancelFlag="Y"</#if> ><input type="checkbox" class="checkGoods" name="suppGoodsId" value="${comboDinnerGoods.suppGoodsId}" data_name="${comboDinnerGoods.goodsName}" data_price_type="${comboDinnerGoods.priceType}" groupId="${comboDinnerGoods.groupId}"  />${comboDinnerGoods.goodsName}[${comboDinnerGoods.suppGoodsId}]</label>
		 			<#assign mainProdBranchId = '${comboDinnerGoods.productBranchId}' />
					<#assign mainSuppGoodsId = '${comboDinnerGoods.suppGoodsId}' />
			 		</#list>
			 		</div>
				</div>
				</#if>
				
	 	    	<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_local' || categoryCode=='category_route_hotelcomb' || categoryCode=='category_route_customized'>
				<div class="row">
					<div class="col w80 mr10 text-right text-gray">附加：</div>
					<div class="col w450">
					<#assign additionList = goodsMap['addition'] />
					<#list additionList as additionGoods>
						<label class="checkbox"  <#if additionGoods.cancelFlag!='Y'>cancelFlag="Y"</#if>  ><input type="checkbox" class="checkGoods" name="suppGoodsId" value="${additionGoods.suppGoodsId}"  data_name="${additionGoods.goodsName}" data_price_type="${additionGoods.priceType}" />${additionGoods.goodsName}[${additionGoods.suppGoodsId}]</label>
					</#list>
					</div>
				</div>
 				</#if>	
 				
 		 	    <#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_customized'>
				<div class="row">
				<div class="col w80 mr10 text-right text-gray"> 升级：</div>
				<#assign upgradList = goodsMap['upgrad'] />
				<#list upgradList as upgradGoods>
					<label class="checkbox"><input type="checkbox" class="checkGoods" name="suppGoodsId" value="${upgradGoods.suppGoodsId}"  data_name="${upgradGoods.goodsName}" data_price_type="${upgradGoods.priceType}" />${upgradGoods.goodsName}[${upgradGoods.suppGoodsId}]</label>
				</#list>
				</div>
				</#if>
 		 
 		 
 		 	    <#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_customized'>
		 		<div class="row">
		 		<div class="col w80 mr10 text-right text-gray">可换酒店：</div>	
		 		<#assign changedHotelList = goodsMap['changed_hotel'] />
		 		<#list changedHotelList as changedHotelGoods>
		 			<label class="checkbox"><input type="checkbox" class="checkGoods" name="suppGoodsId" value="${changedHotelGoods.suppGoodsId}"  data_name="${changedHotelGoods.goodsName}" data_price_type="${changedHotelGoods.priceType}" />${changedHotelGoods.goodsName}[${changedHotelGoods.suppGoodsId}]</label>
		 		</#list>
		 		</div>
		 		</#if>

            	</form>
            </div>
           
            
            <div class="col w150">
                <div class="btn-group">
                    <@mis.checkPerm permCode="5909"><a class="btn btn-warning btn-view" id="search_button">查看</a></@mis.checkPerm>
                </div>
            </div>
            
            <div class="col w160">
            	<#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_local' || categoryCode=='category_route_customized'>
                <div class="row">
                    <div class="col w160">
                    	<@mis.checkPerm permCode="5911"><a class="btn btn-primary btn-sm w120 btnListener"  branchCodeData='adult_child_diff' branchName='房差'>管理成人/儿童/房差</a></@mis.checkPerm>
                    </div>
                </div>
                </#if>
			    
			    <#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_customized'>
                <div class="row">
                    <div class="col w160">
			    	<@mis.checkPerm permCode="5912"><a class="btn btn-primary btn-sm w120 btnListener"  branchCodeData='upgrad' branchName='升级'>管理升级</a></@mis.checkPerm>
                    </div>
                </div>
			    </#if>
			    
			    <#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_customized'>
                <div class="row">
	                <div class="col w160">
			    		<@mis.checkPerm permCode="5913"><a class="btn btn-primary btn-sm w120 btnListener"  branchCodeData='changed_hotel' branchName='可换酒店'>管理可换酒店</a></@mis.checkPerm>
                    </div>
                </div>
			    </#if>

			    <#if categoryCode=='category_route_hotelcomb'>
                <div class="row">
	                <div class="col w160">
			    		<a class="btn btn-primary btn-sm w120 btnListener"  branchCodeData='combo_dinner' branchName='套餐'>管理套餐</a>
                	</div>
                </div>
			    </#if>
			    
              
			    <#if categoryCode=='category_route_group' || categoryCode=='category_route_freedom' || categoryCode=='category_route_local' || categoryCode=='category_route_hotelcomb' || categoryCode=='category_route_customized'>
		      	<div class="row">
	                <div class="col w160">
			    		<@mis.checkPerm permCode="5914"><a class="btn btn-primary btn-sm w120 btnListener" id="brandManager" branchCodeData='addition' branchName='附加'>管理附加</a></@mis.checkPerm>
            		</div>
                </div>
			    </#if>
			    
			    
				<#if categoryCode=='category_route_hotelcomb'>
		      	<div class="row">
	                <div class="col w160">
						<a class="btn btn-primary btn-sm w120" id="showInvalidedGoods" href="javascript:void(0);" style="font-size:12px;"  data="1">显示无效商品</a>
            		</div>
                </div>
				</#if>
                
            </div>
        
    </div>

    <div class="hr mb10"></div>

    <div class="row">
        <div class="pull-left">
            <div class="btn-group">
                <@mis.checkPerm permCode="5906"><a class="btn btn-primary btn-sm " id="batch_button">新增</a></@mis.checkPerm>
                <@mis.checkPerm permCode="5907"><a class="btn btn-primary btn-sm " id="batch_in_update_button">修改</a></@mis.checkPerm>
                <@mis.checkPerm permCode="5908"><a class="btn btn-sm JS_btn_modify_price" id="modify_price_button"><span class="text-warning">批量修改价格</span></a></@mis.checkPerm>
               <#if categoryCode=='category_route_group' || categoryCode=='category_route_local'>
               <@mis.checkPerm permCode="6239"><a class="btn btn-primary"  id="refreshGroupDateButton"> 刷新团期</a></@mis.checkPerm>
               </#if>
            </div>
        </div>
        <div class="pull-right">
            <div class="col w200">
                <@mis.checkPerm permCode="5910"><a class="btn btn-primary showLogDialog" param='objectId=${prodProductId}&objectType=SUPP_GOODS_GOODS&sysName=VST'>查看日志</a></@mis.checkPerm>
            </div>
        </div>
    </div>
    <!--时间价格表 开始-->
    <div class="time-price" id="timePriceDiv">

    </div>
    <!--时间价格表 结束-->

</div>
<!--页面 结束-->

<!--脚本 模板 开始-->
<div class="template">

    <!--单个产品录入&修改-->
    <div class="dialog-single">
        <iframe src="about:blank" class="iframe-single" frameborder="0"></iframe>
    </div>

    <!--新增产品-->
    <div class="dialog-add">
        <iframe src="about:blank" class="iframe-add" frameborder="0"></iframe>
    </div>

    <!--修改产品-->
    <div class="dialog-edit">
        <iframe src="about:blank" class="iframe-edit" frameborder="0"></iframe>
    </div>

    <!--批量修改价格-->
    <div class="dialog-modify-price">
        <iframe src="about:blank" class="iframe-modify-price" frameborder="0"></iframe>
    </div>

</div>
<!--脚本 模板 结束-->

<div id="templateDiv" style="display:none">
 <!-- 多价格价格 --> 
<div id="multiple_price_template">
	<table   class="e_table form-inline" style="width:900px;" goodsId="">
         <tbody>
            <tr>
                <td width="150px">{{}}（成人价）</td>
	            <td width="300px"><label style="display:inline"><input type="checkbox" class="saleAble" name="adult"/>禁售</label></td>
	            <td width="150px">{{}}（儿童价）</td>
	            <td width="300px"><label style="display:inline"><input type="checkbox" class="saleAble" name="child" checked=checked/>禁售</label></td>
            </tr>
            <tr>
                <td class="e_label">销售价：</td>
	            <td><input type="text"  name="auditPrice{index}" data="auditPrice" class="adult" /></td>
           		<td class="e_label">销售价：</td>
	            <td><input type="text"  name="childPrice{index}" data="childPrice" class="child" disabled="disabled"/></td>
            </tr>
            <tr>
                <td class="e_label">结算价：</td>
                <td><input type="text"  name="auditSettlementPrice{index}" data="auditSettlementPrice" class="adult" /></td>
           		<td class="e_label">结算价：</td>
                <td><input type="text"  name="childSettlementPrice{index}" data="childSettlementPrice" class="child" disabled="disabled" /></td>
            </tr>
             <tr>
                <td width="150px">{{}}（单房差）</td>
                <td colspan="3"><label style="display:inline"><input type="checkbox" class="saleAble" name="gap"  checked=checked />禁售</label></td>
             </tr>
             <tr>
                <td class="e_label">销售价：</td>
	            <td><input type="text" name="gapPrice{index}" data="gapPrice" class="gap"  disabled="disabled"/></td>
             </tr>
             <tr>
                <td class="e_label">结算价：</td>
	            <td><input type="text" name="grapSettlementPrice{index}" data="grapSettlementPrice" class="gap" disabled="disabled"/></td>
             </tr>
            </tbody>
   </table>
</div>

<!-- 单价格 --> 
<div id="single_price_template">
	<table  class="e_table form-inline" style="width:320px;" goodsId="">
         <tbody>
            <tr>
                <td width="150px">{{}}</td>
	            <td width="170px"><label style="display:inline"><input type="checkbox" class="saleAble" name="adult"/>禁售</label></td>
            </tr>
            <tr>
                <td class="e_label">销售价：</td>
	            <td><input type="text" name="auditPrice_{index}" data="auditPrice" class="adult" /></td>
            </tr>
            <tr>
                <td class="e_label">结算价：</td>
                <td><input type="text" name="auditSettlementPrice_{index}" data="auditSettlementPrice" class="adult" /></td>
            </tr>
        </tbody>
   </table>
</div>
   
    <!-- 多价格库存 --> 
   <div id="multiple_stock_template">
   <table  class="e_table form-inline" style="width:600px" goodsId="">
         <tbody>
         	<tr><td colspan="2">{{}}</td></tr>
            <tr>
                <td width="150" class="e_label"><label class="radio"><input type="radio" class="typeSelect"  name="stockType" checked="checked" value="INQUIRE_NO_STOCK"/>现询-未知库存</label></td>
           		<td width="450"></td>
            </tr>
            <tr>
                <td class="e_label"><label class="radio"><input type="radio" class="typeSelect"   name="stockType" value="INQUIRE_WITH_STOCK"/>现询-已知库存</label></td>
            	<td></td>
            </tr>
            <tr>
                <td class="e_label">日库存量：</td>
            	<td>
            	<div>
            	<input type="text"  name="stockIncrease_{index}" errorEle="selectDateIncrease{index}" disabled="disabled" required />份(不含婴儿)
            	<div id="selectDateIncrease{index}Error" style="display:inline"></div>
            	</div>
            	</td>
            </tr>
            <tr>
                <td class="e_label">是否可超卖：</td>
            	<td>
            	<select class="w10" name="oversellFlag" disabled="disabled">
                    	<option value="Y">可超卖</option>
                    	<option value="N">不可超卖</option>
                 </select></td>
            </tr>
            <tr>
                <td class="e_label"><label class="radio" style="padding-right:21px;"><input type="radio" class="typeSelect"  name="stockType" value="CONTROL"/>切位/库存</label></td>
            	 <td></td>
            </tr>
            <tr>
                <td class="e_label">日库存量：</td>
            	<td>
            	<div>
            	<input type="text"  name="stockIncrease1_{index}" errorEle="selectDateIncrease1{index}" disabled="disabled" required />份(不含婴儿)
            	<div id="selectDateIncrease1{index}Error" style="display:inline"></div>
            	</div>
            	</td>
            </tr>
            <tr>
                <td class="e_label">是否可超卖：</td>
            	<td>
            	<select class="w10" name="overshellFlag" disabled="disabled">
                    	<option value="Y">可超卖</option>
                    	<option value="N">不可超卖</option>
                    </select></td>
            </tr>
             </tbody>
           </table> 
        </div>  
         
        <!-- 提前预定时间 -->  
        <div id="ahead_time_template">
        <table class="e_table form-inline" goodsId="">
         <tbody>
         	<tr><td colspan="2">{{}}</td></tr>
         	<tr>
                <td width="150" class="e_label">提前预定时间：</td>
                <td>
                	<input type="hidden"  name="aheadBookTime" id="aheadBookTime">
                	<select class="w10 mr10" name="aheadBookTime_day">
	                      <#list 0..50 as i>
	                      <option value="${i}">${i}</option>
	                      </#list>
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
                    <select class="w10" name="bookLimitType" id="bookLimitType">
                    	<option value="NONE">无限制</option>
                    	<option value="PREAUTH">一律预授权</option>
                    	<option value="NOT_PREAUTH">不使用预授权</option>
                    </select>
                </td>
            </tr>
        </tbody>
        </table> 
        </div>
<div>
</body>
</html>

<script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/sales-information.js"></script>
<#include "/base/foot.ftl"/>
<script src="/vst_admin/js/pandora-ebk-calendar.js"></script>
<script src="/vst_admin/js/pandora-calendar.js"></script>
<script>
<#if categoryCode=='category_route_hotelcomb'>
	//将无效的隐藏
	$("label[cancelFlag='Y']").hide();
</#if>
/**
 * 验证结算价必须小于销售价
 */
jQuery.validator.addMethod("compareToPrice", function(value, element) {
    //获得当前元素所在td的索引
    var index = $(element).parent("td").index();
    var priceElement = $(element).parents("tr").prev("tr").find("td").eq(index).find("input");
    return this.optional(element) || (parseFloat(value) <= parseFloat(priceElement.val()));
 }, "");
 
  jQuery.validator.addMethod("isNum", function(value, element) {
		    var num = /^[1-9]{0}\d*(\.\d{1,2})?$/;
		    return this.optional(element) || (num.test(value));       
}, "价格只能为整数或者最多两位小数");

	jQuery.validator.addMethod("isIntegerWith0", function(value, element) {
		var num1 = /(^[1-9]+)$|0$/;
		return this.optional(element) || (num1.test(value));
	}, "库存只能为正整数");
	
	var good = {};
	var globalIndex = 0;
	var specDate;
	$("#backToLastPageButton").click(function(){
		window.history.go(-1);
	});
	
	//为禁售绑定事件
	$(".saleAble").live('click',function(){
		var that = $(this);
		var claszz = that.attr("name");
		$(this).parents("tr").nextAll("tr").find("input").each(function(){
			if(that.attr("checked")!='checked'){
				if($(this).is("."+claszz))
					$(this).removeAttr("disabled");
			}else {
				if($(this).is("."+claszz))
				$(this).attr("disabled","disabled");
			}
			
		});
	});
	
	$(".typeSelect").live('click',function(){
		var that = $(this);
		//首先将其他所有的置为disabled
		$(this).parents("table").find("input[type=text],select").attr("disabled","disabled");
		if(that.val()=='INQUIRE_WITH_STOCK' || that.val()=='CONTROL'){
			$(this).parents("tr").nextAll("tr").eq(0).find("input").removeAttr("disabled");
			$(this).parents("tr").nextAll("tr").eq(1).find("select").removeAttr("disabled");
		}
	});
	
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
	
	//删除模板
	function deleteTemplate(goodsId){
		$("div[goodsid="+goodsId+"]").remove();
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
	    				var stockInput = $(this).closest("tr").nextAll("tr").eq(0).find("input");
	    				//获得库存input
//	    				var stockInput = stockInputType.next("input");
	    				var clone1 = stockInput.clone();
	    				//获得库存的类型
//	    				if(stockInputType.val()=='increase'){
//
//	    				}else if(stockInputType.val()=='decrease'){
//	    					clone1.val(-clone1.val());
//	    				}
	    				clone1.attr("name","timePriceList["+i+"].stock");
    					$("#timePriceFormContent").append(clone1);
    					var obj2 = $(this).closest("tr").nextAll("tr").eq(1).find("select");
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
	
	//设置验证子项
	function setIsOrNotValidate(){
		//如果选择了设置价格
		if($("#isSetPrice").attr("checked")=="checked"){
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
            /**
	    	//添加销售价结算价验证
	    	$("#adult_child_price,#addition_price,#upgrade_price").find("input[name*='SettlementPrice']").each(function(){
	    		$(this).rules("add",{compareToPrice : true,messages : {compareToPrice:'结算价不能大于销售价'}});
	    	});
	    	*/
	    }else {
	    	$("#adult_child_price,#addition_price,#upgrade_price,#change_price").find("input[type=text]").each(function(){
	    		$(this).rules("remove");
	    	});
	    }
	   
	    //如果选择了设置库存
	    if($("#isSetStock").attr("checked")=="checked"){
	    	$("#adult_child_stock,#addition_stock,#upgrade_stock,#change_stock").find("input[type=text]").each(function(){
	    		//判断有没有选择库存设置类型
	    		if($(this).attr("disabled")!="disabled"){
	    			$(this).rules("add",{required : true,isIntegerWith0:true ,min:0,messages : {min:'库存必须为大于等于0的整数'}});
	    		}else {
	    			$(this).rules("remove");
	    		}
	    	});
	    }else {
	    	$("#adult_child_stock,#addition_stock,#upgrade_stock,#change_stock").find("input[type=text]").each(function(){
	    		$(this).rules("remove");
	    	});
	    }
	    
	   
	}
	
	$("#timePriceSaveButton").click(function(){

	   var priceValidate = $("#timePriceFormInput").validate();
	   var formValidate =  $("#timePriceForm").validate()
	  
	   if($("input[type=checkbox][name=weekDay]:checked").size()==0){
		 	$.alert("请选择适用日期");
		 	return;
	   }
	 
	  //清空验证信息
	  formValidate.resetForm();
	  priceValidate.resetForm();
	  //验证日期
	  if(!formValidate.form()){
		  return;
	   }
	   setIsOrNotValidate();
	  //验证必填数据
	  if(!priceValidate.form()){
		  return;
	   }
	
		//构造Form提交数据
		$("#timePriceFormContent").empty();
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
	    $("#timePriceFormContent").append('<input type="hidden" value="${prodProductId}" name="prodProductId">')
	var loading = top.pandora.loading("正在努力保存中...");
	$.ajax({
		url : "/vst_admin/tour/goods/timePrice/editGoodsTimePrice.do",
		data :　$("#timePriceForm").serialize(),
		dataType:'JSON',
		type: "POST",
		success : function(result){
			$.alert(result.message);
			loading.close();
		},
		error : function(){
			$.alert('服务器错误');
			loading.close();
		}
	})
});

<#if categoryCode=='category_route_hotelcomb'>
	$("#showInvalidedGoods,#showInvalidedGoods1").click(function(){
		$("label[cancelFlag='Y']").toggle();
		var data = $(this).attr("data");
		if(data=="1"){
			$("#showInvalidedGoods,#showInvalidedGoods1").attr("data","0");
			$("#showInvalidedGoods,#showInvalidedGoods1").html("隐藏无效商品");
		}else {
			$("#showInvalidedGoods,#showInvalidedGoods1").attr("data","1");
			$("#showInvalidedGoods,#showInvalidedGoods1").html("显示无效商品");
		}

	});
</#if>

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
 
 	//设置全选,优化
$("input[type=checkbox][name=combAll]").click(function(){
	if($(this).attr("checked")=="checked"){
		$("input[type=checkbox][class='checkGoods comb_hotel']").attr("checked","checked");
		var checkboxs=$("input[type=checkbox][class='checkGoods comb_hotel']");
		for(var i=0;i<checkboxs.length;i++){
		   var that = $(checkboxs[i]); 	  
           var name = that.attr("data_name");
           var priceType = that.attr("data_price_type");
           var goodsId = that.val();

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
		}
	}else{
		$("input[type=checkbox][class='checkGoods comb_hotel']").removeAttr("checked");
		
		var checkboxs=$("input[type=checkbox][class='checkGoods comb_hotel']");
		for(var i=0;i<checkboxs.length;i++){
		   var that = $(checkboxs[i]); 	  
		   var goodsId = that.val();
	        //如果是取消，则执行删除模板操作
	       deleteTemplate(goodsId);
	    }
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
     
   	// 填充日历数据
    function fillData() {
        var that = this,
        url = "/vst_admin/lineMultiroute/goods/timePrice/findGoodsTimePriceList.do";
        var month = that.options.date.getMonth();
        var year = that.options.date.getFullYear();
        var day = that.options.date.getDate();
        
        specDate = year+"-"+(month+1)+"-"+day;
        
        function setData(data) {
            if (data === undefined) {
                return;
            }
            data.forEach(function (arr) {
            	routeName = arr.routeName;
            	cancelStrategyName = arr.cancelStrategyName;
            	var isPermission = arr.permission;//是否有权限查看结算价
                var $td = that.warp.find("td[date-map=" + arr.specDateStr + "]");
                var suppGoodsId = arr.suppGoodsId;
                var priceType = $("input[value="+suppGoodsId+"]").attr("data_price_type");
                var goodsName = $("input[value="+suppGoodsId+"]").attr("data_name");
                var groupId = $("input[value="+suppGoodsId+"]").attr("groupId");
                var liArray = [];
             	//适用行程
                if(routeName!=null){
                    liArray.push('<li><span class="cc3">适用行程:'+arr.routeName+'</span></li>');
                }                      
             	//退改规则
                if(cancelStrategyName!=null){
                	if(arr.errorRefundStrategy){
            			liArray.push('<li><span class="cc3" style="color:red;">退改规则:'+arr.cancelStrategyName+'</span></li>');
                	}else{
                		liArray.push('<li><span class="cc3">退改规则:'+arr.cancelStrategyName+'</span></li>');
                	}                    
                }                    
                if(groupId!="" && groupId!=undefined && groupId!=null){
                	liArray.push('<li><span class="cc3">'+goodsName+'</span><span  style="color:blue">&nbsp;共享库存</span></li>');
                }else{
                	liArray.push('<li><span class="cc3">'+goodsName+'</span></li>');
                }
                //设置价格
                //如果是多价格
                if(priceType=='MULTIPLE_PRICE'){
                	var auditPrice = arr.auditPrice;
                	var auditSettlementPrice = arr.auditSettlementPrice;
                	var childPrice = arr.childPrice;
                	var childSettlementPrice = arr.childSettlementPrice;
                	var gapPrice = arr.gapPrice;
                	var grapSettlementPrice = arr.grapSettlementPrice;
                	var onsaleFlag = arr.onsaleFlag;
                	
					if(auditSettlementPrice==null){
            			adultString = "<span style='color:red'>禁售</span>";
            		}else if(auditSettlementPrice!=null && onsaleFlag=="N"){
            			adultString = "<span style='color:red'>禁售</span>";
            		}else{
            			if(auditPrice==null){
            				if(isPermission) adultString = "结:"+(auditSettlementPrice/100).toFixed(2);
            			}else{
            				adultString = "售:"+(auditPrice/100).toFixed(2)+(isPermission?"结:"+(auditSettlementPrice/100).toFixed(2):"");
            			}
            		}


                	if(childSettlementPrice==null){
            			childString = "<span style='color:red'>禁售</span>";
            		}else if(childSettlementPrice!=null && onsaleFlag=="N"){
            			childString = "<span style='color:red'>禁售</span>";
            		}else{
            			if(childPrice==null){
            				if(isPermission) childString = "结:"+(childSettlementPrice/100).toFixed(2);
            			}else{
            				childString = "售:"+(childPrice/100).toFixed(2)+(isPermission?"结:"+(childSettlementPrice/100).toFixed(2):"");
            			}
            		}
                		
            		if(grapSettlementPrice==null){
            			gapString = "<span style='color:red'>禁售</span>";
            		}else if(grapSettlementPrice!=null && onsaleFlag=="N"){
            			gapString = "<span style='color:red'>禁售</span>";
            		}else{
            			if(gapPrice==null){
            				if(isPermission) gapString = "结:"+(grapSettlementPrice/100).toFixed(2);
            			}else{
            				gapString = "售:"+(gapPrice/100).toFixed(2)+(isPermission?"结:"+(grapSettlementPrice/100).toFixed(2):"");
            			}
            		}
                	liArray.push('<li><span class="cc3">成人价：</span>'+ adultString +' <span class="cc3">儿童价：</span>'+childString+' <span class="cc3">房差：</span>'+gapString+'</li>');
                	
                	if("Y".indexOf(arr.preSaleFlag)>=0){
                		var auditPre = arr.auditPrice_pre;
	                	var auditSettlementPre = arr.auditSettlementPrice_pre;
	                	var childPre = arr.childPrice_pre;
	                	var childSettlementPre = arr.childSettlementPrice_pre;
	                	var adultPreString = "";
	                	var childPreString = "";
	                	var onsaleFlag = arr.onsaleFlag;
                		if(auditSettlementPre==null){
            				adultPreString = "<span style='color:red'>禁售</span>";
	            		}else{
	            			if(auditPre==null){
	            				if(isPermission) adultPreString = "结:"+(auditSettlementPre/100).toFixed(2);
	            			}else{
	            				adultPreString = "售:"+(auditPre/100).toFixed(2)+(isPermission?"结:"+(auditSettlementPre/100).toFixed(2):"");
	            			}
	            		}
	
	
	                	if(childSettlementPre==null){
	            			childPreString = "<span style='color:red'>禁售</span>";
	            		}else{
	            			if(childPre==null){
	            				if(isPermission) childPreString = "结:"+(childSettlementPre/100).toFixed(2);
	            			}else{
	            				childPreString = "售:"+(childPre/100).toFixed(2)+(isPermission?"结:"+(childSettlementPre/100).toFixed(2):"");
	            			}
	            		}
	            		liArray.push('<li><span class="cc3"></span>是否买断：是</li>');
	            		liArray.push('<li><span class="cc3">成人买断价：</span>'+ adultPreString +' <span class="cc3">儿童买断价：</span>'+childPreString);
                		
                	}else{
                		
	            		liArray.push('<li><span class="cc3"></span>是否买断：否</li>');
                	}
                	
                	
                }else if(priceType=='SINGLE_PRICE'){
                	var auditPrice = arr.auditPrice;
                	var auditSettlementPrice = arr.auditSettlementPrice;
                	//售卖标志，N为禁售，Y为可售
                	var onsaleFlag = arr.onsaleFlag;
                	if(auditPrice==null){
                		adultString = "<span style='color:red'>禁售</span>";
                	}else if(auditPrice!=null && onsaleFlag=="N"){
                		adultString = "<span style='color:red'>禁售</span>";
                	}else{
                		if(auditSettlementPrice==null){
                			adultString = "售:"+(auditPrice/100).toFixed(2);
                		}else{
                			adultString = "售:"+(auditPrice/100).toFixed(2)+(isPermission?"结:"+(auditSettlementPrice/100).toFixed(2):"");
                		}
                		<#if categoryCode=='category_route_hotelcomb'>
							//酒店套餐，设置为禁售后价格还会保留，所以要根据禁售标志判断
							if(onsaleFlag == "N"){
								adultString = "<span style='color:red'>禁售</span>";
							}
						</#if>
                	}
                	liArray.push('<li><span class="cc3"></span>'+ adultString +'</li>');
                	
                	if("Y".indexOf(arr.preSaleFlag)>=0){
                		var auditPre = arr.auditPrice_pre;
	                	var auditSettlementPre = arr.auditSettlementPrice_pre;
	                	
	                	var adultPreString = "";
                		if(auditSettlementPre==null){
            				adultPreString = "<span style='color:red'>禁售</span>";
	            		}else{
	            			if(auditPre==null){
	            				if(isPermission) adultPreString = "结:"+(auditSettlementPre/100).toFixed(2);
	            			}else{
	            				adultPreString = "售:"+(auditPre/100).toFixed(2)+(isPermission?"结:"+(auditSettlementPre/100).toFixed(2):"");
	            			}
	            		}
						liArray.push('<li><span class="cc3"></span>是否买断：是</li>');
	            		liArray.push('<li><span class="cc3">成人买断价：</span>'+ adultPreString );
                	}else{
                		liArray.push('<li><span class="cc3"></span>是否买断：否</li>');
                	}
                	
                }
                
                 <#if categoryCode=='category_route_hotelcomb'>
				 if(arr.bringPreSale=='Y'){
				     var onsaleFlag = arr.onsaleFlag;
                     liArray.push('<li><span class="cc3"></span>是否预售：是 </li>' );
                     if(arr.hotelIsBanSell == "Y"){
                       liArray.push('<li><span class="cc3" style="color:red">禁售</span></li>' );
                     }else{
                         liArray.push('<li><span class="cc3"> 结：</span>'+(arr.hotelShowPreSale_pre/100).toFixed(2)+ '</li>' );
                     }
                   }else{
                    liArray.push('<li><span class="cc3"></span>是否预售：否</li>');
                 }
                 <#else>
                  if(arr.bringPreSale=='Y'){
                     liArray.push('<li><span class="cc3"></span>是否预售：是 </li>' );
                     var adultString='';
                     if(arr.auditIsBanSell=='Y'){
            			     adultString = "<span style='color:red'>禁售</span>";
            		  }else{
            				 adultString = (arr.auditShowPreSale_pre/100).toFixed(2);
            		  }
                    var childString='';
                	if(arr.childIsBanSell=='Y'){
            			childString = "<span style='color:red'>禁售</span>";
            		}else{
            			childString = (arr.childShowPreSale_pre/100).toFixed(2);
            		}
                     liArray.push('<li><span class="cc3">成人价 结：</span>'+adultString+ '<span class="cc3">儿童价  结：</span>'+childString+'</li>' );
                   }else{
                    liArray.push('<li><span class="cc3"></span>是否预售：否</li>');
                 }
				</#if>
               var aheadBookTime = ''; 
               if(arr.aheadBookTime!=null){
               		aheadBookTime =  minutesToDate(arr.aheadBookTime);
               		aheadBookTime = '提前'+aheadBookTime;
               }
               
               //设置库存
                //杨振中 2016-02-25 目的地BU酒店套餐显示更改为初始库存,日库存，updated on 201604-05 去掉目的地BU，目前包括所有bu的酒店套餐  && arr.bu!=null && arr.bu =='DESTINATION_BU'
                if(arr.categoryId!=null && arr.categoryId==17 ){
                    var stockHtml = '<li><span class="cc3"></span>保留房数';
                    if(arr.stockType=='INQUIRE_NO_STOCK'){
                        stockHtml=stockHtml+'(未知库存)未知库存&nbsp;&nbsp;'+aheadBookTime+'</li>';
                    }else if(arr.stockType=='INQUIRE_WITH_STOCK' || arr.stockType=='CONTROL'){

                        var stock = arr.stock == null ? 0  : arr.stock;
                        var initStock = arr.initStock == null ? 0  : arr.initStock;
                        var oversellFlag = arr.oversellFlag == 'Y' ? '可超'  : '不可超';
                        stockHtml=stockHtml+'('+initStock+')'+stock+'&nbsp;&nbsp;'+oversellFlag+'&nbsp;&nbsp;'+aheadBookTime+'</li>';
                    }else{
                        stockHtml='<li><span class="cc3"></span>'+aheadBookTime+'</li>';
                    }
                    liArray.push(stockHtml);

                }else{
                    if(arr.stockType=='INQUIRE_NO_STOCK'){
                    
                    var subCategoryId=0;
                    subCategoryId=$("#subCategoryId").val();
                    if("FOREIGNLINE"==$("#productType").val() || subCategoryId==181){
                       liArray.push('<li><span class="cc3"></span>现询(未知库存)&nbsp;&nbsp;'+aheadBookTime+'</li>');
                    }else {
                       liArray.push('<li><span class="cc3"></span>现询&nbsp;&nbsp;'+aheadBookTime+'</li>');
                    }
                    }else if(arr.stockType=='INQUIRE_WITH_STOCK'){
                        var stock = arr.stock;
                        var oversellFlag = arr.oversellFlag == 'Y' ? '可超'  : '不可超';
                        liArray.push('<li><span class="cc3"></span>现询('+stock+')&nbsp;&nbsp;'+oversellFlag+'&nbsp;&nbsp;'+aheadBookTime+'</li>');
                    }else if(arr.stockType=='CONTROL'){
                        var stock = arr.stock;
                        var oversellFlag = arr.oversellFlag == 'Y' ? '可超'  : '不可超';
                        liArray.push('<li><span class="cc3"></span>切位('+stock+')&nbsp;&nbsp;'+oversellFlag+'&nbsp;&nbsp;'+aheadBookTime+'</li>');
                    }else {
                        liArray.push('<li><span class="cc3"></span>'+aheadBookTime+'</li>');
                    }
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
                $td.find("div.fill_data").append("<ul>"+liArray.join('')+"</ul>");

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
        
        $("#specDate1").val(specDate);
        $.ajax({
            url: url,
            type: "POST",
            dataType: "JSON",
            data : $("#searchForm").serialize(),
            success: function (json) {
               setData(json);
            },
            error: function () { }
        });

    }
    
 	$("#search_button").live('click',function(){
 		//判断数量是否小于等于5个
 		var size = $("input[type=checkbox]:checked","#searchForm").size();
 		if(size == 0){
 			$.alert('请选择商品');
 			return;
 		}
 		if(size > 5){
 			$.alert("最多选择5个商品，当前选择数量"+size);
 			return;
 		}
 		var goodsId = $(this).val();
		var supplierId = $(this).attr("data");
		good.goodsId = goodsId;
		good.supplierId = supplierId;
		pandora.calendar({
            sourceFn: fillData,
            autoRender: true,
            frequent: true,
            showNext: true,
            mos :0,
            classNames: {
	            week: ["sun", "mon", "tue", "wed", "thu", "fri", "sat"],
	            caldate: "caldate day_box",
	            nodate: "nodate day_box", // 禁用和空
	            today: "today", // 今天
	            hover: "hover", // 鼠标滑过效果
	            festival: "calfest", // 节日
	            monthPrev: "month-prev",
	            monthNext: "month-next"
	        },
            template: template,
            target: $("#timePriceDiv")
        });				
    }); 
	
	 //规格管理页面
     $("a.btnListener").bind("click",function(i){
 		var productId = "${prodProductId!''}";
		var branchCode = $(this).attr("branchCodeData");
		
		if(branchCode=='adult_child_diff'){
			addDialog = new xDialog("/vst_admin/tour/goods/goods/showUpdateSuppGoods.do?productId="+productId,{}, {title:"修改商品",width:900,height:400,iframe:true})
			return;
		}
		
		var branchName = $(this).attr("branchName");
		var categoryId = "${categoryId!''}";
		var mainProdBranchId = "${mainProdBranchId!''}";
		var mainSuppGoodsId = "${mainSuppGoodsId!''}";
		if(mainSuppGoodsId == '' || mainProdBranchId == ''){
			alert("请先新增主规格或主商品");
			return;
		}
		var isPass = true;
		//如果是升级或者可换，则先进行检查
		if(branchCode == 'upgrad' || branchCode=='changed_hotel'){
			$.ajax({
				url : '/vst_admin/packageTour/prod/prodbranch/checkProductBranch.do',
				type : "post",
				data : { "branchCode" : branchCode,"productId" : productId , "categoryId" : categoryId},
				async: false,
				success : function(result){
					if(result=='error')
						isPass = false;
				},
				error :function(result){
				
				}
			});
		}
		
		var bacthButtonDialog,settlementPriceButtonDialog,priceButtonDialog,backRulesButtonDialog,batchLockupButtonDialog,batchProdRouteDialog,saveButtonDialog;
		
		if(!isPass){
			$.alert('升级和可换酒店为互斥模式');
			return;
		}
		
		if((categoryId == '15' || categoryId == '18') && branchCode=='changed_hotel'){
			var url="/vst_admin/productPack/line/showChangeHotelList.do?branchCode=" + branchCode+"&productId=" + productId +"&categoryId=" + categoryId
						+"&mainProdBranchId=" + mainProdBranchId;
			addDialog = new xDialog(url,{},{title:"管理"+ branchName,iframe:true,width:"1094px",height:"800px",zIndex:200});
		}else{
			var url = "/vst_admin/packageTour/prod/prodbranch/findProductBranchList.do?branchCode=" + branchCode + "&productId=" + productId + "&categoryId=" + categoryId + "&mainProdBranchId=" + mainProdBranchId;
			addDialog = new xDialog(url,{}, {title:"管理"+ branchName,iframe:true,width:1100,height:650})
		}
	});
	
	function reload() {
		addDialog.close();
		window.location.reload();
	};
	
	if($("#isView",parent.document).val()=='Y'){
		$("#timePriceSaveButton").remove();
	}
	
	var bacthButtonDialog,settlementPriceButtonDialog,priceButtonDialog,backRulesButtonDialog,batchLockupButtonDialog,batchProdRouteDialog,saveButtonDialog,cancelEditTimeGoodsDialog;

	
    var $template = $(".template");
    

	//批量修改价格
    $("#modify_price_button").bind("click",function(i){
 		var productId = "${prodProductId!''}";
 		var categoryId = "${categoryId!''}";
		settlementPriceButtonDialog = new xDialog("/vst_admin/lineMultiroute/goods/timePrice/showBatchSavePrice.do?productId="+productId+"&categoryId="+categoryId,{}, {title:"批量修改销售价",width:900,height:500,iframe:true})
	});	
	
	//批量录入
    $("#batch_button").bind("click",function(i){
 		var productId = "${prodProductId!''}";
 		var categoryId = "${categoryId!''}";
 		var packageType = "${packageType!''}";
 		var productType = "${productType!''}";
 		bacthButtonDialog = new xDialog("/vst_admin/lineMultiroute/goods/timePrice/showBatchSaveLineMultiRoute.do?productId="+productId+"&categoryId="+categoryId+"&productType="+productType+"&packageType="+packageType,{}, {title:"新增",width:950,height:800,iframe:true})
	});
	//批量新增修改
    $("#batch_in_update_button").bind("click",function(i){
 		var productId = "${prodProductId!''}";
 		var categoryId = "${categoryId!''}";
 		var packageType = "${packageType!''}";
 		var productType = "${productType!''}";
		cancelEditTimeGoodsDialog = new xDialog("/vst_admin/lineMultiroute/goods/timePrice/showEditBatchPrice.do?productId="+productId+"&categoryId="+categoryId+"&productType="+productType+"&packageType="+packageType,{}, {title:"修改",width:950,height:800,iframe:true})
		
	});

		//批量修改退改规则
    $("#back_rules_button").bind("click",function(i){
 		var productId = "${prodProductId!''}";
 		var categoryId = "${categoryId!''}";
		backRulesButtonDialog = new xDialog("/vst_admin/lineMultiroute/goods/timePrice/showBatchSaveCancelStrategy.do?productId="+productId+"&categoryId="+categoryId,{}, {title:"批量修改退改规则",width:900,height:800,iframe:true})
	});
	
	//批量禁售
    $("#batch_lockup_button").bind("click",function(i){
 		var productId = "${prodProductId!''}";
 		var categoryId = "${categoryId!''}";
		batchLockupButtonDialog = new xDialog("/vst_admin/lineMultiroute/goods/timePrice/showBatchSuppGoodsLockUp.do?productId="+productId+"&categoryId="+categoryId,{}, {title:"批量禁售",width:900,height:800,iframe:true})
	});	
	
	//批量修改适用行程
    $("#batch_update_prod_route").bind("click",function(i){
 		var productId = "${prodProductId!''}";
 		var categoryId = "${categoryId!''}";
		priceButtonDialog = new xDialog("/vst_admin/lineMultiroute/goods/timePrice/showBatchSaveSellmentPrice.do?productId="+productId+"&categoryId="+categoryId,{}, {title:"批量修改结算价",width:900,height:800,iframe:true})
	});

	// 单个产品录入
	$('.caltable td').live('click',function(){
		var date = $(this).attr('date-map');
		if(!checkEndTime(date)){
			if(date!='undefined' && date!=null){
				var productId = $('#productId').val();
				var categoryId = $('#categoryId').val();
				var packageType = "${packageType!''}";
 				var productType = "${productType!''}";
				batchProdRouteDialog = new xDialog("/vst_admin/lineMultiroute/goods/timePrice/showSaveLineMultiRoute.do?productId="+productId+"&spec_date="+date+"&categoryId="+categoryId+"&productType="+productType+"&packageType="+packageType,{}, {title:"单个产品录入",width:950,height:800,iframe:true})
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
	
	$("#refreshGroupDateButton").click(function(){
		var productId=$("#productId").val();
		var loading = top.pandora.loading("正在努力计算中...");
		$.ajax({
			url : "/vst_admin/prod/refund/refreshSuppPackGroupDate.do",
			data : {productId:productId},
			dataType:'JSON',
			success : function(result){
				$.alert(result.message,function(){
					
				});
				loading.close();
			},
			error : function(){
				$.alert('服务器错误');
				loading.close();
			}
		});
	});
	

   	
</script>