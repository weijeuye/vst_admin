<#--页眉-->
<#import "/base/spring.ftl" as spring/>
<#import "/base/pagination.ftl" as pagination>
<#if pageParam?? && pageParam.items?? && pageParam.items?size &gt;  0>
    <#assign isItems = true>
</#if>
<div class="p_box" id="logResultList">
            <table class="p_table table_center product" style="width:1100px;">
                <thead> 
                    <tr class="noborder" style="width:50px;">
                    	<#if isItems??>
	                		<th class="w10"><input type="checkbox" class="checkbox_top" name="All"></th>
	                	</#if>
                        <th class="w10" style="width:100px;">产品品类</th>
                        <th class="w10 text_left" style="width:100px;">产品ID</th>
                        <th class="text_left">产品名称</th>       
                        <th class="text_left" style="width:100px;">行程天数</th>
                        <th class="text_left" style="width:100px;">交通</th>
                        <th class="text_left" style="width:100px;">产品经理</th>
                        <th class="text_left" style="width:100px;">操作</th>   
                    </tr>
                </thead>
                <tbody>
                    <#if isItems??>
                    <#list pageParam.items  as prod>
                    <tr>
                    	<td class="w10" align="center" style="width:50px;">
                    		<input type="checkbox" class="checkbox_top" name="productIds" 
	                    		data="${prod.productId}" data1="${prod.bizCategory.categoryId}"
	                    		data2="${prod.prodLineRouteList[0].lineRouteId}" 
	                    		data3="${prod.prodLineRouteList[0].routeNum}" 
	                    		data4="${prod.prodLineRouteList[0].stayNum}" 
	                    		data5="${prod.toTraffic}" data6="${prod.backTraffic}"/>
                    	</td>
                        <td class="w10" style="width:100px;">${prod.bizCategory.categoryName!''}</td>
                        <td class="w10 text_left" style="width:100px;">${prod.productId!''}</td>
                        <td class="text_left">${prod.productName!''}</td>
                        <td class="w10" style="width:100px;">${prod.prodLineRouteList[0].routeNum!''}天${prod.prodLineRouteList[0].stayNum!''}晚</td>
                        <td style="width:100px;">
                            <#if prod.toTraffic==null&&prod.backTraffic==null>无</#if>
                            <#if prod.toTraffic!=null>                            
                                                        去程:${prod.toTraffic!''}<br/>
                            </#if>
                            <#if prod.backTraffic!=null>                            
                        	返程:${prod.backTraffic!''}
                        	</#if>
                        </td>
                        <td style="width:100px;">${prod.managerName!''}</td>
						<td class="oper" style="width:100px;">
							<a href="javascript:void(0);" class="editProp" name="add_prodGroup"
								data="${prod.productId}" data1="${prod.bizCategory.categoryId}"
	                    		data2="${prod.prodLineRouteList[0].lineRouteId}" 
	                    		data3="${prod.prodLineRouteList[0].routeNum}" 
	                    		data4="${prod.prodLineRouteList[0].stayNum}"
	                    		data5="${prod.toTraffic}" data6="${prod.backTraffic}">添加关联</a>
	                    </td>       
                    </tr>
                    </#list>
                    <#else>
                    <tr class="table_nav"><td colspan="6"><div class="no_data mt20"><i class="icon-warn32"></i>暂无相关产品，重新输入相关条件查询！</div></td>	</tr>
                    </#if>
                </tbody>
            </table>
            <#if pageParam?? && pageParam.items?? && pageParam.items?size &gt;  0>
            <div class="pages darkstyle">	
            	<@pagination.paging pageParam true "#logResultList"/>
			 </div>
		 </#if>
  </div>
  <script type="text/javascript">
  	//绑定事件
  	$("a[name=add_prodGroup]").each(function(){
  		$(this).bind("click", add_prodGroup);
  	});
  	
  </script>
