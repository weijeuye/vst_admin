<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
</head>
<body>
<div class="iframe_content mt10">
<#assign routeNum = '' />
<#assign stayNum = '' />
<#assign cancelFlag={"Y":"有效","N":"无效"}>
<#assign saleFlag={"Y":"可售","N":"不可售"}>
<input type="hidden" id = "groupType" name="groupType" value="TRANSPORT"/>
<input type="hidden" id = "productId" name="productId" value="${productId }"/>
<input type="hidden" id = "groupId" name="groupId" />

<form action="" method="post" id="dataForm">
			<div class="p_box box_info p_line" style="border:solid 1px #aaa">
	            <div >
	                <table  style="width: 1054px">
	                    <tbody>
						                <tr>
						                	<td colspan="2">
											  <div class="p_box box_info">
											    <table class="p_table table_center" style="width: 1054px">
									                <thead>
									                    <th>产品类型</th>
									                    <th>产品ID</th>
									                    <th>出发地</th>
									                    <th>目的地</th>
									                    <th>产品名称</th>
									                    <th>规格ID</th>
									                    <th>规格</th>
									                    <th>状态</th>
									                    <th>操作</th>
									                    </tr>
									                </thead>
									                 	<#if prodPackageDetails ??>
															<#list prodPackageDetails as detail> 
																<#if detail?? && detail.prodProductBranch??>
																	<tr >
																		<td >其他机票</td>
																		<td>${detail.prodProductBranch.productId!''}</td>
																		<td>${detail.prodProductBranch.product.prodTraffic.startDistrictObj.districtName!''} </td>
																		<td>${detail.prodProductBranch.product.prodTraffic.endDistrictObj.districtName!''}</td>
																		<td>																		
																			<a style="cursor:pointer" 
																				onclick="openProduct(${detail.prodProductBranch.product.productId!''},21,'其他机票')">
																				${detail.prodProductBranch.product.productName!''}
																			</a>
																		</td>
																		<td>${detail.prodProductBranch.productBranchId!''}</td>
																		<td>${detail.prodProductBranch.branchName!''}</td>
																		<td>
																			[${cancelFlag[detail.prodProductBranch.cancelFlag]}]
																			[${saleFlag[detail.prodProductBranch.saleFlag]}]
																		</td>
																		<td>
																			<a id="deletePackGroupDetail" style="cursor:pointer" onclick="deletePackGroupDetail('${detail.detailId !''}')">取消打包</a>
																		</td>
																	</tr>
																</#if>
															</#list>
														  </#if>
										                </tbody>
									               </table>
									            </div>
						                	</td>
						                </tr>
	                	</tbody>
	                </table>
	            </div>
	        </div>
</form>
<#include "/base/foot.ftl"/>
</body>
</html>
<script>
var addGroupDialog, findCitygroupDialog,selectProductDialog,updateGroupDetailDialog,updateGroupDetailAddPriceDialog;

function openProduct(productId, categoryId, categoryName){
	window.open("/vst_admin/prod/baseProduct/toUpdateProduct.do?productId="+productId+"&categoryId="+categoryId+"&categoryName="+categoryName);
}

//取消打包
function deletePackGroupDetail(detailId){
    $.ajax({
	  url : "/vst_admin/productPack/line/isBoundStamp.do",
	  type : "post",
	  dataType : 'json',
	  async: false,
	  data : "productId=" + $("#productId").val(),
	  success : function(result) {
	   if(result.code == "success"){
	     if(result.attributes.boundStampFalg){
	        $.confirm("确认取消吗 ？",function(){
		      var loading = top.pandora.loading("正在努力中...");
		      $.ajax({
			       url : "/vst_admin/productPack/line/deletePackGroupDetail.do",
			       type : "post",
			       dataType : 'json',
			       data : "detailId=" + detailId+ "&productId=" + $("#productId").val(),
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
	     }else{
	           alert("该产品下有有效预售券，不能更改!");
	          }
		}
	   },
		error : function(result) {
			$.alert(result.message);
		}
	});
}

//----------临时存储加入打包的规格 js结束-----------//
</script>