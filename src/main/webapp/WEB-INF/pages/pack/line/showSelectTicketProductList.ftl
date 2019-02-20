<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
<style type="text/css">
.table_center td {
	white-space: nowrap;
}
.table_center .productName {
	min-width: 120px;
	white-space: normal;
}
.goodsTable td {
	white-space: nowrap;
	text-align: left;
	table-layout: fixed;
	border: 0px;
	padding: 2px 2px;
}
</style>
</head>
<body style="min-height: 800px; min-width: 900px;">
<#assign HOTEL_SCENIC_CATEGORY_VALUE="181">
<div class="iframe_content">
    <div class="p_box box_info">
	<form method="post" action='/vst_admin/productPack/line/showSelectProductList.do' id="searchForm">
		<input type="hidden" id="groupId" name="groupId" value="${groupId }"/>
		<input type="hidden" id="groupType" name="packageType" value="LINE_TICKET"/>
		<input type="hidden" id="subCategoryId" name="subCategoryId" value="${subCategoryId!'' }"/>
		<input type="hidden" id="selectCategoryId" name="selectCategoryId" value="${selectCategoryId }"/>
		<input type="hidden" id="redirectType" name="redirectType" value="${redirectType }"/>
        <table class="s_table">
            <tbody>
                <tr>
                	<td class="s_label">产品品类：</td>
                    <td class="w18">
                    	<select name="bizCategory.categoryId" >
                    		<#list selectCategoryList as bizCategory>1
			    				<#if selectCategoryId == bizCategory.categoryId>
			    					<option value="${bizCategory.categoryId}">${bizCategory.categoryName}</option>
			    				</#if>
							</#list>
				        </select>
                    </td>
                    <td class="s_label">产品名称：</td>
                    <td class="w18"><input type="text" name="productName" value="${prodProduct.productName!''}" /></td>
                    <td class="s_label">产品ID：</td>
                    <td class="w18"><input type="text" name="productId" value="${prodProduct.productId!''}" number="true" ></td>
					<td>&nbsp;</td>
                <tr>
                   <td class="s_label">行政区域：</td>
					<td class="w18">
						<input type="text" class="searchInput" name="bizDistrictName" id="bizDistrictName" value="<#if prodProduct.bizDistrict??>${prodProduct.bizDistrict.districtName!''}</#if>" />
						<input type="hidden" name="bizDistrictId" id="bizDistrictId" value="<#if prodProduct.bizDistrict??>${prodProduct.bizDistrict.bizDistrictId!''}</#if>" />
					</td>
					
					<td class="s_label">规格名称：</td>
                    <td class="w18"><input type="text" name="branchName"  value="${branchName!''}" /></td>
                    <td class="s_label">规格ID：</td>
                    <td class="w18"><input type="text" name="productBranchId" number="true" value="${productBranchId!''}" /></td>
					 <td class=" operate mt10">
                   		<a class="btn btn_cc1" id="search_button">查询</a>
                    </td>  
                </tr>
                <tr>
                <td class="s_label">供应商名称：</td>
	              <td class="w18">
	              <input  type="text" id="supplierName" name="suppSupplier.supplierName" value="<#if prodProduct.suppSupplier??> ${prodProduct.suppSupplier.supplierName!''}</#if>">
                  <input type="hidden"  name="suppSupplier.supplierId" id="supplierId" value="<#if prodProduct.suppSupplier??>${prodProduct.suppSupplier.supplierId!''}</#if>">
	             </td>
	             <#if subCategoryId?? && subCategoryId=='181'>
                	<td class="s_label">商品名称：</td>
                    <td class="w18"><input type="text" name="suppGoods.goodsName" value="<#if prodProduct.suppGoods??>${prodProduct.suppGoods.goodsName!''}</#if>"></td>
                    <td class="s_label">商品ID：</td>
                    <td class="w18"><input type="text" name="suppGoods.suppGoodsId" value="<#if prodProduct.suppGoods??>${prodProduct.suppGoods.suppGoodsId!''}</#if>" number="true" ></td>
                 </#if>
				</tr>
                <tr>
                <#if subCategoryId?? && subCategoryId=='${HOTEL_SCENIC_CATEGORY_VALUE}'>
                    <td class="s_label">商品可售状态：</td>
                    <td class="w18">
                        <select name="goodsValidStatus">
                            <option value="all" <#if goodsValidStatus == 'all'>selected="selected"</#if> >全部商品</option>
                            <option value="hasValidGoods" <#if goodsValidStatus == 'hasValidGoods'>selected="selected"</#if> >可售商品</option>
                        </select>
                    </td>
                </#if>
                </tr>
            </tbody>
        </table>	
		</form>
	</div>
<!-- 主要内容显示区域\\ -->
    <#if pageParam??>
    <#if pageParam.items?? &&  pageParam.items?size &gt; 0>
    <div class="p_box box_info">
    <table class="s_table">
        <tbody>
			<tr style="width:100%;">
		        <td><input type="checkbox" name="" id="selectAllItems" />全选/全不选</td>
			</tr>
		</tbody>
    </table>  
    <table class="p_table table_center">
                <thead>
                    <th>选择</th>
                	<th width="80px">品类</th>
                    <th>产品ID</th>
                    <th>产品名称</th>
                    <#if subCategoryId?? && subCategoryId=='181'>
                    <th>规格ID</th>
                    </#if>
                    <th >规格</th>
	             	<#if subCategoryId?? && subCategoryId=='181'>
                    <th class="goodsTd">商品</th>
                    </#if>
                    </tr>
                </thead> 
                <tbody>
					<#list pageParam.items as productBranch> 
					<tr>
					<td>
                    	<#if subCategoryId?? && subCategoryId=='181'>
							<input type="checkbox" <#if productBranch.suppGoodsList?? && productBranch.suppGoodsList?size gt 0> class="ckbBranch" name="branchIds" value="${productBranch.productBranchId!''}" supplierId="${productBranch.supplierId!''}"<#else>disabled="disabled"</#if> />
						<#else>
							<input type="checkbox" name="branchIds" value="${productBranch.productBranchId!''}" />
						</#if>
					</td>
					<td>${productBranch.categoryName!''}</td>
					<td>${productBranch.productId!''} </td>
					<td class="productName">
						<a style="cursor:pointer" 
							onclick="openProduct(${productBranch.productId!''},${productBranch.categoryId!''},'${productBranch.categoryName!''}')">
							${productBranch.productName!''}
						</a>
					 </td>
					<#if subCategoryId?? && subCategoryId=='181'>
					<td>${productBranch.productBranchId!''}</td>
					</#if>
					<td class="productName">${productBranch.branchName!''}</td>
					<#if subCategoryId?? && subCategoryId=='181'>
					<td>
						<#if productBranch.suppGoodsList?? && productBranch.suppGoodsList?size gt 0>
						<table class="goodsTable" border="0" cellpadding="0" cellspacing="0">
						<#list productBranch.suppGoodsList as goods> 
							<tr name="supplierId_${goods.supplierId}_${productBranch.productBranchId!''}">
								<td >${goods.supplierName!''}：</td>
							</tr>
							<tr>
								<td>&nbsp;<input type="checkbox" name="pb_${productBranch.productBranchId!''}" productBranchId="${productBranch.productBranchId!''}" supplierId="${goods.supplierId}" value="${goods.suppGoodsId}" />
									${goods.goodsName!''}&nbsp;${goods.suppGoodsId}&nbsp;
									<#if isDestinationBU?? && isDestinationBU=='Y'>
										<font color="#FF0000"><#if goods.aperiodicFlag?? && goods.aperiodicFlag=='Y'>期票<#else>普通票</#if></font>
									</#if>
								</td>
							</tr>
						</#list>
						</table>
						<#else>
							<span style="color:red;">无可售商品</span>
						</#if>
					</td>
					</#if>
					</tr>
					</#list>
                </tbody>
            </table>
				<#if pageParam.items?exists> 
					<div class="paging" > 
					${pageParam.getPagination()}
						</div> 
				</#if>
        
	</div><!-- div p_box -->
	<#else>
		<div class="no_data mt20"><i class="icon-warn32"></i>暂无相关产品，重新输入相关条件查询！</div>
    </#if>
    </#if>
<!-- //主要内容显示区域 -->

 		<div class="p_box box_info clearfix mb20">
            <div class="fl operate"><a class="btn btn_cc1" id="saveDetail">加入打包</a></div>
        </div>
        
</div>
<#include "/base/foot.ftl"/>
</body>
</html>
<script type="text/javascript" src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/product-list.js"></script>
<script type="text/javascript" src="/vst_admin/js/iframe-custom.js"></script>
<script type="text/javascript" src="/vst_admin/js/pandora-dialog.js"></script>
<script type="text/javascript" src="/vst_admin/js/lvmama-dialog.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.validate.expand.js"></script>
<script type="text/javascript" src="/vst_admin/js/messages_zh.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_validate.js"></script>
<script type="text/javascript" src="/vst_admin/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.lvtip.js"></script>
<script type="text/javascript" src="/vst_admin/js/newpanel.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.jsonSuggest-2.min.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_pet_util.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_util.js"></script>
<script type="text/javascript" src="/vst_admin/js/log.js"></script>

<script>
vst_pet_util.commListSuggest("#supplierName", "#supplierId",'/vst_back/supp/supplier/searchSupplierList.do','${suppJsonList}');
vst_pet_util.districtSuggest("#bizDistrictName", "input[name=bizDistrictId]");
vst_pet_util.destListSuggest("#destName", "input[id=destReId]");
$(function(){

	//查询
	$("#search_button").bind("click",function(){
		if(!$("#searchForm").validate().form()){
				return false;
			}
		$("#searchForm").submit();
	});
	
	//修改
	$("a.editProd").bind("click",function(){
		var productId = $(this).attr("data");
		var categoryId = $(this).attr("data1");
		var categoryName = $(this).attr("categoryName");
		window.open("/vst_admin/prod/baseProduct/toUpdateProduct.do?productId="+productId+"&categoryId="+categoryId+"&categoryName="+categoryName);
		return false;
	});
	
	$("#saveDetail").bind("click",function(){
		var branchIds = "",suppGoodsIds = "";
		var subCategoryId = $("#subCategoryId").val();
		$('input[name="branchIds"]:checked').each(function(){
			branchIds += $(this).val() + ",";
			if (subCategoryId == 181) {
				var goodsIds = "";
				$("input[name='pb_"+$(this).val()+"']:checked").each(function(){
					goodsIds += $(this).val() + ",";
				});
				suppGoodsIds += goodsIds.substring(0,goodsIds.length - 1)+";";
			}
		});
		if(branchIds == null || branchIds.length == 0){
			$.alert("请选择产品....");
			return;
		}
		if(branchIds != null){
			branchIds = branchIds.substring(0,branchIds.length - 1);
			if (subCategoryId == 181) {
				suppGoodsIds = suppGoodsIds.substring(0,suppGoodsIds.length - 1);
			}
			var groupId = $("#groupId").val();
			var groupType = $("#groupType").val();
			var selectCategoryId = $("#selectCategoryId").val();
			var postData = "groupId=" + groupId + "&groupType=" + groupType + "&branchIds=" + branchIds+ "&selectCategoryId=" + selectCategoryId+"&suppGoodsIds="+suppGoodsIds;
			var loading = top.pandora.loading("正在努力保存中...");
			$.ajax({
				url : "/vst_admin/productPack/line/addGroupDetail.do",
				type : "post",
				dataType : 'json',
				data : postData,
				success : function(result) {
					loading.close();
					if(result.code == "success"){
						var packGroupDetail = {};
						packGroupDetail.groupId = result.attributes.groupId;
						packGroupDetail.groupType = result.attributes.groupType;
						packGroupDetail.selectCategoryId = result.attributes.selectCategoryId;
						packGroupDetail.detailIds = result.attributes.detailIds;
						parent.onSavePackGroupDetail(packGroupDetail);
					}
					if(result.code == "error"){
						//$.alert(result.message);
						top.pandora.alert(result.message);
					}
				},
				error : function(result) {
					loading.close();
					$.alert(result.message);
				}
			});
		}
	});
	
	//董宁波2016年9月6日10:09:30
	//级联操作
	$(".ckbBranch").change(function(e){
		var productBranchId = $(this)[0].value;
		var checked = $(this)[0].checked;
		checkedSuppGoods(productBranchId, checked);
	});
	//响应列头的checkbox，选中/取消 商品选择
	function checkedSuppGoods(productBranchId, checked) {
		if (checked) {
			$("input[name='pb_"+productBranchId+"']").attr("checked","checked");
		} else {
			$("input[name='pb_"+productBranchId+"']").removeAttr("checked");
		}
	}
	//级联操作
	$("input[name^='pb_']").bind("click",function(){
		var productBranchId = $($(this)[0]).attr("productBranchId");
		var checked = $("input[name^='pb_"+productBranchId+"']:checked").length;
		if (checked > 0) {
			$("input[value='"+productBranchId+"']").attr("checked","checked");
		} else {
			$("input[value='"+productBranchId+"']").removeAttr("checked");
		}
	});
	//end
	
	//全选/全不选
	$("#selectAllItems").click(function(){
		var allItem = $("input[name='branchIds']");
		if($(this).attr("checked")) {
			allItem.each(function(index, dom){
				checkedSuppGoods(dom.value, true);
				$(dom).attr("checked", true);
			});
		} else {
			allItem.each(function(index, dom){
				checkedSuppGoods(dom.value, false);
				$(dom).attr("checked", false);
			});
		}
	});
	//将相同供应商的商品合并
	mergerSupplier();
});
	//将相同供应商的商品合并
	function mergerSupplier() {
		$("tr[name^='supplierId_']").each(function(index, dom){
			var supplierAry = $("tr[name='"+dom.attributes.name.value+"']");
			var len = supplierAry.length;
			if(len==1){		//只有一个
				return true;
			} 
			//多个供应商
			for (var i=1;i<len;i++) {
				//将第二次出现的供应商下的商品，移动到同一个供应商下
				$(supplierAry[i]).next().insertAfter($(supplierAry[0]).next()).children();
				//删除多余供应商
				$(supplierAry[i]).remove();
			}
		});
	}

	function openProduct(productId, categoryId, categoryName){
		window.open("/vst_admin/prod/baseProduct/toUpdateProduct.do?productId="+productId+"&categoryId="+categoryId+"&categoryName="+categoryName);
	}
	
</script>
