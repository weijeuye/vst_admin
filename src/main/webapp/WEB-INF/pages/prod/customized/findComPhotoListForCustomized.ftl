<!DOCTYPE html>
<html>
	<head>
		<#include "/base/head_meta.ftl"/>
	</head>
	
	<body>
	  <div class="p_box box_info">
	  </div>
		<!-- 主要内容显示区域\\ -->
		<div class="p_box box_info">
		    <table class="p_table table_center">
		                <thead>
		                    <tr>
		                    <th width="350px">产品编号</th>
		                    <th width="350px">产品标题</th>
		                    <th width="350px">操作</th>
		                    </tr>
		                </thead>
		                <tbody>
							<tr>
								<td>${customizedProduct.customizedProdId!''} </td>
								<td>${customizedProduct.productName!''} </td>
								<td class="oper">
		                            <a href="javascript:void(0);" class="editProd" data="${customizedProduct.customizedProdId}" data1="${customizedProdDetail.seq}">编辑</a>
		                        </td>
							</tr>
		                </tbody>
		            </table>
		</div><!-- div p_box -->
		
		<div class="p_box box_info">
		    <table class="p_table table_center">
		                <thead>
		                    <tr>
		                    <th width="350px">详情编号</th>
		                    <th width="350px">详情标题</th>
		                    <th width="350px">操作</th>
		                    </tr>
		                </thead>
		                <tbody>
							<#list customizedProdDetailList as customizedProdDetail> 
							<tr>
								<td>详情${customizedProdDetail.seq!''} </td>
								<td>${customizedProdDetail.customizedProdDetailName!''} </td>
								<td class="oper">
		                            <a href="javascript:void(0);" class="editProdDetail" data="${customizedProdDetail.customizedProdId}" data1="${customizedProdDetail.seq}">编辑</a>
		                        </td>
							</tr>
							</#list>
		                </tbody>
		            </table>
		</div><!-- div p_box -->
		
	    <div class="p_box box_info">
		    <table class="p_table table_center">
		                <thead>
		                    <tr>
		                    <th width="350px">行程编号</th>
		                    <th width="350px">行程标题</th>
		                    <th width="350px">操作</th>
		                    </tr>
		                </thead>
		                <tbody>
							<#list customizedProdLineInfoList as customizedProdLineInfo> 
							<tr>
								<td>第${customizedProdLineInfo.nDay!''}天 </td>
								<td>${customizedProdLineInfo.prodLineInfoName!''} </td>
								<td class="oper">
		                            <a href="javascript:void(0);" class="editProdLineInfo" data="${customizedProdLineInfo.customizedProdId}" data1="${customizedProdLineInfo.nDay}">编辑</a>
		                        </td>
							</tr>
							</#list>
		                </tbody>
		            </table>
		</div><!-- div p_box -->
		
		<#include "/base/foot.ftl"/>
	</body>
</html>
<script>
$(function(){
	
	//跳转到焦点图编辑页面
	$("a.editProd").bind("click",function(){
		
		var productId = $(this).attr("data");
		var seq = $(this).attr("data1");
		var url="/vst_admin/prod/customized/findComPhotoList.do?objectId="+productId+"&parentId="+productId+"&objectType=CUSTOMIZED_PRODUCT";
		$("a.editProd").attr("href", url);
	});
	//跳转到详情图片编辑页面
	$("a.editProdDetail").bind("click",function(){
		
		var productId = $(this).attr("data");
		var seq = $(this).attr("data1");
		var url="/vst_admin/prod/customized/findComPhotoList.do?objectId="+productId+"&parentId="+productId+"&objectType=CUSTOMIZED_PROD_DETAIL_"+seq+"";
		$("a.editProdDetail").attr("href", url);
	});
	//跳转到行程图片编辑页面
	$("a.editProdLineInfo").bind("click",function(){
		
		var productId = $(this).attr("data");
		var nDay = $(this).attr("data1");
		var url="/vst_admin/prod/customized/findComPhotoList.do?objectId="+productId+"&parentId="+productId+"&objectType=CUSTOMIZED_PROD_LINE_INFO_"+nDay+"";
		$("a.editProdLineInfo").attr("href", url);
	});
})
</script>





