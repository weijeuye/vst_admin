<#if productView?? && productView.isTeMai>
<div class="box_content">
    <table class="p_table table_center ">
        <thead>
        <th>产品</th>
        <th>商品</th>
        </thead>
        <tbody>
		<tr>
		<td>
        	<#if productView.urls?? && productView.urls?size gt 0>
        		<#list productView.urls  as producturl>
				<a target="blank" href="${producturl.url}">${producturl.channelName}</a>
	        	</#list>
        	</#if>
		</td>
		<td>
    		<#if productView.goodsViews?? && productView.goodsViews?size gt 0 >
				<#list productView.goodsViews as goodView>
			        <#if goodView.urls?? && goodView.urls?size gt 0 >
						${goodView.id}
						<#list goodView.urls as goodUrl>
						<a target="blank" href="${goodUrl.url}">${goodUrl.channelName}</a>
						</#list><br/>
	    			</#if>
				</#list>
			</#if>
		</td>
		</tr>
    	</tbody>
    </table>
</div>
<#else>
</#if>