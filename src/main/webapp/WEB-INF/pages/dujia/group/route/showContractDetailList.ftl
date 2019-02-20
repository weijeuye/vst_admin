<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>推荐活动</title>
    <link href="/vst_admin/css/ui-common.css" rel="stylesheet"/>
    <link href="/vst_admin/css/ui-components.css" rel="stylesheet"/>
    <link href="/vst_admin/css/iframe.css" rel="stylesheet"/>
    <link href="/vst_admin/css/dialog.css" rel="stylesheet"/>

    <!--新增样式表-->
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/group-input.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/vst-group-input.css"/>
</head>
<body>
<input type="hidden" id="noEditFlag" name="noEditFlag" value="${noEditFlag}">
<div class="iframe_header">
    <ul class="iframe_nav">
        <li><a href="#">${prodProduct.bizCategory.categoryName!''}</a> &gt;</li>
        <li><a href="#">${packageType!''}</a> &gt;</li>
        <li><a href="#">产品维护</a> &gt;</li>
        <li class="active">行程</li>
    </ul>
</div>
<div class="iframe_content mt10">
    <div class="p_box box_info">
        <div class="box_content">

            <div class="gi-header">
                <h1>行程展示：${prodLineRoute.routeName}</h1>
                <a id="returnRoute" style="font-size:13px;margin-left:10px;" href="/vst_admin/prod/prodLineRoute/showUpdateRoute.do?productId=${prodProduct.productId}">返回行程</a>
                <#if noEditFlag == "true">
                 <a href="javascript:void(0);" id="toEdit">编辑合同</a>
                </#if>
            </div>
			<input type="hidden" value="${productId!''}" name="productId"  id="productId"/>
			<input type="hidden" value="${lineRouteId!''}" name="lineRouteId"  id="lineRouteId"/>
			<input type="hidden" value="${categoryId!''}" name="categoryId" id="categoryId"/>
            <!--活动推荐 开始-->
            <div class="gi-form JS_inner_activity">
                <form>
                    <dl class="clearfix">
                        <dt>
                            项目推荐 ：
                        </dt>
                      <dd>  
                      <#if prodProduct.productType!="FOREIGNLINE"><span>若需新增推荐项目或购物说明，请在行程明细中操作。 </span> 
                      <#else>
                      	<div class="clearfix">
                            <a id="newRecommendButton" onclick="addProdContractDetail('RECOMMEND')" href="javascript:void(0);" class="fr gi-project-add">增加一栏</a>
                        </div>
                        </#if>    
                      </dd>
                    </dl>
                    <div class="gi-table-box">
                    <table class="table-list table-blue gi-table gi-project">
                                <colgroup>
                                    <col class="gi-col">
                                    <col class="gi-col">
                                    <col class="gi-col">
                                    <col class="gi-col">
                                    <col class="gi-col">
                                    <col class="gi-col">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>地点</th>
                                    <th>名称</th>
                                    <th>参考价格</th>
                                    <th>项目时长(分钟)</th>
                                    <th>说明</th>
                                    <#if prodProduct.productType=="FOREIGNLINE" || noEditFlag != "true"><th>操作</th></#if>
                                </tr>
                                </thead>
                                <tbody>
							    	<#if recommendList?? && recommendList?size &gt; 0>
									<#list recommendList as recommendItem> 
										<tr>
											<td>${recommendItem.address!''} </td>
											<td>${recommendItem.detailName!''} </td>
											<td>${recommendItem.detailValue!''} </td>
											<td>${recommendItem.stay!''} </td>
											<td>
											   <#if categoryId==15>
													<#if recommendItem.other?? && recommendItem.other?length gt 0>
														${recommendItem.other}
													<#else>
														特别说明：自费项目均是建议性项目，客人应本着“自愿自费”的原则酌情参加，如以上项目参加人数不足时，则可能无法成行或费用做相应调整。
													</#if>
											    <#else>
											    	${recommendItem.other!''}
											    </#if>
											</td>
											<#if prodProduct.productType=="FOREIGNLINE" || noEditFlag != "true"><td>
						                    <a href="javascript:void(0);" onclick="updateProdContractDetail('${recommendItem.detailId!''}','${recommendItem.routeContractSource!''}')" class="cancel">修改</a>
						                    <a href="javascript:void(0);" onclick="deleteProdContractDetail('${recommendItem.detailId!''}','${recommendItem.routeContractSource!''}','RECOMMEND')" class="cancel">删除</a>
											</td></#if>
								        </tr>
									</#list>
									</#if>
							    </tbody>
                            </table>
                    </div>

                    <dl class="clearfix">
                        <dt>
                            购物说明 ：
                        </dt>
                        <#if prodProduct.productType=="FOREIGNLINE" >
                       <dd>
                            <div class="clearfix">
                                <a id="newShopingButton" onclick="addProdContractDetail('SHOPING')" href="javascript:void(0);" class="fr gi-shop-add">增加一栏</a>
                            </div>
                            
                        </dd>
                        </#if>
                    </dl>
					<div class="gi-table-box">
					<table class="table-list table-blue gi-table gi-shop">
                                <colgroup>
                                    <col class="gi-col">
                                    <col class="gi-col">
                                    <col class="gi-col">
                                    <col class="gi-col">
                                    <col class="gi-col">
                                    <col class="gi-col">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>地点</th>
                                    <th>名称</th>
                                    <th>营业产品</th>
                                    <th>停留时间(分钟)</th>
                                    <th>说明</th>
                                    <#if prodProduct.productType=="FOREIGNLINE" || noEditFlag != "true">
                                    	<th>操作</th>
                                	</#if>
                                </tr>
                                </thead>
                                <tbody>
							    	<#if shopingList?? && shopingList?size &gt; 0>
									<#list shopingList as shopingItem> 
										<tr>
											<td>${shopingItem.address!''} </td>
											<td>${shopingItem.detailName!''} </td>
											<td>${shopingItem.detailValue!''} </td>
											<td>${shopingItem.stay!''} </td>
											<td>${shopingItem.other!''}</td>
											<#if prodProduct.productType=="FOREIGNLINE" || noEditFlag != "true">
												<td>
												<a href="javascript:void(0);" onclick="updateProdContractDetail('${shopingItem.detailId!''}','${shopingItem.routeContractSource!''}')" class="cancel">修改</a>
												<a href="javascript:void(0);" onclick="deleteProdContractDetail('${shopingItem.detailId!''}','${shopingItem.routeContractSource!''}','SHOPING')" class="cancel">删除</a>
											    </td>
										    </#if>
								        </tr>
									</#list>
									</#if>
							    </tbody>
                            </table>
					</div>
                </form>
            </div>
            <!--活动推荐 结束-->

        </div>
    </div>
</div>

<!--脚本模板使用 开始-->
<div class="JS_template">

</div>
<!--脚本模板使用 结束-->

<!--jQuery文件-->
<script src="http://pic.lvmama.com/min/index.php?f=/js/new_v/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.validate.expand.js"></script>
<script type="text/javascript" src="/vst_admin/js/messages_zh.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_validate.js"></script>
<script type="text/javascript" src="/vst_admin/js/pandora-dialog.js"></script>
<script type="text/javascript" src="/vst_admin/js/lvmama-dialog.js"></script>

<script>
var showAddContractDetailDialog;
$(function(){
	var editDialog;
     if($("#noEditFlag").val() == "true"){
     	$('a').removeAttr('href');
     	$('a').removeAttr("onclick");
     	$("#returnRoute").attr("href","/vst_admin/prod/prodLineRoute/showUpdateRoute.do?productId=${prodProduct.productId}&oldProductId=${oldProductId}")
   	}
   	
   	$("#toEdit").bind("click",function () {
       		var	url = "/vst_admin/prod/product/prodContractDetail/showAddContractDetailList.do?productId=${productId}&categoryId=${prodProduct.bizCategory.categoryId!''}&lineRouteId=${lineRouteId}";
      		editDialog = new xDialog(url,{},{title:"编辑合同",iframe:true, width:1000, height:450});
  	});
});
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
			url : "/vst_admin/dujia/group/route/contractDetail/deleteProdContractDetail.do?detailId="+detailId+"&routeContractSource="+routeContractSource+"&detailType="+detailType,
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
		var url = "/vst_admin/dujia/group/route/contractDetail/addOrUpdateContractDetail.do?detailType="+ detailType +"&productId="+$("#productId").val()+"&lineRouteId="+$("#lineRouteId").val()+"&categoryId="+$("#categoryId").val();
		showAddContractDetailDialog = new xDialog(url,{},{title:"新增"+ title, width:600, height:450});
	}
}
//修改
function updateProdContractDetail(detailId,routeContractSource) {
	var url = "/vst_admin/dujia/group/route/contractDetail/addOrUpdateContractDetail.do?detailId="+detailId+"&routeContractSource="+routeContractSource+"&lineRouteId="+$("#lineRouteId").val()+"&categoryId="+$("#categoryId").val();
	showAddContractDetailDialog = new xDialog(url,{},{title:"修改信息", width:600, height:450});
}

isView();
</script>

</body>
</html>
