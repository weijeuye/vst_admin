<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
</head>
<body>
<div class="iframe_header">
        <ul class="iframe_nav">
            <li><a href="#">${categoryName !''}</a> &gt;</li>
            <li><a href="#">自主打包</a> &gt;</li>
            <li><a href="#">组合打包</a> </li>
        </ul>
</div>
<div class="iframe_content mt10">
<div class="tiptext tip-warning"><span class="tip-icon tip-icon-warning"></span>
 注：选择有预付商品的产品，前台仅调取预付商品。<br/>
 注：前台购买，每个区间段，必须且仅可购买一个规格的商品……若是用户可选是否要，请在“运营>关联销售”里面维护。<br/>
  </div><br/>
<#assign routeNum = '' />
<#assign stayNum = '' />
<#if prodProduct.prodLineRouteList ?? >
	<#assign routeNum=prodProduct.prodLineRouteList[0].routeNum />
	<#assign stayNum=prodProduct.prodLineRouteList[0].stayNum />
</#if>
<#if prodProduct.prodDestReList ?? &&  prodProduct.prodDestReList?size gt 0>
	<input type="hidden" name="prodDestReList[0].destId" id="destId" value="${prodProduct.prodDestReList[0].destId}"> 
</#if>
<#assign cancelFlag={"Y":"有效","N":"无效"}>
<#assign saleFlag={"Y":"可售","N":"不可售"}>
<input type="hidden" id = "groupType" name="groupType" value="TRANSPORT"/>
<input type="hidden" id = "productId" name="productId" value="${productId }"/>
<input type="hidden" id = "productType" name="productType" value="${productType }"/>
<input type="hidden" id = "BU" name="BU" value="${BU}"/>
<input type="hidden" id = "categoryId" name="categoryId" value="${categoryId}"/>
<input type="hidden" id = "backGroupId" name="backGroupId" value="${backGroupId }"/>
<input type="hidden" id = "toGroupId" name="toGroupId" value="${toGroupId }"/>
<input type="hidden" id = "groupId" name="groupId" />
<input type="hidden" id = "routeNum" name="routeNum" value="${routeNum }" />
<input type="hidden" id = "stayNum" name="stayNum" value="${stayNum }" />
<input type="hidden" id = "categoryParentId" name="categoryParentId" value="${categoryParentId }"/>
<input type="hidden" id = "selectParentCategoryFlag" name="selectParentCategoryFlag" value="${selectParentCategoryFlag }"/>

<form action="" method="post" id="dataForm">
			<div class="p_box box_info p_line" style="border:solid 1px #aaa">
	            <div class="box_content">
	                <table class="e_table form-inline" style="width: 1054px" >
	                    <tbody>
		                <tr style="background-color:#E4E4E4">
		                	<td class="e_label" width="20px" style="font-weight:bold;text-align: left">
		                		大交通
		                			-[指定区间日期，不可选]
		                	</td>
		                	<td class="e_label" width="10px" style="font-weight:bold;text-align: center">
		                		行程天数：${routeNum}天${ stayNum}晚
		                	</td>
		                	<td class="e_label" width="20px" style="text-align: right;">
		                	<a class="btn btn_cc1"  onclick="findCitygroup()" >城市组维护</a>
		                	<a class="btn btn_cc1"  onclick="addGroup('19')" selectCategoryId="19">插入交通信息</a>
		                	</td>
		                </tr>
	                	</tbody>
	                </table>
	            </div>
	            <div >
	                <table  style="width: 1054px">
	                	<input type="hidden" name="muiltDpartureFlag" id="muiltDpartureFlag" value="${prodProduct.muiltDpartureFlag}"/>
	                    <tbody>
	                     <#if packGroupList?? && groupType??>
					          <!-- 大交通开始 -->
					          <#if groupType == 'TRANSPORT' >
	    						<#list packGroupList as packGroup>
	    							<#if packGroup ?? && packGroup.prodPackageGroupTransport??>
	    								<#--一键打包标记-->
										<#assign autoPack = packGroup.prodPackageGroupTransport.autoPackage == 'Y'/>
	    								<tr>
						                	<td  style="font-weight:bold;text-align: left;width:750px">
						                	<!-- 非多出发地开始-->
						                		<#if prodProduct.muiltDpartureFlag == "N">
						                		<#if packGroup.prodPackageGroupTransport.transportType=="TOBACK">
						                		往返程&nbsp;&nbsp;[去程]${packGroup.prodPackageGroupTransport.toStartPointDistrict.districtName}-${packGroup.prodPackageGroupTransport.toDestinationDistrict.districtName},
						                		第${packGroup.prodPackageGroupTransport.toStartDays}天出发&nbsp;&nbsp;[返程]${packGroup.prodPackageGroupTransport.backStartPointDistrict.districtName}-${packGroup.prodPackageGroupTransport.backDestinationDistrict.districtName},
						                		第${packGroup.prodPackageGroupTransport.backStartDays}天出发
						                		</#if>
						                		
						                		<#if packGroup.prodPackageGroupTransport.transportType=="TO">
						                		单程&nbsp;&nbsp;
						                		<#if packGroup.prodPackageGroupTransport.toStartPoint??>
						                		[去程]${packGroup.prodPackageGroupTransport.toStartPointDistrict.districtName}-${packGroup.prodPackageGroupTransport.toDestinationDistrict.districtName},
						                		第${packGroup.prodPackageGroupTransport.toStartDays}天出发&nbsp;&nbsp;
						                		</#if>
						                		<#if packGroup.prodPackageGroupTransport.backStartPoint??>
						                		[返程]${packGroup.prodPackageGroupTransport.backStartPointDistrict.districtName}-${packGroup.prodPackageGroupTransport.backDestinationDistrict.districtName},
						                		第${packGroup.prodPackageGroupTransport.backStartDays}天出发
						                		</#if>
						                		</#if>
						                		<!--非多出发地结束-->
						                		
						                		<!-- 多出发地开始-->
						                		<#elseif prodProduct.muiltDpartureFlag == "Y">
						                		<!-- 往返程 -->
                                                <#if packGroup.prodPackageGroupTransport.transportType=="TOBACK">
						                		<#list packGroup.prodPackageGroupTransport.getToStartPointDistrictList() as toStart>
						                		往返程&nbsp;&nbsp;[去程]${toStart.districtName}-${packGroup.prodPackageGroupTransport.toDestinationDistrictMuch.districtName},
						                		第${packGroup.prodPackageGroupTransport.toStartDays}天出发&nbsp;&nbsp;
						                		[返程]
						                			<#if packGroup.prodPackageGroupTransport.backStartPoint != null && packGroup.prodPackageGroupTransport.backStartPoint != packGroup.prodPackageGroupTransport.toDestinationDistrictMuch.districtId >
						                				${packGroup.prodPackageGroupTransport.backStartPointDistrict.districtName}-${toStart.districtName},
						                			<#else>
						                				${packGroup.prodPackageGroupTransport.toDestinationDistrictMuch.districtName}-${toStart.districtName},
						                			</#if>
						                		第${packGroup.prodPackageGroupTransport.backStartDays}天出发</br>
						                		</#list>
						                		</#if>
						                		
						                		<!-- 单程 -->
						                		<#if packGroup.prodPackageGroupTransport.transportType=="TO">
						                		单程&nbsp;&nbsp;
						                		<#if autoPack>
						                		<#--格式化成如下格式：【去程]全国-三亚   第1天出发    航班到达时段：00：00-15：00【返程】三亚-全国  第5天出发       航班起飞时段：16：00-23：59-->
						                			<#if packGroup.prodPackageGroupTransport.toStartDays ??>
							                		[去程]${packGroup.prodPackageGroupTransport.toStartPointDistrict.districtName}-${packGroup.prodPackageGroupTransport.toDestinationDistrict.districtName},
							                		第${packGroup.prodPackageGroupTransport.toStartDays}天出发, 航班到达时段：${packGroup.prodPackageGroupTransport.timeBegin}-${packGroup.prodPackageGroupTransport.timeEnd}&nbsp;&nbsp;
						                			<#else>
							                		[返程]${packGroup.prodPackageGroupTransport.backStartPointDistrict.districtName}-${packGroup.prodPackageGroupTransport.backDestinationDistrict.districtName},
							                		第${packGroup.prodPackageGroupTransport.backStartDays}天出发,航班起飞时段：${packGroup.prodPackageGroupTransport.timeBegin}-${packGroup.prodPackageGroupTransport.timeEnd}
						                			</#if>
						                		<#else>
						                		<#if packGroup.prodPackageGroupTransport.getToStartPointDistrictList()?? && packGroup.prodPackageGroupTransport.toStartDays??>
						                		[去程]&nbsp;第${packGroup.prodPackageGroupTransport.toStartDays}天出发&nbsp;&nbsp;</br>
						                		出发地：&nbsp;
						                		<#list packGroup.prodPackageGroupTransport.getToStartPointDistrictList() as toStart>
						                		${toStart.districtName}
						                		</#list></br>
						                		目的地：&nbsp;${packGroup.prodPackageGroupTransport.toDestinationDistrictMuch.districtName}
						                		</#if>
						                		<#if packGroup.prodPackageGroupTransport.backStartDays??>
						                		[返程]&nbsp;第${packGroup.prodPackageGroupTransport.backStartDays}天出发&nbsp;&nbsp;</br>
						                		 出发地：&nbsp;
						                			<#if packGroup.prodPackageGroupTransport.backStartPoint != null && packGroup.prodPackageGroupTransport.backStartPoint != backStartPoint.districtId >
						                				${packGroup.prodPackageGroupTransport.backStartPointDistrict.districtName}
					                				<#else>
						                				${backStartPoint.districtName}
						                			</#if>
						                		</br>
						                		目的地：&nbsp;
						                		<#list backDestDistricts as toStart>
						                		${toStart.districtName}
						                		</#list>
						                		</#if>
						                		</#if>
						                		</#if>
						                		
						                		</#if>
						                		<!--多出发地结束-->
						                		
						                	</td>
						                	<td style="text-align: right">
						                		<#if !autoPack >
						                		<a class="btn btn_cc1" onclick="selectPackGroupProductBranch('${packGroup.groupId }','19')" >选择产品</a>
						                		</#if>
						                		<#if autoPack>
						                			<input type="hidden" id = "${packGroup.groupId }_autoPack" value="Y"/>
						                		</#if>
												<a class="btn btn_cc1" onclick="deletePackGroup('${packGroup.groupId }','${packGroup.prodPackageGroupTransport.transportType}')">删除该段</a>
						                	</td>
						                </tr>
						                <tr>
						                	<td colspan="2">
											  <div class="p_box box_info">
											    <table class="p_table table_center" style="width: 1054px">
									                <thead>
									                    <th>产品类型</th>
									                    <th>产品ID</th>
									                    <th>出发地</th>
									                    <th>目的地</th>
									                    <th>产品名称</th>
									                    <th>规格ID</th>
									                    <th>规格</th>
									                    <th>销售价规则</th>
									                    <th>状态</th>
									                    <th>操作</th>
									                    </tr>
									                </thead>
									                 	<#if packGroup.prodPackageDetails ??>
															<#list packGroup.prodPackageDetails as detail> 
																<#if detail?? && detail.prodProductBranch??>
																	<tr >
																		<td >${detail.prodProductBranch.categoryName!''}</td>
																		<td>${detail.prodProductBranch.productId!''}</td>
																		<td>${detail.prodProductBranch.product.prodTraffic.startDistrictObj.districtName!''} </td>
																		<td>${detail.prodProductBranch.product.prodTraffic.endDistrictObj.districtName!''}</td>
																		<td>	
																			<#if autoPack>
																				${detail.prodProductBranch.productName!''}
																			<#else>																	
																			<a style="cursor:pointer" 
																				onclick="openProduct(${detail.prodProductBranch.productId!''},${detail.prodProductBranch.categoryId!''},'${detail.prodProductBranch.categoryName!''}')">
																				${detail.prodProductBranch.productName!''} 
																			</a>
																			</#if>
																		</td>
																		<td>${detail.prodProductBranch.productBranchId!''}</td>
																		<td>${detail.prodProductBranch.branchName!''}</td>
																		<td>
																			<#if detail.priceType?? && detail.priceType == 'FIXED_PRICE'>
																				加价：${detail.price/100}
																			</#if>
																			<#if detail.priceType?? && detail.priceType == 'MAKEUP_PRICE'>
																				利润：${detail.price/100}%
																			</#if>
																			</td>
																		<td>
																			<#if !autoPack >
																			[${cancelFlag[detail.prodProductBranch.cancelFlag]}]
																			[${saleFlag[detail.prodProductBranch.saleFlag]}]
						                									<#else>
																			&nbsp;																			
																			</#if>
																		</td>
																		<td>
																			<#if autoPack>
																			<a id="setPriceRule" style="cursor:pointer" onclick="updateAutoPackGroupDetail('${packGroup.groupId }')">设置价格规则</a>
																			<#else>
																			<a id="setPriceRule" style="cursor:pointer" onclick="updatePackGroupDetail('${detail.detailId !''}')">设置价格规则</a>
																			<a id="deletePackGroupDetail" style="cursor:pointer" onclick="deletePackGroupDetail('${detail.detailId !''}')">取消打包</a>
																			</#if>
																			<!-- 出境 -->
																			<#if prodProduct?? && prodProduct.bu == 'OUTBOUND_BU'>
																				<a id="setPriceRule" style="cursor:pointer" onclick="updatePackGroupDetailAddPrice('${detail.detailId !''}')">设置特殊价格规则</a>
																			</#if>
																			<#if autoPack>
																				<a id="setPriceRule" style="cursor:pointer" onclick="openAutoPackGroupDetail('${packGroup.groupId }')">详细</a>
																				<#if packGroup.prodPackageGroupTransport.toStartDays ??>
																				<a id="setStartPoints" style="cursor:pointer" onclick="openManagerPoints('${packGroup.groupId }','TO')">出发地管理</a>
													                			<#else>
																				<a id="setBackDests" style="cursor:pointer" onclick="openManagerPoints('${packGroup.groupId }','BACK')">目的地管理</a>
													                			</#if>
																			</#if>
																		</td>
																	</tr>
																</#if>
															</#list>
														  </#if>
										                </tbody>
									               </table>
									            </div>
						                	</td>
						                </tr>
						                </#if>
						                <!-- 大交通结束 -->
	    						 </#list>
					          </#if>	
				         </#if>
	                	</tbody>
	                </table>
	            </div>
	        </div>
</form>
<div class="fl operate">
	<a href="javascript:void(0);"  class="showLogDialog btn btn_cc1" param='objectId=${productId}&objectType=PROD_PRODUCT_PRODUCT_GROUP&sysName=VST'>操作日志</a>
</div>
</div>
<!-- 存储弹出页面的临时的打包规格数据 -->
<#include "/base/foot.ftl"/>
</body>
</html>
<script>
var addGroupDialog, findCitygroupDialog,selectProductDialog,updateGroupDetailDialog,updateGroupDetailAddPriceDialog,openAutoPackGroupDetailDialog,openManagerPointsDialog;

function addGroup(selectCategoryId){
      $.ajax({
			url : "/vst_admin/productPack/line/isBoundStamp.do",
			type : "post",
			dataType : 'json',
			data : "productId=" + $("#productId").val(),
			success : function(result) {
				if(result.code == "success"){
				if(result.attributes.boundStampFalg){
				var url = "/vst_admin/productPack/line/showAddGroup.do?groupType=" +  $("#groupType").val() + "&productId=" + $("#productId").val();
	            url += "&selectCategoryId=" + selectCategoryId + "&routeNum=" + $("#routeNum").val() + "&stayNum=" + $("#stayNum").val()+"&destId="+ $("#destId").val();
	            addGroupDialog = new xDialog(url,{},{title:"新增组",width:"1100",height:"800",iframe:true});
	            }else{
	              alert("该产品下有有效预售券，不能更改!");
	            }
				}
			},
			error : function(result) {
				$.alert(result.message);
			}
		});
	
}

//查看城市组信息页面
function findCitygroup(){
	var url = "/vst_admin/biz/citygroup/findCitygroupList.do";
	findCitygroupDialog = new xDialog(url,{},{title:"城市组维护",width:"1150",height:"900",iframe:true});
}

//取消打包
function deletePackGroupDetail(detailId){
    $.ajax({
	  url : "/vst_admin/productPack/line/isBoundStamp.do",
	  type : "post",
	  dataType : 'json',
	  async: false,
	  data : "productId=" + $("#productId").val(),
	  success : function(result) {
	   if(result.code == "success"){
	     if(result.attributes.boundStampFalg){
	        $.confirm("确认取消吗 ？",function(){
		      var loading = top.pandora.loading("正在努力中...");
		      $.ajax({
			       url : "/vst_admin/productPack/line/deletePackGroupDetail.do",
			       type : "post",
			       dataType : 'json',
			       data : "detailId=" + detailId+ "&productId=" + $("#productId").val(),
			       success : function(result) {
				    loading.close();
				    if(result.code == "success"){
					    window.location.reload();
				    }
			      },
			      error : function(result) {
				     loading.close();
				     $.alert(result.message);
			      }
		      });
	        });
	     }else{
	           alert("该产品下有有效预售券，不能更改!");
	          }
		}
	   },
		error : function(result) {
			$.alert(result.message);
		}
	});
}

/**
 * 加入产品规格
 */
function selectPackGroupProductBranch(groupId,selectCategoryId){
	var groupType = $("#groupType").val();
	var categoryParentId = $("#categoryParentId").val();
	var productType = $("#productType").val();
	var BU = $("#BU").val();
	var categoryId = $("#categoryId").val();
	var url = "/vst_admin/productPack/line/showSelectProductList.do?groupType=" + groupType + "&groupId=" + groupId  
		+ "&selectParentCategoryFlag=" + $("#selectParentCategoryFlag").val()
		+ "&selectCategoryId=" + selectCategoryId
		+ "&productType=" + productType
		+ "&BU=" + BU
		+ "&categoryId_=" + categoryId;
	if(groupType != 'HOTEL'){
		url += "&categoryParentId=" + categoryParentId;
	}
	
	addTransientBranchs('');//清空存储临时的打包信息

	selectProductDialog = new xDialog(url,{},{title:"选择产品",iframe:true,width : "1000px", height : "600px"});
}

function deletePackGroup(groupId,transportType){
      $.ajax({
			url : "/vst_admin/productPack/line/isBoundStamp.do",
			type : "post",
			dataType : 'json',
			async: false,
			data : "productId=" + $("#productId").val(),
			success : function(result) {
		if(result.code == "success"){
		if(result.attributes.boundStampFalg){
	      $.confirm("确认删除吗 ？",function(){
		//单程时做出判断，如果是单程去程并且存在对应的单程返程交通组信息时做出提示
		if ($("#muiltDpartureFlag").val() == 'Y' && transportType == 'TO') {
			var tip = sendAjaxValidateIsExistBack(groupId);
			if (tip) {
				$.alert("该去程下存在对应的返程交通组信息，请先删除返程交通信息！");
				return;
				/*$.confirm("该单程去程存在对应的单程返程交通组信息，确定一起删除么？",function(){
					sendAjaxToDeletePackgroup(groupId);
					return;
				});*/
			 }
		  }

    	   sendAjaxToDeletePackgroup(groupId);
	     });
	    }else{
	       alert("该产品下有有效预售券，不能更改!");
	      }
		 }
		},
		error : function(result) {
			$.alert(result.message);
		}
	});
}

//发送ajax校验是否存在对应的单程返程信息(如果是多出发地并且是单程去程时，若存在单程返程做出提示)
function sendAjaxValidateIsExistBack(groupId) {
	if (typeof(groupId) == 'undefined' || groupId == "" || groupId.length == 0) {
		$.alert("删除时出错，参数groupId接收到");
		return;
	}

	var tip = false;
	var loading = top.pandora.loading("数据检测中...");
	$.ajax({
		url : "/vst_admin/productPack/line/validateIsExistBack.do",
		type : "post",
		dataType : 'json',
		async: false, 
		data : "groupId=" + groupId + "&groupType=" + $("#groupType").val() + "&productId=" + $("#productId").val(),
		success : function(result) {
			if(result.code == "success"){
				loading.close();
				var isExistBack = result.attributes.isExistBack;
				if (isExistBack) {
					tip = true;
				}
			} else {
				loading.close();
				$.alert(result.message);
			}
			return tip;
		},
		error : function(result) {
			loading.close();
			$.alert(result.message);
		}
	});
	
	return tip;
}

// 发送ajax删除打包组
function sendAjaxToDeletePackgroup(groupId){
	if (typeof(groupId) == 'undefined' || groupId == "" || groupId.length == 0) {
		$.alert("删除时出错，参数groupId接收到");
		return;
	}

	var loading = top.pandora.loading("正在努力中...");
	
	var data = {
		groupType : $("#groupType").val(),
		productId : $("#productId").val()
	};
	data.groupId = groupId;
	
	
	$.ajax({
		url : "/vst_admin/productPack/line/deletePackGroup.do",
		type : "post",
		dataType : 'json',
		data : data,
		success : function(result) {
			loading.close();
			if(result.code == "success"){
				window.location.reload();
			}
		},
		error : function(result) {
			loading.close();
			$.alert(result.message);
		}
	});
}

//保存时间段
var groupId = '';
function onSavePackGroup(params){
	 if(params != null){
		groupId = params.groupId;
		var groupType = params.groupType;
		if(groupType == 'HOTEL'){
			$("#categoryParentId").val();
		}
		/*var selectCategoryId = params.selectCategoryId;
		var url = "/vst_admin/productPack/line/showSelectProductList.do?groupType=" + groupType + "&groupId=" + groupId  
					+ "&selectParentCategoryFlag=" + $("#selectParentCategoryFlag").val()
					+ "&selectCategoryId=" + selectCategoryId;
		selectProductDialog = new xDialog(url,{},{title:"选择产品",iframe:true,width:"1000",height:"600"}); */
	} 
	addGroupDialog.close();
	window.location.reload();
}

//关联规格与产品或者商品
function onSavePackGroupDetail(params){
	if(params != null){
		var groupId = params.groupId;
		var groupType = params.groupType;
		var selectCategoryId = params.selectCategoryId;
		var detailIds = params.detailIds;
		var url = "/vst_admin/productPack/line/showUpdateGroupDetail.do?groupType=" + groupType + "&groupId=" + groupId 
					+ "&selectCategoryId=" + selectCategoryId+ "&detailIds=" + detailIds;
		updateGroupDetailDialog = new xDialog(url,{},{title:"设置价格规则",iframe:true,width:"600",height:"600"});
	}
	
	selectProductDialog.close();
}
//插入自动打包交通组完成之后，弹出设置价格规则窗口
function onSaveAutoPackGroupDetail(params){
	if(params != null){
		var toGroupId = 0;
		var backGroupId = 0;
		if(params.toGroupId){toGroupId = params.toGroupId}
		if(params.backGroupId){backGroupId = params.backGroupId}
		var groupType = params.groupType;
		var url = "/vst_admin/productPack/line/showSingleUpdateGroupDetail.do?groupType=" + groupType + "&backGroupId=" + backGroupId+ "&toGroupId=" + toGroupId;
		updateGroupDetailDialog = new xDialog(url,{},{title:"设置价格规则",iframe:true,width:"600",height:"600"});
	}
	
	addGroupDialog.close();
}


//设置单条记录价格规则
function updatePackGroupDetail(detailId){
	var groupType = $("#groupType").val();
	var url = "/vst_admin/productPack/line/showSingleUpdateGroupDetail.do?groupType=" + groupType + "&detailIds=" + detailId;
	updateGroupDetailDialog = new xDialog(url,{},{title:"设置价格规则",iframe:true,width:"600",height:"600"});	
}
function updateAutoPackGroupDetail(groupId){
	if(!groupId){
		$.alert("删除时出错，参数groupId未接收到");
	}
	var groupType = $("#groupType").val();
	var url = "/vst_admin/productPack/line/showSingleUpdateGroupDetail.do?groupType=" + groupType + "&toGroupId=" + groupId;
	updateGroupDetailDialog = new xDialog(url,{},{title:"设置价格规则",iframe:true,width:"600",height:"600"});	
}

//设置单条记录特殊价格规则
function updatePackGroupDetailAddPrice(detailId){
	var groupType = $("#groupType").val();
	var url = "/vst_admin/productPack/line/showSingleUpdateGroupDetailAddPrice.do?groupType=" + groupType + "&detailIds=" + detailId;
	updateGroupDetailAddPriceDialog = new xDialog(url,{},{title:"设置特殊价格规则",iframe:true,width:"700",height:"700"});	
}

//自动打包详情
function openAutoPackGroupDetail(groupId){
	if(!groupId){
		$.alert("查看详细时出错，参数groupId未接收到");
	}
	var productId = $("#productId").val();
	var url = "/vst_admin/productPack/line/showPackageDetail.do?productId=" + productId + "&groupId=" + groupId;
	openAutoPackGroupDetailDialog = new xDialog(url,{},{title:"自动打包交通详情",iframe:true,width:"1200",height:"900"});	
}

//自动打包出发地和目的地管理
function openManagerPoints(groupId,start){
	if(!groupId){
			$.alert("查看详细时出错，参数groupId未接收到");
	}
	var productId = $("#productId").val();
	var titleLabel = start == "TO"?"出发地管理":"目的地管理";
	var url = "/vst_admin/productPack/line/showManagerPoints.do?productId=" + productId + "&groupId=" + groupId;
	openManagerPointsDialog = new xDialog(url,{},{title: titleLabel,iframe:true,width:"800",height:"600"});	
}

//设置价格规则
function onUpdatePackGroupDetail(){
	updateGroupDetailDialog.close();
	window.location.reload();
}
//关闭管理目的地界面并刷新
function onOpenManagerPoints(){
	openManagerPointsDialog.close();
	window.location.reload();
}


//设置特殊价格规则
function onUpdatePackGroupDetailAddPrice(){
	updateGroupDetailAddPriceDialog.close();
	window.location.reload();
}
function openProduct(productId, categoryId, categoryName){
	window.open("/vst_admin/prod/baseProduct/toUpdateProduct.do?productId="+productId+"&categoryId="+categoryId+"&categoryName="+categoryName);
}
isView();

//----------临时存储加入打包的规格 js开始-----------//
window.checkedBranchs = new Array();

//获得全局branchs
function getCheckBranchs() {
	return window.checkedBranchs;
}

//添加保存弹出页临时的选择的规格信息
function addTransientBranchs(checkedBoxs) {
	if (checkedBoxs == '') {
		window.checkedBranchs = new Array();
	} else {
		$.each(checkedBoxs, function(index, value) {
			addCheckedBranch(value);
		});
	}
}

//对全局变量添加（去重复）
function addCheckedBranch(branch) {
	var isNewBranch = true;
	$.each(window.checkedBranchs, function(index, value) {
		if (branch.productBranchId == value.productBranchId) {
			isNewBranch = false;
		}
	});
	//如果是一个新的规格则添加
	if (isNewBranch) {
		window.checkedBranchs.push(branch);
	}
}

//对全局变量删除值
function deleteBranch(branchId){
	if (branchId == '') {
		return;
	}

	$.each(window.checkedBranchs, function(index, value) {
		if (typeof(value) != 'undefined' && branchId == value.productBranchId) {
			window.checkedBranchs.splice(index,1);
			return;
		}
	});
}

//----------临时存储加入打包的规格 js结束-----------//
</script>