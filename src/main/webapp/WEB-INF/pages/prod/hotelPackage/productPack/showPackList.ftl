<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
</head>
<body>
<div class="iframe_header">
        <ul class="iframe_nav">
            <li><a href="#">酒店套餐</a> &gt;</li>
            <li><a href="#">打包</a> &gt;</li>
            <li><a href="#">组合打包</a> </li>
        </ul>
</div>
<div class="iframe_content mt10">
<div class="tiptext tip-warning"><span class="tip-icon tip-icon-warning"></span>
注：此处维护的只是酒店和门票信息，与时间价格表及库存无关<br/>
1.酒店信息，同一行程中时间段不能交叉，不同行程时间段可相同；<br/>
2.维护多个信息前台呈现酒店或门票可选<br/>
3.添加酒店规格或门票商品，需要到原产品对应供应商下增加<br/>
</div>
 <br/>
<input type="hidden" id = "productId" name="productId" value="${productId }"/>
<input type="hidden" id="suppGoodsId"  name="suppGoodsId" value="${suppGoodsId}"/>
<form action="" method="post" id="dataForm">
酒店信息
<hr/>
<br/>
<!--酒店组-->
		<#if hotelBizcategory??>
	 	<#if hotelBizcategory.categoryId == '1'> 
		<div class="p_box box_info p_line" style="border:solid 1px #aaa">
	            <div class="box_content">
	                <table class="e_table form-inline" style="width:900px" >
	                    <tbody>
		                <tr style="background-color:#E4E4E4">
		                	<td class="e_label" width="20px" style="font-weight:bold;text-align: left">
		                		${hotelBizcategory.cnName}
		                	</td>
		                	<td class="e_label" width="20px" style="text-align: right;"><a class="btn btn_cc1"  categoryId=${hotelBizcategory.categoryId}  onclick="addGroup(${hotelBizcategory.categoryId})" >插入时间段</a></td>
		                </tr>
	                	</tbody>
	                </table>
	            </div>
	           
	           </#if>
	           <#if prodPackageHotelCombHotelList?? && prodPackageHotelCombHotelList?size gt 0>
	           <#list prodPackageHotelCombHotelList as prodPackageHotelCombHotel>
	           <table  style="width: 900px">
	                    <tbody>
	    					
	    					<tr>
						         <td style="font-weight:bold;text-align: left;width:500px">
						         				<#assign days = prodPackageHotelCombHotel.stayDays?split(',')>
						                		第 ${days[0]} 晚——第 ${days[days?size-1]} 晚 【备注：${prodPackageHotelCombHotel.reMark}】                       
						          		</td>
						          			<span><h6><b>【${prodPackageHotelCombHotel.prodLineRoute.routeName}】</b><h6></span>
						                	<td  style="text-align: right">
						                		<a class="btn btn_cc1" onclick="selectPackGroupBranchOrGood(${hotelBizcategory.categoryId},${prodPackageHotelCombHotel.hotelGroupId})" >选择产品</a>
												<a class="btn btn_cc1" onclick="deletePackGroup(${prodPackageHotelCombHotel.hotelGroupId},${hotelBizcategory.categoryId},${suppGoodsId},${prodPackageHotelCombHotel.lineRouteId})">删除该段</a>
						                	</td>
						                </tr>
						                
						                <tr>
						                	<td colspan="2">
											  <div class="p_box box_info">
											    <table class="p_table table_center" style="width: 900px">
									                <thead>
									                    <th>酒店ID</th>
									                    <th>酒店名称</th>
									                    <th>行政区划</th>
									                    <th>规格ID</th>
									                    <th>规格名称</th>
									                    <th>操作</th>
									                    </tr>
									                </thead>
									                
									                 <tbody>
									                 <#if prodPackageHotelCombHotel.combDetailVOs??&&prodPackageHotelCombHotel.combDetailVOs?size gt 0 >
									                 <#list prodPackageHotelCombHotel.combDetailVOs as prodPackageHotelCombHotelDetail>
																	<tr>
																		<td>${prodPackageHotelCombHotelDetail.prodProduct.productId}</td>
																		<td style="text-align:left;">
																			<a style="cursor:pointer" title=${prodPackageHotelCombHotelDetail.prodProduct.productName}
																				title="${prodPackageHotelCombHotelDetail.prodProduct.productName}" 
																				onclick="openHotelProduct(${prodPackageHotelCombHotelDetail.prodProduct.productId},${hotelBizcategory.categoryId},'${hotelOnlineFlag}')">
																					<#assign length = prodPackageHotelCombHotelDetail.prodProduct.productName?length>
																					<#assign names = prodPackageHotelCombHotelDetail.prodProduct.productName>
																					<#if names?length gt 16  || names?length ==16  >
																						<p>${names?substring(0,8)}</p>
																						${names?substring(8,16)}
																						<#if names?length gt 16 >
																						....
																						</#if>
																					<#elseif names?length lt 16 && names?length gt 8 >
																						<p>${names?substring(0,8)}</p>
																						${names?substring(8,length)}
																					<#else>
																						${names}
																					</#if>
																			</a>
																		</td>
																		<td
																		title="${prodPackageHotelCombHotelDetail.bizDistrict.districtName}"
																		style="text-align:left;"
																		>
																		<#assign length = prodPackageHotelCombHotelDetail.bizDistrict.districtName?length>
																					<#assign names = prodPackageHotelCombHotelDetail.bizDistrict.districtName>
																					<#if names?length gt 16  || names?length ==16  >
																						<p>${names?substring(0,8)}</p>
																						${names?substring(8,16)}
																						<#if names?length gt 16 >
																						....
																						</#if>
																					<#elseif names?length lt 16 && names?length gt 8 >
																						<p>${names?substring(0,8)}</p>
																						${names?substring(8,length)}
																					<#else>
																						${names}
																					</#if>
																		</td>
																		<td>${prodPackageHotelCombHotelDetail.prodProductBranch.productBranchId}</td>
																		<td  title="${prodPackageHotelCombHotelDetail.prodProductBranch.branchName}" style="text-align:left;">
																					<#assign length = prodPackageHotelCombHotelDetail.prodProductBranch.branchName?length>
																					<#assign names = prodPackageHotelCombHotelDetail.prodProductBranch.branchName>
																					<#if names?length gt 16  || names?length ==16  >
																						<p>${names?substring(0,8)}</p>
																						${names?substring(8,16)}
																						<#if names?length gt 16 >
																						....
																						</#if>
																					<#elseif names?length lt 16 && names?length gt 8 >
																						<p>${names?substring(0,8)}</p>
																						${names?substring(8,length)}
																					<#else>
																						${names}
																					</#if>
																		
																		</td>
																		<td>
																			<a id="setPriceRule" style="cursor:pointer" onclick="showProdbranchINfo(${prodPackageHotelCombHotelDetail.prodProductBranch.productBranchId},${prodPackageHotelCombHotelDetail.bizBranch.branchId},'${hotelOnlineFlag}')">查看规格信息</a>
																			<a id="deletePackGroupDetail" style="cursor:pointer" onclick="deletePackGroupDetail(${prodPackageHotelCombHotelDetail.hotelCombDetailId},${prodPackageHotelCombHotelDetail.bizCategory.categoryId},${suppGoodsId})">取消打包</a>
																		</td>
																	</tr>
															</#list>
														</#if>			
										                </tbody>
									               </table>
									              
									            </div>
						                	</td>
						                </tr>
						         <tbody>
						  </table>
						  </#list>
						  </#if> 
				</div>
</#if>
<br/>
门票信息
<hr/>
<br/>
<!--门票组-->
<#if ticketBizcategory??>
	 	<#if ticketBizcategory.categoryId == '5'> 
		<div class="p_box box_info p_line" style="border:solid 1px #aaa">
	            <div class="box_content">
	                <table class="e_table form-inline" style="width:900px" >
	                    <tbody>
		                <tr style="background-color:#E4E4E4">
		                	<td class="e_label" width="20px" style="font-weight:bold;text-align: left">
		                		${ticketBizcategory.cnName}
		                	</td>
		                	<td class="e_label" width="20px" style="text-align: right;"><a class="btn btn_cc1" categoryId=${ticketBizcategory.categoryId}  onclick="addGroup(${ticketBizcategory.categoryId})" selectCategoryId="">插入时间段</a></td>
		                </tr>
	                	</tbody>
	                </table>
	            </div>
	           <div>
	           </#if>
	           <#if prodPackageHotelCombTicketList?? && prodPackageHotelCombTicketList?size gt 0>
	           <#list prodPackageHotelCombTicketList as prodPackageHotelCombTicket>
	           <table  style="width: 900px">
	                    <tbody>
	    					<tr >
						         <td  style="font-weight:bold;text-align: left;width:500px">
						                	第&nbsp;${prodPackageHotelCombTicket.stayDays}&nbsp;天 
						                	【备注：${prodPackageHotelCombTicket.reMark}】
						                	</td>
						                	<span><h6><b>${prodPackageHotelCombTicket.categoryName}【${prodPackageHotelCombTicket.prodLineRoute.routeName}】</b><h6></span>
						                	<td  style="text-align: right">
						                		<a class="btn btn_cc1" onclick="selectPackGroupBranchOrGood(${prodPackageHotelCombTicket.categoryId},${prodPackageHotelCombTicket.ticketGroupId})" >选择产品</a>
												<a class="btn btn_cc1" onclick="deletePackGroup(${prodPackageHotelCombTicket.ticketGroupId},${prodPackageHotelCombTicket.categoryId},${suppGoodsId},${prodPackageHotelCombTicket.lineRouteId})">删除该段</a>
						                	</td>
						                </tr>
						                <tr>
						                	<td colspan="2">
											  <div class="p_box box_info">
											    <table class="p_table table_center" style="width: 900px">
									                <thead>
									                    <th>门票ID</th>
									                    <th>产品名称</th>
									                    <th>目的地名称</th>
									                    <th>规格ID</th>
									                    <th>规格名称</th>
									                    <th>商品ID</th>
									                    <th>商品名称</th>
									                    <th>操作</th>
									                    </tr>
									                </thead>
									                
									                 <tbody>
									                 <#if prodPackageHotelCombTicket.combDetailVOs??&&prodPackageHotelCombTicket.combDetailVOs?size gt 0 >
									                <#list prodPackageHotelCombTicket.combDetailVOs as prodPackageHotelCombTicketDetail>
																	<tr>
																		<td>${prodPackageHotelCombTicketDetail.prodProduct.productId}</td>
																		<td style="text-align:left;">
																			<a style="cursor:pointer" 
																				title="${prodPackageHotelCombTicketDetail.prodProduct.productName}"
																				onclick="openProduct(${prodPackageHotelCombTicketDetail.prodProduct.productId},${prodPackageHotelCombTicket.categoryId})">
																				<#assign length = prodPackageHotelCombTicketDetail.prodProduct.productName?length>
																					<#assign names = prodPackageHotelCombTicketDetail.prodProduct.productName>
																					<#if names?length gt 16  || names?length ==16  >
																						<p>${names?substring(0,8)}</p>
																						${names?substring(8,16)}
																						<#if names?length gt 16 >
																						....
																						</#if>
																					<#elseif names?length lt 16 && names?length gt 8 >
																						<p>${names?substring(0,8)}</p>
																						${names?substring(8,length)}
																					<#else>
																						${names}
																					</#if>
																			</a>
																		</td>
																		<td
																		title="${prodPackageHotelCombTicketDetail.bizDest.destName}"
																		style="text-align:left;"
																		>
																		<#assign length = prodPackageHotelCombTicketDetail.bizDest.destName?length>
																					<#assign names = prodPackageHotelCombTicketDetail.bizDest.destName>
																					<#if names?length gt 16  || names?length ==16  >
																						<p>${names?substring(0,8)}</p>
																						${names?substring(8,16)}
																						<#if names?length gt 16 >
																						....
																						</#if>
																					<#elseif names?length lt 16 && names?length gt 8 >
																						<p>${names?substring(0,8)}</p>
																						${names?substring(8,length)}
																					<#else>
																						${names}
																					</#if>
																		</td>
																		<td>${prodPackageHotelCombTicketDetail.prodProductBranch.productBranchId}</td>
																		<td title="${prodPackageHotelCombTicketDetail.prodProductBranch.branchName}"  style="text-align:left;">
																					<#assign length = prodPackageHotelCombTicketDetail.prodProductBranch.branchName?length>
																					<#assign names = prodPackageHotelCombTicketDetail.prodProductBranch.branchName>
																					<#if names?length gt 16  || names?length ==16  >
																						<p>${names?substring(0,8)}</p>
																						${names?substring(8,16)}
																						<#if names?length gt 16 >
																						....
																						</#if>
																					<#elseif names?length lt 16 && names?length gt 8 >
																						<p>${names?substring(0,8)}</p>
																						${names?substring(8,length)}
																					<#else>
																						${names}
																					</#if>
																		</td>
																		<td>${prodPackageHotelCombTicketDetail.suppGoods.suppGoodsId}</td>
																		<td  title="${prodPackageHotelCombTicketDetail.suppGoods.goodsName}" style="text-align:left;">
																					<#assign length = prodPackageHotelCombTicketDetail.suppGoods.goodsName?length>
																					<#assign names = prodPackageHotelCombTicketDetail.suppGoods.goodsName>
																					<#if names?length gt 16  || names?length ==16  >
																						<p>${names?substring(0,8)}</p>
																						${names?substring(8,16)}
																						<#if names?length gt 16 >
																						....
																						</#if>
																					<#elseif names?length lt 16 && names?length gt 8 >
																						<p>${names?substring(0,8)}</p>
																						${names?substring(8,length)}
																					<#else>
																						${names}
																					</#if>
																		</td>
																		<td>
																			<a id="setPriceRule" style="cursor:pointer" onclick="showSuppGoodsDescInitINfo(${prodPackageHotelCombTicketDetail.objectId})">查看商品描述</a>
																			<a id="deletePackGroupDetail" style="cursor:pointer" onclick="deletePackGroupDetail(${prodPackageHotelCombTicketDetail.hotelCombDetailId},${prodPackageHotelCombTicketDetail.bizCategory.categoryId},${suppGoodsId})">取消打包</a>
																		</td>
																	</tr>
															</#list>
										                </#if>
										                </tbody>
									               </table>
									            </div>
						                	</td>
						                </tr>
						         <tbody>
						  </table>
						  </#list>
						  </#if> 
					</div>
				</div>	               						                
</#if>

<div class="fl operate"><a href="javascript:void(0);"  class="showLog btn btn_cc1" param='objectId=${suppGoodsId}&objectType=PROD_PRODUCT_HOTELCOMMB_GROUP&sysName=VST'>操作日志</a></div>

</form>
<#include "/base/foot.ftl"/>
</body>
</html>
<script>
var addGroupDialog, selectProductDialog,updateGroupDetailDialog;
function addGroup(selectCategoryId){
	var url = "/vst_admin/hotelCommbPackage/productPack/showAddGroup.do?categoryId=" + selectCategoryId + "&productId=" + $("#productId").val()+"&suppGoodsId="+$("#suppGoodsId").val();
	addGroupDialog = new xDialog(url,{},{title:"新增组",iframe:true,width:"600",height:"600"});
} 


/**
 * 加入产品规格或商品
 */
function selectPackGroupBranchOrGood(selectCategoryId,hotelGroupId){
	var url = "/vst_admin/hotelCommbPackage/productPack/showSelectProductList.do? "+"&groupId=" + hotelGroupId+ "&selectCategoryId=" + selectCategoryId+"&suppGoodsId="+$("#suppGoodsId").val();  
	selectProductDialog = new xDialog(url,{},{title:"选择产品",iframe:true,width : "880px"});
}


//删除时间段组
function deletePackGroup(groupId,categoryId,suppGoodsId,lineRouteId){
	$.confirm("确认删除吗 ？",function(){
		var loading = top.pandora.loading("正在努力中...");
		$.ajax({
			url : "/vst_admin/hotelCommbPackage/productPack/delGroup.do",
			type : "post",
			dataType : 'json',
			data : "groupId=" + groupId+"&categoryId="+categoryId+"&suppGoodsId="+suppGoodsId+"&lineRouteId="+lineRouteId,
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
}




//保存时间段后刷新窗口
var groupId = '';
function onSavePackGroup(params){
	addGroupDialog.close();
	window.location.reload();
}



//保存规格或商品后关闭窗口
function onSaveGroupDetail(){
	selectProductDialog.close();
	window.location.reload();
}

//查看产品基本信息
function openProduct(productId,categoryId){
	window.open("/vst_admin/prod/baseProduct/toUpdateProduct.do?productId="+productId+"&categoryId="+categoryId);
}

//查看酒店产品基本信息
function openHotelProduct(productId,categoryId,hotelOnlineFlag){
	//新系统上线，跳转至新连接
	if(hotelOnlineFlag == 'true'){
	window.open("/lvmm_dest_back/prod/baseProduct/toUpdateProduct.do?productId="+productId+"&categoryId="+categoryId);
	}else{
	window.open("/vst_admin/prod/baseProduct/toUpdateProduct.do?productId="+productId+"&categoryId="+categoryId);
	}
}
isView();




//取消打包
function deletePackGroupDetail(hotelCombDetailId,categoryId,suppGoodsId){
	$.confirm("确认取消吗 ？",function(){
		var loading = top.pandora.loading("正在努力中...");
		$.ajax({
			url : "/vst_admin/hotelCommbPackage/productPack/delGroupDetail.do",
			type : "post",
			dataType : 'json',
			data : {hotelCombDetailId:hotelCombDetailId,categoryId:categoryId,suppGoodsId:suppGoodsId},
			success : function(result) {
				loading.close();
				if(result.code == "success"){
						loading.close();
						$.alert(result.message);		
						window.location.reload();
				}else{
					loading.close();
					$.alert(result.message);
				}
			},
			error : function(result) {
				loading.close();
				$.alert(result.message);
			}
		});
	});
}

function showProdbranchINfo(productBranchId,branchId,hotelOnlineFlag){
	if(hotelOnlineFlag == 'true'){
		searchProdbranchDialog = new xDialog("/lvmm_dest_back/prod/prodbranch/showUpdateBranch.do",{"productBranchId":productBranchId,"branchId":branchId}, {title:"查看产品规格",width:700,height:300});
	}else{
		searchProdbranchDialog = new xDialog("/vst_admin/prod/prodbranch/showUpdateBranch.do",{"productBranchId":productBranchId,"branchId":branchId}, {title:"查看产品规格",width:700,height:300});
	}
	if(searchProdbranchDialog){
		//因为是查看规格，所有把保存按钮移除即可
		searchProdbranchDialog.dialog.wrap.find("textarea ").attr("disabled",true);
		searchProdbranchDialog.dialog.wrap.find("input").attr("disabled",true);
		searchProdbranchDialog.dialog.wrap.find("select").attr("disabled",true);
		searchProdbranchDialog.dialog.wrap.find(".dialog-content .clearfix").find("#save").remove();
	}

}


function showSuppGoodsDescInitINfo(suppGoodsId){
	searchGoodsDescInitDialog = new xDialog("/vst_admin/ticket/goods/goods/suppGoodsDescInit.do",{"suppGoodsId":suppGoodsId}, {title:"查看商品描述",width:700,height:300});
	if(searchGoodsDescInitDialog){
		//因为是查看信息，所有把保存按钮移除即可
		searchGoodsDescInitDialog.dialog.wrap.find("textarea ").attr("disabled",true);
		searchGoodsDescInitDialog.dialog.wrap.find("input").attr("disabled",true);
		searchGoodsDescInitDialog.dialog.wrap.find("select").attr("disabled",true);
		searchGoodsDescInitDialog.dialog.wrap.find(".dialog-content .clearfix").find("#saveDesc").remove();
		
	}

}


$("a.showLog").live("click",function(){
		var param=$(this).attr("param");
	    new xDialog("/lvmm_log/bizLog/showVersatileLogList?"+param,{},{title:"查看日志",iframe:true,width:1000,hight:300,iframeHeight:680,scrolling:"yes"});
	});





//获取选择框窗口对象设置的属性
function getObj(){
	return selectProductDialog.lableMiniHtml; 
}
//保存选择框窗口选择的商品或规格信息
function setObj(obj){
	return selectProductDialog.lableMiniHtml = obj; 
}


</script>