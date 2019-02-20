<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
</head>
<body>
<div class="iframe_header">
        <ul class="iframe_nav">
            <li><a href="#">首页</a> &gt;</li>
            <li><a href="#">产品维护</a> &gt;</li>
            <li class="active">关联推荐</li>
        </ul>
</div>
<div class="iframe_content mt10">
    <div class="tiptext tip-warning cc5"><span class="tip-icon tip-icon-warning"></span>友情提示：
    <p class="pl15">1、每个产品最多只能推荐8条</p>
    <p class="pl15">2、当前产品排列顺序为前台推荐产品展示顺序</p>    
    <p class="pl15">3、该模块推荐内容展示在网站产品详情页线路推荐模块内</p>   
    </div>

	<div class="operate" style="margin-top:10px;margin-bottom:10px"><a class="btn btn_cc1" id="selectRecommendProduct">推荐产品</a></div>
	<#if prodAssociateRecommendList??>
		<table class="p_table table_center">
			<thead>
				<tr>
					<th>序号</th>
					<th>产品品类</th>
					<th>产品ID</th>
					<th>产品名称</th>
					<th>行程天数</th>
					<th>费用包含</th>
					<th>目的地</th>
					<th>状态</th>
					<th>是否可售</th>
					<th>推荐排序</th>
					<th>操作</th>
				</tr>
			</thead>
			<tbody class="arList">
				<#list prodAssociateRecommendList as ar>
					<tr>
						<td width="30px">${ar_index +1}</td>
						<td width="50px">${ar.categoryName}</td>
						<td width="50px">${ar.slaveProductId}</td>
						<td width="100px">${ar.slaveProductName}</td>
						<td width="50px">${ar.lineRoute}</td>
						<td width="150px">${ar.feeIncluded}</td>
						<td width="90px">${ar.destinationInfo}</td>
						<td width="50px">${ar.cancelFlag}</td>
						<td width="40px">${ar.sellFlag}</td>
						<td width="50px">
							<select onChange="changeRecommendOrder('${ar.recommendId}', ${master_product_id},this.value)">
	 							<option value="1" <#if '1' == ar.recommendOrder>selected='selected'</#if>  >1</option>
								<option value="2" <#if '2' == ar.recommendOrder>selected='selected'</#if>  >2</option>
								<option value="3" <#if '3' == ar.recommendOrder>selected='selected'</#if>  >3</option>
								<option value="4" <#if '4' == ar.recommendOrder>selected='selected'</#if>  >4</option>
								<option value="5" <#if '5' == ar.recommendOrder>selected='selected'</#if>  >5</option>
								<option value="6" <#if '6' == ar.recommendOrder>selected='selected'</#if>  >6</option>
								<option value="7" <#if '7' == ar.recommendOrder>selected='selected'</#if>  >7</option>
								<option value="8" <#if '8' == ar.recommendOrder>selected='selected'</#if>  >8</option>
							</select>
						</td>
						</td>
						<td width="50px"><a href="javascript:void(0);" onclick="cancelRecommend('${ar.recommendId}', ${master_product_id})">取消推荐</a></td>
					</tr>
				</#list>
			</tbody>
		</table>
	</#if>
</div>
<#include "/base/foot.ftl"/>
</body>
</html>

<script>
	var selectRecommendProductDialog;
	$("#selectRecommendProduct").click(function(e){
		console.log($(".arList tr").size());
		 if($(".arList tr").size() >=8 ) {
		 	$.alert("每个产品最多只能推荐8条");
		 } else {
				selectRecommendProductDialog = new xDialog(
				"/vst_admin/associationRecommend/initAddAssociationRecommend.do",
				{"master_product_id":${master_product_id}, "categoryId":${categoryId} , "bu": '${bu}' },{title:"选择推荐产品",width:"1000",height:"1000"});
				/*xDialog.resizeWH()多次执行宽度会越来越窄，每次小20px,使用自定义函数 */
				selectRecommendProductDialog.myResizeWH = function(){
			   		 var cont =this.dialog.wrap.find("div.dialog-content"); 
			   		 this.dialog.size(cont.width()+40,cont.height()+80); 
			   	}
		 }
	});

	function changeRecommendOrder(recommendId, master_product_id, recommendOrder) {
		var url = "/vst_admin/associationRecommend/updateAssociationRecommend.do?recommend_id="  + recommendId + 
						"&recommend_order=" + recommendOrder + 
						"&master_product_id=" + master_product_id;
		$.ajax({
			url : url,
			type : "post",
			dataType : 'json',
			success : function(result) {
				if(result.code == "success"){
					$("li:has(a[name='associationRecommend'])", window.parent.document).click();
				}else {
					$.alert(result.message);
				}
			},
			error : function(e){
				console.error(e);
			}
		});  //$.ajax
	}

	function cancelRecommend(recommendId, master_product_id) {
		var url = "/vst_admin/associationRecommend/removeAssociationRecommend.do?recommend_id="  + recommendId + "&master_product_id=" + master_product_id;
		var msg = '是否确定取消推荐';
		$.confirm(msg,function(){		
			$.ajax({
				url : url,
				type : "post",
				dataType : 'json',
				success : function(result) {
					if(result.code == 'success' ) {
						$.alert("取消推荐成功", function(){
							$("li:has(a[name='associationRecommend'])", window.parent.document).click();
						});
					} else {
						$.alert(result.message);
					}
				},
				error : function(e){
					console.error(e);
				}
			});
		
		});//$.confirm
}
</script>