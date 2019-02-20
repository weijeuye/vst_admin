<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
<link rel="stylesheet"  href="/vst_admin/css/hotelCommbPackageSelect.css" type="text/css"/>
</head>
<body style="min-height:950px;">
<div class="iframe_content">
    <div class="p_box box_info">
	<form method="post" action='/vst_admin/hotelCommbPackage/productPack/showSelectProductList.do' id="searchForm">
		<input type="hidden" id="suppGoodsId" name="suppGoodsId" value="${suppGoodsId!''}"/>
		<input type="hidden" id="groupId" name="groupId" value="${groupId!''}"/>
		<input type="hidden" id="selectCategoryId" name="selectCategoryId" value="${selectCategoryId!''}"/>
		<input type="hidden" id="redirectType" name="redirectType" value="${redirectType!''}"/>
		<input type="hidden" id="isSelectFlag" name="isSelectFlag" value="${isSelectFlag!''}"/>
        <table class="s_table">
            <tbody>
                <tr>
                    <td class="s_label">酒店名称：</td>
                    <td class="w18"><input id="productName" type="text" name="prodProduct.productName" value="${productName!''}"></td>
                    <td class="s_label">酒店ID：</td>
                    <td class="w18"><input id="productId" type="text" name="prodProduct.productId" value="${productId!''}" number="true" ></td>
					<td class="s_label">行政区划：</td>
                    	<td class="w18">
						<input type="text" class="searchInput" name="bizDistrict.districtName" value="${districtName!''}" id="bizDistrictName" />
						<input type="hidden" name="bizDistrict.districtId"  value="${districtId!''}" id="districtId"/>
					</td>
                </tr>
                <tr>
                <td>&nbsp;</td>
                 <td>&nbsp;</td>
                <td class="s_label">规格ID：</td>
                    <td class="w18"><input id="productBranchId" type="text" name="prodProductBranch.productBranchId" value="${productBranchId!''}" number="true" ></td>
                </tr>
                </tr>
                <tr>
                	<td class=" operate mt10">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td class=" operate mt10">
                   	<a class="btn btn_cc1" id="search_button">查询</a>
                    </td>
                     <td class=" operate mt10">&nbsp;</td>
                    <td class=" operate mt10">
                   	<a class="btn btn_cc1" id="saveDetail">确认</a>
                    </td>
                </tr>
                
            </tbody>
        </table>	
		</form>
		<div class="check_wrap" <#if isSelectFlag != '1'>style="display:none;"</#if> >
        <div class="title">已选规格:</div>
        <div class="check_container">
        <ul></ul>
        </div>
    	</div>
		<li id="label_mini_templete"  data-id="" data-name="" title="" style="display:none;"><span></span><a  href="javascript:;">×</a></li>
	</div>
<!-- 主要内容显示区域\\ -->
    <#if pageParam??>
    <#if pageParam.items?? &&  pageParam.items?size &gt; 0>
    <div class="p_box box_info" style="min-height:400px;">
    <table class="p_table table_center">
                <thead>
                    <th>选择</th>
                    <th>产品ID</th>
                    <th>产品名称</th>
                    <th>行政区划</th>
                    <th >规格ID</th>
                    <th >规格名称</th>
                    <th>操作</th>
                    </tr>
                </thead>
                <tbody>
					<#list pageParam.items as productBranch> 
					<tr>
					<td><input type="checkbox" name="checkOjectId" value="${productBranch.objectId!''}"/></td>
					<td>${productBranch.prodProduct.productId!''} </td>
					<td  style="text-align:left;">
						<a style="cursor:pointer"
							title="${productBranch.prodProduct.productName}"  
							onclick="openProduct(${productBranch.prodProduct.productId!''},${productBranch.bizCategory.categoryId!''},'${productBranch.bizCategory.categoryName!''}','${hotelOnlineFlag}')">
							<#assign length = productBranch.prodProduct.productName?length>
							<#assign names = productBranch.prodProduct.productName>
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
						<#if productBranch.bizDistrict??>
							<td title="${productBranch.bizDistrict.districtName}"  style="text-align:left;">
							<#assign length = productBranch.bizDistrict.districtName?length>
							<#assign names = productBranch.bizDistrict.districtName>
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
						<#else>
							<td title=""  style="text-align:left;">						
						</#if>
					</td>
					
					<td>${productBranch.prodProductBranch.productBranchId}</td>
					<td title="${productBranch.prodProductBranch.branchName}" class="objectName" style="text-align:left;">
							<#assign length = productBranch.prodProductBranch.branchName?length>
							<#assign names = productBranch.prodProductBranch.branchName>
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
					<a id="showProdbranchINfo" style="cursor:pointer" onclick="showProdbranchINfo(${productBranch.prodProductBranch.productBranchId},${productBranch.bizBranch.branchId},'${hotelOnlineFlag}')">查看规格</a>
					<a id="addProdbranch" style="cursor:pointer" onclick="addProdbranch(${productBranch.prodProduct.productId},${productBranch.bizCategory.categoryId!''},'${hotelOnlineFlag}')">添加规格</a>
					</td>
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
		<div class="no_data mt20"><i class="icon-warn32"></i>您要的酒店未找到，可能当前产品不能满足打包条件，或者不存在此产品，您可以在VST->产品管理->标准产品管理中新增一个酒店</div>
    </#if>
    </#if>
<!-- //主要内容显示区域 -->
</div>
<#include "/base/foot.ftl"/>
</body>
</html>
<script>
var parms={};
var objectIds= new Array();
var  isSelectFlag;
vst_pet_util.districtSuggest("#bizDistrictName", "input[name=bizDistrictId]");
vst_pet_util.commListSuggest("#productName","#productId","/vst_admin/hotelCommbPackage/productPack/seachProductList.do?groupId="+${groupId}+"&bizCategoryId="+${selectCategoryId});
$(function() {




	//页面每次载入从父窗口中获取已选商品信息
    params = parent.getObj();
    if (params != null && params != undefined) {
        $(".check_container").html(params.pannel);
        objectIds = params.objectIds;
        isSelectFlag = params.isSelectFlag;
        $("#isSelectFlag").val(isSelectFlag);
        if (isSelectFlag) {
            $(".check_wrap").show();
        }
    }
	
	
	//标签列表已选商品或规格对应勾选复选框选中
    $(".check_container li").each(function() {
        
        var objectId = $(this).attr("data-id");

        $("input[name='checkOjectId']").each(function() {

            if (objectId == $(this).val()) {

                $(this).prop("checked", true);
            }

        });
    });
    
    
    
    
    //勾选商品选中和取消分别在标签框中加入或删除
    $("input[name='checkOjectId']").bind("click", function () {
        var $this = $(this);
        var objectName = $this.parents("tr").find(".objectName").attr("title");
		var objectId = $this.val();
        if ($this.is(":checked")) {
        	var hasflg = false;
		if($("#isSelectFlag").val() == ""){
		isSelectFlag = "1";
		}
		
		if(isSelectFlag){
			$(".check_wrap").show();
		}
		$("#isSelectFlag").val(isSelectFlag);
	$(".check_container li").each(function(){
		if($(this).attr("data-id") && $(this).attr("data-id") == objectId ){
		hasflg = true;
	}

	});
		if(hasflg){
			return;
		}
		//获取标签列表模板，复制然后加入商品或规格信息，在标签列表中显示
		var $clone = $("#label_mini_templete").clone();
		$clone.find("span").text(objectName);
		$clone.attr({"data-id":objectId,"data-name":objectName,"title":objectName});
		$(".check_container ul").append($clone);
		$clone.show();
		//过滤已存在的id
		if(jQuery.inArray(objectId,objectIds) == -1){
			objectIds.push(objectId);
		}
		saveObjectInfo();
        } else {
            $(".check_container").find("li[data-id=" + objectId + "]").remove();
            objectIds = $.grep(objectIds, function (num, index) {
    			return  num !== objectId;});
    			saveObjectInfo();
        }
    });
    
    
    //选中商品标签删除时联动取消复选框选中状态	
      $(".check_container li").live("click", function (e) {
        e = e || event;
        var target = e.target || e.srcElement;
        if (target.tagName.toLowerCase() === "a") {
            var id = $(this).attr("data-id");
            var parentId = $(this).attr("data-id");
            $(this).remove();
             objectIds = $.grep(objectIds, function (num, index) {
    		return  num !== parentId;});
    		saveObjectInfo();
			$("input[name='checkOjectId']:checked").each(function(){
				var objectId = $(this).val();
				if(parentId == objectId){
				$(this).prop("checked",false);
			}
		
		});
        }
    });  
    
    
    
	
	

//查询
$("#search_button").bind("click",function() {
    if (!$("#searchForm").validate().form()) {
        return false;
    }
    if($("#productName").val() == "" && $("#productId").val()=="" && $("#bizDistrictName").val()=="" && $("#productBranchId").val()==""){
    	$.alert("查询条件不能全为空，请填入任意一个查询条件再查询!")
    	return false;
    }
    saveObjectInfo();
    $("#redirectType").val("1");
    $("#searchForm").submit();

});

	
	
//修改
$("a.editProd").bind("click",
function() {
    var productId = $(this).attr("data");
    var categoryId = $(this).attr("data1");
    var categoryName = $(this).attr("categoryName");
    window.open("/vst_admin/prod/baseProduct/toUpdateProduct.do?productId=" + productId + "&categoryId=" + categoryId + "&categoryName=" + categoryName);
    return false;
});
	
	
//保存
$("#saveDetail").bind("click",
function() {
	var suppGoodsId = $("#suppGoodsId").val();
	var objectIdStr = objectIds.join(",");
    if (objectIdStr == null || objectIdStr == "") {
        $.alert("请选择产品");
        return;
    }

    if (objectIds != null) {
        var groupId = $("#groupId").val();
        var selectCategoryId = $("#selectCategoryId").val();
        var suppGoodsId = $("#suppGoodsId").val();
        var postData = "groupId=" + groupId + "&selectCategoryId=" + selectCategoryId + "&objectIdStr=" + objectIdStr+"&suppGoodsId="+suppGoodsId;
        $.confirm("确认保存吗 ？",
        function() {
            var loading = top.pandora.loading("正在努力保存中...");
            $.ajax({
                url: "/vst_admin/hotelCommbPackage/productPack/addGroupDetail.do",
                type: "post",
                dataType: 'json',
                data: postData,
                success: function(result) {
                    loading.close();
                    if (result.code == "success") {
                    	$.alert(result.message);
    					parent.onSaveGroupDetail();
                    }else if(result.code == "error"){
                    	$.alert(result.message);
                    }else{
                    	if(result.code){
                    		var objectIds = result.code.split(",");
                    		if(objectIds!=null && objectIds.length >0){
                    			removeExtitstObjectIds(objectIds);
                    		}
                    		
                    	}
                    	$.alert(result.message);
                    }
                    
                },
                error: function(result) {
                    loading.close();
                    $.alert(result.message);
                }
            });
        });
    }
});
});



//在父窗口存放已选择规格或商品信息，用于解决查询和分页点击时刷新页面，丢失数据
function saveObjectInfo() {
	
	//获取已选商品或规格面板，循环遍历里面所有标签，与父窗口保存的对象id对比，排除己存在id
    $(".check_container li").each(function() {
        var objectId = $(this).attr("data-id");
        if (jQuery.inArray(objectId, objectIds) == -1) {
            objectIds.push(objectId);
        }

    });
    //用于存放勾选中的商品的标签进窗口对象，当刷新页面或者翻页也可以取出选中商品标签参数
    parms.pannel = $(".check_container").html();
    //每次提交表单或点击分页链接时保存标签框里面已选的商品或规格id
    parms.objectIds = objectIds;
    //是否已经选择过规格或商品，当第一次点击了复选框选择商品或规格时，状态一直保持下去，会一直显示标签框
    parms.isSelectFlag = $("#isSelectFlag").val();

    parent.setObj(parms);

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

//校验已存在打包规格或商品回调取消对应标签和勾选框
function removeExtitstObjectIds(objectIds){
if(objectIds!=undefined &&objectIds!=null && objectIds!=""&& objectIds.length >0){
		var notExitstIds =[];
	    $(".check_container li").each(function() {
        
        	var objectId = $(this).attr("data-id");
        	
        	if(jQuery.inArray(objectId,objectIds)!= -1){
        		
        		$(this).find("a").trigger("click");
        	
        	}else{
        		notExitstIds.push(objectId);
        	}
        });
        objectIds = notExitstIds;
}
}




//跳转至添加酒店规格页面
function addProdbranch(productId,categoryId,hotelOnlineFlag){
	if(hotelOnlineFlag == 'true'){
		window.open("/lvmm_dest_back/prod/product/showProductMaintain.do?productId="+productId+"&categoryId="+categoryId+"&hotelCommbGotoPackegGoodPage="+'N');
	}else{
		window.open("/vst_admin/prod/product/showProductMaintain.do?productId="+productId+"&categoryId="+categoryId+"&hotelCommbGotoPackegGoodPage="+'N');
	}
}


//打开产品基本信息页面
function openProduct(productId, categoryId, categoryName, hotelOnlineFlag){
	if(hotelOnlineFlag == 'true'){
		window.open("/lvmm_dest_back/prod/baseProduct/toUpdateProduct.do?productId="+productId+"&categoryId="+categoryId+"&categoryName="+categoryName);
	}else{
		window.open("/vst_admin/prod/baseProduct/toUpdateProduct.do?productId="+productId+"&categoryId="+categoryId+"&categoryName="+categoryName);
	}
}


		
</script>
