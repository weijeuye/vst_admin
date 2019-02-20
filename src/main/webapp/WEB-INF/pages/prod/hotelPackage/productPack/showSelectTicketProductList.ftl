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
		<input type="hidden" id="selectCategoryId" name="selectCategoryId" value="${selectCategoryId!'' }"/>
		<input type="hidden" id="redirectType" name="redirectType" value="${redirectType!''}"/>
		<input type="hidden" id="isSelectFlag" name="isSelectFlag" value="${isSelectFlag!''}"/>
        <table class="s_table">
            <tbody>
                   <tr>
                    <td class="s_label">门票名称：</td>
                    <td class="w18"><input id="productName" maxlength=100 type="text" name="prodProduct.productName" value="${productName!''}"></td>
                    <td class="s_label">门票ID：</td>
                    <td class="w18"><input id="productId" type="text" name="prodProduct.productId" value="${productId!''}" number="true" ></td>
					<td class="s_label">目的地：</td>
                    	<td class="w18">
						<input type="text" class="searchInput" name="bizDest.destName" value="${destName!''}" id="destName" />
						<input type="hidden"  name="bizDest.destId" id="destId" value="${destId!''}"/>
					</td>
                </tr>
                <tr>
                 <td>&nbsp;</td>
                 <td>&nbsp;</td>
                <td class="s_label">规格ID：</td>
                    <td class="w18"><input id="productBranchId" type="text" name="prodProductBranch.productBranchId" value="${productBranchId!''}" number="true" ></td>
                    <td class="s_label">商品ID：</td>
                    <td class="w18"><input id="pSuppGoodsId" type="text" name="suppGoods.suppGoodsId" value="${pSuppGoodsId!''}" number="true" ></td>
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
        <br/>
    
		</form>
		<div class="check_wrap" <#if isSelectFlag != '1'>style="display:none;"</#if> >
        <div class="title">已选商品:</div>
        <div class="check_container">
        <ul></ul>
        </div>
    	</div>
		<li id="label_mini_templete"  data-id="" data-name="" title="" style="display:none;"><span></span><a  href="javascript:;">×</a></li>
	</div>
	
	
<!-- 主要内容显示区域\\ -->
    <#if pageParam??>
    <#if pageParam.items?? &&  pageParam.items?size &gt; 0>
    <div class="p_box box_info">
    <table class="p_table table_center">
                <thead>
                    <th>选择</th>
                    <th>门票ID</th>
                    <th>门票名称</th>
                    <th>目的地名称</th>
                    <th >规格ID</th>
                    <th >规格名称</th>
                    <th>商品ID</th>
                    <th>商品名称</th>
                    <th>操作</th>
                    </tr>
                </thead>
                <tbody>
					<#list pageParam.items as productBranch> 
					<tr>
					<td><input type="checkbox" name="checkOjectId" value="${productBranch.objectId!''}"/></td>
					<td>${productBranch.prodProduct.productId!''} </td>
					<td style="text-align:left;">
						<a style="cursor:pointer"
							title="${productBranch.prodProduct.productName}" 
							onclick="openProduct(${productBranch.prodProduct.productId!''},${productBranch.bizCategory.categoryId!''},'${productBranch.bizCategory.categoryName!''}')">
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
					 <#if productBranch.bizDest??>
					 	<td title="${productBranch.bizDest.destName!''}"  style="text-align:left;">
							<#assign length = productBranch.bizDest.destName?length>
							<#assign names = productBranch.bizDest.destName>
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
					 <td title="" style="text-align:left;">
					 </#if>
					</td>
					<td>${productBranch.prodProductBranch.productBranchId}</td>
					<td title="${productBranch.prodProductBranch.branchName}"  style="text-align:left;">
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
					<td>${productBranch.suppGoods.suppGoodsId}</td>
					<td title="${productBranch.suppGoods.goodsName}" class="objectName" style="text-align:left;" >
					<#assign length = productBranch.suppGoods.goodsName?length>
							<#assign names = productBranch.suppGoods.goodsName>
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
					<a id="showSuppGoodsDescInitINfo" style="cursor:pointer" onclick="showSuppGoodsDescInitINfo(${productBranch.suppGoods.suppGoodsId})">查看商品</a>
					<a class="addSuppGoods" 
					productId ="${productBranch.prodProduct.productId}" 
					supplierId="${productBranch.supplier.supplierId}" 
					categoryId = "${productBranch.bizCategory.categoryId}" 
					supplierName ="${productBranch.supplier.supplierName}"
					categoryName = "${productBranch.bizCategory.categoryName}"
					  style="cursor:pointer" >添加商品</a>
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
		<div class="no_data mt20"><i class="icon-warn32"></i>您要的景点未找到，可能当前产品不能满足打包条件，或者不存在此产品，您可以在VST->产品管理->标准产品管理中新增一个景点门票</div>
    </#if>
    </#if>

        
</div>
<#include "/base/foot.ftl"/>
</body>
</html>
<script>


var parms={};
var objectIds= new Array();
var  isSelectFlag;
vst_pet_util.destListSuggest("#destName", "#destId");
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
    

//查询
$("#search_button").bind("click",function() {
    if (!$("#searchForm").validate().form()) {
        return false;
    }
    if($("#productName").val() == "" && $("#productId").val()=="" && $("#destName").val()=="" && $("#productBranchId").val()=="" && $("#pSuppGoodsId").val()==""){
    	$.alert("查询条件不能全为空，请填入任意一个查询条件再查询!")
    	return false;
    }
    saveObjectInfo();
    $("#redirectType").val("1");
    $("#searchForm").submit();

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


//添加门票商品
$(".addSuppGoods").bind("click",function(){

var productId = $(this).attr("productId");
var categoryId =  $(this).attr("categoryId");
var categoryName = $(this).attr("categoryName"); 
var supplierId = $(this).attr("supplierId");
var supplierName = $(this).attr("supplierName");
var code = "";
if(categoryId=='11'){

code = "singleTicket";

}else if(categoryId=='12'){

code = "otherTicket";

}else if(categoryId=='13'){

code = "combTicket";


}
window.open("/scenic_back/"+code+"/prod/product/showProductMaintain.do?productId="+productId+"&categoryId="+categoryId+"&categoryName="+categoryName+"&hotelCommbGotoPackegGoodPage="+'Y'+"&dataId="+supplierId+"&dataName="+supplierName);


});

//查看商品描述
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



//打开产品基本信息页面
function openProduct(productId, categoryId, categoryName){

	window.open("/vst_admin/prod/baseProduct/toUpdateProduct.do?productId="+productId+"&categoryId="+categoryId+"&categoryName="+categoryName);
}


	
</script>
