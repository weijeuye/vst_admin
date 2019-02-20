<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
</head>
<body>
<div class="iframe_header">
        <ul class="iframe_nav">
            <li><a href="#">首页</a> &gt;</li>
            <li><a href="#">产品管理</a> &gt;</li>
            <li class="active">产品列表</li>
        </ul>
</div>
<div class="iframe_content">
	<div class="tiptext tip-warning cc5"><span class="tip-icon tip-icon-warning"></span>友情提示：
    <p class="pl15">1.品类名字后面显示“无效”，表示该品类已经不能做新产品增加。</p>
    <p class="pl15">2. 可售是指，产品有效、规格有效，且规格下属有有效的商品，且该商品在当前时间往后至少有一天有价格库存</p>      
    </div>
    
    <div class="p_box box_info">
	<form method="post" action='/vst_admin/prod/product/findProductAuditList.do' id="searchForm">
        <table class="s_table">
            <tbody>
                <tr>
                    <td class="s_label">产品名称：</td>
                    <td class="w18"><input type="text" name="productName" value="${prodProduct.productName!''}"></td>
                    <td class="s_label">产品ID：</td>
                    <td class="w18"><input type="text" name="productId" value="${prodProduct.productId!''}" number="true" maxLength="11"></td>
					<td class="s_label">行政区划：</td>
                    <td class="w18">
                    <input type="text" name="bizDistrict.districtName" value="<#if prodProduct.bizDistrict??>${prodProduct.bizDistrict.districtName!''}</#if>"></td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                	<td class="s_label">审核状态：</td>
                    <td class="w18">
                    	<select name="auditStatus">
                    		<option value="all">不限</option>
                    		<#list auditTypeList as audit>
                    			<option value="${audit.code}" <#if prodProduct?? && prodProduct.auditStatus==audit.code>selected=selected </#if>  >${audit.cnName}</option>
                    		</#list>
                    	</select>
                    </td>
                 	<td class="s_label">是否可售：</td>
                    <td class="w18">
                            <select name="saleFlag">
                    	 			<option value="">不限</option>
			                    	<option value='Y' <#if prodProduct.saleFlag == 'Y'>selected</#if> >是</option>
			                    	<option value='N' <#if prodProduct.saleFlag == 'N'>selected</#if> >否</option>
			        	</select>
                    </td>
                    <td class="s_label">产品品类：</td>
                    <td class="w18">
                    	 <select id="categoryId" name="bizCategory.categoryId">
                    	 			<option value="">不限</option>
		    				<#list bizCategoryList as bizCategory> 
			                    	<option value=${bizCategory.categoryId!''} <#if prodProduct.bizCategory!=null && prodProduct.bizCategory.categoryId == bizCategory.categoryId>selected</#if> >${bizCategory.categoryName!''}</option>
			                </#list>
			        	</select>
					</td>
                    <td class=" operate mt10">
                    	<select name="subCategoryId" <#if prodProduct.bizCategory==null || prodProduct.bizCategory.categoryId != 18>style = "display:none;"</#if>>
                    	 			<option value="">不限</option>
		    				<#list subCategoryList as bizCategory> 
			                    	<option value=${bizCategory.categoryId!''} <#if prodProduct.subCategoryId == bizCategory.categoryId>selected</#if> >${bizCategory.categoryName!''}</option>
			                </#list>
			        	</select>
					</td>
                    <td class=" operate mt10">
                   	<a class="btn btn_cc1" id="search_button">查询</a> 
                    </td>
                </tr>
                
            </tbody>
        </table>	
		</form>
	</div>
<!-- 主要内容显示区域\\ -->
    <#if pageParam??>
    <#if pageParam.items?? &&  pageParam.items?size &gt; 0>
    <div class="p_box box_info">
    <table class="p_table table_center">
                <thead>
                    <tr>
                	<th width="80px">品类</th>
                    <th>产品ID</th>
                    <th>产品名称</th>
                    <th>产品状态</th>
                    <th>审核状态</th>
                     <th>推荐级别</th>
                    <th>行政区划</th>
                    <th width="350px">操作</th>
                    </tr>
                </thead>
                <tbody>
					<#list pageParam.items as product> 
					<tr>
					<td><#if product.bizCategory ??>${product.bizCategory.categoryName!''}</#if><#if product.bizCategory ?? && product.bizCategory.cancelFlag == 'N'><span class="notnull">[无效]</span></#if></td>
					<td>${product.productId!''} </td>
					<td>${product.productName!''} </td>
					<td>
						<#if product.cancelFlag == "Y"> 
						<span style="color:green" class="cancelProd">有效</span>
						<#else>
						<span style="color:red" class="cancelProd">无效</span>
						</#if>
					</td>
					<td>
						<#list auditTypeList as audit>
                    			 <#if product?? && product.auditStatus==audit.code>${audit.cnName}</#if>
                    	</#list>
                    	</br>
                    	<#if product.senisitiveFlag=='Y'><span style="color:red">(有敏感词)</span></#if>
					</td>
					<td>${product.recommendLevel}</td>
					<td><#if product.bizDistrict??>${product.bizDistrict.districtName!''}</#if></td>
					<td class="oper">
                        	<a href="javascript:void(0);" class="editProd" data="${product.productId}" categoryName="<#if product.bizCategory ??>${product.bizCategory.categoryName!''}</#if>" data1="<#if product.bizCategory ??>${product.bizCategory.categoryId!''}</#if>" data2="${product.modelVersion}" data3="${product.packageType}" data4="${product.productType}" >查看</a>
                            <a href="javascript:void(0);" class="showProd" data1="${product.urlId}" data=${product.productId} categoryId=${product.bizCategory.categoryId} >预览</a>
                        <#if product.auditStatus?? && product.auditStatus=='AUDITTYPE_TO_QA'>
                        		<@mis.checkPerm permCode="3883" >
                                <a href="javascript:void(0);" class="audit" currentAuditType="AUDITTYPE_TO_QA" source="${product.source}" data="${product.productId}" data1="${product.bizCategory.categoryId}">QA审核</a>
                                </@mis.checkPerm>
                        </#if>
                        <#if product.auditStatus?? && product.auditStatus=='AUDITTYPE_TO_BUSINESS'>
                        	<@mis.checkPerm permCode="3884" >
                           	 <a href="javascript:void(0);" class="audit" currentAuditType="AUDITTYPE_TO_BUSINESS" source="${product.source}" data1="${product.bizCategory.categoryId}" data="${product.productId}">商务审核</a>
                           	 </@mis.checkPerm>
                        </#if>
                        	<a href="javascript:void(0);" class="showLogDialog" param='parentId=${product.productId}&parentType=PROD_PRODUCT&sysName=VST'>审核备注</a> 
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
		<div class="no_data mt20"><i class="icon-warn32"></i>暂无相关产品，重新输入相关条件查询！</div>
    </#if>
    </#if>
<!-- //主要内容显示区域 -->
</div>
<#include "/base/foot.ftl"/>
</body>
</html>
<script>
var categorySelectDialog;
var auditDialog;
var currentAuditType;
var productId;
var categoryId;
//查询
$("#search_button").bind("click",function(){
	if(!$("#searchForm").validate().form()){
			return false;
		}
	$(".iframe-content").empty();
	$(".iframe-content").append("<div class='loading mt20'><img src='../../img/loading.gif' width='32' height='32' alt='加载中'> 加载中...</div>");
	$("#searchForm").submit();
});

//显示子品类
$("#categoryId").bind("change", function(){
	var $categoryId = $(this).val();
	if($categoryId==18){
		$("select[name=subCategoryId]").show();
	}else{
		$("select[name=subCategoryId]").hide();
		$("select[name=subCategoryId]").val("");
	}
});

//新建
$("#new_button").bind("click",function(){
	//打开弹出窗口
	categorySelectDialog = new xDialog("/vst_admin/prod/product/showSelectCategory.do",{},{title:"请选择产品的所属品类",width:900,height:600});
	return;
});

//修改
$("a.editProd").bind("click",function(){
	var productId = $(this).attr("data");
	categoryId = $(this).attr("data1");
	var categoryName = $(this).attr("categoryName");
	var modelVersion = $(this).attr("data2");
	var packageType=$(this).attr("data3");
	var productType=$(this).attr("data4");
	if(modelVersion >= 1.0 && ((categoryId != 18 && categoryId != 16 && categoryId!=15) || (categoryId == 15 && packageType != "LVMAMA"))){
		window.open("/vst_admin/prod/baseProduct/toUpdateSupplierProduct.do?productId="+productId+"&categoryId="+categoryId+"&categoryName="+categoryName+"&isView=Y"+"&packageType="+packageType);
	}else{
		if(categoryId == 15 && productType=="FOREIGNLINE" && packageType!="LVMAMA"){
			window.open("/vst_admin/prod/baseProduct/toUpdateSupplierProduct.do?productId="+productId+"&categoryId="+categoryId+"&categoryName="+categoryName+"&isView=Y"+"&packageType="+packageType);
		}else{
			window.open("/vst_admin/prod/baseProduct/toUpdateProduct.do?productId="+productId+"&categoryId="+categoryId+"&categoryName="+categoryName+"&isView=Y"+"&packageType="+packageType);
		}
	}
	return false;
});

$(".audit").click(function(){
	currentAuditType = $(this).attr("currentAuditType");
	productId = $(this).attr("data");
	categoryId = $(this).attr("data1");
	var htmlArray = [];
	htmlArray.push('<div id="aduitDiv">');
	htmlArray.push('<div style="margin:5px;"><input type="radio" name="isPass" value="Y">审核通过</div>');
	htmlArray.push('<div style="margin:5px;"><input type="radio" name="isPass" checked="checked" value="N">审核不通过</div>');
	if(currentAuditType=="AUDITTYPE_TO_PM"){
	htmlArray.push('<div style="margin:5px;"><input type="radio" name="isBackEbk"  id="isBackEbk" value="Y" checked="checked">返回EBK修改 &nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="isBackEbk"  id="isBackEbk" value="N">返回VST修改</div>');
	}
	htmlArray.push('<div style="margin:5px;"><textarea name="content" style="width:400px;height:50px;resize:none;"></textarea></div>');
	htmlArray.push('<div class="operate" style="margin-left:5px;margin-top:20px;"><a class="btn btn_cc1" id="audit_submit" data-categoryId="'+categoryId+'">提交</a><a class="btn btn_cc1" id="audit_cancel">取消</a></div>');
	htmlArray.push('</div>');
	
	auditDialog = pandora.dialog({
        width: 500,
        title: "提交审核结果",
        mask : true,
        content: htmlArray.join('')
	 });
});

$("#audit_submit").live("click",function(){
	var msg;
	var source = $(".audit").attr("source");
	var categoryId = $(this).attr("data-categoryId");
    var url="/vst_admin/prod/product/updateAudtiType.do";
    var url_sens = "/vst_admin/prod/product/getSensitiveFlag.do";
    if(categoryId=="2"||categoryId=="8"||categoryId=="9"||categoryId=="10"){
        url = "/ship_back/prod/product/updateAudtiType.do";
        url_sens = "/ship_back/prod/product/getSensitiveFlag.do";
    }
    $.ajax({
        url : url_sens,
        type : "post",
        dataType:"JSON",
        data : {"productId":productId},
        async:false,
        success : function(result) {
            if (result.code == "success") {
                msg = "确定提交？";
            }else {
                msg = result.message+'确定提交?';
            }
        }
    });
	$.confirm(msg,function(){
		var isPass = $("input[name='isPass']:checked").val();
		var content = $.trim($("textarea[name='content']").val());
		var isBackEbk = "N";
		if($("#isBackEbk").is(":checked")){
			isBackEbk = "Y";
		}
		if(isPass=="N"&&content==""){
			$.alert("必须填写审核不通过原因");
			return;
		}
		$.ajax({
			url : url,
			type : "post",
			dataType:"JSON",
			data : {"productId":productId,"currentAuditStatus":currentAuditType,"isPass" : isPass,"content" : content,"bizCategoryId":categoryId,"source":source},
			success : function(result) {
			if (result.code == "success") {
				$.alert(result.message,function(){
					auditDialog.close();
					$("#search_button").click();
				});
			}else {
				$.alert(result.message);
			}
			}
		});
	});
});


$("#audit_cancel").live("click",function(){
		auditDialog.close();
});		


//预览
$("a.showProd").bind("click",function(){
    var productId = $(this).attr("data");
    var categoryId = $(this).attr("categoryId");
    var urlId = $(this).attr("data1");
    if(categoryId=="1"){
        preview(categoryId,productId);
    }else if(categoryId=="11" ){
        preview(categoryId,urlId);
    }else if( categoryId=="12"){
        preview(categoryId,productId);
    }else if(categoryId=="13"){
        $.alert("该产品不能预览");
        return;
    }else if(categoryId=="8"){
        preview(categoryId,productId);
    }else if(categoryId=="15"){
        preview(categoryId,urlId);
    }else if(categoryId=="16"){
        preview(categoryId,urlId);
    }else if(categoryId=="17"){
        preview(categoryId,urlId);
    }else if(categoryId=="18"){
        preview(categoryId,urlId);
    }else if(categoryId=="4"){
        preview(categoryId,$(this).attr("district"));
    }else if(categoryId=="32"){
    	preview(categoryId,urlId);
    }else if(categoryId=="41"){
    	preview(categoryId,urlId);
    }else {
        $.alert("该产品不能预览");
        return;
    }
});

//设置为预览
function preview(categoryId,previewId){
    window.open("/vst_admin/prod/baseProduct/preview.do?categoryId="+categoryId+"&previewId="+previewId);
}

function confirmAndRefresh(result){
	if (result.code == "success") {
		pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
			$("#searchForm").submit();
		}});
	}else {
		pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
			$.alert(result.message);
		}});
	}
};
	
</script>


