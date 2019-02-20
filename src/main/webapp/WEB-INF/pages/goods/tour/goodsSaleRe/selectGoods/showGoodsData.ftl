 <div>
    <!-- 系统逻辑下商品数量 -->
    <input type="hidden" id="systemLogicGoodsNum" name="systemLogicGoodsNum" value="${systemLogicGoodsNum!''}"/>
     <!-- 系统逻辑下商品id字符串的拼接 -->
    <input type="hidden" id="systemLogicGoodsIdString" name="systemLogicGoodsIdString" value="${systemLogicGoodsIdString!''}"/>
     <!-- 系统逻辑下商品名称字符串的拼接 -->
    <input type="hidden" id="systemLogicGoodsNameString" name="systemLogicGoodsNameString" value="${systemLogicGoodsNameString!''}"/>
    <!-- 是否已经打包 -->
	<input type="hidden" id="whetherPackaged" name="whetherPackaged" value="${whetherPackaged!''}"/>
    <!-- 已打包商品id字符串的拼接 -->
    <input type="hidden" id="suppGoodsIdString" name="suppGoodsIdString" value="${suppGoodsIdString!''}"/>
    <!-- 已打包商品名称字符串的拼接 -->
    <input type="hidden" id="goodsNameString" name="goodsNameString" value="${goodsNameString!''}"/>
</div>
 <#if pageParam??> 
 <#if pageParam.items?? && pageParam.items?size &gt;0>
<div class="p_box box_info">
	<table class="p_table table_center">
		<thead>
			<tr>
				<th><input type="checkbox" name="" id="selectAllItems" />选择</th>
				<th>商品ID</th>
				<th>商品名称</th>
				<th>是否可售</th>
				<th>是否有效</th>
				<th>供应商名称</th>
				<th>行政区划</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
			<#list pageParam.items as hotelGoodsData>
			<tr>
				<td><input id="checkbox${hotelGoodsData.suppGoodsId!''}"
					type="checkbox" name="checkOjectId"
					value="${hotelGoodsData.suppGoodsId!''}" /></td>
				<td title="${hotelGoodsData.suppGoodsId!''}"
					class="objectsuppGoodsId" style="text-align: left;">${hotelGoodsData.suppGoodsId!''}
				</td>
				<td title="${hotelGoodsData.goodsName!''}" class="objectName"
					style="text-align: left;">${hotelGoodsData.goodsName!''}<span>【${branchName!''}】</span></td>
				<td><#if hotelGoodsData.onlineFlag?? &&
					hotelGoodsData.onlineFlag == 'Y'>是<#elseif
					hotelGoodsData.onlineFlag?? && hotelGoodsData.onlineFlag ==
					'N'>否<#else>${hotelGoodsData.onlineFlag!''}</#if></td>
				<td><#if hotelGoodsData.cancelFlag?? &&
					hotelGoodsData.cancelFlag == 'Y'>是<#elseif
					hotelGoodsData.cancelFlag?? && hotelGoodsData.cancelFlag ==
					'N'>否<#else>${hotelGoodsData.cancelFlag!''}</#if></td>
				<td>${hotelGoodsData.supplierName!''}</td>
				<td>${hotelGoodsData.districtName!''}</td>
				<td><a style="cursor: pointer"
					onclick="showGoodsTimePrice('${productId!''}','${productBranchId!''}','${hotelGoodsData.supplierId!''}','${hotelGoodsData.suppGoodsId!''}')">时间价格表</a>
					<a style="cursor: pointer"
					onclick="openProduct('${productId!''}','${categoryId!''}','${hotelGoodsData.supplierName!''}','${hotelGoodsData.suppGoodsId!''}','${hotelGoodsData.supplierId!''}')">进入产品</a>
				</td>
			</tr>
			</#list>
		</tbody>
	</table>
	<#if pageParam.items?exists>
	<div class="paging" >${pageParam.getAsyncPagination()}</div>
	</#if>
</div>
<!-- div p_box -->
<#else>
<div class="no_data mt20">
	<i class="icon-warn32"></i>您要的商品未找到,您可以在VST->产品管理->标准产品管理中新增一个商品!
</div>
</#if> 
</#if>