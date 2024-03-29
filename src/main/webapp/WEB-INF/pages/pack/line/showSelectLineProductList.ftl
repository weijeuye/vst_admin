<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
</head>
<body style="min-height:950px;">
<div class="iframe_content">
    <div class="p_box box_info">
	<form method="post" action='/vst_admin/productPack/line/showSelectProductList.do' id="searchForm">
		<input type="hidden" id="groupId" name="groupId" value="${groupId }"/>
		<input type="hidden" id="groupType" name="groupType" value="LINE"/>
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
                    <td class="w18"><input type="text" name="productName" ></td>
                    <td class="s_label">产品ID：</td>
                    <td class="w18"><input type="text" name="productId" number="true" ></td>
                </tr>
                <tr>
                   <td class="s_label">出发地：</td>
					<td class="w18">
						<input type="text" class="searchInput" name="bizDistrictName" id="bizDistrictName" />
						<input type="hidden" name="bizDistrictId" id="bizDistrictId"/>
					</td>
					<td class=" operate mt10">目的地：</td>
					<td class="w18">
						<input type="text"   class="searchInput" name="destName" id="destName"/>
						<input type="hidden" name="prodDestRe.destId" id="destReId"/>
					</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
                </tr>
               	<tr>
               		<td class="s_label">行程天数：</td>
                    <td class="w18">
                    	<input type="text" name="prodLineRoute.routeNum" id="routeNum" value='${prodPackageGroupLine.travelDays}' readonly="readonly"/> 
					</td>
                    <td class=" operate mt10">入住晚数：</td>
                    <td class="w18"><input type="text" name="prodLineRoute.stayNum" id="stayNum" value='${prodPackageGroupLine.stayDays}' readonly="readonly"/></td>
					 <td class=" operate mt10">
					<#if !hotelCombFlag>
                   		<a class="btn btn_cc1" id="search_button">查询</a> 
                   	</#if>
                    </td>
               	</tr>
               	<#if hotelCombFlag ?? && hotelCombFlag >
               		<tr>
	               		<td class="s_label">成人数：</td>
	                    <td class="w18">
	                    	<input type="text"  id="adult" value='${prodPackageGroupLine.adult}' readonly="readonly"/> 
						</td>
	                    <td class=" operate mt10">儿童数：</td>
	                    <td class="w18"><input type="text"  id="child" value='${prodPackageGroupLine.child}' readonly="readonly"/></td>
	                    <td class=" operate mt10">
	                   	<a class="btn btn_cc1" id="search_button">查询</a> 
	                    </td> 	
	               	</tr>
               	</#if>
                
            </tbody>
        </table>	
		</form>
	</div>
<!-- 主要内容显示区域\\ -->
    <#if pageParam??>
    <#if pageParam.items?? &&  pageParam.items?size &gt; 0>
    <div class="p_box box_info">
    <#if selectCategoryId==16 || selectCategoryId==17>
		<table class="s_table">
	        <tbody>
				<tr style="width:100%;">
			        <td><input type="checkbox" name="" id="selectAllItems" />全选/全不选</td>
				</tr>
			</tbody>
	    </table>    
    </#if>
    <table class="p_table table_center">
                <thead>
                    <th>选择</th>
                	<th width="80px">品类</th>
                    <th>产品ID</th>
                    <th>产品名称</th>
                    <th>行政区划</th>
                    <th >规格</th>
                    </tr>
                </thead>
                <tbody>
					<#list pageParam.items as productBranch> 
					<tr>
					<td><input 
					type="${inputType }" 
					
					name="branchIds" value="${productBranch.productBranchId!''}"/></td>
					<td>${productBranch.categoryName!''}</td>
					<td>${productBranch.productId!''} </td>
					<td>
						<a style="cursor:pointer" 
							onclick="openProduct(${productBranch.productId!''},${productBranch.categoryId!''},'${productBranch.categoryName!''}')">
							${productBranch.productName!''}
						</a>
					</td>
					<td>${productBranch.districtName!''}</td>
					<td>${productBranch.branchName!''}</td>
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
<script>
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
		var branchIds = "";
		$('input[name="branchIds"]:checked').each(function(){
			branchIds += $(this).val() + ",";
		});
		
		if(branchIds == null || branchIds.length == 0){
			$.alert("请选择产品....");
			return;
		}
		
		if(branchIds != null){
			branchIds = branchIds.substring(0,branchIds.length - 1);
			var groupId = $("#groupId").val();
			var groupType = $("#groupType").val();
			var selectCategoryId = $("#selectCategoryId").val();
			var postData = "groupId=" + groupId + "&groupType=" + groupType + "&branchIds=" + branchIds+ "&selectCategoryId=" + selectCategoryId;
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
						$.alert(result.message);
					}
				},
				error : function(result) {
					loading.close();
					$.alert(result.message);
				}
			});
		}
	});
});
		//全选/全不选
		$("#selectAllItems").click(function(){
			var allItem = $("input[name='branchIds']");
			if($(this).attr("checked")) {
				allItem.each(function(index, dom){
					$(dom).attr("checked", true);
				});
			} else {
				allItem.each(function(index, dom){
					$(dom).attr("checked", false);
				});
			}
		});

function openProduct(productId, categoryId, categoryName){
	window.open("/vst_admin/prod/baseProduct/toUpdateProduct.do?productId="+productId+"&categoryId="+categoryId+"&categoryName="+categoryName);
}
	
</script>
