<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
</head>
<body>
<style>
tr .city {
	background-color:#EEEEEE;
	display:block; 
	float:left;
	margin-right:10px;
	margin-bottom:5px;
}
tr .cityGroupNamec1 {
	display:block; 
	float:left;
	margin-right:10px;
	margin-bottom:5px;
}
tr .cityGroupNamec2 {
	display:block; 
	float:left;
	margin-right:10px;
	margin-bottom:5px;
}
tr .city span:nth-child(1){
	margin:8px;
}

tr .city span:nth-child(2){
	margin-right:4px;
	color:red;
	cursor:pointer;
}

.day_error{
	color: red;
	margin: 0px;
	padding: 0px;
	display: inline;
}
</style>
<div class="iframe_content mt10">
<div class="tiptext tip-warning"><span class="tip-icon tip-icon-warning"></span>插入交通信息</div>
       <div class="p_box box_info p_line">
       <form action="/vst_admin/productPack/line/addGroup.do" method="post" id="dataForm">
       		<input type="hidden"  name="productId" id="productId"  value="${productId }"/>
       		<input type="hidden"  name="groupType" id="groupType"  value="${groupType }"/>
       		<input type="hidden"  name="selectCategoryId" id="selectCategoryId" value="${selectCategoryId }"/>
       		<input type="hidden"  name="isMuiltDparture" id="isMuiltDparture" value="${isMuiltDparture }"/>
       		<input type="hidden"  name="BU" id="BU" value="${BU }"/>
       		<input type="hidden"  name="destId" id="destId" value="${destId }"/>
       		<!----------公共的头部DIV start--------------->
            <div class="box_content">
	            <table class="e_table form-inline" >
					   <tr >
		                	<td class="e_label" style="text-align: left;">产品品类</td>
		                    <td style="text-align: left;">
		                    	<select name="categoryId" id="categoryId"  readonly = "true">
								  	<#list bizCategoryList as list>
								  		<#if selectCategoryId == list.categoryId>
					                    	<option value="${list.categoryId}" selected>${list.categoryName}</option>
					                    </#if>
								  	</#list>
							  	</select>
		                    </td>
		                    <td></td>
		                </tr>
		                 <tr>
		                	<td class="e_label" style="text-align: left;">组时间限制</td>
		                    <td style="text-align: left;">
		                    	<select name="dateType" id="dateType" readonly = "true">
		                    			<#if selectCategoryId == '16'>
		                    				<option value="DATERANGESELECT" selected>区间日期，可选</option>
		                    			<#else>
		                    				<option value="NODATESELECT" selected>指定日期，不可选</option>
		                    			</#if>
							  	</select>
		                    </td>
		                    <td></td>
		                </tr>
		                 <tr>
		                	<td class="e_label" style="text-align: left;">组可添加产品数量限制</td>
		                    <td style="text-align: left;">
		                    	<select name="selectType" id="selectType" readonly = "true">
		                    		<#if selectCategoryId == '15' || selectCategoryId == '18'>
		                    			<option value="ONE" selected>只能添加一个产品</option>
		                    		<#else>
		                    			 <option value="NOLIMIT" selected>无限制</option>
		                    		</#if>
							  	</select>
		                    </td>
		                    <td></td>
		                </tr>
		                <tr>
		                	<td class="e_label" style="text-align: left;">交通类型</td>
		                    <td style="text-align: left;">
		                    	<input type="radio"  data="transportType" name="prodPackageGroupTransport.transportType" value="TOBACK" checked="checked" class="c1 autoPackageClass"/>往返程&nbsp;&nbsp;
			             		<input type="radio" data="transportType" name="prodPackageGroupTransport.transportType" value="TO" class="c2 autoPackageClass"/>单程
		                    </td>
		                    <td></td>
		                </tr>
		                <#if isMuiltDparture== 'Y'>
		                <tr>
		                	<td class="e_label" style="text-align: left;">产品品类</td>
		                    <td style="text-align: left;">
							  	<#list twoLevelTraffics as twoLevelTraffic>
							  	   <input class = "autoPackageClass" type="radio" data="${twoLevelTraffic.name()}" name="twoLevelCategry" id="twoLevelCategry_${twoLevelTraffic.getCategoryId()}" value="${twoLevelTraffic.getCategoryId()}"/>${twoLevelTraffic.getCnName()}&nbsp;&nbsp;
							  	</#list>
		                    </td>
		                    <td></td>
		                </tr>
		                <tr>
		                	<td class="e_label" style="text-align: left;"><div id = "autoPackageLabelDiv" hidden="true">打包方式</div></td>
		               		<td style="text-align: left;">
		               			<div id="autoPackageRadioDiv" hidden="true">
		                    	<input type="radio" data="autoPackage" name="prodPackageGroupTransport.autoPackage" value="N" checked="checked" class="autoPackageClass"/>手工打包&nbsp;&nbsp;
			             		<input type="radio" data="autoPackage" name="prodPackageGroupTransport.autoPackage" value="Y" class="autoPackageClass"/>自动打包
                    			</div>
		                    </td>
		                    <td>
		                    </td>
		                </tr>
		                </#if>
	            </table>
            </div>
			<!----------公共的头部DIV end--------------->

            <!-----------  多出发地DIV start   -------->
            <div id="muiltDpartureDiv">
            <div class="box_content">
                <!-- 接收多出发地的城市id组的隐藏域-->
       			<input type="hidden" name="multiToStartPointIds" id="multiToStartPointIds" value=""/>
            	<table class="e_table form-inline">
             		<tbody>
	             		<!-- 往返程 start-->
	                    <tr class="c1">
	             			<td class="e_label" style="text-align: right;">去程：</td>
	             			<td style="" >
	             				出发地 &nbsp;&nbsp;<input type="text" class="" name="n1"  id="multiToStartPoint">
		                    </td>
		                    <td style="" >
	             				第<select style="width:50px;" class="travelDays" name="prodPackageGroupTransport.toStartDays"></select>天出发
		                    </td>
	             		</tr>
	             		<tr class="c1">
	             		    <td class="e_label"></td>
	             			<td colspan="2" class="e_label" style="text-align: left;" id="cityGroupNamec1" >
	             			</td>
	                    </tr>
	                    <tr class="c1">
	                    	<td class="e_label"></td>
	             			<td colspan="2" class="e_label" id="multiToBackStartCitysTd" style="text-align: left;">
	             			</td>
	                    </tr>
	             		<tr class="c1">
	             			<td class="e_label" style="text-align: right;"></td>
	             			<td style="" >
	             				目的地 &nbsp;&nbsp;<input type="text" name="n2"  id="multiToDestination" required>
	             				<input type="hidden" class="" name="prodPackageGroupTransport.toDestination" id="multiToDestinationHidden">
		                    </td>
		                    <td style="">
		                    </td>
	             		</tr>
	             		 <tr class="c1">
	             			<td class="e_label" style="text-align: right;">返程：</td>
	             			<td style="" id="toBackbackStartPointTr">
	             				<div style="float:left;">出发地 &nbsp;&nbsp;</div>
	             				<input type="text" id="multiBackStartPoint" required>
	             				<input type="hidden" id="multiBackStartPointHidden" name="prodPackageGroupTransport.backStartPoint">
	             			</td>
		                    <td style="" >
	             				第<select style="width:50px;" class="travelDays" name="prodPackageGroupTransport.backStartDays"></select>天出发
		                    </td>
	             		</tr>
	             		<tr class="c1">
	             			<td colspan="3" class="e_label" style="text-align: left;">
	                    </tr>
	             		<tr class="c1">
	             			<td class="e_label" style="text-align: left;"></td>
	             		<td style="" id="multiBackDestPointTd"><div style="float:left;">目的地 &nbsp;&nbsp;</div>
		                    </td>
		                    <td style="" >
		                    </td>
	             		</tr>
	             		<!-- 往返程 end-->

	             		<!-- 单程 start-->
	                    <tr class="c2 d1">
	             			<td class="e_label" style="text-align: right;"><input type="radio" name="type" id="multiToRadio" value="to" class="toType" checked="checked"/>去程：</td>
	             			<td style="" >
	             				出发地 &nbsp;&nbsp;<input type="text" class="" name="n5" id="multiToStartPoint1">
	             				<input type="hidden" class="" name="prodPackageGroupTransport.toStartPoint" id="multiToStartPoint1Hidden">
		                    </td>
		                    <td style="" >
	             				第<select style="width:50px;" class="travelDays"  name="prodPackageGroupTransport.toStartDays"></select>天出发
		                    </td>
	             		</tr>
	             		<tr class="c2 d1">
	             		    <td class="e_label"></td>
	             			<td colspan="2" class="e_label" id="cityGroupNamec2" style="text-align: left;">
	                    </tr>
	                    <tr class="c2 d1">
	                    	<td class="e_label"></td>
	             			<td colspan="2" class="e_label" id="multiToStartCitysTd" style="text-align: left;">
	             				
	             			</td>
	                    </tr>
	             		<tr class="c2 d1">
	             			<td class="e_label" style="text-align: right;"></td>
	             			<td style="" >
	             				目的地 &nbsp;&nbsp;<input type="text" class="" name="n6" id="multiToDestination1" required>
	             				<input type="hidden" class="" name="prodPackageGroupTransport.toDestination" id="multiToDestination1Hidden">
		                    </td>
		                    <td style="">
		                    </td>
	             		</tr>
	             		<tr class="c2 d2">
	             			<td class="e_label" style="text-align: right;"><input type="radio" name="type" id="multiBackRadio" value="back" class="toType"/>返程：</td>
	             			<td style="" >
	             				<div style="float:left;">出发地 &nbsp;&nbsp;</div><div style="float:left;"><input type="text" class="" name="n7" id="multiBackStartPoint1" required></div>
	             				<input type="hidden" class="" name="prodPackageGroupTransport.backStartPoint" id="multiBackStartPoint1Hidden">
		                    </td>
		                    <td style="" >
	             				第<select style="width:50px;" class="travelDays"  name="prodPackageGroupTransport.backStartDays"></select>天出发
		                    </td>
	             		</tr>
	             		<tr class="c2 d2">
	             			<td class="e_label" style="text-align: left;"></td>
	             			<td style="" >
	             				<div style="float:left;">目的地 &nbsp;&nbsp;</div><div style="float:left;"><input type="text" class="" name="n8" id="multiBackDestination1" required></div>
	             				<input type="hidden" class="" name="prodPackageGroupTransport.backDestination" id="multiBackDestination1Hidden">
		                    </td>
		                    <td style="">
		                    </td>
	             		</tr>
	             		<!-- 单程 en-->
             		</tbody>
         	 	</table>
           	 </div>
           	 </div>
           	 <!------------ 多出发地DIV end--------->


			<!------------- 非多出发地DIV start---------------->
           	<div id="notMuiltDpartureDiv">
	        <div class="box_content">
        		<table class="e_table form-inline">
             		<tbody>
	                    <tr class="c1">
	             			<td class="e_label" style="text-align: right;">去程：</td>
	             			<td style="" >
	             				出发地 &nbsp;&nbsp;<input type="text" class="" name="n1"  id="toStartPoint" required>
	             				<input type="hidden" class="" name="prodPackageGroupTransport.toStartPoint" id="toStartPointHidden">
		                    </td>
		                    <td style="" >
	             				第<select style="width:50px;" class="travelDays" name="prodPackageGroupTransport.toStartDays"></select>天出发
		                    </td>
	             		</tr>
	             		<tr class="c1">
	             			<td class="e_label" style="text-align: right;"></td>
	             			<td s	tyle="" >
	             				目的地 &nbsp;&nbsp;<input type="text" class="" name="n2"  id="toDestination" required>
	             				<input type="hidden" class="" name="prodPackageGroupTransport.toDestination" id="toDestinationHidden">
		                    </td>
		                    <td style="" >
		                    </td>
	             		</tr>
	             		 <tr class="c1">
	             			<td class="e_label" style="text-align: right;">返程：</td>
	             			<td style="" >
	             				出发地 &nbsp;&nbsp;<input type="text" class="" name="n3"  id="backStartPoint" required>
	             				<input type="hidden" class="" name="prodPackageGroupTransport.backStartPoint" id="backStartPointHidden">
		                    </td>
		                    <td style="" >
	             				第<select style="width:50px;" class="travelDays" name="prodPackageGroupTransport.backStartDays"></select>天出发
		                    </td>
	             		</tr>
	             		<tr class="c1">
	             			<td class="e_label" style="text-align: left;"></td>
	             			<td s	tyle="" >
	             				目的地 &nbsp;&nbsp;<input type="text" class="" name="n4" id="backDestination" required>
	             				<input type="hidden" class="" name="prodPackageGroupTransport.backDestination" id="backDestinationHidden">
		                    </td>
		                    <td style="" >
		                    </td>
	             		</tr>
             		  
             		  
	                    <tr class="c2">
	             			<td class="e_label" style="text-align: right;"><input type="radio" name="type" value="to" class="toType" checked=checked/>去程：</td>
	             			<td style="" >
	             				出发地 &nbsp;&nbsp;<input type="text" class="" name="n5" id="toStartPoint1" required>
	             				<input type="hidden" class="" name="prodPackageGroupTransport.toStartPoint" id="toStartPoint1Hidden">
		                    </td>
		                    <td style="" >
	             				第<select style="width:50px;" class="travelDays"  name="prodPackageGroupTransport.toStartDays"></select>天出发
		                    </td>
	             		</tr>
	             		<tr class="c2">
	             			<td class="e_label" style="text-align: right;"></td>
	             			<td style="" >
	             				目的地 &nbsp;&nbsp;<input type="text" class="" name="n6" id="toDestination1" required>
	             				<input type="hidden" class="" name="prodPackageGroupTransport.toDestination" id="toDestination1Hidden">
		                    </td>
		                    <td style="" >
		                    </td>
	             		</tr>
	             		<tr class="c2">
	             			<td class="e_label" style="text-align: right;"><input type="radio" name="type" value="back" class="toType"/>返程：</td>
	             			<td style="" >
	             				出发地 &nbsp;&nbsp;<input type="text" class="" name="n7" id="backStartPoint1">
	             				<input type="hidden" class="" name="prodPackageGroupTransport.backStartPoint" id="backStartPoint1Hidden">
		                    </td>
		                    <td style="" >
	             				第<select style="width:50px;" class="travelDays"  name="prodPackageGroupTransport.backStartDays"></select>天出发
		                    </td>
	             		</tr>
	             		<tr class="c2">
	             			<td class="e_label" style="text-align: left;"></td>
	             			<td style="" >
	             				目的地 &nbsp;&nbsp;<input type="text" class="" name="n8" id="backDestination1" required>
	             				<input type="hidden" class="" name="prodPackageGroupTransport.backDestination" id="backDestination1Hidden">
		                    </td>
		                    <td style="" >
		                    </td>
	             		</tr>
             		</tbody>
             	</table>
            </div>
           	</div>
           	<!---------- 非多出发地DIV end-------->
           	
           	<!---------- 往返程+其他机票+自动打包DIV start-------->
           	<div id="tobackAutoPack">
	        <div class="box_content">
        		<table class="e_table form-inline">
             		<tbody>
             			<div id="toAutoPackDestnation">

	             		</div>
	             		<div id="backAutoPackDestnation">

	             		</div>
	                    <tr class="toAutoPack">
	             			<td class="e_label" style="text-align: right;">
	             				<input type="radio" id="toAutopackageRadio" class="autopackageRadioClass" name="autopackageToRadio" value="TO" class=""/>去程&nbsp;&nbsp;：
	             			</td>
		                    <td style="" >
	             				第<select style="width:50px;" id="startDaySelect" class="tobackTravelDays" name="prodPackageGroupTransport.toStartDays"></select>天出发
		                    </td>
		                    <td class="e_label" style="text-align: right;">航班到达时段&nbsp;&nbsp;：</td>
		                    <td style="" >
	             				<input type="text"  style="width:20px;" class="hour" id="toStartHour" value="00">&nbsp;&nbsp;时
	             				<input type="text"  style="width:20px;" class="minute" id="toStartMinute"id="toStartHour" value="00">&nbsp;&nbsp;分&nbsp;&nbsp;至
	             				<input type="text"  style="width:20px;" class="hour" id="toStartHour1" value="23">&nbsp;&nbsp;时
	             				<input type="text"  style="width:20px;" class="minute" id="toStartMinute1" value="59">&nbsp;&nbsp;分
		                    </td>
	             		</tr>
	             		<tr class="backAutoPack">
	             			<td class="e_label" style="text-align: right;">
	             				<input type="radio" id="backAutopackageRadio" class="autopackageRadioClass" name="autopackageBackRadio" value="BACK" class=""/>返程&nbsp;&nbsp：
	             			</td>
		                    <td style="" >
	             				第<select style="width:50px;" id="backStartDaySelect" class="tobackTravelDays" name="prodPackageGroupTransport.backStartDays"></select>天出发
		                    </td>
		                    <td class="e_label" style="text-align: right;">航班起飞时段&nbsp;&nbsp：</td>
		                    <td style="" >
	             				<input type="text"  style="width:20px;" class="hour" id="backStartHour" value="00">&nbsp;&nbsp;时
	             				<input type="text"  style="width:20px;" class="minute" id="backStartMinute" value="00">&nbsp;&nbsp;分&nbsp;&nbsp;至
	             				<input type="text"  style="width:20px;" class="hour" id="backStartHour1" value="23">&nbsp;&nbsp;时
	             				<input type="text"  style="width:20px;" class="minute" id="backStartMinute1" value="59">&nbsp;&nbsp;分
		                    </td>
	             		</tr>
             		</tbody>
             	</table>
            </div>
           	</div>
           	<!---------- 往返程+其他机票+自动打包DIV end-------->
            </form>
        </div>
        
        <div class="p_box box_info clearfix mb20">
            <div class="fl operate"><a class="btn btn_cc1" id="save">确认并保存</a></div>
        </div>
</div>
<#include "/base/foot.ftl"/>
</body>
</html>
<script>

//根据品类显示城市组模板
function showCityGroupName(categoryId){
   var BU = $("#BU").val();
   var cityGroupNamehtml = "";
   	var classValue = $("input[data=transportType]:checked").attr("class");
	var classValueArr = classValue.split(' ');
	if (classValueArr[0] == 'undefined') {
		return;
	}
	var c = classValueArr[0];
   $.ajax({
		url : "/vst_admin/productPack/line/getCityGroupByCategoryId.do?categoryId="+categoryId+"&BU="+BU,
		type : "post",
		dataType : 'json',
		success : function(result) {
		    $.each( result, function(key, value){ 
		        //多出发地往返程
		        if(c == 'c1'){
		           cityGroupNamehtml += '<div class="cityGroupNamec1"><span> <input type="radio" name="cityGroupNameRadio" id="cityGroupNameRadio" onchange="showCity('+ key +');"/> ' + value + '</span></div>';
		        }else if(c == 'c2'){
		           cityGroupNamehtml += '<div class="cityGroupNamec2"><span> <input type="radio" name="cityGroupNameRadio" id="cityGroupNameRadio" onchange="showCity('+ key +');"/> ' + value + '</span></div>';
		        }
            });
           if(c == 'c1'){
              $("#cityGroupNamec1").append(cityGroupNamehtml);
           }else if(c == 'c2'){
              $("#cityGroupNamec2").append(cityGroupNamehtml);
           }
		}
	})
	
	//cleanSavedMulteInfo();
	//清空节点
	if(c == 'c1'){
       $("#cityGroupNamec1").empty();  
       $("#multiBackDestPointTd").children("div:gt(0)").remove();
    }else if(c == 'c2'){
       $("#cityGroupNamec2").empty();
    }
}

//查询城市组城市
function showCity(key){
    var hasXhtml ="";
    var arrayCitys = new Array();
    var classValue = $("input[data=transportType]:checked").attr("class");
	var classValueArr = classValue.split(' ');
	if (classValueArr[0] == 'undefined') {
		return;
	}
	var c = classValueArr[0];
    $.ajax({
		url : "/vst_admin/productPack/line/getCityGroupBycityGroupId.do?cityGroupId="+key,
		type : "post",
		dataType : 'json',
		success : function(result) {
		    $.each(result, function(key, value){ 
		          var district = {};
		          district.districtId = key;
	          	  district.districtName = value;
		          arrayCitys.push(district);
            });
			
			if (c == 'c1') {
				var html = addDistrictsCity(arrayCitys);
				$("#multiToBackStartCitysTd").append(html.hasXhtml);
				$("#multiBackDestPointTd").append(html.nohasXhtml);
			} else if (c == 'c2') {
				var html = addDistrictsCity(arrayCitys);
				$("#multiToStartCitysTd").append(html.hasXhtml);
			}            
		}
	})
	//清空节点
	if(c == 'c1'){
	   $("#multiToBackStartCitysTd").empty(); 
       $("#multiBackDestPointTd").children("div:gt(0)").remove();
    }else if(c == 'c2'){
       $("#multiToStartCitysTd").empty();
    }
}
//
function addDistrictsCity(districts) {
	var cityArray = new Array();
	var hasXhtml = '';// 将要返回的有删除的多城市信息的拼接字符串
	var nohasXhtml = '';// 将要返回的没有删除的多城市信息的拼接字符串
	$.each(districts, function(index, district){
		cityArray.push(district.districtId);
		hasXhtml += '<div class="city"><span>' + district.districtName + '</span><span data="' + district.districtId + '">X</span></div>';
		nohasXhtml += '<div class="city"><span>' + district.districtName + '</span><span data="' + district.districtId + '"></span></div>';
		
	});

	$("#multiToStartPointIds").val(cityArray.join(','));
	var html = {}; 
	html.hasXhtml = hasXhtml;
	html.nohasXhtml = nohasXhtml;
	return html;
}

function checkMuiltDparture(){

	var isMuiltDparture = $("#isMuiltDparture").val();
	//判断是否为多出发地DIV显示,备注：isMuiltDparture == 'Y' 显示多出发DIV，否则为单出发地
	if (isMuiltDparture == 'Y') {
		$("#notMuiltDpartureDiv").find("input,select").attr("disabled","disabled");
		$("#notMuiltDpartureDiv").hide();
		$("#muiltDpartureDiv").show();
	} else {
		$("#muiltDpartureDiv").find("input,select").attr("disabled","disabled");
		$("#muiltDpartureDiv").hide();
		$("#notMuiltDpartureDiv").show();
	}
	
	// 获取当前要创建的线路产品的品类ID，备注：跟团游 15，自由行 18，当地游 16，酒店套餐 17
	var selectCategoryId = $("#selectCategoryId").val();
	//当地游
	if(selectCategoryId == '16'){
		//入住晚数
		$("#stayDays").append("<option value='0>0</option>");
	}

	setSelectValue();
	isView();
	
	//设置disabled
	$("input[data=transportType]").each(function(){
		$("#multiToStartPointIds").val('');
		var that = $(this);
		var classValue = that.attr("class");
		var classValueArr = classValue.split(' ');
		if (classValueArr[0] == 'undefined') {
			return;
		}
		var cl = classValueArr[0].toString();

		//如果没被选中，则找到后面紧跟的div然后设置为disabled
		if(!that.is(":checked")){
			if (isMuiltDparture == 'Y') {
				$("#muiltDpartureDiv " + "."+cl).find("input,select").attr("disabled","disabled");
				$("#muiltDpartureDiv " + "."+cl).hide();
			} else {
				$("#notMuiltDpartureDiv " + "."+cl).find("input,select").attr("disabled","disabled");
				$("#notMuiltDpartureDiv " + "."+cl).hide();
			}
		} else {
			if (isMuiltDparture == 'Y') {
				$("#muiltDpartureDiv " + "."+cl).find("input,select").removeAttr("disabled");
				$("#muiltDpartureDiv " + "."+cl).show();
			} else {
				$("#notMuiltDpartureDiv " + "."+cl).find("input,select").removeAttr("disabled");
				$("#notMuiltDpartureDiv " + "."+cl).show();
			}
		}
	});
}

//初始化目的地，备注：往返程+其他机票+自动打包情况下初始化为基本信息第一个市县级城市
function initDestnationPlace(){
	var destId = $("#destId").val();
	if(destId){
		 $.ajax({
			url : "/vst_admin/productPack/line/getCityBizDest.do",
			type : "get",
			dataType : 'json',
			data : "destId=" + destId,
			success : function(result) {
				if(result){
					$("#destnationPlace").val(result.destName);
					$("#destnationPlaceHidden").val(result.districtId);
					$("#sendPlace").val(result.destName);
					$("#sendPlaceHidden").val(result.districtId);
				}
			},
			error : function(result) {
				$.alert(result.message);
			}
		});
	}
}

//为第几天出发下拉按钮赋值
function setSelectValue(){
	var routeNum = "${routeNum}";
	if(routeNum != null && routeNum != ''){
	$(".travelDays,.tobackTravelDays").empty();
		$(".travelDays,.tobackTravelDays").append("<option value=''></option>");
		for(var index = 0 ; index < parseInt(routeNum); index ++){
			//添加行程天数
			$(".travelDays,.tobackTravelDays").append("<option value='" + (index + 1) + "'>" + (index + 1) + "</option>");
		}
		$("#startDaySelect").val(1);
		$("#backStartDaySelect").val(parseInt(routeNum));
	}
}

//jquery初始化方法
$(function(){
	
	$("#tobackAutoPack").hide();
	setDivAvalible($("#tobackAutoPack"),false);
	checkMuiltDparture();

	$(".autoPackageClass").live("change",function(){

		var that = $(this);
		var data = that.attr("data");
		var name = that.attr("name");
		var value = that.attr("value");
		//交通类型
   		var transportType = $("input[data=transportType]:checked").val();
		//产品品类
   		var twoLevelCategry = $("input[name=twoLevelCategry]:checked").val();
   		
		var isMuiltDparture = $("#isMuiltDparture").val();
		if(isMuiltDparture == 'Y' && name == 'twoLevelCategry'){
			showCityGroupName(value);
		}else if(isMuiltDparture == 'Y' && name == 'prodPackageGroupTransport.autoPackage'){
		    showCityGroupName(21);
		}
		
   		//判断现实逻辑
   		if($("#autoPackageRadioDiv").is(":hidden")){
   			if(twoLevelCategry==21){
   				$("#autoPackageRadioDiv").show();
   				$("#autoPackageLabelDiv").show();
   			}
   		}else{
   			if(twoLevelCategry!=21){
   				$("#autoPackageRadioDiv").hide();
   				$("#autoPackageLabelDiv").hide();
   			}
   		}

		//打包方式 
   		var autoPackage = $("input[data=autoPackage]:checked").val();
   		if(!transportType||!twoLevelCategry||!autoPackage){
   			checkMuiltDparture();
			setTransportTypeChangeAction($("input[data=transportType]:checked"));
			if(name=="twoLevelCategry"){
				$(this).attr("checked",true);
			}
   			return;
   		}else if(twoLevelCategry==21&&autoPackage=='Y'){
   			//设置隐藏div
		   	$("#notMuiltDpartureDiv").hide();
   			setDivAvalible($("#notMuiltDpartureDiv"),false);
	   		$("#muiltDpartureDiv").hide();
   			setDivAvalible($("#muiltDpartureDiv"),false);
	   		$("#tobackAutoPack").show();
	   		setDivAvalible($("#tobackAutoPack"),true);
	   		if(transportType == 'TO'){
	   				$(".autopackageRadioClass").show();
					autopackageRadioChange("TO");
					$("#toAutopackageRadio").attr("checked",true);
   				}else{
   					$(".autopackageRadioClass").hide();
   					autopackageSetDescription('TOBACK');
   			}
   			//初始化出发天数
   			setSelectValue();
			//初始化目的地
   			initDestnationPlace();
   		}else{
   			//设置显示div 
			$("#tobackAutoPack").hide();
			setDivAvalible($("#tobackAutoPack"),false);
			setDivAvalible($("#notMuiltDpartureDiv"),true);
			setDivAvalible($("#muiltDpartureDiv"),true);
   			checkMuiltDparture();
			setTransportTypeChangeAction($("input[data=transportType]:checked"));
			if(name=="twoLevelCategry"){
				$(this).attr("checked",true);
			}else if(name=="prodPackageGroupTransport.autoPackage"){
			    $("input[data = 'category_traffic_aero_other']").attr("checked", true);
			}

   			return;	
   		}
   		
  	});
  	
  	//一键打包单程时，去程和返程的raidochange事件
  	$(".autopackageRadioClass").live("click",function(){
		autopackageRadioChange($(this).val());
		
	});

});

	//设置去程和返程的change事件，同时控制出发地和目的地的显示逻辑
function autopackageRadioChange(value){

	if(!value){
			return;
		}else if(value == 'TO'){
			setDivAvalible($(".toAutoPack"),true);
			setDivAvalible($(".backAutoPack"),false);
			$("#backAutopackageRadio").removeAttr("disabled");
			$("#backAutopackageRadio").attr("checked",false);
			autopackageSetDescription('TO');
			initDestnationPlace();
		}else{
			setDivAvalible($(".backAutoPack"),true);
			setDivAvalible($(".toAutoPack"),false);
			$("#toAutopackageRadio").removeAttr("disabled");
			$("#toAutopackageRadio").attr("checked",false);
			autopackageSetDescription('TOBACK');
			initDestnationPlace();
		}
	}
	
function autopackageSetDescription(value){
	$("#toAutoPackDestnation").empty();
	$("#backAutoPackDestnation").empty();
	var transportType = $("input[data=transportType]:checked").val();
	if(!transportType){
		return;
	}
	var html = "";
	if(transportType == 'TOBACK'){
			html += "<tr>"; 
			html += "<td class='e_label' style='text-align: right;'>出发地&nbsp;&nbsp;：</td>"; 
			html += "<td class='e_label' style='text-align: left;'>全国&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; 
			html += "</td>"; 
			html += "<td class='e_label' style='text-align: right;'>目的地&nbsp;&nbsp;：</td>"; 
			html += "<td>"; 
			html += "<input type='text' class='' name='n1'  id='destnationPlace' required>"; 
			html += "<input type='hidden' class='' name='prodPackageGroupTransport.toDestination' id='destnationPlaceHidden'>"; 
			html += "</td>"; 
			html += "</tr>"; 
			$("#toAutoPackDestnation").html(html);
			return;
	}
	if(transportType == 'TO'){
		if(value == 'TO'){
			html += "<tr>"; 
			html += "<td class='e_label' style='text-align: right;'>出发地&nbsp;&nbsp;：</td>"; 
			html += "<td class='e_label' style='text-align: left;'>全国&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; 
			html += "</td>"; 
			html += "<td class='e_label' style='text-align: right;'>目的地&nbsp;&nbsp;：</td>"; 
			html += "<td>"; 
			html += "<input type='text' class='' name='n1'  id='destnationPlace' required>"; 
			html += "<input type='hidden' class='' name='prodPackageGroupTransport.toDestination' id='destnationPlaceHidden'>"; 
			html += "</td>"; 
			html += "</tr>"; 
			$("#toAutoPackDestnation").html(html);
			return;
	}else{
			html += "<tr>"; 
			html += "<td class='e_label' style='text-align: right;'>出发地&nbsp;&nbsp;：</td>"; 
			html += "<td>"; 
			html += "<input type='text' class='' name='n1'  id='sendPlace' required>"; 
			html += "<input type='hidden' class='' name='prodPackageGroupTransport.backStartPoint' id='sendPlaceHidden'>"; 
			html += "</td>"; 
			html += "<td class='e_label' style='text-align: right;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;目的地&nbsp;&nbsp;：</td>"; 
			html += "<td class='e_label' style='text-align: left;'>全国"; 
			html += "</td>"; 
			html += "</tr>"; 
			$("#toAutoPackDestnation").html(html);
			return;
			
		}
	}
	
}

function setDivAvalible(obj,avalible){
	if(!obj){
		return;
	}
	if(avalible){
		obj.children().each(function(i,element){
	     	$(element).find("input,select").removeAttr("disabled");
	    });
	}else{
		obj.children().each(function(i,element){
	     	$(element).find("input,select").attr("disabled","disabled");
	    });
	}
}

//------------------- 公共js start --------------------//
var isMuiltDparture = $("#isMuiltDparture").val();
var districtSelectDialog;

//选择行政区（单选）
function onSelectDistrict(params){
	if(params!=null){
		$("#"+params.nameId).val(params.districtName);
		$("#"+params.elementId).val(params.districtId);
	}
	
	if ($("#isMuiltDparture").val() == 'Y') {//是多出发地
		var c = $("#"+params.nameId).closest("tr").attr("class");
		if (c == 'c1') {//往返程
			//如果已经存在了往返程的返程目的地那么先将其删除，然后再append
			/*if ($("#toBackbackStartPointTr div:nth-child(2)").length >0) {
				$("#toBackbackStartPointTr div:nth-child(2)").remove();
			}
			$("#toBackbackStartPointTr").append('<div class="city"><span>' + params.districtName + '</span></div>');*/

			$("#multiBackStartPoint").val(params.districtName);
			$("#multiBackStartPointHidden").val(params.districtId);
		}
	}

	districtSelectDialog.close();
	$("#districtError").hide();
}

function setTransportTypeChangeAction(that){
	var classValue = that.attr("class");
	var classValueArr = classValue.split(' ');
	if (classValueArr[0] == 'undefined') {
		return;
	}
	var cl = classValueArr[0];
	//全部设置为无效并不显示
	$("tr.c1,tr.c2").find("input,select").attr("disabled","disabled");
	$("tr.c1,tr.c2").hide();
	//如果没被选中，则找到后面紧跟的div然后设置为disabled
	if(that.is(":checked")){
		if (isMuiltDparture == 'Y') {
			cleanSavedMulteInfo();//清除保存的多出发地信息;
			if(cl=='c1'){
				//清除城市组相关信息
			    $("input[name = 'twoLevelCategry']").attr("checked", false);
			    $("#cityGroupNamec1").empty();

				$("#muiltDpartureDiv tr.c1").show();
				$("#muiltDpartureDiv tr.c1").find("input,select").removeAttr("disabled");
				
			}else if(cl=='c2'){
				//清除城市组相关信息
			    $("input[name = 'twoLevelCategry']").attr("checked", false);
			    $("#cityGroupNamec2").empty();

				$("#muiltDpartureDiv tr.c2").show();
				$("#muiltDpartureDiv tr.c2").find("input[value='to']").attr("checked","checked");
				
				var className = $("#muiltDpartureDiv tr.c2").find("input[name='type']:checked").closest("tr").attr("class");
				var classNameArr = className.split(' ');
				if (classNameArr[1] != 'undefined') {
					var d = classNameArr[1];
					$("#muiltDpartureDiv tr.d1,tr.d2").find("input,select").attr("disabled","disabled");
					if (d == 'd1') {
						$("#muiltDpartureDiv " + "tr.d1").find("input,select").removeAttr("disabled");
						$("#muiltDpartureDiv " + "tr.d2").find("input,select").attr("disabled");
					} else if (d=='d2') {
						$("#muiltDpartureDiv " + "tr.d2").find("input,select").removeAttr("disabled");
						$("#muiltDpartureDiv " + "tr.d1").find("input,select").attr("disabled");
					} else {
						$.alert("js出错");
					}
				}
				//把选中框设置为可用
				$("#muiltDpartureDiv").find("input[name='type']").removeAttr("disabled");
				
				$("#multiToStartPointIds").val('');
			}
		} else {
			if(cl=='c1'){
				$("#notMuiltDpartureDiv .c1").find("input,select").removeAttr("disabled");
				$("#notMuiltDpartureDiv .c1").show();
			}else if(cl=='c2'){
				$("#notMuiltDpartureDiv .c2").show();
				//把选中框设置为可用
				$("#notMuiltDpartureDiv .toType").removeAttr("disabled");
				$("#notMuiltDpartureDiv tr.c2").find("input[value='to']").attr("checked","checked");
				//把已选中的设置为非disabled
				$("#notMuiltDpartureDiv .c2").find("input[type=radio]:checked").closest("tr").find("input,select").removeAttr("disabled");
				$("#notMuiltDpartureDiv .c2").find("input[type=radio]:checked").closest("tr").next("tr").find("input,select").removeAttr("disabled");
			}
		}
	}
}

//保存事件
$("#save").bind("click",function(){
	if($("#tobackAutoPack").is(":hidden")){
		addGroup();
	}else{
		tobackAutoPackAddGroup();
	}
	
});

function getTime(hour,minute){
	if(hour==null||hour==""){
		hour = "00";
	}
	if(minute==null||minute==""){
		minute = "00";
	}
	if(hour.length==1){
		hour = "0"+hour;
	}
	if(minute.length==1){
		minute = "0"+minute;
	}
	return hour.toString()+minute.toString();
}

//往返程地总打包点击保存事件
function tobackAutoPackAddGroup(){

	//验证
	if(!$("#dataForm").validate({
		rules : {},
		messages : {}
	}).form()){
		return;
	}
	
	//校验第几天出发是否选择
	var existNotSelectDay = false;
	$.each($(".tobackTravelDays"), function(index, travelDaySelect) {
		var $travelDaySelect = $(travelDaySelect);
		if ($travelDaySelect.attr("disabled") != "disabled" && $travelDaySelect.val() == "") {
			var $travelDayTd = $travelDaySelect.closest("td")
			var $dayErrorI = $travelDayTd.find("i");
			if ($dayErrorI.length == 0) {
				$travelDayTd.append("<i class='day_error'>请填写行程天数信息！</i>");
			}
			existNotSelectDay = true;
		} else {
			$travelDaySelect.siblings("i").remove();
		}
	});
	if (existNotSelectDay) {
		return;
	}

	//校验时间段格式
	var cHour = false;
	$.each($(".hour"), function(index, hour) {
			if(!checkHour($(hour).val())){
				cHour = true;
			}
		}
	);
	if(cHour){
		alert("小时格式不正确，为0-23之间的整数(包含0和23)");
		return;
	}
	var cMinute = false;
	$.each($(".minute"), function(index, minute) {
			if(!checkMin($(minute).val())){
				cMinute = true;
			}
		}
	);
	if(cMinute){
		alert("分钟格式不正确，为0-59之间的整数(包含0和59)");
		return;
	}

	
	//添加单程和往返程是否已经存在校验
	var type =$("input[class=autopackageRadioClass]:checked").val();
	$.ajax({
		url : "/vst_admin/productPack/line/checkAutoPackGroup.do",
		type : "get",
		dataType : 'json',
		async: false,
		data : $("#dataForm").serialize()+"&type="+type,
		success : function(result) {
			if(!result){
				autoPackageSave();
			}
			if(result.code == "success"){
				$.confirm(result.message,function(){
					autoPackageSave();
	        	});
			}else if(result.code == "error"){
				$.alert(result.message);
			}
		},
		error : function(XMLHttpRequest, textStatus, errorThrown,exc) {
		}
	});
	
}

function autoPackageSave(){
	//检查去程和返程时间是否满足要求
	if($("#startDaySelect").val() > $("#backStartDaySelect").val()){
		$.alert("去程出发时间不能大于返程出发时间");
		return;
	}
	//校验航班到达和起飞时段
	var toStartTimeBegin = parseInt(getTime($("#toStartHour").val(),$("#toStartMinute").val()));
	var toStartTimeEnd = parseInt(getTime($("#toStartHour1").val(),$("#toStartMinute1").val()));
	if(toStartTimeEnd<=toStartTimeBegin){
		$.alert("航班到达时段:出发时间不能晚于或者等于到达时间");
		return;
	}
	var backStartTimeBegin = parseInt(getTime($("#backStartHour").val(),$("#backStartMinute").val()));
	var backStartTimeEnd = parseInt(getTime($("#backStartHour1").val(),$("#backStartMinute1").val()));
	if(backStartTimeEnd<=backStartTimeBegin){
		$.alert("航班起飞时段:出发时间不能晚于或者等于到达时间");
		return;
	}
	var paramurl = "&toStartTimeBegin="+toStartTimeBegin+"&toStartTimeEnd="+toStartTimeEnd+"&backStartTimeBegin="+backStartTimeBegin+"&backStartTimeEnd="+backStartTimeEnd;
	
	//保存
	$.ajax({
		url : "/vst_admin/productPack/line/tobackAutoPackAddGroup.do",
		type : "post",
		dataType : 'json',
		async: false,
		data : $("#dataForm").serialize()+paramurl,
		success : function(result) {
			if(result.code == "success"){
				var params = {};
				if(result.attributes.toGroupId){params.toGroupId = result.attributes.toGroupId;}
				if(result.attributes.backGroupId){params.backGroupId = result.attributes.backGroupId;}
				params.groupType = result.attributes.groupType;
				parent.onSaveAutoPackGroupDetail(params);
			}else if(result.code == "error"){
				$.alert(result.message);
			}
		},
		error : function(XMLHttpRequest, textStatus, errorThrown,exc) {
		}
	});
	
}
//检查小时的格式
function checkHour(value){
	if(!value){
		return true;
	}
	var parten = /^\d{1,2}$/;
	if(parten.test(value)){
		if(value < 24 && value >= 0){
			return true;
		}
	}
}
//检查分钟的格式
function checkMin(value){
	if(!value){
		return true;
	}
	var parten = /^\d{1,2}$/;
	if(parten.test(value)){
		if(value < 60 && value >= 0){
			return true;
		}
	}
}

//多出发地和单出发地点击保存事件
function addGroup(){

	//校验多出发地时，出发地不能为空
	if (isMuiltDparture == "Y") {
		//检查出发地不能为空
		if($("#multiToStartPointIds").val() == "") {
			var classValue = $("input[data=transportType]:checked").attr("class");
			var classValueArr = classValue.split(' ');
			if (classValueArr[0] == 'undefined') {
				return;
			}
			var cl = classValueArr[0];
			if (cl == 'c1') {
				if ($("i[for='multiToStartPoint']").length == 0) {
					$("#multiToStartPoint").after('<i for="multiToStartPoint" class="error">至少选择一个出发地城市</i>');
				}
			} else if (cl == 'c2') {
				if ($("i[for='multiToStartPoint1']").length == 0) {
					$("#multiToStartPoint1").after('<i for="multiToStartPoint1" class="error">至少选择一个出发地城市</i>');
				}
			}
			return;
		}
	}

	//验证
	if(!$("#dataForm").validate({
		rules : {},
		messages : {}
	}).form()){
		return;
	}

	//校验第几天出发是否选择
	var existNotSelectDay = false;
	$.each($(".travelDays"), function(index, travelDaySelect) {
		var $travelDaySelect = $(travelDaySelect);
		if ($travelDaySelect.attr("disabled") != "disabled" && $travelDaySelect.val() == "") {
			var $travelDayTd = $travelDaySelect.closest("td")
			var $dayErrorI = $travelDayTd.find("i");
			if ($dayErrorI.length == 0) {
				$travelDayTd.append("<i class='day_error'>请填写行程天数信息！</i>");
			}
			existNotSelectDay = true;
		} else {
			$travelDaySelect.siblings("i").remove();
		}
	});
	if (existNotSelectDay) {
		return;
	}

	//判断是不是往返类型
	if($("input[data=transportType]:checked").val()=="TOBACK"){
		//检查去程和返程时间是否满足要求
		if($("select[name=toStartDays][disabled!=disabled]").val() > $("select[name=backStartDays][disabled!=disabled]").val()){
				$.alert("去程出发时间不能大于返程出发时间");
				return;
		}
	}
	$.ajax({
		url : "/vst_admin/productPack/line/addGroup.do",
		type : "post",
		dataType : 'json',
		async: false,
		data : $("#dataForm").serialize(),
		success : function(result) {
			if(result.code == "success"){
				pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
					//取得最上级父窗口，触发其左侧的 选择交通 按钮
					$("#traffic",window.top.document).parent("li").trigger("click");
				}});
			}else if(result.code == "error"){
				$.alert(result.message);
			}
		},
		error : function(XMLHttpRequest, textStatus, errorThrown,exc) {
		}
	})
}

//清除保存的多出发地信息
function cleanSavedMulteInfo() {

	$("#multiToStartPointIds").val('');
	$("#multiToBackStartCitysTd").empty();
	$("#multiBackDestPointTd").children("div:gt(0)").remove();
	$("#multiToStartCitysTd").empty('');

	$("#multiBackStartPoint1").val('');
	$("#multiBackDestination1").show();
	$("#multiBackDestination1").nextAll(".city").remove();
	$("#multiBackDestination1").val('');
	$("#multiBackDestination1Hidden").val('');
}

//------------------- 多出发地js start --------------------//
//打开单选的选择行政区窗口 
$("#multiToDestination,#multiBackStartPoint,#multiBackDestination,#multiBackStartPoint1,#multiToDestination1,#multiBackDestination1").click(function(){
	//用于显示文字的元素ID
	var nameId = $(this).attr("id");
	//用于显示ID的元素ID
	var elementId = nameId+"Hidden";
	districtSelectDialog = new xDialog("/vst_admin/biz/district/selectDistrictList.do?elementId="+elementId+"&nameId="+nameId,{},{title:"选择行政区",iframe:true,width:"860",height:"400"});
});

//打开多选的选择行政区窗口
$("#multiToStartPoint,#multiToStartPoint1").click(function(){
	//用于显示文字的元素ID
	var nameId = $(this).attr("id");
	//用于显示ID的元素ID
	var elementId = nameId+"Hidden";
	districtSelectDialog = new xDialog("/vst_admin/biz/district/multiSelectDistrictList.do?elementId="+elementId+"&nameId="+nameId,{},{title:"选择行政区",iframe:true,width:"860",height:"400"});
});

//选择行政区（多选）
function onMultiSelectDistrict(location, districts){
	if(location != null && districts!=null){
		var classValue = $("#"+location.nameId).closest("tr").attr("class");
		var classValueArr = classValue.split(' ');
		if (classValueArr[0] == 'undefined') {
			return;
		}
		var c = classValueArr[0];
		if (c == 'c1') {
			var html = addCity(districts);
			$("#multiToBackStartCitysTd").append(html.hasXhtml);
			$("#multiBackDestPointTd").append(html.nohasXhtml);
		} else if (c == 'c2') {
			var html = addCity(districts);
			$("#multiToStartCitysTd").append(html.hasXhtml);
		}
	}

	districtSelectDialog.close();
	$("#districtError").hide();
}

//添加城市
function addCity(districts) {
	var oldCityIds = $("#multiToStartPointIds").val();
	var cityArray = new Array();
	if (oldCityIds != '') {
		cityArray = oldCityIds.split(',')
	}

	var hasXhtml = '';// 将要返回的有删除的多城市信息的拼接字符串
	var nohasXhtml = '';// 将要返回的没有删除的多城市信息的拼接字符串
	$.each(districts, function(index, district){
		var isNewCity = true;
		$.each(cityArray, function(index, cityId) {
			if (cityId == district.districtId) {
				isNewCity = false;
			}
		});

		if (isNewCity) {
			cityArray.push(district.districtId);
			hasXhtml += '<div class="city"><span>' + district.districtName + '</span><span data="' + district.districtId + '">X</span></div>';
			nohasXhtml += '<div class="city"><span>' + district.districtName + '</span><span data="' + district.districtId + '"></span></div>';
		}
	});

	$("#multiToStartPointIds").val(cityArray.join(','));
	var html = {};
	html.hasXhtml = hasXhtml;
	html.nohasXhtml = nohasXhtml;
	return html;
}

//点击删除某城市红X
$("tr .city span:nth-child(2)").live("click",function(){
	var cityId = $(this).attr("data");
	deleteCity(cityId);
});

//删除城市
function deleteCity(cityId){
	var oldCityIds = $("#multiToStartPointIds").val();
	var cityArray = new Array();
	if (oldCityIds != '') {
		cityArray = oldCityIds.split(',')
	}

	console.log('删除前：' + cityArray);
	if ($.inArray(cityId,cityArray) != -1) {
		cityArray.splice($.inArray(cityId, cityArray), 1);
		$('.city span:nth-child(2)[data=' + cityId +']').closest('div').remove();
	}
	$("#multiToStartPointIds").val(cityArray.join(','));
	console.log('删除后：' +cityArray);
}

//单程返程点击事件（备注：在tr元素上class = d1的为单程去程的内容，class = d2的为单程返程的内容）
$("#muiltDpartureDiv input[value=back]").bind("click",function(){

	var productId = $("#productId").val();
	if (productId == "") {
		$.alert("productId 为空！");
		$("#multiToRadio").trigger("click");
		return;
	}

	cleanSavedMulteInfo();//清除保存的多出发地信息

	//ajax取是否有存在单程去程多出发地的信息
	$.ajax({
		url : "/vst_admin/productPack/line/getToPackageGroupTransport.do",
		type : "get",
		dataType : 'json',
		async: false,
		data : {productId:productId},
		success : function(result) {
			if(result.code == "success"){
				var backDestDistricts = result.attributes.backDestDistricts;
				var backStartPoint = result.attributes.backStartPoint;
				
				//转换输入框是否可用
				$("#muiltDpartureDiv tr.d2").find("input,select").removeAttr("disabled");
				$("#muiltDpartureDiv tr.d1").find("input,select").attr("disabled","disabled");
				$(".toType").removeAttr("disabled");

				//渲染单程返程出发地
				$("#multiBackStartPoint1").val(backStartPoint.districtName);
				$("#multiBackStartPoint1Hidden").val(backStartPoint.districtId);

				//渲染单程返程多目的地
				var nohasXhtml = '';
				var cityArray = new Array();
				$.each(backDestDistricts,function(index,district){
					nohasXhtml += '<div class="city"><span>' + district.districtName + '</span><span data="' + district.districtId + '"></span></div>';
					cityArray.push(district.districtId);
				});
				$("#multiToStartPointIds").val(cityArray.join(','));
				$("#multiBackDestination1").after(nohasXhtml);
				$("#multiBackDestination1").hide();
				$("#multiBackDestination1").val(backDestDistricts[0].districtName);
				$("#multiBackDestination1Hidden").val(backDestDistricts[0].districtId);
				
			}else if(result.code == "error"){
				$.alert(result.message);
				$("#multiToRadio").trigger("click");
			}
		},
		error : function(XMLHttpRequest, textStatus, errorThrown,exc) {
			$.alert(errorThrown);
			$("#multiToRadio").trigger("click");
		}
	})
});

//单程去程点击事件（备注：在tr元素上class = d1的为单程去程下的内容，class = d2的为单程返程下的内容）
$("#muiltDpartureDiv input[value='to']").bind("click",function(){
	cleanSavedMulteInfo();

	if($(this).is(":checked")){
		$("#muiltDpartureDiv tr.d1").find("input,select").removeAttr("disabled");
		$("#muiltDpartureDiv tr.d2").find("input,select").attr("disabled","disabled");
		$(".toType").removeAttr("disabled");
	}
});

//------------------- 多出发地js end --------------------//

//------------------- 非多出发地js start --------------------//
//打开选择行政区窗口
$("#toStartPoint,#toDestination,#sendPlace,#destnationPlace,#backStartPoint,#backDestination,#toStartPoint1,#toDestination1,#backStartPoint1,#backDestination1").live('click',function(){
   //用于显示文字的元素ID
	var nameId = $(this).attr("id");
	//用于显示ID的元素ID
	var elementId = nameId+"Hidden";
	districtSelectDialog = new xDialog("/vst_admin/biz/district/selectDistrictList.do?elementId="+elementId+"&nameId="+nameId,{},{title:"选择行政区",iframe:true,width:"860",height:"400"});
});

//去程返程点击事件
$("#notMuiltDpartureDiv input[value=back]").bind("click",function(){
	var that = $(this);
	if(that.is(":checked")){
		//把去程设置为不可点击
		$("input[value=to]").closest("tr").find("input[type=text],select").attr("disabled","disabled");
		$("input[value=to]").closest("tr").next("tr").find("input[type=text],select").attr("disabled","disabled");
	}
	that.closest("tr").find("input,select").removeAttr("disabled");
	that.closest("tr").next("tr").find("input,select").removeAttr("disabled");
});

//去程返程点击事件
$("#notMuiltDpartureDiv input[value=to]").bind("click",function(){
	var that = $(this);
	if(that.is(":checked")){
		//把去程设置为不可点击
		$("input[value=back]").closest("tr").find("input[type=text],select").attr("disabled","disabled");
		$("input[value=back]").closest("tr").next("tr").find("input[type=text],select").attr("disabled","disabled");
	}
	that.closest("tr").find("input,select").removeAttr("disabled");
	that.closest("tr").next("tr").find("input,select").removeAttr("disabled");
});
//------------------- 非多出发地js end --------------------//
</script>