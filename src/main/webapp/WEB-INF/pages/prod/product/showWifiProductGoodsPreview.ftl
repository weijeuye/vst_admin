
<div class="box_content">
    <table class="p_table table_center ">
        <thead>
        <th>商品</th>
        </thead>
        <tbody>
        <#if suppList??>
		<#list suppList as goods>
		<tr>
		<td>
	        <#if goods.goodsName??>
				<a target="blank" style="overflow:hidden;white-space:nowrap;" href="http://dujia.lvmama.com/<#if productType=="WIFI">wifi<#else>phcard</#if>/${goods.suppGoodsId}/preview">${goods.goodsName}</a>
			</#if>
		</td>
		</tr>
		</#list>
		</#if>
    	</tbody>
    </table>
</div>
