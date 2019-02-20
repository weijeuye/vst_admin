
			<table class="display-table">
			<#if hotelSortList??  && hotelSortList?size gt 0> 
			<thead>
            <tr>
                <th width="3%">
                    <label>
                        <input class="JS_result_select_all" type="checkbox">全选
                    </label>
                </th>
                <th width="80">匹配度</th>
                <th width="8%">酒店名称</th>
                <th width="50">价格</th>
                <th width="5%">星级标准</th>
                <th width="5%">好评度</th>
                <th width="8%">地址</th>
            </tr>
            </thead>
            
            <tbody>
            	<#list hotelSortList as item>
            	<tr>
                <td>
                    <label>
                        <input class="JS_result_select" type="checkbox">
                    </label>
                </td>
                <td id="hotelId" style="display:none;">${item.hotelId}</td>
                <td id="priority">${item_index+1}</td>
                <td id="hotelName">${item.hotelName}</td>
                <td id="hotelPrice" value=${item.hotelPrice}>
                    &yen;${item.hotelPrice}
                </td>
                <td id="starLevel" value=${item.starLevel}><#if item.starLevel==5>豪华型酒店<#elseif item.starLevel==4>品质型酒店<#elseif item.starLevel==3>舒适型酒店 <#elseif item.starLevel==2>简约型酒店 <#else>其他 </#if></td>
                <td id="goodComments" value=${item.goodComments}>
                    <#if item.goodComments?exists>${item.goodComments}%<#else>无</#if>
                </td>
                <td id="hotelAddress">${item.hotelAddress}</td>
            </tr>
            	</#list>
            </tbody>
			<#else>
			<div class="no-set">
            	抱歉，无匹配到相关酒店哦~
        	</div>
			</#if>
        </table>
        <div >
        <#if hotelSortList??  && hotelSortList?size gt 0>
        	提示：本页面最多展示200个酒店！
         </#if>
        </div>
 