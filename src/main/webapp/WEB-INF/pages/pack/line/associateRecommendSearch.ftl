<div class="iframe_content">
	<div class="p_box box_info">
		<table class="s_table">
            <tbody>
                <tr>
                	<td class="s_label">产品品类:
                		<input type="hidden" name="master_product_id" value="${master_product_id}">
                		<input type="hidden" name="bu" value="${bu}">
                	</td>
                    <td class="w18">
                    	<select name="categoryId">
						  <option value ="14" <#if categoryId == 14>selected='selected'</#if>   >全部</option>
						  <option value ="15" <#if categoryId == 15>selected='selected'</#if>   >跟团游</option>
						  <option value="16" <#if categoryId == 16>selected='selected'</#if>   >当地游</option>
						  <option value="18" <#if categoryId == 18>selected='selected'</#if>   >自由行</option>
						</select>
                    <td class="s_label">产品ID：</td>
                    <td class="w18"><input type="text" value="" name="productId"></td>
                    <td class="s_label">产品名称：</td>
                    <td class="w18"><input type="text" number="true" value="" name="productName"></td>
                    <td class=" operate mt10">
                   		<a href="javascript:void(0);" name="selectCandidateProduct"  class="btn btn_cc1">查询 </a>
                    </td>
                </tr>
            </tbody>
        </table>
	</div>
	
	<!-- 主要内容显示区域\\ -->
	<div class="p_box" id="dataDiv">
		<#include "pack/line/associateRecommendCandidateList.ftl"/>
	</div>
	
<script>
		$("[name=selectCandidateProduct]").click(function(e){
			var $tr = $(e.target).closest("tr");
			var data = {
				"categoryId" : $tr.find("[name='categoryId']").val(),
				"slave_product_id" : $tr.find("[name='productId']").val(),
				"productName" : $tr.find("[name='productName']").val(),
				"master_product_id":$tr.find("[name='master_product_id']").val(),
				"bu":$tr.find("[name='bu']").val()
			};
			
			$.ajax({
				url : "/vst_admin/associationRecommend/selectCandidateProduct.do",
				type : 'POST',
				data : data,
				success : function(res){
					console.log(res);
					$("#dataDiv").html(res);
					if(selectRecommendProductDialog) {
						selectRecommendProductDialog.myResizeWH();
					}
				}
			});
		});
	
	function addAssociationRecommend(event, slave_product_id){
		var data = {
				"master_product_id": $("[name=master_product_id]").val(),
				"slave_product_id": slave_product_id
			};
		$.ajax({
				url : "/vst_admin/associationRecommend/addAssociationRecommend.do",
				type : "post",
				dataType : 'json',
				data : data,
				success : function(result) {
					if(result.code == "success"){
						selectRecommendProductDialog.close();
						$("li:has(a[name='associationRecommend'])", window.parent.document).click();
					}else {
						$.alert(result.message);
					}
				},
				error : function(e){
					console.error(e);
				}
			});    //end $.ajax
	};
</script>