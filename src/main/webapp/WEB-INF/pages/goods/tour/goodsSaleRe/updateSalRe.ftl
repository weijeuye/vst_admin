<div class="iframe_content">
	<div>注，任选[0、1、2、3、…最大购买数]；可选[0、最大购买数]；等量[最大购买数]</div>
 </div>
 <div class="iframe_content">
	设置规则
 </div>
 <#if saleRelationList?? &&  saleRelationList?size==1>
 	<#assign saleRelation = saleRelationList[0].suppGoodsSaleRe>
 </#if>

 <form id="form">
 <div class="iframe_content">
 	<!--如果仅有一个关联关系，则设置默认选中-->
	<span style="margin-right:20px;">常规限制：</span>
	<input type="radio"  name="reType" value="OPTIONAL" checked="checked">
	任选<#if hasConnects=="N"><input type="radio"  name="reType" value="OPTION" <#if saleRelation??&&saleRelation.reType=='OPTION'>checked=checked</#if> >可选</#if>
 </div>
 
 <#--主产品类别，跟团游、当地游、自由行（机酒、交通+服务）-->
 <#assign isLineScope = mainProductProuct?? && (mainProductProuct.bizCategoryId == 15
 					|| mainProductProuct.bizCategoryId == 15
 					|| mainProductProuct.bizCategoryId == 16
 					|| mainProductProuct.bizCategoryId == 18 && (mainProductProuct.subCategoryId == 182 || mainProductProuct.subCategoryId == 183|| mainProductProuct.subCategoryId == 184) )/>
 <#if categoryId != 4 && isLineScope>
 <div class="iframe_content">
	<span style="margin-right:20px;">选择出游时间：</span>
	   第 <#list 1..routeNum as num>
	       <input type="checkbox" name="routeNum" value="${num}" <#if limitDays?exists&&limitDays?contains(num?string)>checked="checked"</#if>> ${num}
	   </#list>天
 </div>
 </#if>
<!-- 主要内容显示区域\\ -->
    <#if saleRelationList?? &&  saleRelationList?size &gt; 0>
    <div class="p_box box_info">
    <table class="p_table table_center">
                <thead>
                    <tr>
                	<th width="80px">产品类型</th>
                    <th>产品ID</th>
                    <th>产品名称</th>
                    <th>规格ID</th>
                    <th>规格</th>
                    </tr>
                </thead>
                <tbody>
                <input type ="hidden" name = "mainProductId" value="${mainProductId}">
					<#list saleRelationList as pgr> 
					<input type="hidden" name="reIds" value="${pgr.suppGoodsSaleRe.reId}">
					<tr>
					<td>${pgr.category.categoryName!''}</td>
					<td>${pgr.product.productId!''} </td>
					<td>${pgr.product.productName!''} </td>
					<td>${pgr.productBranch.productBranchId!''}</td>
					<input type ="hidden" name = "productBranchIds" value="${pgr.productBranch.productBranchId}">
					<input type ="hidden" name = "suppGoodsIds" value="${pgr.suppGoodsSaleRe.suppGoodsIdStr}">
					<td>${pgr.productBranch.branchName!''}</td>
					</tr>
					</#list>
                </tbody>
            </table>
        
	</div><!-- div p_box -->
	</form>
	<#else>
		<div class="no_data mt20"><i class="icon-warn32"></i>暂无相关关联产品！</div>
    </#if>
<!-- //主要内容显示区域 -->
</div>
  <div class="operate">
  	<a class="btn btn_cc1" id="update_button">保存并添加</a> 
  </div>
<script>
    
	$("#update_button").click(function(){
		$.ajax({
			url : '/vst_admin/tour/goods/goods/updateGoodsSaleRe.do',
			type : 'POST',
			async : false,
			data : $("#form").serialize(),
			success : function(message){
				if(message=="success"){
					$.alert("更新成功",function(){
						window.location.reload();
					});
				}else 
					$.alert(message);
			}
		});
		});
</script>


