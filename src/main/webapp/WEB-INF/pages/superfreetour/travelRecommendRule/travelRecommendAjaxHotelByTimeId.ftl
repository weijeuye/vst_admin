<#if hotelSortList?? && hotelSortList?size gt 0>
	<div id="${hotelTimeId}" class="js-hotel-set-box" style="display: block">
        <div class="manage-box">
           	 已选酒店
            <a class="btn btn-blue set-hotel" data-timeId="${hotelTimeId}" data-timeName="${timeName}">设置适用酒店</a>
            <a class="btn js-delete-all" data-timeId="${hotelTimeId}" data-timeName="${timeName}">清除全部适用酒店</a>
        </div>
        <table class="display-table">
            <thead>
            <tr>
                <th width="50">匹配度</th>
                <th width="8%">酒店名称</th>
                <th width="50">价格</th>
                <th width="5%">星级标准</th>
                <th width="5%">好评度</th>
                <th width="8%">地址</th>
                <th width="80">操作</th>
            </tr>
            </thead>
            <tbody>
	<#list hotelSortList as item>
	<tr>
	 	<td  id="hotelId" style="display:none;">${item.hotelId}</td>
        <td  id="priority" >${item.priority}</td>
        <td  id="hotelName" >${item.hotelName}</td>
        <td  id="hotelPrice" value=${item.hotelPrice}>
            &yen;${item.hotelPrice}
        </td>
        <td id="starLevel" value=${item.starLevel}>
        <#if item.starLevel==5>豪华型酒店<#elseif item.starLevel==4>品质型酒店<#elseif item.starLevel==3>舒适型酒店 <#elseif item.starLevel==2>简约型酒店 <#else>其他 </#if>
		</td>
        <td  id="goodComments" value=${item.goodComments}>
             <#if item.goodComments?exists>${item.goodComments}%<#else>无</#if>
        </td>
        <td  id="hotelAddress"> ${item.hotelAddress}</td>
        <td>
            <a href="javascript:;" class="up-btn">升级</a>
            <a href="javascript:;" class="down-btn">降级</a>
            <a href="javascript:;" class="delete-btn">删除</a>
        </td>
    </tr>
	</#list>
	  </tbody>
     </table>
	<div>
	<#else>
	<!--没有设置时间段 提示-->
	<div class="no-set">
		该时间段下暂时还没有适用的酒店哦，赶快设置吧~<br>
		<a  data-timeId="${hotelTimeId}" class="btn btn-blue set-hotel">立即设置</a>
	</div>
	</#if>
	<div class="save-hotel-btn">
	<a class="btn btn-blue" data-timeId="${hotelTimeId}" data-timeName="${timeName}">保存</a>
	</div>
	<script>
	</script>

