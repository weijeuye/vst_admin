<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
</head>
<body>

<#--页眉-->
<!--<#import "/base/spring.ftl" as spring/>
<#import "/base/pagination.ftl" as pagination>
--> 
<#--页面导航-->
<div class="p_box box_info">
	<form method="post" action='/vst_admin/front/destAdvertising/findProductList.do' id="searchForm">
    	<table class="s_table">
        <tbody>
            <tr>
                 <td class="s_label">品类:</td>
                 <td>
                 	<select id="categoryIds" name ="categoryIds">
                 		<option value ="${allcategoryIds}">请选择</option>
	                    <#if categoryIds?? >
	                    	<#list allcategoryIds?split(",") as s>
	                     	<#list bizCategoryList as bizCategory>
	                     		<#if s == bizCategory.categoryId >
	                     	 	<option <#if categoryIds == s>selected ='selected'</#if> value=${s}>${bizCategory.categoryName!''}</option>
	                     		</#if>
	                    	</#list>
	                    </#list>
	                    </#if>
	                    <#if showTab?? && showTab == "GROUP" >
                        	<option value = "NS-66" <#if selectedCategoryId?? && selectedCategoryId ='NS-66'>selected ='selected'</#if> >NS-代售跟团游</option>
						</#if>
						<#if showTab?? && showTab == "GROUP" >
                        	<option value = "NS-60" <#if selectedCategoryId?? && selectedCategoryId ='NS-60'>selected ='selected'</#if> >NS-跟团游</option>
						</#if>
						 <#if showTab?? && showTab == "FREETOUR" >
                        	<option value = "NS-65" <#if selectedCategoryId?? && selectedCategoryId ='NS-65'>selected ='selected'</#if> >NS-代售自由行</option>
						</#if>
						<#if showTab?? && showTab == "FREETOUR" >
                        	<option value = "NS-22" <#if selectedCategoryId?? && selectedCategoryId ='NS-22'>selected ='selected'</#if> >NS-自由行</option>
						</#if>
						<#if showTab?? && showTab == "LOCAL" >
                        	<option value = "NS-67" <#if selectedCategoryId?? && selectedCategoryId ='NS-67'>selected ='selected'</#if> >NS-当地游</option>
						</#if>
						<#if showTab?? && showTab == "ALL" >
                        	<option value = "NS-60" <#if selectedCategoryId?? && selectedCategoryId ='NS-60'>selected ='selected'</#if> >NS-跟团游</option>
                        	<option value = "NS-66" <#if selectedCategoryId?? && selectedCategoryId ='NS-66'>selected ='selected'</#if> >NS-代售跟团游</option>
                        	<option value = "NS-22" <#if selectedCategoryId?? && selectedCategoryId ='NS-22'>selected ='selected'</#if> >NS-自由行</option>
                        	<option value = "NS-65" <#if selectedCategoryId?? && selectedCategoryId ='NS-65'>selected ='selected'</#if> >NS-代售自由行</option>
                        	<option value = "NS-67" <#if selectedCategoryId?? && selectedCategoryId ='NS-67'>selected ='selected'</#if> >NS-当地游</option>
						</#if>
                 	</select>
					<select name ="subIds" style="<#if categoryIds != 18>display: none;</#if>" id="childrenIds">
                 		<option value="">请选择</option>
                   		<#if bizFreedomList?? >
	                    	<#list bizFreedomList as bizCategory>
	                    	 	<option <#if bizCategory.categoryId == subIds>selected ='selected'</#if> value=${bizCategory.categoryId}>${bizCategory.categoryName!''}</option>
	                    	</#list>
                   	 	</#if>
                 	</select>
				</td>
			</tr>
			<tr>
                <td class="s_label">产品ID：</td>
                <td class="w18"><input type="text" name="productId" value="${productId!''}" number="true" ></td>
                <td class="s_label">产品名称：</td>
                <td class="w18"><input type="text" name="productName" value="${productName!''}"></td>
                <td class=" operate mt10">
               		<a class="btn btn_cc1" id="search_button">查询</a> 
                </td>
               <input type="hidden" name="page" value="${page}">
               <input type="hidden" name="allcategoryIds" value="${allcategoryIds}">
               <input type='hidden' id='subIdsHide' value='${subIds}'/>
                <input type="hidden" name="showTab" value="${showTab!''}" id="showTab">
            </tr>
        </tbody>
    </table>	
	</form>
</div>

<div class="iframe-content">   
    <div class="p_box">
	<table class="p_table table_center">
        <thead>
            <tr>
            <th>选择</th>
           	<#if categoryIds=="4"><th>规格编号</th><#else><th>产品编号</th></#if>
           	<#if categoryIds=="4"><th>规格名称</th><#else><th>产品名称</th></#if>
            <th>产品状态</th>
            <th>是否可售</th>
            </tr>
        </thead>
        <tbody>
        	  <#if pageParam?? && pageParam.items?? && pageParam.items?size &gt; 0>
                    <#list pageParam.items  as prod>
                    	<#if prod.bizCategoryId =='4'>
							<#list prod.prodProductBranchList as prodBranch>
	                    		<tr>
				            	   <td class="w10">
				            	   	<input type="radio"  name="productBranchId"  cancelFlag=${prodBranch.cancelFlag}  saleFlag=${prodBranch.saleFlag}   value="${prodBranch.productBranchId!''}"/>
				            	   	<input type="hidden" name="productNameHide" value="${prod.productName!''}"/>
									<input type="hidden" name="productIdHide" value="${prod.productId!''}"/>
									<input type="hidden" name="productBanchIdHide" value="${prodBranch.productBranchId!''}"/>
									<input type="hidden" name="branchName" value="${prodBranch.branchName!''}"/>
									<input type="hidden" id = "categoryIdHide" name="categoryIdHide" value="${prod.bizCategoryId!''}"/>
									<input type="hidden" id = "subCategoryIdHide" name="subCategoryIdHide" value="${prod.subCategoryId!''}"/>
									<#if prod.bizDistrict??>
									<input type="hidden" name="prod.bizDistrict.districtName" value="${prod.bizDistrict.districtName!''}">
									<input type="hidden" name="prod.muiltDpartureFlag" value="${prod.muiltDpartureFlag!''}">
		                        	</#if>
				            	   </td>
				                   <td class="w10 text_left">${prodBranch.productBranchId}</td>
				                   <td class="text_left">${prodBranch.branchName}</td>
				                   <td>
									  <#if prodBranch.cancelFlag == "Y"> 
									  <span style="color:green" class="cancelProd">有效</span>
									  <#else>
									  <span style="color:red" class="cancelProd">无效</span>
									  </#if>
								    </td>
									<td><#if prodBranch.saleFlag =="Y">是<#else>否</#if></td>
								</tr>
	                    	</#list>
                    	<#else>
		                    <tr>
		                        <td class="w10">
		                        	<input type="radio" name="productId"  cancelFlag=${prod.cancelFlag} saleFlag=${prod.saleFlag}    value="${prod.productId!''}"/>
		                        	<input type="hidden" name="productNameHide" value="${prod.productName!''}"/>
									<input type="hidden" name="productIdHide" value="${prod.productId!''}"/>
									<input type="hidden" id = "categoryIdHide" name="categoryIdHide" value="${prod.bizCategoryId!''}"/>
									<input type="hidden" id = "subCategoryIdHide" name="subCategoryIdHide" value="${prod.subCategoryId!''}"/>
									<input type="hidden" id = "productType" name="productType" value="${prod.productType!''}"/>
                                    <input type="hidden" id = "saleFlag" name="saleFlag" value="${prod.saleFlag!''}"/>
                                    <input type="hidden" id = "bizCategoryName" name="bizCategoryName" value="${prod.categoryName!''}"/>
									<#if prod.bizDistrict??>
									<input type="hidden" name="prod.bizDistrict.districtName" value="${prod.bizDistrict.districtName!''}">
									<input type="hidden" name="prod.muiltDpartureFlag" value="${prod.muiltDpartureFlag!''}">
		                        	</#if>
		                        </td>
								<td class="w10 text_left">${prod.productId}</td>
		                        <td class="text_left">${prod.productName}</td>
		                        <td>
									<#if prod.cancelFlag == "Y"> 
									<span style="color:green" class="cancelProd">有效</span>
									<#else>
									<span style="color:red" class="cancelProd">无效</span>
									</#if>
								</td>
								<td><#if prod.saleFlag =="Y">是<#else>否</#if></td>
		                    </tr>
	                    </#if>
                  </#list>
            <#else>
			<tr class="table_nav"><td colspan="4"><div class="no_data mt20"><i class="icon-warn32"></i>暂无相关产品，重新输入相关条件查询！</div></td>	</tr>
		    </#if>
      </tbody>
   </table>
     <table class="co_table">
        <tbody>
            <tr>
                 <td class="s_label">
                 	<#if pageParam.items?exists> 
						<div class="paging" > 
						${pageParam.getPagination()}
						</div> 
					</#if>
                 </td>
            </tr>
        </tbody>
    </table>	
	</div><!--p_box-->
	
</div><!-- //主要内容显示区域 -->

<#include "/base/foot.ftl"/>
</body>
</html>

<script>
var newProds = window.parent.prods;
var newProd;
if(typeof(newProds) != "undefined"){
	var newProd = newProds.split(',');
}

//排除所有已有的产品
$("input[type='radio']").each(function(){
    if (typeof(newProds) != "undefined" && newProds.length > 0){
	   if($.inArray($(this).val(), newProd)>-1)
	   {
	       //$(this).attr("checked",true);
	   } 
	}
});

//查询
$("#search_button").bind("click",function(){
    if(!$("#searchForm").validate().form()){
		return;
	}
	var allcategoryIds =  parent.getcategoryIds();
	$("#searchForm").submit();
});

$("input[type='radio']").bind("click",function(){
	var obj = $(this).parent("td");
	var prod = {};
	if($(this).attr('cancelFlag') != 'Y' || $(this).attr('saleFlag')!='Y'){
		alert("产品状态或可售状态必须为有效");
		return;
	}
	prod.productId = $("input[name='productIdHide']",obj).val();
    prod.productName = $("input[name='productNameHide']",obj).val();
    prod.districtName = $("input[name='prod.bizDistrict.districtName']",obj).val();
    prod.muiltDpartureFlag = $("input[name='prod.muiltDpartureFlag']",obj).val();
    prod.bizCategoryId = $("input[name='categoryIdHide']",obj).val();
    prod.bizSubCategoryId = $("input[name='subCategoryIdHide']",obj).val();
    prod.bizCategoryName=$("input[name='bizCategoryName']",obj).val();
    prod.productBranchId = $("input[name='productBanchIdHide']",obj).val();
    prod.branchName = $("input[name='branchName']",obj).val();
    prod.productType= $("input[name='productType']",obj).val();
    prod.saleFlag= $("input[name='saleFlag']",obj).val();
	parent.onSelectProd(prod);
});

//为下拉框绑定事件，选择自由行时，显示酒+景下拉
$("#categoryIds").bind("change", function(){
	var item = $(this);
	//选择自由行时
	if (item[0].value == 18) {
		$("#childrenIds").show();
	} else {
		$("#childrenIds").hide();
		$("#childrenIds").val("");
	}
});
</script>
