<#--页眉-->
<#import "/base/spring.ftl" as spring/>
<#import "/base/pagination.ftl" as pagination>
<#if pageParam?? && pageParam.items?? && pageParam.items?size &gt;  0>
    <#assign isItems = true>
</#if>
<div class="p_box" id="logResultList">
            <table class="p_table table_center product">
                <thead> 
                    <tr class="noborder">
                    	<#if isItems??>
	                		<th class="w10"><input type="checkbox" class="checkbox_top" name="All"></th>
	                	</#if>
                        <th class="w10">产品类型</th>
                        <th class="w10 text_left">产品ID</th>
                        <th class="text_left">产品名称</th>       
                        <th class="text_left">行程天数</th>
                        <th class="text_left">产品状态</th>
                        <th class="text_left" style="width:8%;">操作</th>   
                    </tr>
                </thead>
                <tbody>
                    <#if isItems??>
                    <#list pageParam.items  as prod>
                    <tr>
                    	<td class="w10" align="center">
                    		<input type="checkbox" class="checkbox_top" name="productIds" 
	                    		data="${prod.productId}" data1="${prod.bizCategory.categoryId}"
	                    		data2="${prod.prodLineRouteList[0].lineRouteId}" 
	                    		data3="${prod.prodLineRouteList[0].routeNum}" 
	                    		data4="${prod.prodLineRouteList[0].stayNum}" />
                    	</td>
                        <td class="w10">${prod.bizCategory.categoryName!''}</td>
                        <td class="w10 text_left">${prod.productId!''}</td>
                        <td class="text_left">${prod.productName!''}</td>
                        <td class="w10">${prod.prodLineRouteList[0].routeNum!''}天${prod.prodLineRouteList[0].stayNum!''}晚</td>
                        <td>
							<#if prod.cancelFlag == "Y"> 
							<span style="color:green" class="cancelProd">有效</span>
							<#else>
							<span style="color:red" class="cancelProd">无效</span>
							</#if>
						</td>
						<td class="oper">
							<a href="javascript:void(0);" class="editProp" name="add_prodGroup"
								data="${prod.productId}" data1="${prod.bizCategory.categoryId}"
	                    		data2="${prod.prodLineRouteList[0].lineRouteId}" 
	                    		data3="${prod.prodLineRouteList[0].routeNum}" 
	                    		data4="${prod.prodLineRouteList[0].stayNum}">添加关联</a>
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
