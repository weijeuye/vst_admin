<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
</head>
 
<body style="min-height:700px;">
<input type="hidden" id="noEditFlag" name="noEditFlag" value="${noEditFlag}">
<div class="iframe_header">
    <ul class="iframe_nav">
       <li><a href="#">${prodProduct.bizCategory.categoryName!''}</a> &gt;</li>
       <!-- <li><a href="#">${packageType!''}</a> &gt;</li>-->
        <li><a href="#">产品维护</a> &gt;</li>
        <li class="active">合同条款</li>
        <li><#if noEditFlag == 'true'><a id="toEdit" href="javascript:void(0);">编辑合同</a></#if></li>
    </ul>
</div> 

<input type="hidden" value="${productId!''}" name="productId"  id="productId"/>
<input type="hidden" value="${lineRouteId!''}" name="lineRouteId"  id="lineRouteId"/>
<table class="p_table table_center">
        <thead>
            <tr>
            	<td> 
					<div class="fl operate" style="margin:20px;">
					推荐项目&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a class="btn btn_cc1" id="newRecommendButton" onclick="addProdContractDetail('RECOMMEND')" href="javascript:void(0);">新增</a>
					</div>
				</td>
             </tr>
        </thead>
    </table>

<!-- 主要内容显示区域\\ -->
<div class="iframe-content">   
    <div class="p_box">
	<table class="p_table table_center">
	    <thead>
	        <tr>
	    	<th>行程天数</th>
	        <th>地点</th>
	        <th>项目名称和内容</th>
	        <th>费用</th>
	        <th>项目时长(分钟)</th>
	        <th>其他说明</th>
	        <th>操作</th>
	        </tr>
	    </thead>
	    <tbody>
	    	<#if recommendList?? && recommendList?size &gt; 0>
			<#list recommendList as recommendItem> 
				<tr>
					<td>${recommendItem.nDays!''} </td>
					<td>${recommendItem.address!''} </td>
					<td>${recommendItem.detailName!''} </td>
					<td>${recommendItem.detailValue!''} </td>
					<td>${recommendItem.stay!''} </td>
					<td>${recommendItem.other!''}</td>
					<td>
	                    <a href="javascript:void(0);" onclick="updateProdContractDetail('${recommendItem.detailId!''}','${recommendItem.routeContractSource!''}','${recommendItem.nDays!''}')" class="cancel">修改</a>
						<a href="javascript:void(0);" onclick="deleteProdContractDetail('${recommendItem.detailId!''}','${recommendItem.routeContractSource!''}','RECOMMEND')" class="cancel">删除</a>
					</td>
		        </tr>
			</#list>
			</#if>
	    </tbody>
	</table>
	</div><!-- div p_box -->
</div><!-- //主要内容显示区域 -->

<div class="operate" style="margin-bottom:10px;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;购物说明&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a class="btn btn_cc1" id="newShopingButton" onclick="addProdContractDetail('SHOPING')" href="javascript:void(0);">新增</a>
</div>

<!-- 主要内容显示区域\\ -->
<div class="iframe-content">   
    <div class="p_box">
	<table class="p_table table_center">
	    <thead>
	        <tr>
	    	<th>行程天数</th>
	        <th>地点</th>
	        <th>购物场所名称</th>
	        <th>主要商品信息</th>
	        <th>项目时长(分钟)</th>
	        <th>其他说明</th>
	        <th>操作</th>
	        </tr>
	    </thead>
	    <tbody>
	    	<#if shopingList?? && shopingList?size &gt; 0>
			<#list shopingList as shopingItem> 
				<tr>
					<td>${shopingItem.nDays!''} </td>
					<td>${shopingItem.address!''} </td>
					<td>${shopingItem.detailName!''} </td>
					<td>${shopingItem.detailValue!''} </td>
					<td>${shopingItem.stay!''} </td>
					<td>${shopingItem.other!''}</td>
					<td>
						<a href="javascript:void(0);" onclick="updateProdContractDetail('${shopingItem.detailId!''}','${shopingItem.routeContractSource!''}','${shopingItem.nDays!''}')" class="cancel">修改</a>
						<a href="javascript:void(0);" onclick="deleteProdContractDetail('${shopingItem.detailId!''}','${shopingItem.routeContractSource!''}','SHOPING')" class="cancel">删除</a>
					</td>
		        </tr>
			</#list>
			</#if>
	    </tbody>
	</table>
	</div><!-- div p_box -->
</div><!-- //主要内容显示区域 -->
<#include "/base/foot.ftl"/>

</body>
</html>
<script>

$(function () {
	//页面关联则不可修改
	 var $document = $(document);
     if($("#noEditFlag").val() == "true"){
     	$('a').removeAttr('href');
     	$('a').removeAttr("onclick");
   	 }
   	 $("#toEdit").bind("click",function () {
   		var	url = "/vst_admin/prod/product/prodContractDetail/showAddContractDetailList.do?productId=${productId}&categoryId=${prodProduct.bizCategory.categoryId!''}&lineRouteId=${lineRouteId}";
  		var editDialog = new xDialog(url,{},{title:"编辑合同",iframe:true, width:1000, height:450});
	 });
   
 });	
 
var showAddContractDetailDialog;
//删除
function deleteProdContractDetail(detailId,routeContractSource,detailType) {
	if(!detailId) {
		return false;
	}
	var msg = "";
	if(detailType === "SHOPING"){
	   msg = "行程明细内购物点模块也将一起删除，确认删除？";
	}else{
	   msg = "行程明细内推荐模块也将一起删除，确认删除？";
	}
	$.confirm(msg,function(){
	 $.ajax({
		url : "/vst_admin/prod/product/prodContractDetail/deleteProdContractDetail.do?detailId="+detailId+"&routeContractSource="+routeContractSource+"&detailType="+detailType,
		type : "get",
		dataType:"json",
		async: false,
		success : function(result) {
		   if(result.code=="success"){
				alert(result.message);
   				window.location.reload();
			}else {
				alert(result.message);
	   		}
		}
      });
	});
	    
}
//新增
function addProdContractDetail(detailType) {
   var title = detailType == "RECOMMEND" ? "推荐项目" : "购物说明"; 
	if(detailType != "") {
		var url = "/vst_admin/prod/product/prodContractDetail/addOrUpdateContractDetail.do?detailType="+ detailType +"&productId="+$("#productId").val()+"&lineRouteId="+$("#lineRouteId").val();
		showAddContractDetailDialog = new xDialog(url,{},{title:"新增"+ title, width:600, height:450});
	}
}
//修改
function updateProdContractDetail(detailId,routeContractSource,nDays) {
	var url = "/vst_admin/prod/product/prodContractDetail/addOrUpdateContractDetail.do?detailId="+detailId+"&nDays="+nDays+"&routeContractSource="+routeContractSource+"&lineRouteId="+$("#lineRouteId").val();;
	showAddContractDetailDialog = new xDialog(url,{},{title:"修改信息", width:600, height:450});
}

isView();
</script>
